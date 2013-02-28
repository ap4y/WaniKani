//
//  WKKanjiViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKKanjiViewController.h"
#import "WKItemsHeaderView.h"
#import "WKKanjiViewCell.h"
#import "WKKanji.h"

#import "WKCustomization.h"

@interface WKKanjiViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *kanjiCollectionView;

@property (strong, nonatomic) NSDictionary *kanjiByLevel;
@end

@implementation WKKanjiViewController

static NSString * const kKanjiCellIdentifier        = @"WKKanjiCell";
static NSString * const kKanjiSuppViewIdentifier    = @"WKKanjiSuppView";
static NSString * const kDetailsSegueIdentifier     = @"WKKanjiDetailsSegue";

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    NSArray *kanji      = [WKKanji requestResult:[WKKanji all] managedObjectContext:mainThreadContext()];
    self.kanjiByLevel   = [WKItem itemsByLevel:kanji];
    
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"btn_kanji_pressed"]
                  withFinishedUnselectedImage:[UIImage imageNamed:@"btn_kanji_normal"]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WKCustomization setBackgroundForView:self.view];
    [_kanjiCollectionView setBackgroundColor:[UIColor clearColor]];
    
    [WKKanji fetchKanjiWithSuccess:^(NSArray *kanji) {
        
        self.kanjiByLevel = [WKItem itemsByLevel:kanji];
        [_kanjiCollectionView reloadData];
        
    } failure:^(NSError *error) {
        
        /**
         TODO: Add error handling
         */
        NSLog(@"%@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    UIImage *selectionImage = [WKCustomization resizableImageNamed:@"kanji_selection"
                                                     withCapInsets:UIEdgeInsetsMake(2.5f, 2.5f, 2.5f, 2.5f)];
    [self.tabBarController.tabBar setSelectionIndicatorImage:selectionImage];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kDetailsSegueIdentifier]) {
        
        NSIndexPath *indexPath      = [_kanjiCollectionView indexPathForCell:sender];
        NSNumber *levelKey          = [[_kanjiByLevel allKeys] objectAtIndex:indexPath.section];
        NSArray *kanjiForLevel      = [_kanjiByLevel objectForKey:levelKey];
        WKKanji *kanjiItem          = [kanjiForLevel objectAtIndex:indexPath.row];
        
        [segue.destinationViewController setValue:kanjiItem forKey:@"item"];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_kanjiByLevel count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSNumber *levelKey      = [[_kanjiByLevel allKeys] objectAtIndex:section];
    NSArray *kanjiForLevel  = [_kanjiByLevel objectForKey:levelKey];
    
    return [kanjiForLevel count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    WKItemsHeaderView *suppView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                     withReuseIdentifier:kKanjiSuppViewIdentifier
                                                                            forIndexPath:indexPath];
    NSNumber *levelKey          = [[_kanjiByLevel allKeys] objectAtIndex:indexPath.section];
    [suppView setItems:[WKKanji itemsForLevel:levelKey] level:levelKey];
    
    return suppView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *levelKey      = [[_kanjiByLevel allKeys] objectAtIndex:indexPath.section];
    NSArray *kanjiForLevel  = [_kanjiByLevel objectForKey:levelKey];
    WKKanji *kanjiItem      = [kanjiForLevel objectAtIndex:indexPath.row];
    
    WKKanjiViewCell *cell   = [collectionView dequeueReusableCellWithReuseIdentifier:kKanjiCellIdentifier
                                                                        forIndexPath:indexPath];
    [cell setKanjiItem:kanjiItem];
    
    return cell;
}

@end
