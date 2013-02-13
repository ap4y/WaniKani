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

+ (WKHTTPClient *)sharedClient;
@end
