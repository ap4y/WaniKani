//
//  WKVocabViewControllerTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 14/02/13.
//
//

#import "WKVocabViewControllerTests.h"
#import "WKVocabViewController.h"
#import "WKVocab.h"

@interface WKVocabViewControllerTests ()
@property (strong, nonatomic) WKVocabViewController *subject;
@end

@implementation WKVocabViewControllerTests

- (void)setUp {
    [super setUp];
    
    self.subject = [[WKVocabViewController alloc] init];
}

- (void)testControllerConfiguration {
    
    STAssertEqualObjects([WKVocab class],           [_subject itemClass],                                   nil);
    STAssertEqualObjects(@"WKVocabCell",            [_subject collectionItemCellViewIdentifier],            nil);
    STAssertEqualObjects(@"WKVocabSuppView",        [_subject collectionItemSupplementaryViewIdentifier],   nil);
    STAssertEqualObjects(@"WKVocabDetailsSegue",    [_subject detailsSegueIdentifier],                      nil);
}

@end
