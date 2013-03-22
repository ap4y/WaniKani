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
    NSRange maxResultItemsRange = NSMakeRange(0, MIN([result count], 10));
    return [[result orderByDescriptors:descDateDescriptor, nil] subarrayWithRange:maxResultItemsRange];
}

+ (NSArray *)combinedAvailableReviews {
    
    NSArray *radicals   = [WKRadical availableReviews];
    NSArray *kanji      = [WKKanji availableReviews];
    NSArray *vocab      = [WKVocab availableReviews];
    
    NSMutableArray *result = [NSMutableArray array];
    [result addObjectsFromArray:radicals];
    [result addObjectsFromArray:kanji];
    [result addObjectsFromArray:vocab];
    
    return result;
}

@end
