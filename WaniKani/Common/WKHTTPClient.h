//
//  WKHTTPClient.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "AFHTTPClient.h"

@interface WKHTTPClient : AFHTTPClient
@property (copy, nonatomic) NSString *userKey;
@property (copy, nonatomic) NSString *gravatarId;

+ (WKHTTPClient *)sharedClient;

- (void)pingRequestWithSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
