//
//  WKItemViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 2/03/13.
//
//

#import "WKItemViewController.h"
#import "WKItemsHeaderView.h"
#import "WKItemCollectionCell.h"
#import "WKItem.h"
#import "WKSyncManager.h"

#import "WKCustomization.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "PSTCollectionView.h"

@interface WKItemViewController ()
@property (strong, nonatomic) NSDictionary *itemsByLevel;
@property (strong, nonatomic) NSMutableDictionary *collapsedItemsByLevel;
@end

@implementation WKItemViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    if (![[self itemClass] isSubclassOfClass:[WKItem class]]) return nil;

    self.collapsedItemsByLevel  = [NSMutableDictionary dictionary];
    [self updateItemCollectionsWithCollapsedRefresh:NO];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:WKSyncMangerDidSyncNotification
                                                      object:[WKSyncManager sharedManager]
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      [_itemsCollectionView.pullToRefreshView stopAnimating];
                                                      [self updateItemCollectionsWithCollapsedRefresh:YES];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:WKSyncMangerDidFailNotification
                                                      object:[WKSyncManager sharedManager]
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      [_itemsCollectionView.pullToRefreshView stopAnimating];
                                                      /**
                                                       TODO: Handle error situation
                                                       */
                                                      NSLog(@"%@", [[note userInfo] valueForKey:WKSyncMangerFailErrorKey]);
                                                  }];
    
    [[WKSyncManager sharedManager] fetchItems];    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WKCustomization setBackgroundForView:self.view];
    [_itemsCollectionView setBackgroundColor:[UIColor clearColor]];    
    [_itemsCollectionView addPullToRefreshWithActionHandler:^{
       
        [[WKSyncManager sharedManager] fetchItems];
    }];
}

#pragma mark - private

- (void)updateItemCollectionsWithCollapsedRefresh:(BOOL)withCollapsedRefresh {
    
    Class itemClass         = [self itemClass];
    NSArray *items          = [itemClass requestResult:[itemClass all] managedObjectContext:mainThreadContext()];
    self.itemsByLevel       = [WKItem itemsByLevel:items];
    
    [[_itemsByLevel allKeys] enumerateObjectsUsingBlock:^(id levelKey, NSUInteger idx, BOOL *stop) {
        
        if (withCollapsedRefresh) {
            
            if ([_collapsedItemsByLevel objectForKey:levelKey]) {
                
                [_collapsedItemsByLevel setObject:[_itemsByLevel objectForKey:levelKey] forKey:levelKey];
            }
            
        } else {
            
            if (idx == 0) {
                
                [_collapsedItemsByLevel setObject:[_itemsByLevel objectForKey:levelKey] forKey:levelKey];
                
            } else {
                
                [_collapsedItemsByLevel setValue:nil forKey:levelKey];
            }
        }
    }];
    
    if (withCollapsedRefresh) [_itemsCollectionView reloadData];
}

- (void)configureCollectionItemCell:(WKItemCollectionCell *)cell forItem:(WKItem *)item {
    
    __weak WKItemCollectionCell *weakCell = cell;
    [cell setItem:item];
    [cell setCellViewTouched:^{
        
        [self performSegueWithIdentifier:[self detailsSegueIdentifier] sender:weakCell];
    }];
}

#pragma mark - controller setting

- (Class)itemClass {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:NSLocalizedString(@"Override this method in concrete class", nil)
                                 userInfo:nil];
}

- (NSString *)collectionItemSupplementaryViewIdentifier {

    return @"";
}

- (NSString *)collectionItemCellViewIdentifier {
    
    return @"";
}

- (NSString *)detailsSegueIdentifier {
    
    return @"";
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView {
    return [_itemsByLevel count];
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSNumber *levelKey          = [[_itemsByLevel allKeys] objectAtIndex:section];
    NSArray *itemsForLevel      = [_collapsedItemsByLevel objectForKey:levelKey];
    
    return [itemsForLevel count];
}

- (PSUICollectionReusableView *)collectionView:(PSUICollectionView *)collectionView
             viewForSupplementaryElementOfKind:(NSString *)kind
                                   atIndexPath:(NSIndexPath *)indexPath {
    
    NSString *suppIdentifier    = [self collectionItemSupplementaryViewIdentifier];
    WKItemsHeaderView *suppView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                     withReuseIdentifier:suppIdentifier
                                                                            forIndexPath:indexPath];
    NSNumber *levelKey          = [[_itemsByLevel allKeys] objectAtIndex:indexPath.section];
    [suppView setItems:[[self itemClass] itemsForLevel:levelKey] level:levelKey];
    [suppView setHeaderViewTouched:^{
        
        if (![_collapsedItemsByLevel objectForKey:levelKey]) {
            
            [_collapsedItemsByLevel setObject:[_itemsByLevel objectForKey:levelKey] forKey:levelKey];
            [collectionView reloadData];
            [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]
                                   atScrollPosition:PSTCollectionViewScrollPositionBottom
                                           animated:YES];
        } else {
            
            [_collapsedItemsByLevel setValue:nil forKey:(id)levelKey];
            [collectionView reloadData];
        }
    }];
    
    return suppView;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView
                    cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *levelKey          = [[_itemsByLevel allKeys] objectAtIndex:indexPath.section];
    NSArray *itemsForLevel      = [_itemsByLevel objectForKey:levelKey];
    WKItem *item                = [itemsForLevel objectAtIndex:indexPath.row];
    
    NSString *cellIdentifier    = [self collectionItemCellViewIdentifier];
    WKItemCollectionCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                            forIndexPath:indexPath];
    [self configureCollectionItemCell:cell forItem:item];
    
    return cell;
}

@end
