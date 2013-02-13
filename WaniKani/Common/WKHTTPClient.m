//
//  WKHTTPClient.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKHTTPClient.h"
#import "AFJSONRequestOperation.h"

@implementation WKHTTPClient

NSString * const kBaseUrlString  = @"http://www.wanikani.com/api";
NSString * const kUserKeySaveKey = @"WKUserKey";

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

#pragma mark - private

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
    return [NSString stringWithFormat:@"/user/%@", _userKey];
}

@end
