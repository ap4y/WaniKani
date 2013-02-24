//
//  WKGravatarImage.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 17/02/13.
//
//

#import "WKGravatarImage.h"
#import "AFImageRequestOperation.h"

@implementation WKGravatarImage

static NSString * const kGravatarUrl    = @"http://www.gravatar.com/avatar";

+ (void)gravatarImageForGravatarId:(NSString *)gravatarId success:(void (^)(UIImage *image))success {
    
    NSString *gravatarUrl       = [kGravatarUrl stringByAppendingFormat:@"/%@.jpg?s=200", gravatarId];
    NSURLRequest *imageRequest  = [NSURLRequest requestWithURL:[NSURL URLWithString:gravatarUrl]];
    [[AFImageRequestOperation imageRequestOperationWithRequest:imageRequest
                                          imageProcessingBlock:^UIImage *(UIImage *image) {
        
                                              CGRect bounds = CGRectZero;
                                              bounds.size   = CGSizeMake(30.0f, 30.0f);
                                              UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0f);
                                              CGContextRef context = UIGraphicsGetCurrentContext();
                                              
                                              CGContextSaveGState(context);
                                              
                                              CGPathRef ellipse = CGPathCreateWithEllipseInRect(bounds, NULL);
                                              CGContextAddPath(context, ellipse);
                                              CGContextClip(context);
                                              
                                              [image drawInRect:bounds];
                                              
                                              CGContextRestoreGState(context);
                                              
                                              UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
                                              UIGraphicsEndImageContext();
                                              CGPathRelease(ellipse);
                                              
                                              return roundedImage;
                                              
                                          } success:^(NSURLRequest *request,
                                                      NSHTTPURLResponse *response,
                                                      UIImage *image) {
                                              
                                              if (success) success(image);
                                              
                                          } failure:nil] start];
}

@end
