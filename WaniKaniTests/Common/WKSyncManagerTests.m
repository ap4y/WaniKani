//
//  WKSyncManagerTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 6/03/13.
//
//

#import "WKSyncManagerTests.h"
#import "WKSyncManager.h"

#import "WKTestHelpers.h"

@interface WKSyncManager ()
- (void)createLocalNotification;
@end

@interface WKSyncManagerTests ()
@property (strong, nonatomic) WKSyncManager *subject;
@end

@implementation WKSyncManagerTests

- (void)setUp {
    [super setUp];
    
    [OHHTTPStubs shouldStubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return ([[request.URL absoluteString] rangeOfString:@"radicals"].location != NSNotFound);
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFile:@"radicals.json"
                                         contentType:@"application/json"
                                        responseTime:0.0];
    }];
    [OHHTTPStubs shouldStubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return ([[request.URL absoluteString] rangeOfString:@"kanji"].location != NSNotFound);
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFile:@"kanji.json"
                                         contentType:@"application/json"
                                        responseTime:0.0];
    }];
    [OHHTTPStubs shouldStubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return ([[request.URL absoluteString] rangeOfString:@"vocabulary"].location != NSNotFound);
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFile:@"vocabulary.json"
                                         contentType:@"application/json"
                                        responseTime:0.0];
    }];
    
    self.subject = [[WKSyncManager alloc] init];
}

- (void)tearDown {
    [OHHTTPStubs removeAllRequestHandlers];
    [super tearDown];
}

- (void)testShouldNotRunTwoSyncOperations {
    
    STAssertTrue([_subject fetchItems], nil);
    STAssertFalse([_subject fetchItems], nil);
}

- (void)testShouldPostNotification {
    
    __block BOOL notificationReceived = NO;
    [[NSNotificationCenter defaultCenter] addObserverForName:WKSyncMangerDidSyncNotification
                                                      object:_subject
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      notificationReceived = YES;
                                                  }];
    [AETestHelpers runAsyncTest:^(BOOL *endCondition) {
        
        [_subject fetchItems];
        
    } interval:0.5];
    
    STAssertTrue(notificationReceived, nil);
}

- (void)testShouldCreateLocalNotification {
    
    id partial = [OCMockObject partialMockForObject:_subject];
    [[partial expect] createLocalNotification];
    
    [AETestHelpers runAsyncTest:^(BOOL *endCondition) {
        
        [_subject fetchItems];
        
    } interval:0.5];
    
    [partial verify];
}

@end
