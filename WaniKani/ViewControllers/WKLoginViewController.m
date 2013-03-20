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
#import "WKHijackHTTPClient.h"

#import "SVProgressHUD.h"
#import "AEAlert.h"

@interface WKLoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation WKLoginViewController

static NSString * const kRadicalsSegueIdentifier = @"WKRadicalsSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WKCustomization setBackgroundForView:self.view];
    
    if ([WKHTTPClient sharedClient].userKey && [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] count] > 0) {
        
        [self performSegueWithIdentifier:kRadicalsSegueIdentifier sender:self]; 
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_userNameTextField becomeFirstResponder];
}

- (IBAction)login:(id)sender {
    
    if ([_userNameTextField.text length] <= 0) {
        
        [AEAlert composeAlertViewWithTitle:NSLocalizedString(@"Error", nil)
                                andMessage:NSLocalizedString(@"Username can't be empty.", nil)];
        return;
    }

    if ([_passwordTextField.text length] <= 0) {
        
        [AEAlert composeAlertViewWithTitle:NSLocalizedString(@"Error", nil)
                                andMessage:NSLocalizedString(@"Password can't be empty.", nil)];
        return;
    }

    WKHijackHTTPClient *hijackClient = [WKHijackHTTPClient sharedClient];

    [SVProgressHUD showProgress:0.0f status:NSLocalizedString(@"Processing...", nil)];
    [hijackClient loginWithUsername:_userNameTextField.text
                           password:_passwordTextField.text
                           remember:YES success:^(NSString *apiKey) {
                              
                               [SVProgressHUD showProgress:0.5f
                                                    status:NSLocalizedString(@"Requesting API key...", nil)];
                               [self checkApiKey:apiKey];
                               
                           } failure:^(NSError *error) {
                               
                               [SVProgressHUD dismiss];
                               NSString *errorMessage = NSLocalizedString(@"Unable to login. Please check input.", nil);
                               [AEAlert composeAlertViewWithTitle:NSLocalizedString(@"Error", nil)
                                                       andMessage:errorMessage];
                               
                           }];
}

#pragma mark - private

- (void)checkApiKey:(NSString *)apiKey {
    
    WKHTTPClient *client    = [WKHTTPClient sharedClient];
    client.userKey          = apiKey;
    [client pingRequestWithSuccess:^(id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Success!", nil)];
        client.gravatarId   = [responseObject valueForKeyPath:@"user_information.gravatar"];
        [self performSegueWithIdentifier:kRadicalsSegueIdentifier sender:self];
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD show];
        [AEAlert composeAlertViewWithTitle:NSLocalizedString(@"Error", nil)
                                andMessage:NSLocalizedString(@"Unable to connect. Please check your API key.", nil)];
        client.userKey = nil;
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField  {
    
    UITextField *nextTextField = (UITextField *)[self.view viewWithTag:( textField.tag + 1 )];
    if (nextTextField) {
     
        [nextTextField becomeFirstResponder];
        
    } else {
        
        [self login:nil];
    }
    
    return YES;
}

@end
