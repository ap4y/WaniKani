//
//  WKCustomization.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 17/02/13.
//
//

#import "WKCustomization.h"
#import <QuartzCore/QuartzCore.h>

#import "WKItem.h"
#import "WKRadical.h"
#import "WKKanji.h"
#import "WKVocab.h"

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

+ (UIImage *)resizableBackButtonImageNamedForItemClass:(Class)itemClass {
    
    NSString *imageName = @"radical_back_button";
    if ( itemClass == [WKKanji class] ) {
        
        imageName = @"kanji_back_button";
        
    } else if ( itemClass == [WKVocab class] ) {
        
        imageName = @"vocab_back_button";
    }

    
    return [WKCustomization resizableImageNamed:imageName withCapInsets:UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 5.0f)];
}

+ (void)insertView:(UIView *)view into:(UIView *)containerView positionedBelow:(UIView *)aboveView {
    
    CGRect viewFrame    = view.frame;
    viewFrame.origin.y  = aboveView.frame.origin.y + aboveView.frame.size.height;
    view.frame          = viewFrame;
    [containerView addSubview:view];
}

+ (CGSize)sizeThatFitsView:(UIView *)view {
    
    return CGSizeMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y + view.frame.size.height);
}

+ (void)prepare {
    
    [self prepareUITabBarCustomization];
    [self prepareUINavigationBarCustomization];
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

+ (void)prepareUINavigationBarCustomization {
    
    NSArray *colors         = @[ RGBA(255.0, 255.0, 255.0, 1.0), RGBA(242.0, 242.0, 242.0, 1.0) ];
    UIImage *outputImage    = [self gradientImageWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)
                                                    colors:colors
                                                startPoint:CGPointMake(0.5f, 0.0f)
                                                  endPoint:CGPointMake(0.5f, 1.0f)];
    [[UINavigationBar appearance] setBackgroundImage:outputImage forBarMetrics:UIBarMetricsDefault];
    NSDictionary *textAttributes = @{
        UITextAttributeFont: [UIFont fontWithName:@"HelveticaNeue" size:22.0f],
        UITextAttributeTextColor: RGBA(51.0, 51.0, 51.0, 1.0),
        UITextAttributeTextShadowColor: RGBA(255.0, 255.0, 255.0, 1.0),
        UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)]
    };
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:0.0f forBarMetrics:UIBarMetricsDefault];
    
    UIImage *selectionImage = [WKCustomization resizableBackButtonImageNamedForItemClass:[WKRadical class]];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:selectionImage
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    textAttributes = @{
        UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)]
    };
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes
                                                forState:UIControlStateNormal];
}

+ (void)prepareUIProgressViewCustomization {
    
    UIImage *trackImage     = [self resizableImageNamed:@"progress_track" withCapInsets:UIEdgeInsetsZero];
    UIImage *progressImage  = [self resizableImageNamed:@"progress_progress" withCapInsets:UIEdgeInsetsZero];
    
    [[UIProgressView appearance] setTrackImage:trackImage];
    [[UIProgressView appearance] setProgressImage:progressImage];
}

+ (void)prepareUISliderCustomization {
    
    UIImage *trackImage     = [self resizableImageNamed:@"progress_track" withCapInsets:UIEdgeInsetsZero];
    UIImage *progressImage  = [self resizableImageNamed:@"progress_progress" withCapInsets:UIEdgeInsetsZero];
    
    [[UISlider appearance] setMinimumTrackImage:progressImage forState:UIControlStateNormal];
    [[UISlider appearance] setMaximumTrackImage:trackImage forState:UIControlStateNormal];
}

@end
