//
//  WKTabBarController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 17/03/13.
//
//

#import "WKTabBarController.h"
#import "WKStatsManager.h"
#import "AEAlert.h"
#import "WKSyncManager.h"

@interface WKTabBarController () <UITabBarControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *progressView;

@end

@implementation WKTabBarController

static const NSUInteger kReviewsItemIndex       = 2;
static const NSTimeInterval kAnimationDuration  = 0.2;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    self.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserverForName:WKSyncMangerDidStartNotification
                                                      object:[WKSyncManager sharedManager]
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      [self setProgressViewHidden:NO];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:WKSyncMangerDidSyncNotification
                                                      object:[WKSyncManager sharedManager]
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      [self setProgressViewHidden:YES];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:WKSyncMangerDidFailNotification
                                                      object:[WKSyncManager sharedManager]
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      [self setProgressViewHidden:YES];
                                                  }];
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:@"WKSyncProgressView" owner:self options:nil];
    [self.view insertSubview:_progressView belowSubview:self.tabBar];

    CGRect progressViewFrame    = _progressView.frame;
    progressViewFrame.origin.y  = self.view.bounds.size.height - progressViewFrame.size.height - 49.0f;
    _progressView.frame         = progressViewFrame;    
}

#pragma mark - private

- (void)setProgressViewHidden:(BOOL)hidden {
 
    [UIView animateWithDuration:kAnimationDuration animations:^{
       
        CGRect progressViewFrame    = _progressView.frame;
        CGFloat gapHeight           = ( hidden ? 0.0f : progressViewFrame.size.height );
        progressViewFrame.origin.y  = self.view.frame.size.height - 49.0f - gapHeight;
        _progressView.frame         = progressViewFrame;
    }];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if ([self.viewControllers indexOfObject:viewController] == kReviewsItemIndex) {

        if ( [[WKStatsManager combinedAvailableReviews] count] > 0 ) {

            UIStoryboard *storyboard;
            UIViewController *reviewController;
            storyboard          = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            reviewController    = [storyboard instantiateViewControllerWithIdentifier:@"WKReviewViewController"];

            [self presentViewController:reviewController animated:YES completion:nil];
            
        } else {
            
            [AEAlert composeAlertViewWithTitle:nil
                                    andMessage:NSLocalizedString(@"You don't have available reviews", nil)];
        }

        return NO;
    }

    return YES;
}

@end
