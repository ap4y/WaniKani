//
//  WKCustomization.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 17/02/13.
//
//

#import "WKCustomization.h"
#import <QuartzCore/QuartzCore.h>

@implementation WKCustomization

+ (UIImage *)resizableImageNamed:(NSString *)imageName withCapInsets:(UIEdgeInsets)edgeInsets {
    
    return [[UIImage imageNamed:imageName] resizableImageWithCapInsets:edgeInsets];
}

+ (UIImage *)defaultViewControllerBackground {
    
    return [self resizableImageNamed:@"background"
                       withCapInsets:UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f)];
}

+ (void)setBackgroundForView:(UIView *)view {
    
    UIImage *defaultBackgroundImage     = [WKCustomization defaultViewControllerBackground];
    UIImageView *backgroundImageView    = [[UIImageView alloc] initWithImage:defaultBackgroundImage];
    
    backgroundImageView.frame = view.bounds;    
    [view insertSubview:backgroundImageView atIndex:0];
}

+ (void)prepare {
    
    [self prepareUITabBarCustomization];
    [self prepareUIProgressViewCustomization];
}

+ (void)prepareUITabBarCustomization {
    
    CAGradientLayer *gradientLayer  = [CAGradientLayer layer];
    gradientLayer.startPoint        = CGPointMake(0.5f, 0.0f);
    gradientLayer.endPoint          = CGPointMake(0.5f, 1.0f);
    gradientLayer.frame             = CGRectMake(0.0f, 0.0f, 320.0f, 49.0f);
    gradientLayer.colors            = @[ (id)[RGBA(242.0, 242.0, 242.0, 1.0) CGColor],
                                         (id)[RGBA(255.0, 255.0, 255.0, 1.0) CGColor] ];
    
    UIGraphicsBeginImageContext([gradientLayer frame].size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];    
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[UITabBar appearance] setBackgroundImage:outputImage];
    
    NSDictionary *textAttributes = @{
        UITextAttributeFont: [UIFont fontWithName:@"HelveticaNeue" size:12.0f]
    };
    [[UITabBarItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
}

+ (void)prepareUIProgressViewCustomization {
    
    UIImage *trackImage     = [self resizableImageNamed:@"progress_track"
                                          withCapInsets:UIEdgeInsetsZero];
    UIImage *progressImage  = [self resizableImageNamed:@"progress_progress"
                                          withCapInsets:UIEdgeInsetsZero];
    [[UIProgressView appearance] setTrackImage:trackImage];
    [[UIProgressView appearance] setProgressImage:progressImage];
}

@end
