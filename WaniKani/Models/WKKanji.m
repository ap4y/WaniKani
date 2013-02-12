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

+ (void)fetchKanjiWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    [WKKanji fetchWithClient:[WKHTTPClient sharedClient]
                        path:@"/kanji"
                  parameters:nil
                     success:success
                     failure:failure];
    
}

#pragma mark - entity settings

+ (NSDictionary *)propertyMappings {
    return @{ @"importantReading": @"important_reading" };
}

@end
