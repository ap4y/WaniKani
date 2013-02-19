//
//  WKGravatarImage.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 17/02/13.
//
//

#import <Foundation/Foundation.h>

@interface WKGravatarImage : NSObject
+ (void)gravatarImageForGravatarId:(NSString *)gravatarId success:(void (^)(UIImage *image))success;
@end
