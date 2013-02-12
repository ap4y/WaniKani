//
//  WKTestHelpers.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKTestHelpers.h"

@implementation WKTestHelpers

+ (void)stubHTTPRequestPassingTest:(BOOL (^)(NSURLRequest *request))requestTest
              responseJsonFileName:(NSString *)jsonFileName {
    
    [OHHTTPStubs shouldStubRequestsPassingTest:requestTest
                              withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                                  
          return [OHHTTPStubsResponse responseWithFile:[NSString stringWithFormat:@"%@.json", jsonFileName]
                                           contentType:@"application/json"
                                          responseTime:0.0];
      }];
}

@end
