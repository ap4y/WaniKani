//
//  WKVocabViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKVocabViewController.h"
#import "WKItemsHeaderView.h"
#import "WKVocabViewCell.h"
#import "WKVocab.h"

#import "WKCustomization.h"

@interface WKVocabViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *vocabCollectionView;

@property (strong, nonatomic) NSDictionary *vocabByLevel;
@end

@implementation WKVocabViewController

static NSString * const kVocabCellIdentifier        = @"WKVocabCell";
static NSString * const kVocabSuppViewIdentifier    = @"WKVocabSuppView";

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    NSArray *vocab      = [WKVocab requestResult:[WKVocab all] managedObjectContext:mainThreadContext()];
    self.vocabByLevel   = [WKItem itemsByLevel:vocab];
    
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"btn_vocab_pressed"]
                  withFinishedUnselectedImage:[UIImage imageNamed:@"btn_vocab_normal"]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WKCustomization setBackgroundForView:self.view];
    [_vocabCollectionView setBackgroundColor:[UIColor clearColor]];
        
    [WKVocab fetchVocabWithSuccess:^(NSArray *vocab) {
        
        self.vocabByLevel = [WKItem itemsByLevel:vocab];
        [_vocabCollectionView reloadData];
        
    } failure:^(NSError *error) {
        
        /**
         TODO: Add error handling
         */
        NSLog(@"%@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    UIImage *selectionImage = [WKCustomization resizableImageNamed:@"vocab_selection"
                                                     withCapInsets:UIEdgeInsetsMake(2.5f, 2.5f, 2.5f, 2.5f)];
    [self.tabBarController.tabBar setSelectionIndicatorImage:selectionImage];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_vocabByLevel count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSNumber *levelKey      = [[_vocabByLevel allKeys] objectAtIndex:section];
    NSArray *vocabForLevel  = [_vocabByLevel objectForKey:levelKey];
    
    return [vocabForLevel count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    WKItemsHeaderView *suppView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                     withReuseIdentifier:kVocabSuppViewIdentifier
                                                                            forIndexPath:indexPath];
    NSNumber *levelKey          = [[_vocabByLevel allKeys] objectAtIndex:indexPath.section];
    [suppView setItems:[WKVocab itemsForLevel:levelKey] level:levelKey];

    return suppView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *levelKey      = [[_vocabByLevel allKeys] objectAtIndex:indexPath.section];
    NSArray *vocabForLevel  = [_vocabByLevel objectForKey:levelKey];
    WKVocab *vocabItem      = [vocabForLevel objectAtIndex:indexPath.row];
    
    WKVocabViewCell *cell   = [collectionView dequeueReusableCellWithReuseIdentifier:kVocabCellIdentifier
                                                                        forIndexPath:indexPath];
    [cell setVocabItem:vocabItem];
    
    return cell;
}

@end
