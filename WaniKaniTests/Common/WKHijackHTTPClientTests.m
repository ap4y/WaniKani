//
//  WKHijackHTTPClientTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 16/03/13.
//
//

#import "WKHijackHTTPClientTests.h"
#import "WKHijackHTTPClient.h"

#import "WKTestHelpers.h"

@interface WKHijackHTTPClient ()
@property (strong, nonatomic) NSString *csrfToken;
@end

@interface WKHijackHTTPClientTests ()
@property (strong, nonatomic) WKHijackHTTPClient *subject;
@end

@implementation WKHijackHTTPClientTests

- (void)setUp {
    [super setUp];
    
    self.subject        = [[WKHijackHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://test.com"]];
    _subject.csrfToken  = @"1234";
}

- (void)tearDown {
    [OHHTTPStubs removeAllRequestHandlers];
    
    [super tearDown];
}

- (void)testShouldLoginWithUsernameAndPassword {
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
       return [OHHTTPStubsResponse responseWithFile:@"api.html"
                                        contentType:@"text/html"
                                       responseTime:0.0];
    }];
    
    BOOL isFinished = [AETestHelpers runAsyncTest:^(BOOL *endCondition) {
        
        [_subject loginWithUsername:@"login" password:@"password" remember:YES success:^(NSString *apiKey) {
            
            STAssertEqualObjects(@"12345", apiKey, nil);
            
            *endCondition = YES;
        } failure:^(NSError *error) {
            STFail(nil);
        }];
        
    } interval:0.1];
    
    STAssertTrue(isFinished, nil);
}

- (void)testShouldStartReviewSession {
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
        return [OHHTTPStubsResponse responseWithFile:@"session.html"
                                         contentType:@"text/html"
                                        responseTime:0.0];
    }];
    
    BOOL isFinished = [AETestHelpers runAsyncTest:^(BOOL *endCondition) {
        
        [_subject startReviewSessionWithSuccess:^(NSDictionary *question) {
            
            STAssertNotNil(question, nil);
            NSDictionary *expected = @{
                @"info": @{
                    @"character": @"ラ",
                    @"image": @"",
                    @"name": @"Ra",
                    @"name_mnemonic": @"This radical looks just like the katakana character \"ra\" (ラ). The sound \"ra\" sounds just like the famous Egyptian God \"Ra\" as well, so we're going to say this radical represents Egypt's God <span class=\"radical-highlight\">Ra</span>.",
                    @"related_items": @[]
                },
                @"item": @"r:85",
                @"q": @"m"
            };
            STAssertEqualObjects(expected, question, nil);
            STAssertEqualObjects(@"1g6n4kSL0WYcHb5OuP/1IFkIcmHTsRIVDyyLcVkhcgY=", _subject.csrfToken, nil);
            
            *endCondition = YES;
        } failure:^(NSError *error) {
            STFail(nil);
        }];
        
    } interval:0.1];
    
    STAssertTrue(isFinished, nil);
}

- (void)testShouldFetchReviewQuestions {
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
        return [OHHTTPStubsResponse responseWithFile:@"question.html"
                                         contentType:@"text/javascript"
                                        responseTime:0.0];
    }];
    
    BOOL isFinished = [AETestHelpers runAsyncTest:^(BOOL *endCondition) {
        
        [_subject fetchReviewQuestionWithSuccess:^(NSDictionary *question) {
            
            STAssertNotNil(question, nil);
            NSDictionary *expected = @{
                @"info": @{
                    @"character": @"幺",
                    @"image": @"",
                    @"name": @"Poop",
                    @"name_mnemonic": @"You have the pile radical (ム), then you have something that's taller (this one). The taller pile is a little grosser. Why? Because it's a stinking pile of <span class=\"radical-highlight\">poop</span>. We can only hope it's not human...",
                    @"related_items": @[]
                },
                @"item": @"r:121",
                @"q": @"m"
            };
            STAssertEqualObjects(expected, question, nil);
            
            *endCondition = YES;
        } failure:^(NSError *error) {
            STFail(nil);
        }];
        
    } interval:0.1];
    
    STAssertTrue(isFinished, nil);
}

- (void)testShouldPostReviewAnswer {
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
        
        return [OHHTTPStubsResponse responseWithFile:@"answer.html"
                                         contentType:@"text/javascript"
                                        responseTime:0.0];
    }];
 
    BOOL isFinished = [AETestHelpers runAsyncTest:^(BOOL *endCondition) {
        
        [_subject putReviewAnswerForItem:@"r:100" answer:@"answer" success:^(NSDictionary *answer) {
            
            STAssertNotNil(answer, nil);
            NSDictionary *expected = @{
                @"item": @"r:85",
                @"q": @"m",
                @"result": @{
                    @"available_count": @(21),
                    @"completed_count": @(1),
                    @"correct": @(1),
                    @"percentage": @(100),
                    @"stat": @{
                        @"incorrect_count": @(0),
                        @"previous_srs": @(4),
                        @"srs": @[ @(5), @"guru" ]
                    }
                }
            };
            STAssertEqualObjects(expected, answer, nil);
            
            *endCondition = YES;
        } failure:^(NSError *error) {
            STFail(nil);
        }];
        
    } interval:0.1];
    
    STAssertTrue(isFinished, nil);
}

@end
