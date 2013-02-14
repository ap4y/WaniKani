//
//  WKRadicalsViewControllerTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 14/02/13.
//
//

#import "WKRadicalsViewControllerTests.h"
#import "WKRadicalsViewController.h"
#import "WKRadical.h"

#import "WKTestHelpers.h"

@interface WKRadicalsViewController ()
@property (strong, nonatomic) NSArray *radicals;
@end

@interface WKRadicalsViewControllerTests ()
@property (strong, nonatomic) WKRadicalsViewController *subject;
@property (strong, nonatomic) WKRadical *radical;
@end

@implementation WKRadicalsViewControllerTests

- (void)setUp {
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    self.subject = [storyboard instantiateViewControllerWithIdentifier:@"WKRadicalsViewController"];
    [_subject loadView];
    
    NSArray *radicals = [WKRadical requestResult:[WKRadical all] managedObjectContext:mainThreadContext()];
    [radicals enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [mainThreadContext() deleteObject:obj];
    }];
    
    self.radical  = [NSEntityDescription insertNewObjectForEntityForName:@"WKRadical"
                                                  inManagedObjectContext:mainThreadContext()];
    _radical.id         = @"ground";
    _radical.character  = @"一";
}

- (void)tearDown {
    [OHHTTPStubs removeAllRequestHandlers];
    
    [super tearDown];
}

- (void)testFetchRadicals {
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
        return [OHHTTPStubsResponse responseWithFile:@"radicals.json"
                                         contentType:@"application/json"
                                        responseTime:0.0];        
    }];
    
    [AETestHelpers runAsyncTest:^(BOOL *endCondition) {
        
        [_subject viewDidLoad];
        STAssertEqualObjects(@[ _radical ], _subject.radicals, nil);
        
    } interval:0.1];
    
    STAssertEquals(27U, [_subject.radicals count], nil);
}

@end
