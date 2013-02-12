//
//  WKRadical.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKRadical.h"

@implementation WKRadical
@dynamic image;

+ (void)fetchRadicalsWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    [WKRadical fetchWithClient:[WKHTTPClient sharedClient]
                          path:@"/radicals"
                    parameters:nil
                       success:success
                       failure:failure];
    
}

@end
