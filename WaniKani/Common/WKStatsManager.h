//
//  WKStatsManager.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 4/03/13.
//
//

#import <Foundation/Foundation.h>
#import "WKItem.h"

@interface WKStatsManager : NSObject

+ (NSString *)nextReviewDateString;
+ (NSArray *)combinedItemsWithSRSType:(WKItemSRSType)srsType;
+ (NSArray *)combinedCriticalItemsWithPercentage:(CGFloat)percentage;
+ (NSArray *)combinedUnlockedItems;

@end
