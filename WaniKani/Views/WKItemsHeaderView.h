//
//  WKItemsHeaderView.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 17/02/13.
//
//

#import <UIKit/UIKit.h>

@interface WKItemsHeaderView : UICollectionReusableView
@property (copy, nonatomic) void (^headerViewTouched)();

- (void)setItems:(NSArray *)items level:(NSNumber *)level;

@end
