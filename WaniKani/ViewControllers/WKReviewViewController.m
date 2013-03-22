//
//  WKReviewViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 16/03/13.
//
//

#import "WKReviewViewController.h"

#import "WKCustomization.h"
#import "WKHijackHTTPClient.h"
#import "WKCorrectAnswerView.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"
#import "WKSyncManager.h"
#import "WKStatsManager.h"

@interface WKReviewViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *answerTextField;
@property (weak, nonatomic) IBOutlet UILabel *availableIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkMarkIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentageIconLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
@property (weak, nonatomic) IBOutlet WKCorrectAnswerView *correctAnswerView;
@property (weak, nonatomic) IBOutlet UIImageView *characterImage;

@property (strong, nonatomic) NSString *currentItemId;
@property (nonatomic) BOOL questionAnswered;
@property (nonatomic) NSUInteger availableCount;
@end

@implementation WKReviewViewController

static const NSTimeInterval kAnimationDuration = 0.2;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    [self.tabBarItem setTitle:@""];
    [self updateReviewsCountImage];
    [[NSNotificationCenter defaultCenter] addObserverForName:WKSyncMangerDidSyncNotification
                                                      object:[WKSyncManager sharedManager]
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      [self updateReviewsCountImage];
                                                  }];

    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [WKCustomization setBackgroundForView:self.view];
    NSArray *colors = @[ RGBA(0.0, 170.0, 255.0, 1.0), RGBA(0.0, 147.0, 221.0, 1.0) ];
    [_backgroundImageView setImage:[WKCustomization gradientImageWithFrame:_backgroundImageView.frame
                                                                    colors:colors
                                                                startPoint:CGPointMake(0.0f, 0.0f)
                                                                  endPoint:CGPointMake(0.0f, 1.0f)]];
    
    UIFont *fontAwesome         = [UIFont fontWithName:@"fontawesome" size:18.0f];
    _availableIconLabel.font    = fontAwesome;
    _availableIconLabel.text    = @"\uf01c";
    _checkMarkIconLabel.font    = fontAwesome;
    _checkMarkIconLabel.text    = @"\uf00c";
    _percentageIconLabel.font   = fontAwesome;
    _percentageIconLabel.text   = @"\uf087";

    _closeButton.titleLabel.font = [UIFont fontWithName:@"fontawesome" size:24.0f];
    [_closeButton setTitle:@"\uf00d" forState:UIControlStateNormal];
    
    _correctAnswerView.layer.cornerRadius = 5.0f;
    [_correctAnswerView setHidden:NO];
    
    _characterLabel.text = @"";
    
    /**
     iPhone 5 settings
     */
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&
        [[UIScreen mainScreen] bounds].size.height > 480.0f) {
        
        _characterLabel.font    = [UIFont boldSystemFontOfSize:200.0f];
        _answerTextField.font   = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0f];
    }
    
    _questionAnswered   = NO;
    _availableCount     = -1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBarItem setTitleTextAttributes:@{ UITextAttributeTextColor: [UIColor whiteColor] }
                                   forState:UIControlStateNormal];
    
    [_answerTextField becomeFirstResponder];
    
    [SVProgressHUD show];
    [[WKHijackHTTPClient sharedClient] startReviewSessionWithSuccess:^(NSDictionary *question) {
        
        [SVProgressHUD dismiss];
        [self setupViewsForQuestion:question];
        
    } failure:^(NSError *error) {

        NSLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Connection Error", nil)];
    }];
}

- (IBAction)stopReview:(id)sender {

    [_answerTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private

- (void)updateReviewsCountImage {
    
    CGRect bounds           = CGRectZero;
    bounds.size             = CGSizeMake(80.0f, 80.0f);
    NSString *reviewsCount  = [NSString stringWithFormat:@"%i", [[WKStatsManager combinedAvailableReviews] count]];
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0f);
    
    [[UIColor whiteColor] set];
    [reviewsCount drawInRect:CGRectMake(0.0f, 30.0f, 80.0f, 80.0f)
                    withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]
               lineBreakMode:NSLineBreakByWordWrapping
                   alignment:NSTextAlignmentCenter];

    [NSLocalizedString(@"Reviews", nil) drawAtPoint:CGPointMake(17.0f, 52.0f)
                                           withFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    
    UIImage *reviewsImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.tabBarItem setFinishedSelectedImage:reviewsImage withFinishedUnselectedImage:reviewsImage];
}

