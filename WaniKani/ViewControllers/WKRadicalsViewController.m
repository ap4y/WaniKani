//
//  WKRadicalsViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKRadicalsViewController.h"
#import "WKRadicalViewCell.h"
#import "WKRadical.h"

#import "WKCustomization.h"

@interface WKRadicalsViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *radicalsCollectionView;

@property (strong, nonatomic) NSDictionary *radicalsByLevel;
@end

@implementation WKRadicalsViewController

static NSString * const kRadicalsCellIdentifier     = @"WKRadicalsCell";
static NSString * const kRadicalsSuppViewIdentifier = @"WKRadicalsSuppView";

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"btn_radicals_pressed"]
                  withFinishedUnselectedImage:[UIImage imageNamed:@"btn_radicals_normal"]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.viewControllers = (self.parentViewController ? @[ self.parentViewController ] : @[]);
    [WKCustomization setBackgroundForView:self.view];
    [_radicalsCollectionView setBackgroundColor:[UIColor clearColor]];
    
    NSArray *radicals       = [WKRadical requestResult:[WKRadical all] managedObjectContext:mainThreadContext()];
    self.radicalsByLevel    = [WKItem itemsByLevel:radicals];

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

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_radicalsByLevel count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSNumber *levelKey          = [[_radicalsByLevel allKeys] objectAtIndex:section];
    NSArray *radicalsForLevel   = [_radicalsByLevel objectForKey:levelKey];
    
    return [radicalsForLevel count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *suppView;
    suppView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                  withReuseIdentifier:kRadicalsSuppViewIdentifier
                                                         forIndexPath:indexPath];
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
