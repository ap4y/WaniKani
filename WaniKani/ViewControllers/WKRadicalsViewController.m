//
//  WKRadicalsViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKRadicalsViewController.h"
#import "WKItemsHeaderView.h"
#import "WKRadicalViewCell.h"
#import "WKRadical.h"

#import "WKCustomization.h"

@interface WKRadicalsViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *radicalsCollectionView;

@property (strong, nonatomic) NSDictionary *radicalsByLevel;
@property (strong, nonatomic) NSMutableDictionary *collapsedRadicalsByLevel;
@end

@implementation WKRadicalsViewController

static NSString * const kRadicalsCellIdentifier     = @"WKRadicalsCell";
static NSString * const kRadicalsSuppViewIdentifier = @"WKRadicalsSuppView";
static NSString * const kDetailsSegueIdentifier     = @"WKRadicalDetailsSegue";

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    NSArray *radicals       = [WKRadical requestResult:[WKRadical all] managedObjectContext:mainThreadContext()];
    self.radicalsByLevel    = [WKItem itemsByLevel:radicals];

    self.collapsedRadicalsByLevel = [NSMutableDictionary dictionary];
    [[_radicalsByLevel allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        if (idx == 0) {
            
            [_collapsedRadicalsByLevel setObject:[_radicalsByLevel objectForKey:obj] forKey:obj];
            
        } else {
            
            [_collapsedRadicalsByLevel setValue:nil forKey:obj];
        }
    }];
    
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"btn_radicals_pressed"]
                  withFinishedUnselectedImage:[UIImage imageNamed:@"btn_radicals_normal"]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.viewControllers = (self.parentViewController ? @[ self.parentViewController ] : @[]);
    [WKCustomization setBackgroundForView:self.view];
    [_radicalsCollectionView setBackgroundColor:[UIColor clearColor]];
    
    [WKRadical fetchRadicalsWithSuccess:^(NSArray *radicals) {
       
        self.radicalsByLevel = [WKItem itemsByLevel:radicals];
        [_radicalsCollectionView reloadData];
        
    } failure:^(NSError *error) {
        
        /**
         TODO: Add error handling
         */
        NSLog(@"%@", error);
    }];        
}

- (void)viewWillAppear:(BOOL)animated {
    
    UIImage *selectionImage = [WKCustomization resizableImageNamed:@"radicals_selection"
                                                     withCapInsets:UIEdgeInsetsMake(2.5f, 2.5f, 2.5f, 2.5f)];
    [self.tabBarController.tabBar setSelectionIndicatorImage:selectionImage];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kDetailsSegueIdentifier]) {
    
        NSIndexPath *indexPath      = [_radicalsCollectionView indexPathForCell:sender];
        NSNumber *levelKey          = [[_radicalsByLevel allKeys] objectAtIndex:indexPath.section];
        NSArray *radicalsForLevel   = [_radicalsByLevel objectForKey:levelKey];
        WKRadical *radical          = [radicalsForLevel objectAtIndex:indexPath.row];

        [segue.destinationViewController setValue:radical forKey:@"item"];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_radicalsByLevel count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSNumber *levelKey          = [[_radicalsByLevel allKeys] objectAtIndex:section];
    NSArray *radicalsForLevel   = [_collapsedRadicalsByLevel objectForKey:levelKey];
    
    return [radicalsForLevel count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    WKItemsHeaderView *suppView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                     withReuseIdentifier:kRadicalsSuppViewIdentifier
                                                                            forIndexPath:indexPath];
    NSNumber *levelKey          = [[_radicalsByLevel allKeys] objectAtIndex:indexPath.section];
    [suppView setItems:[WKRadical itemsForLevel:levelKey] level:levelKey];
    [suppView setHeaderViewTouched:^{
        
        if (![_collapsedRadicalsByLevel objectForKey:levelKey]) {
            
            [_collapsedRadicalsByLevel setObject:[_radicalsByLevel objectForKey:levelKey] forKey:levelKey];
            [collectionView reloadData];
            [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]
                                   atScrollPosition:UICollectionViewScrollPositionBottom
                                           animated:YES];
        } else {
            
            [_collapsedRadicalsByLevel setValue:nil forKey:(id)levelKey];
            [collectionView reloadData];
        }
    }];
    
    return suppView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *levelKey          = [[_radicalsByLevel allKeys] objectAtIndex:indexPath.section];
    NSArray *radicalsForLevel   = [_radicalsByLevel objectForKey:levelKey];
    WKRadical *radical          = [radicalsForLevel objectAtIndex:indexPath.row];
    
    WKRadicalViewCell *cell     = [collectionView dequeueReusableCellWithReuseIdentifier:kRadicalsCellIdentifier
                                                                            forIndexPath:indexPath];
    [cell setRadical:radical];
    
    return cell;
}

@end
