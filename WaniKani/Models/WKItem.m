//
//  WKItem.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKItem.h"
#import "WKItemStats.h"

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
