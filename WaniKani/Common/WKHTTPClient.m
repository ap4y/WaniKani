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

/**
 TODO: Handle user scope
 */

NSString * const baseUrlString = @"http://www.wanikani.com/api";

+ (WKHTTPClient *)sharedClient {
    static WKHTTPClient *_sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:baseUrlString];
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
    
    return self;
}

@end
