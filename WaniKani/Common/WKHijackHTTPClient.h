//
//  WKHijackHTTPClient.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 16/03/13.
//
//

#import "AFHTTPClient.h"

@interface WKHijackHTTPClient : AFHTTPClient

+ (WKHijackHTTPClient *)sharedClient;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                 remember:(BOOL)remember
                  success:(void (^)(NSString *apiKey))success
                  failure:(void (^)(NSError *error))failure;

- (void)startReviewSessionWithSuccess:(void (^)(NSDictionary *question))success
                              failure:(void (^)(NSError *error))failure;
- (void)fetchReviewQuestionWithSuccess:(void (^)(NSDictionary *question))success
                               failure:(void (^)(NSError *error))failure;
- (void)putReviewAnswerForItem:(NSString *)item
                        answer:(NSString *)answer
                       success:(void (^)(NSDictionary *answer))success
                       failure:(void (^)(NSError *error))failure;
@end
