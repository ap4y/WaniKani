//
//  WKKanjiTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKKanjiTests.h"
#import "WKKanji.h"

#import "WKTestHelpers.h"

@implementation WKKanjiTests

- (void)testFetchKanji {
    
    [WKTestHelpers stubHTTPRequestPassingTest:^BOOL(NSURLRequest *request) {
        NSString *url = [request URL].absoluteString;
        STAssertFalse([url rangeOfString:@"kanji"].location == NSNotFound, nil);
        STAssertEqualObjects(@"GET", [request HTTPMethod], nil);
        
        return YES;
    } responseJsonFileName:@"kanji"];
    
    BOOL isFinished = [AETestHelpers runAsyncTest:^(BOOL *endCondition) {
        
        [WKKanji fetchKanjiWithSuccess:^(NSArray *kanji) {
            
            STAssertEquals(18U, [kanji count], nil);
            
            NSPredicate *sevenPredicate = [NSPredicate predicateWithFormat:@"meaning == 'seven'"];
            WKKanji *seven = [[kanji filteredArrayUsingPredicate:sevenPredicate] lastObject];
            
            STAssertNotNil(seven, nil);
            
            STAssertEqualObjects(@"七",      seven.character,        nil);
            STAssertEqualObjects(@"seven",  seven.meaning,          nil);
            STAssertEqualObjects(@"しち",     seven.onyomi,           nil);
            STAssertEqualObjects(@"なな.*",   seven.kunyomi,          nil);
            STAssertEqualObjects(@"onyomi", seven.importantReading, nil);
            STAssertEqualObjects(@(1),      seven.level,            nil);
                        
            *endCondition = YES;
            
        } failure:^(NSError *error) {
            STFail(nil);
        }];
        
    } interval:0.1];
    
    STAssertTrue(isFinished, nil);
}

@end
