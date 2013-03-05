//
//  WKItemsHeaderViewTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 5/03/13.
//
//

#import "WKItemsHeaderViewTests.h"
#import "WKItemsHeaderView.h"

#import "WKRadical.h"
#import "WKItemStats.h"

@interface WKItemsHeaderView ()
@property (strong, nonatomic) IBOutlet PSUICollectionReusableView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelTitleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *percentageProgressBar;
@end

@interface WKItemsHeaderViewTests ()
@property (strong, nonatomic) WKItemsHeaderView *subject;
@end

@implementation WKItemsHeaderViewTests

- (void)setUp {
    [super setUp];
    
    self.subject = [[WKItemsHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
}

- (void)tearDown {
    [mainThreadContext() reset];
    [super tearDown];
}

- (void)testShouldCreateViewFromNib {
 
    STAssertNotNil(_subject.headerView, nil);
}

- (void)testShouldUpdateViewFormItems {
    WKItemStats *stats  = [NSEntityDescription insertNewObjectForEntityForName:@"WKItemStats"
                                                            inManagedObjectContext:mainThreadContext()];
    WKRadical *radical  = [NSEntityDescription insertNewObjectForEntityForName:@"WKRadical"
                                                        inManagedObjectContext:mainThreadContext()];
    stats.srs           = @"guru";
    radical.stats       = stats;
    
    [_subject setItems:@[ radical ] level:@(1)];
    
    STAssertEqualObjects(@"Level 1",  _subject.levelTitleLabel.text, nil);
    STAssertEqualObjects(@"1/1",   _subject.percentageLabel.text, nil);
    STAssertEquals(1.0f,  _subject.percentageProgressBar.progress, nil);
}

- (void)testShouldCallBlockForTouchEvent {
    
    __block BOOL blockCalled = NO;
    [_subject setHeaderViewTouched:^{
        
        blockCalled = YES;
    }];
    [_subject touchesEnded:[NSSet setWithArray:@[ @"" ]] withEvent:nil];
    
    STAssertTrue(blockCalled, nil);
}

@end