- (void)setupViewsForQuestion:(NSDictionary *)question {
    
    NSDictionary *questionInfo;
    questionInfo        = [question valueForKey:@"info"];
    NSString *itemId    = [question valueForKey:@"item"];
    NSString *qType     = [question valueForKey:@"q"];
    NSString *itemType  = [itemId substringToIndex:1];
    NSString *character = [questionInfo valueForKey:@"character"];
    NSString *image     = [questionInfo valueForKey:@"image"];

    self.currentItemId  = itemId;
    [_correctAnswerView setupCorrectAnswer:questionInfo itemType:itemType questionType:qType];
    
    if (![image isEqual:[NSNull null]] && [image length] > 0) {
        
        [_characterImage setImageWithURL:[NSURL URLWithString:image]];
        _characterLabel.text = @"";
        
    } else {
        
        [_characterImage setImage:nil];
        _characterLabel.text = character;
    }
    
    NSString *placeholder   = NSLocalizedString(@"Radical Name?", nil);
    NSArray *colors         = @[ RGBA(0.0, 170.0, 255.0, 1.0), RGBA(0.0, 147.0, 221.0, 1.0) ];
    if ([itemType isEqualToString:@"k"]) {
        
        placeholder = ( [qType isEqualToString:@"m"] ?
                        NSLocalizedString(@"Kanji Meaning?", nil) :
                        NSLocalizedString(@"Kanji Reading?", nil) );
        colors      = @[ RGBA(255.0, 0.0, 170.0, 1.0), RGBA(221.0, 0.0, 147.0, 1.0) ];
        
    } else if ([itemType isEqualToString:@"v"]) {

        placeholder = ( [qType isEqualToString:@"m"] ?
                        NSLocalizedString(@"Vocabulary Meaning?", nil) :
                        NSLocalizedString(@"Vocabulary Reading?", nil) );

        colors      = @[ RGBA(170.0, 0.0, 255.0, 1.0), RGBA(147.0, 0.0, 221.0, 1.0) ];
    }
    
    [_answerTextField setPlaceholder:placeholder];
    [_backgroundImageView setImage:[WKCustomization gradientImageWithFrame:_backgroundImageView.frame
                                                                    colors:colors
                                                                startPoint:CGPointMake(0.0f, 0.0f)
                                                                  endPoint:CGPointMake(0.0f, 1.0f)]];
}

- (void)showAnswerResults:(NSDictionary *)results {
    
    NSNumber *correct = [results valueForKey:@"correct"];
    NSNumber *availableCount    = [results valueForKey:@"available_count"];
    NSNumber *completedCount    = [results valueForKey:@"completed_count"];
    NSNumber *percentage        = [results valueForKey:@"percentage"];
    _percentageLabel.text       = [NSString stringWithFormat:@"%@%%", percentage];
    _availableCountLabel.text   = [availableCount stringValue];    
    _availableCount             = [availableCount integerValue];
        
    if (![completedCount isEqual:[NSNull null]]) {
            
        _completedCountLabel.text = [completedCount stringValue];
    }
    
    if ([correct boolValue]) {
        
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Correct!", nil)];
        
    } else {
        
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Incorrect!", nil)];
    }
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
       
        _correctAnswerView.alpha = 1.0f;
    }];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    
    NSValue* keyboardFrameBegin     = [[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect   = [keyboardFrameBegin CGRectValue];
    
    CGRect answerTextFieldRect      = _answerTextField.frame;
    answerTextFieldRect.origin.y    = self.view.frame.size.height - keyboardFrameBeginRect.size.height - 30.0f;
    _answerTextField.frame          = answerTextFieldRect;
    
    CGRect correctAnswerFrame       = _correctAnswerView.frame;
    correctAnswerFrame.size.height  = answerTextFieldRect.origin.y + answerTextFieldRect.size.height - 40.0f;
    _correctAnswerView.frame        = correctAnswerFrame;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    [_answerTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([SVProgressHUD isVisible]) return NO;
    
    WKHijackHTTPClient *client = [WKHijackHTTPClient sharedClient];
    if (!_questionAnswered) {

        _questionAnswered = YES;
        [_answerTextField setReturnKeyType:UIReturnKeyNext];
        
        [SVProgressHUD show];
        [client putReviewAnswerForItem:_currentItemId
                                answer:_answerTextField.text
                               success:^(NSDictionary *answer) {
                                   
                                   [self showAnswerResults:[answer valueForKey:@"result"]];
                                   
                               } failure:^(NSError *error) {

                                   NSLog(@"%@", error);
                                   [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Connection Error", nil)];
                               }];
        
    } else {
        
        if ( _availableCount == 0 ) {
            
            /**
             We are sending question request, to stop current preview session
             */
            [[WKHijackHTTPClient sharedClient] fetchReviewQuestionWithSuccess:nil failure:nil];
            [[WKSyncManager sharedManager] fetchItems];
            [self stopReview:nil];
            return NO;
        }
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            
            _correctAnswerView.alpha = 0.0f;
        }];
        
        _questionAnswered       = NO;
        _answerTextField.text   = @"";
        _characterLabel.text    = @"";
        
        [_answerTextField setPlaceholder:@""];
        [_answerTextField setBackgroundColor:[UIColor clearColor]];
        [_answerTextField setReturnKeyType:UIReturnKeySend];
        
        [SVProgressHUD show];
        [client fetchReviewQuestionWithSuccess:^(NSDictionary *question) {
            
            [SVProgressHUD dismiss];
            [self setupViewsForQuestion:question];
            
        } failure:^(NSError *error) {

            NSLog(@"%@", error);
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Connection Error", nil)];
        }];
    }
    
    return NO;
}

@end
