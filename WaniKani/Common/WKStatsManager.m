//
//  WKStatsManager.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 4/03/13.
//
//

#import "WKStatsManager.h"

#import "WKRadical.h"
#import "WKKanji.h"
#import "WKVocab.h"

#import "NSArray+orderBy.h"
#import "TTTTimeIntervalFormatter.h"

@implementation WKStatsManager

+ (NSString *)nextReviewDateString {
    
    TTTTimeIntervalFormatter *timeIntervalFormatter;
    NSDate *closestDate     = [WKItem nextReviewDate];
    
    if ( !closestDate ) return @"";
    
    timeIntervalFormatter   = [[TTTTimeIntervalFormatter alloc] init];
    NSTimeInterval timeDiff = [closestDate timeIntervalSinceNow];
    
    return [timeIntervalFormatter stringForTimeInterval:timeDiff];
}

+ (NSArray *)combinedItemsWithSRSType:(WKItemSRSType)srsType {
    
    return [WKItem itemsWithSRSType:srsType];
}

+ (NSArray *)combinedCriticalItemsWithPercentage:(CGFloat)percentage {
    
    return [WKItem criticalItemsWithPercentage:percentage];
}

+ (NSArray *)combinedUnlockedItems {
        
    NSArray *items = [WKItem unlockedItems];
    
    NSSortDescriptor *descDateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"stats.unlockedDate"
                                                                         ascending:NO];
    NSRange maxResultItemsRange = NSMakeRange(0, MIN([items count], 10));
    return [[items orderByDescriptors:descDateDescriptor, nil] subarrayWithRange:maxResultItemsRange];
}

+ (NSArray *)combinedAvailableReviews {
    
    return [WKItem availableReviews];
}

@end
