//
//  WKRadicalTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKRadicalTests.h"
#import "WKRadical.h"

#import "WKTestHelpers.h"

@implementation WKRadicalTests

- (void)testFetchRadicals {
    
    [WKTestHelpers stubHTTPRequestPassingTest:^BOOL(NSURLRequest *request) {
        NSString *url = [request URL].absoluteString;
        STAssertFalse([url rangeOfString:@"radicals"].location == NSNotFound, nil);
        STAssertEqualObjects(@"GET", [request HTTPMethod], nil);
        
        return YES;
    } responseJsonFileName:@"radicals"];
    
    BOOL isFinished = [AETestHelpers runAsyncTest:^(BOOL *endCondition) {
        
        [WKRadical fetchRadicalsWithSuccess:^(NSArray *radicals) {
            
            STAssertEquals(27U, [radicals count], nil);
            
            NSPredicate *groundPredicate = [NSPredicate predicateWithFormat:@"meaning == 'ground'"];
            WKRadical *ground = [[radicals filteredArrayUsingPredicate:groundPredicate] lastObject];
            
            STAssertNotNil(ground, nil);
            
            STAssertEqualObjects(@"一",      ground.character,   nil);
            STAssertEqualObjects(@"ground", ground.meaning,     nil);
            STAssertEqualObjects(@(1),      ground.level,       nil);
            
            STAssertNotNil(ground.stats, nil);
            
            *endCondition = YES;
            
        } failure:^(NSError *error) {
            STFail(nil);
        }];
        
    } interval:0.1];
    
    STAssertTrue(isFinished, nil);
}

@end
