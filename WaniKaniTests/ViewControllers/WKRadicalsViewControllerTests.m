//
//  WKRadicalsViewControllerTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 14/02/13.
//
//

#import "WKRadicalsViewControllerTests.h"
#import "WKRadicalsViewController.h"
#import "WKRadical.h"

@interface WKRadicalsViewControllerTests ()
@property (strong, nonatomic) WKRadicalsViewController *subject;
@end

@implementation WKRadicalsViewControllerTests

- (void)setUp {
    [super setUp];
    
    self.subject = [[WKRadicalsViewController alloc] init];}

- (void)testControllerConfiguration {
    
    STAssertEqualObjects([WKRadical class],         [_subject itemClass],                                   nil);
    STAssertEqualObjects(@"WKRadicalsCell",         [_subject collectionItemCellViewIdentifier],            nil);
    STAssertEqualObjects(@"WKRadicalsSuppView",     [_subject collectionItemSupplementaryViewIdentifier],   nil);
    STAssertEqualObjects(@"WKRadicalDetailsSegue",  [_subject detailsSegueIdentifier],                      nil);
}

@end
