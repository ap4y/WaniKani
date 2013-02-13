//
//  WKLoginViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKLoginViewController.h"
#import "WKHTTPClient.h"

@interface WKLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userKeyTextField;
@end

@implementation WKLoginViewController

static NSString * const kRadicalsSegueIdentifier = @"WKRadicalsSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([WKHTTPClient sharedClient].userKey) {
        
        [self performSegueWithIdentifier:kRadicalsSegueIdentifier sender:self]; 
    }
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
