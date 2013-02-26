//
//  WKLoginViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKLoginViewController.h"
#import "WKHTTPClient.h"
#import "WKCustomization.h"

@interface WKLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userKeyTextField;
@end

@implementation WKLoginViewController

static NSString * const kRadicalsSegueIdentifier = @"WKRadicalsSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WKCustomization setBackgroundForView:self.view];
    
    if ([WKHTTPClient sharedClient].userKey) {
        
        [self performSegueWithIdentifier:kRadicalsSegueIdentifier sender:self]; 
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_userKeyTextField becomeFirstResponder];
}

- (IBAction)showKeyInfo:(id)sender {
    
    NSURL *apiInfoUrl = [NSURL URLWithString:@"http://www.wanikani.com/api"];
    [[UIApplication sharedApplication] openURL:apiInfoUrl];
}

- (IBAction)login:(id)sender {
    
    if ([_userKeyTextField.text length] <= 0) {        
        /**
         TODO: Handle error situation
         */
        return;
    }

    WKHTTPClient *client    = [WKHTTPClient sharedClient];
    client.userKey          = _userKeyTextField.text;
    
    [client pingRequestWithSuccess:^{
        
        [self performSegueWithIdentifier:kRadicalsSegueIdentifier sender:self]; 
        
    } failure:^(NSError *error) {
        /**
         TODO: Handle error situation
         */
        NSLog(@"%@", error);
        client.userKey = nil;
    }];
}

@end
