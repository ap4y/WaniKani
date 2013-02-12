//
//  WKVocab.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKVocab.h"

@implementation WKVocab
@dynamic kana;

+ (void)fetchVocabWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
 
    [WKVocab fetchWithClient:[WKHTTPClient sharedClient]
                        path:@"/vocabulary"
                  parameters:nil
                     success:success
                     failure:failure];
    
}

+ (NSString *)jsonRoot {
    return @"requested_information.general";
}

@end
