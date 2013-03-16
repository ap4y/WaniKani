//
//  WKHijackHTTPClient.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 16/03/13.
//
//

#import "WKHijackHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "NSJSONSerializationCategories.h"

@interface WKHijackHTTPClient ()
@property (strong, nonatomic) NSString *csrfToken;
@end

@implementation WKHijackHTTPClient

static NSString * const kBaseUrlString      = @"http://www.wanikani.com";
static NSString * const kHijackErrorDomain  = @"com.wk.hijack.error";

+ (WKHijackHTTPClient *)sharedClient {
    static WKHijackHTTPClient *_sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:kBaseUrlString];
        _sharedClient = [[WKHijackHTTPClient alloc] initWithBaseURL:baseUrl];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [self setStringEncoding:NSUTF8StringEncoding];
	[self setDefaultHeader:@"Accept" value:@"*/*"];
    [self setParameterEncoding:AFFormURLParameterEncoding];
    
    return self;
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                 remember:(BOOL)remember
                  success:(void (^)(NSString *apiKey))success
                  failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{
        @"user[login]": username,
        @"user[password]": password,
        @"user[remember_me]": remember ? @(1) : @(0)
    };
    
    [self postPath:@"/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self fetchApiKeyWithSuccess:success failure:failure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        if (failure) failure(error);
    }];
}

- (void)startReviewSessionWithSuccess:(void (^)(NSDictionary *question))success
                              failure:(void (^)(NSError *error))failure {
    
    [self getPath:@"/review/session/start"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              self.csrfToken = [self extractCSRFTokenFromResponseString:[operation responseString]];
              if (!_csrfToken) {
                  
                  NSString* errorMsg    = NSLocalizedString(@"Incorrect session response", nil);
                  NSError *error        = [NSError errorWithDomain:kHijackErrorDomain
                                                              code:2
                                                          userInfo:@{ NSLocalizedDescriptionKey: errorMsg }];
                  if (failure) failure(error);
                  return;
              }

              NSDictionary *result = [self extractJsonFromResponseString:[operation responseString]];
              if (success) success(result);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              if (failure) failure(error);
          }];
}

- (void)fetchReviewQuestionWithSuccess:(void (^)(NSDictionary *question))success
                               failure:(void (^)(NSError *error))failure {
    
    [self getPath:@"/review/session/question"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSDictionary *result = [self extractJsonFromResponseString:[operation responseString]];
              if (!result) {
                  
                  NSString* errorMsg    = NSLocalizedString(@"Incorrect question response", nil);
                  NSError *error        = [NSError errorWithDomain:kHijackErrorDomain
                                                              code:0
                                                          userInfo:@{ NSLocalizedDescriptionKey: errorMsg }];
                  if (failure) failure(error);
                  return;
              }

              if (success) success(result);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              if (failure) failure(error);
          }];
}

- (void)putReviewAnswerForItem:(NSString *)item
                        answer:(NSString *)answer
                       success:(void (^)(NSDictionary *answer))success
                       failure:(void (^)(NSError *error))failure {
    
    if (!_csrfToken) {
        
        NSString* errorMsg    = NSLocalizedString(@"CSRF token not found", nil);
        NSError *error        = [NSError errorWithDomain:kHijackErrorDomain
                                                    code:0
                                                userInfo:@{ NSLocalizedDescriptionKey: errorMsg }];
        if (failure) failure(error);
        return;
    }
    
    [self putPath:@"/review/session/answer"
       parameters:@{ @"item_name": item, @"user_response": answer, @"authenticity_token": _csrfToken }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSDictionary *result = [self extractJsonFromResponseString:[operation responseString]];
              if (!result) {
                  
                  NSString* errorMsg    = NSLocalizedString(@"Incorrect question response", nil);
                  NSError *error        = [NSError errorWithDomain:kHijackErrorDomain
                                                              code:0
                                                          userInfo:@{ NSLocalizedDescriptionKey: errorMsg }];
                  if (failure) failure(error);
                  return;
              }
              
              if (success) success(result);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              if (failure) failure(error);
          }];
}

#pragma mark - private

- (void)fetchApiKeyWithSuccess:(void (^)(NSString *apiKey))success
                       failure:(void (^)(NSError *error))failure {
    
    [self getPath:@"/api" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSRange apiKeyRange = [[operation responseString] rangeOfString:@"Your API key is .*?[.]"
                                                                options:NSRegularExpressionSearch];
        if (apiKeyRange.location == NSNotFound) {
        
            NSString* errorMsg    = NSLocalizedString(@"Incorrect api key response", nil);
            NSError *error        = [NSError errorWithDomain:kHijackErrorDomain
                                                        code:1
                                                    userInfo:@{ NSLocalizedDescriptionKey: errorMsg }];
            if (failure) failure(error);
            return;
        }

        NSString *apiKey;
        apiKey  = [[operation responseString] substringWithRange:apiKeyRange];
        apiKey  = [apiKey stringByReplacingOccurrencesOfString:@"Your API key is <code>" withString:@""];
        apiKey  = [apiKey stringByReplacingOccurrencesOfString:@"</code>." withString:@""];
        if (success) success(apiKey);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) failure(error);
    }];
}

- (NSDictionary *)extractJsonFromResponseString:(NSString *)responseString {
    
    NSRange jsonRange = [responseString rangeOfString:@"[{].*[}]" options:NSRegularExpressionSearch];
    if (jsonRange.location == NSNotFound) return nil;
    
    NSString *cleanedResponse = [responseString substringWithRange:jsonRange];
    return [cleanedResponse objectFromJSONString];
}

- (NSString *)extractCSRFTokenFromResponseString:(NSString *)responseString {
 
    NSRange csrfRange = [responseString rangeOfString:@"<meta content=\".*\" name=\"csrf-token\""
                                              options:NSRegularExpressionSearch];
    if (csrfRange.location == NSNotFound) return nil;
    
    NSString *csrfToken;
    csrfToken  = [responseString substringWithRange:csrfRange];
    csrfToken  = [csrfToken stringByReplacingOccurrencesOfString:@"<meta content=\"" withString:@""];
    csrfToken  = [csrfToken stringByReplacingOccurrencesOfString:@"\" name=\"csrf-token\"" withString:@""];
    return csrfToken;
}

@end
