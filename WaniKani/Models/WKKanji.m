//
//  WKKanji.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKKanji.h"

@implementation WKKanji
@dynamic onyomi;
@dynamic kunyomi;
@dynamic importantReading;

#pragma mark - entity settings

+ (NSDictionary *)propertyMappings {
    return @{ @"importantReading": @"important_reading" };
}

@end
