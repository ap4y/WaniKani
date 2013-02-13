//
//  WKItem.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKItemStats.h"

@interface WKItem : AEManagedObject
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *character;
@property (strong, nonatomic) NSNumber *level;
@property (strong, nonatomic) NSDate *synchronizedAt;
@property (strong, nonatomic) WKItemStats *stats;

- (NSString *)meaning;

+ (NSArray *)itemsWithSRSType:(WKItemSRSType)srsType;
+ (NSArray *)completedItems;
+ (NSArray *)unlockedItems;
+ (NSArray *)criticalItemsWithPercentage:(CGFloat)percentage;

@end
