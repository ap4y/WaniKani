//
//  WKHTTPClient.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKHTTPClient.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@implementation WKHTTPClient

NSString * const kBaseUrlString     = @"http://www.wanikani.com/api";
NSString * const kUserKeySaveKey    = @"WKUserKey";
NSString * const kGravatarIdSaveKey = @"WKGravatarIdKey";

+ (WKHTTPClient *)sharedClient {
    static WKHTTPClient *_sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:kBaseUrlString];
        _sharedClient = [[WKHTTPClient alloc] initWithBaseURL:baseUrl];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setStringEncoding:NSUTF8StringEncoding];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setParameterEncoding:AFJSONParameterEncoding];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.userKey = [userDefaults valueForKey:kUserKeySaveKey];
    
    return self;
}

- (void)pingRequestWithSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    [self getPath:@"/user-information"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              if (success) success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              if (failure) failure(error);
          }];
}

#pragma mark - private

- (void)setGravatarId:(NSString *)gravatarId {
    _gravatarId = [gravatarId copy];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:_gravatarId forKey:kGravatarIdSaveKey];
    [userDefaults synchronize];    
}

- (void)setUserKey:(NSString *)userKey {
    _userKey = [userKey copy];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:userKey forKey:kUserKeySaveKey];
    [userDefaults synchronize];
}

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *, id))success
        failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    [super getPath:[[self userScope] stringByAppendingString:path]
        parameters:parameters
           success:success
           failure:failure];
}

- (NSString *)userScope {
    return [NSString stringWithFormat:@"user/%@", _userKey];
}

@end
