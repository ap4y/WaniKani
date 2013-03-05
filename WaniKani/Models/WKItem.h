//
//  WKItem.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import <CoreData/CoreData.h>
#import "AEManagedObject.h"

#import "WKHTTPClient.h"
#import "AEManagedObject+AEJSONSerialization.h"
#import "AEManagedObject+AERemoteFetch.h"

typedef enum : NSUInteger {
    WKItemSRSApprentice = 0,
    WKItemSRSGuru,
    WKItemSRSMaster,
    WKItemSRSEnlighten,
    WKItemSRSBurned
} WKItemSRSType;

static NSString * const WKItemSRSTypeStrings[] = {
    @"apprentice",
    @"guru",
    @"master",
    @"enlighten",
    @"burned"
};

@class WKItemStats;
@interface WKItem : AEManagedObject
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *character;
@property (strong, nonatomic) NSNumber *level;
@property (strong, nonatomic) NSDate *synchronizedAt;
@property (strong, nonatomic) WKItemStats *stats;

- (NSString *)meaning;

+ (NSArray *)itemsWithSRSType:(WKItemSRSType)srsType;
+ (NSPredicate *)completedItemsPredicate;
+ (NSArray *)completedItems;
+ (NSArray *)unlockedItems;
+ (NSArray *)criticalItemsWithPercentage:(CGFloat)percentage;
+ (NSArray *)availableReviews;
+ (NSDate *)nextReviewDate;
+ (NSDictionary *)itemsByLevel:(NSArray *)radicals;
+ (NSArray *)itemsForLevel:(NSNumber *)level;

@end
