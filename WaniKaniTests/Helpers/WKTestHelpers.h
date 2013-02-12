//
//  WKTestHelpers.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "AETestHelpers.h"
#import "OCMock.h"

@interface WKTestHelpers : NSObject
+ (void)stubHTTPRequestPassingTest:(BOOL (^)(NSURLRequest *request))requestTest
              responseJsonFileName:(NSString *)jsonFileName;
@end
