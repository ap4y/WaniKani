//
//  WKRadicalCell.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 17/02/13.
//
//

#import <UIKit/UIKit.h>

@class WKRadical;
@interface WKRadicalViewCell : UICollectionViewCell
@property (copy, nonatomic) void (^cellViewTouched)();

- (void)setRadical:(WKRadical *)radical;
@end
