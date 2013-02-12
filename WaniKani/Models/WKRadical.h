//
//  WKRadical.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKItem.h"

@interface WKRadical : WKItem
@property (strong, nonatomic) NSString *image;

+ (void)fetchRadicalsWithSuccess:(void (^)(NSArray *radicals))success
                         failure:(void (^)(NSError *error))failure;
@end
