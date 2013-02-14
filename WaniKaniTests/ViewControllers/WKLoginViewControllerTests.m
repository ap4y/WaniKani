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
@property (weak, nonatomic) IBOutlet UITextField *userKeyTextField;

- (IBAction)login:(id)sender;
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
    
    [super tearDown];
}

- (void)testLogin {
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
        return [OHHTTPStubsResponse responseWithFile:@"user_information.json"
                                         contentType:@"application/json"
                                        responseTime:0.0];
    }];
    _subject.userKeyTextField.text = @"1234";
    
    [AETestHelpers runAsyncTest:^(BOOL *endCondition) {
        
        [_subject login:nil];
        STAssertEqualObjects(@"1234", [WKHTTPClient sharedClient].userKey, nil);
        
    } interval:0.1];    
}

- (void)testPassLoginWithUserKey {
    [WKHTTPClient sharedClient].userKey = @"1234";        
    [_subject viewDidLoad];
}

@end
