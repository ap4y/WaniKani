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
#import "WKRadical.h"
#import "WKKanji.h"
#import "WKVocab.h"

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

+ (NSArray *)completedItems {
    
    NSArray *completedSRSTypes = @[
        WKItemSRSTypeStrings[WKItemSRSGuru],
        WKItemSRSTypeStrings[WKItemSRSMaster],
        WKItemSRSTypeStrings[WKItemSRSEnlighten]
    ];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stats.srs IN %@", completedSRSTypes];
    return [self requestResult:[self where:predicate] managedObjectContext:mainThreadContext()];
}

+ (NSArray *)unlockedItems {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stats.unlockedDate != nil"];
    return [self requestResult:[[self where:predicate] orderBy:@"stats.unlockedDate", nil]
          managedObjectContext:mainThreadContext()];
}

+ (NSArray *)criticalItemsWithPercentage:(CGFloat)percentage {

    NSString *predicateString   = @"stats.meaningIncorrect > 0 OR stats.readingIncorrect > 0";
    NSPredicate *predicate      = [NSPredicate predicateWithFormat:predicateString];
    NSArray *criticalItems      = [self requestResult:[self where:predicate]
                                 managedObjectContext:mainThreadContext()];
    
    NSPredicate *percentagePredicate = [NSPredicate predicateWithBlock:^BOOL(WKItem *item, NSDictionary *bindings) {
        
        CGFloat meaningCorrect, meaningIncorrect, meaningPercentage,
                readingCorrect, readingIncorrect, readingPercentage;
        
        meaningCorrect      = item.stats.meaningCorrect.floatValue;
        meaningIncorrect    = item.stats.meaningIncorrect.floatValue;
        readingCorrect      = item.stats.readingCorrect.floatValue;
        readingIncorrect    = item.stats.readingIncorrect.floatValue;
        
        meaningPercentage   = meaningCorrect/(meaningCorrect + meaningIncorrect);
        readingPercentage   = readingCorrect/(readingCorrect + readingIncorrect);
        
        return ( meaningPercentage <= percentage/100.0 ) || ( readingPercentage <= percentage/100.0 );
    }];
    
    return [criticalItems filteredArrayUsingPredicate:percentagePredicate];
}

+ (NSArray *)availableReviews {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stats.availableDate <= %f",
                              [[NSDate date] timeIntervalSince1970]];
    return [self requestResult:[self where:predicate] managedObjectContext:mainThreadContext()];
}

+ (NSDate *)nextReviewDate {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stats.availableDate != nil"];
    WKItem *latestAvailableItem = [self requestFirstResult:[[self where:predicate] orderBy:@"stats.availableDate", nil]
                                      managedObjectContext:mainThreadContext()];
    
    return [NSDate dateWithTimeIntervalSince1970:[latestAvailableItem.stats.availableDate doubleValue]];
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

+ (NSString *)nextReviewDateString {

    NSDateFormatter *localDateFormatter;
    NSArray *reviewDates    = @[ [WKRadical nextReviewDate], [WKKanji nextReviewDate], [WKVocab nextReviewDate] ];
    NSDate *closestDate     = [[reviewDates orderBy:@"self", nil] objectAtIndex:0];
    localDateFormatter      = [[NSDateFormatter alloc] init];
    [localDateFormatter setDateFormat:@"eeee 'at' HH:mm"];
    
    return [localDateFormatter stringFromDate:closestDate];
}

+ (NSArray *)combinedItemsWithSRSType:(WKItemSRSType)srsType {

    NSArray *radicals   = [WKRadical itemsWithSRSType:srsType];
    NSArray *kanji      = [WKKanji itemsWithSRSType:srsType];
    NSArray *vocab      = [WKVocab itemsWithSRSType:srsType];
    
    NSMutableArray *result = [NSMutableArray array];
    [result addObjectsFromArray:radicals];
    [result addObjectsFromArray:kanji];
    [result addObjectsFromArray:vocab];
        
    return result;
}

+ (NSArray *)combinedCriticalItemsWithPercentage:(CGFloat)percentage {
    
    NSArray *radicals   = [WKRadical criticalItemsWithPercentage:percentage];
    NSArray *kanji      = [WKKanji criticalItemsWithPercentage:percentage];
    NSArray *vocab      = [WKVocab criticalItemsWithPercentage:percentage];
    
    NSMutableArray *result = [NSMutableArray array];
    [result addObjectsFromArray:radicals];
    [result addObjectsFromArray:kanji];
    [result addObjectsFromArray:vocab];
    
    return result;
}

+ (NSArray *)combinedUnlockedItems {
    
    NSArray *radicals   = [WKRadical unlockedItems];
    NSArray *kanji      = [WKKanji unlockedItems];
    NSArray *vocab      = [WKVocab unlockedItems];
    
    NSMutableArray *result = [NSMutableArray array];
    [result addObjectsFromArray:radicals];
    [result addObjectsFromArray:kanji];
    [result addObjectsFromArray:vocab];
    
    NSSortDescriptor *descDateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"stats.unlockedDate"
                                                                         ascending:NO];
    return [[result orderByDescriptors:descDateDescriptor, nil] subarrayWithRange:NSMakeRange(0, 10)];
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
