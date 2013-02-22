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

+ (UIImage *)gradientImageWithFrame:(CGRect)frame
                             colors:(NSArray *)colors
                         startPoint:(CGPoint)startPoint
                           endPoint:(CGPoint)endPoint {
    
    NSMutableArray *cgColors        = [NSMutableArray array];
    [colors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger idx, BOOL *stop) {        
        [cgColors addObject:(id)color.CGColor];
    }];
    
    CAGradientLayer *gradientLayer  = [CAGradientLayer layer];
    gradientLayer.startPoint        = startPoint;
    gradientLayer.endPoint          = endPoint;
    gradientLayer.frame             = frame;
    gradientLayer.colors            = cgColors;
    
    UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, YES, 0.0f);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

+ (void)prepare {
    
    [self prepareUITabBarCustomization];
    [self prepareUIProgressViewCustomization];
    [self prepareUISliderCustomization];
}

+ (void)prepareUITabBarCustomization {    
    
    NSArray *colors         = @[ RGBA(242.0, 242.0, 242.0, 1.0), RGBA(255.0, 255.0, 255.0, 1.0) ];
    UIImage *outputImage    = [self gradientImageWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 49.0f)
                                                    colors:colors
                                             startPoint:CGPointMake(0.5f, 0.0f)
                                               endPoint:CGPointMake(0.5f, 1.0f)];
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
