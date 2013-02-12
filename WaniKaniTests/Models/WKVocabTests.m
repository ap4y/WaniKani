//
//  WKVocabTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKVocabTests.h"
#import "WKVocab.h"

#import "WKTestHelpers.h"

@implementation WKVocabTests

- (void)testFetchVocab {
    
    [WKTestHelpers stubHTTPRequestPassingTest:^BOOL(NSURLRequest *request) {
        NSString *url = [request URL].absoluteString;
        STAssertFalse([url rangeOfString:@"vocabulary"].location == NSNotFound, nil);
        STAssertEqualObjects(@"GET", [request HTTPMethod], nil);
        
        return YES;
    } responseJsonFileName:@"vocabulary"];
    
    BOOL isFinished = [AETestHelpers runAsyncTest:^(BOOL *endCondition) {
        
        [WKVocab fetchVocabWithSuccess:^(NSArray *vocab) {
            
            STAssertEquals(41U, [vocab count], nil);
            
            NSPredicate *onePredicate = [NSPredicate predicateWithFormat:@"meaning == 'one'"];
            WKVocab *one = [[vocab filteredArrayUsingPredicate:onePredicate] lastObject];
            
            STAssertNotNil(one, nil);
            
            STAssertEqualObjects(@"一",      one.character,  nil);
            STAssertEqualObjects(@"one",    one.meaning,    nil);
            STAssertEqualObjects(@"いち",     one.kana,       nil);
            STAssertEqualObjects(@(1),      one.level,      nil);
            
            *endCondition = YES;
            
        } failure:^(NSError *error) {
            STFail(nil);
        }];
        
    } interval:0.1];
    
    STAssertTrue(isFinished, nil);
}

@end
