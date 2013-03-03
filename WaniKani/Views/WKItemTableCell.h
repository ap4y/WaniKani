//
//  WKItemTableCell.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 24/02/13.
//
//

#import <UIKit/UIKit.h>

@class WKItem;
@interface WKItemTableCell : UITableViewCell
- (void)setItem:(WKItem *)item;
- (void)setDetailsText:(NSString *)detailsText;
@end
