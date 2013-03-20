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

@interface WKTabBarController () <UITabBarControllerDelegate>

@end

@implementation WKTabBarController

static const NSUInteger kReviewsItemIndex = 2;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    self.delegate = self;
        
    return self;
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
