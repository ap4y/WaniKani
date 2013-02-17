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

+ (void)prepare;

@end
