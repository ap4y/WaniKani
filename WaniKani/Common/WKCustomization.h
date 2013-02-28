//
//  WKCustomization.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 17/02/13.
//
//

#import <Foundation/Foundation.h>

@interface WKCustomization : NSObject

+ (UIImage *)resizableImageNamed:(NSString *)imageName withCapInsets:(UIEdgeInsets)edgeInsets;

+ (UIImage *)defaultViewControllerBackground;
+ (void)setBackgroundForView:(UIView *)view;
+ (UIImage *)gradientImageWithFrame:(CGRect)frame
                             colors:(NSArray *)colors
                         startPoint:(CGPoint)startPoint
                           endPoint:(CGPoint)endPoint;

+ (void)insertView:(UIView *)view into:(UIView *)containerView positionedBelow:(UIView *)aboveView;
+ (CGSize)sizeThatFitsView:(UIView *)view;

+ (void)prepare;

@end
