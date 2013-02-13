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

- (void)testRadicalsWithSRSType {
    
    STAssertEquals(23U, [[WKRadical itemsWithSRSType:WKItemSRSApprentice] count],   nil);
    STAssertEquals(1U,  [[WKRadical itemsWithSRSType:WKItemSRSEnlighten] count],    nil);
    STAssertEquals(1U,  [[WKRadical itemsWithSRSType:WKItemSRSGuru] count],         nil);
    STAssertEquals(1U,  [[WKRadical itemsWithSRSType:WKItemSRSMaster] count],       nil);
    STAssertEquals(1U,  [[WKRadical itemsWithSRSType:WKItemSRSBurned] count],       nil);
}

- (void)testRadicalsWithCompletedProgress {
    
    STAssertEquals(3U, [[WKRadical completedItems] count], nil);
}

- (void)testUnlockedRadicals {
    
    STAssertEquals(27U, [[WKRadical unlockedItems] count], nil);
}

- (void)testRadicalsWithCriticalPercentage {
    
    STAssertEquals(3U, [[WKRadical criticalItemsWithPercentage:95.0] count], nil);
}

- (void)testNextReviewDate {
    
    STAssertEqualObjects([NSDate dateWithTimeIntervalSince1970:1360734768], [WKRadical nextReviewDate], nil);
}

@end
