//
//  WKItemViewController.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 2/03/13.
//
//

#import <UIKit/UIKit.h>

@class WKItem;
@interface WKItemViewController : PSUICollectionViewController
@property (strong, nonatomic) IBOutlet PSUICollectionView *itemsCollectionView;
@property (strong, nonatomic, readonly) NSDictionary *itemsByLevel;

- (Class)itemClass;
- (NSString *)collectionItemSupplementaryViewIdentifier;
- (NSString *)collectionItemCellViewIdentifier;
- (NSString *)detailsSegueIdentifier;

@end
