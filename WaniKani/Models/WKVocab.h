//
//  WKVocab.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKItem.h"

@interface WKVocab : WKItem
@property (strong, nonatomic) NSString *kana;

+ (void)fetchVocabWithSuccess:(void (^)(NSArray *vocab))success
                      failure:(void (^)(NSError *error))failure;
@end
