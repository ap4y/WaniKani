//
//  WKKanji.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKItem.h"

@interface WKKanji : WKItem
@property (strong, nonatomic) NSString *onyomi;
@property (strong, nonatomic) NSString *kunyomi;
@property (strong, nonatomic) NSString *importantReading;

+ (void)fetchKanjiWithSuccess:(void (^)(NSArray *kanji))success
                      failure:(void (^)(NSError *error))failure;
@end
