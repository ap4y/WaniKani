//
//  WKItemStats.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKItemStats.h"
#import "WKItem.h"

@implementation WKItemStats
@dynamic srs;
@dynamic unlockedDate;
@dynamic availableDate;
@dynamic burned;
@dynamic burnedDate;
@dynamic meaningCorrect;
@dynamic meaningIncorrect;
@dynamic meaningMaxStreak;
@dynamic meaningCurrentStreak;
@dynamic readingCorrect;
@dynamic readingIncorrect;
@dynamic readingMaxStreak;
@dynamic readingCurrentStreak;
@dynamic item;

#pragma mark - entity settings

+ (NSDictionary *)propertyMappings {
    return @{
        @"unlockedDate":            @"unlocked_date",
        @"availableDate":           @"available_date",
        @"burnedDate":              @"burned_date",
        @"meaningCorrect":          @"meaning_correct",
        @"meaningIncorrect":        @"meaning_incorrect",
        @"meaningMaxStreak":        @"meaning_max_streak",
        @"meaningCurrentStreak":    @"meaning_current_streak",
        @"readingCorrect":          @"reading_correct",
        @"readingIncorrect":        @"reading_incorrect",
        @"readingMaxStreak":        @"reading_max_streak",
        @"readingCurrentStreak":    @"reading_current_streak"                
    };
}

@end
