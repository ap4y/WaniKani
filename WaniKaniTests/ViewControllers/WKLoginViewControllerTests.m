//
//  WKLoginViewControllerTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 14/02/13.
//
//

#import "WKLoginViewControllerTests.h"
#import "WKLoginViewController.h"

#import "WKTestHelpers.h"
#import "WKHTTPClient.h"

@interface WKLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)login:(id)sender;
- (void)checkApiKey:(NSString *)apiKey;
@end

@interface WKLoginViewControllerTests ()
@property (strong, nonatomic) WKLoginViewController *subject;
@property (strong, nonatomic) id partial;
@end

@implementation WKLoginViewControllerTests

- (void)setUp {
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    self.subject = [storyboard instantiateViewControllerWithIdentifier:@"WKLoginViewController"];
    [_subject loadView];
    
    self.partial = [OCMockObject partialMockForObject:_subject];
    [[_partial expect] performSegueWithIdentifier:@"WKRadicalsSegue" sender:OCMOCK_ANY];
}

- (void)tearDown {
    [_partial verify];
    [OHHTTPStubs removeAllRequestHandlers];
    [WKHTTPClient sharedClient].userKey = nil;
    
    [super tearDown];
}

- (void)testCheckApiKey {
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
        return [OHHTTPStubsResponse responseWithFile:@"user_information.json"
                                         contentType:@"application/json"
                                        responseTime:0.0];
    }];

    [AETestHelpers runAsyncTest:^(BOOL *endCondition) {
        
        [_subject checkApiKey:@"1234"];
        STAssertEqualObjects(@"1234", [WKHTTPClient sharedClient].userKey, nil);
        
    } interval:0.1];
    
    STAssertEqualObjects(@"f9e852694ab8a659d1edbf438c2bb4ea", [WKHTTPClient sharedClient].gravatarId, nil);    
}

- (void)testPassLoginWithUserKey {
    NSDictionary *properties = @{
        NSHTTPCookieOriginURL: [NSURL URLWithString:@"http://test.com"],
        NSHTTPCookieName: @"testCookies",
        NSHTTPCookieValue: @"1",
        NSHTTPCookiePath: @"/path"
    };
    NSHTTPCookie *loginCookie = [NSHTTPCookie cookieWithProperties:properties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:loginCookie];
    [WKHTTPClient sharedClient].userKey = @"1234";
    [_subject viewDidLoad];
}

@end
