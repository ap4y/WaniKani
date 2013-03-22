//
//  WKItem.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKItem.h"
#import "WKItemStats.h"

#import "NSArray+orderBy.h"

@implementation WKItem
@dynamic id;
@dynamic character;
@dynamic level;
@dynamic synchronizedAt;
@dynamic stats;

- (NSString *)meaning {
    return self.id;
}

+ (NSArray *)itemsWithSRSType:(WKItemSRSType)srsType {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stats.srs == %@", WKItemSRSTypeStrings[srsType]];
    return [self requestResult:[self where:predicate] managedObjectContext:mainThreadContext()];
}

+ (NSPredicate *)completedItemsPredicate {
    
    NSArray *completedSRSTypes = @[
       WKItemSRSTypeStrings[WKItemSRSGuru],
       WKItemSRSTypeStrings[WKItemSRSMaster],
       WKItemSRSTypeStrings[WKItemSRSEnlighten]
    ];
    return [NSPredicate predicateWithFormat:@"stats.srs IN %@", completedSRSTypes];
}

+ (NSArray *)completedItems {
    
    return [self requestResult:[self where:[self completedItemsPredicate]] managedObjectContext:mainThreadContext()];
}

+ (NSArray *)unlockedItems {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stats.unlockedDate != nil"];
    return [self requestResult:[[self where:predicate] orderBy:@"stats.unlockedDate", nil]
          managedObjectContext:mainThreadContext()];
}

+ (NSArray *)criticalItemsWithPercentage:(CGFloat)percentage {

    NSString *predicateString;
    predicateString = @"stats.srs == 'apprentice' && ( stats.meaningIncorrect > 0 || stats.readingIncorrect > 0 )";
        
    NSPredicate *predicate      = [NSPredicate predicateWithFormat:predicateString];
    NSArray *criticalItems      = [self requestResult:[self where:predicate] managedObjectContext:mainThreadContext()];

    NSPredicate *percentagePredicate = [NSPredicate predicateWithFormat:@"stats.combinedCorrectPercentage < %f",
                                        percentage/100.0f];
    
    return [criticalItems filteredArrayUsingPredicate:percentagePredicate];
}

+ (NSArray *)availableReviews {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stats.availableDate <= %f",
                              [[NSDate date] timeIntervalSince1970]];
    return [self requestResult:[self where:predicate] managedObjectContext:mainThreadContext()];
}

+ (NSDate *)nextReviewDate {
    
    NSPredicate *predicate      = [NSPredicate predicateWithFormat:@"stats.availableDate != nil"];
    WKItem *latestAvailableItem = [self requestFirstResult:[[self where:predicate] orderBy:@"stats.availableDate", nil]
                                      managedObjectContext:mainThreadContext()];
    NSNumber *availableDate     = latestAvailableItem.stats.availableDate;
    
    return ( availableDate ? [NSDate dateWithTimeIntervalSince1970:[availableDate doubleValue]] : nil );
}

+ (NSDictionary *)itemsByLevel:(NSArray *)radicals {
    
    NSMutableDictionary *radicalsByLevel = [NSMutableDictionary dictionary];
    
    NSArray *levels = [radicals valueForKeyPath:@"@distinctUnionOfObjects.level"];
    [levels enumerateObjectsUsingBlock:^(NSNumber *level, NSUInteger idx, BOOL *stop) {
        
        NSPredicate *levelPredicate = [NSPredicate predicateWithFormat:@"level == %@", level];
        [radicalsByLevel setObject:[[radicals filteredArrayUsingPredicate:levelPredicate] orderBy:@"meaning", nil]
                            forKey:level];
    }];
    
    return radicalsByLevel;
}

+ (NSArray *)itemsForLevel:(NSNumber *)level {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"level == %@", level];
    return [self requestResult:[self where:predicate] managedObjectContext:mainThreadContext()];
}

#pragma mark - entity settings

- (void)updateFromJSONObject:(id)jsonObject withRelations:(BOOL)withRelations {
    [super updateFromJSONObject:jsonObject withRelations:withRelations];
    
    self.synchronizedAt = [NSDate date];
}

+ (NSString *)jsonRoot {
    return @"requested_information";
}

+ (NSDictionary *)propertyMappings {
    return @{ @"id": @"meaning" };
}

@end
