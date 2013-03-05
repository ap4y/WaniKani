//
//  WKKanjiViewControllerTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 14/02/13.
//
//

#import "WKKanjiViewControllerTests.h"
#import "WKKanjiViewController.h"
#import "WKKanji.h"

@interface WKKanjiViewControllerTests ()
@property (strong, nonatomic) WKKanjiViewController *subject;
@end

@implementation WKKanjiViewControllerTests

- (void)setUp {
    [super setUp];
    
    self.subject = [[WKKanjiViewController alloc] init];
}

- (void)testControllerConfiguration {
    
    STAssertEqualObjects([WKKanji class],           [_subject itemClass],                                   nil);
    STAssertEqualObjects(@"WKKanjiCell",            [_subject collectionItemCellViewIdentifier],            nil);
    STAssertEqualObjects(@"WKKanjiSuppView",        [_subject collectionItemSupplementaryViewIdentifier],   nil);
    STAssertEqualObjects(@"WKKanjiDetailsSegue",    [_subject detailsSegueIdentifier],                      nil);
}

@end
