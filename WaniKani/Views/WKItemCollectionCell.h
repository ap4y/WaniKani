//
//  WKItemCollectionCell.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 2/03/13.
//
//

#import <UIKit/UIKit.h>

@class WKItem;
@interface WKItemCollectionCell : PSUICollectionViewCell
@property (copy, nonatomic) void (^cellViewTouched)();

- (void)setItem:(WKItem *)item;

@end
