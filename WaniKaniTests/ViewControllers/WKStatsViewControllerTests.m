//
//  WKStatsViewControllerTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 5/03/13.
//
//

#import "WKStatsViewControllerTests.h"
#import "WKStatsViewController.h"

#import "WKTestHelpers.h"
#import "WKRadical.h"
#import "WKItemStats.h"
#import "WKSyncManager.h"

@interface WKStatsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *informationBox;
@property (weak, nonatomic) IBOutlet UITableView *statsTableView;
@property (weak, nonatomic) IBOutlet UIButton *apprenticeButton;
@property (weak, nonatomic) IBOutlet UIButton *guruButton;
@property (weak, nonatomic) IBOutlet UIButton *masterButton;
@property (weak, nonatomic) IBOutlet UIButton *enlightenButton;
@property (weak, nonatomic) IBOutlet UIButton *burnedButton;
@property (weak, nonatomic) IBOutlet UILabel *nextReviewLabel;

@property (strong, nonatomic) NSDictionary *statsTableItems;

- (void)updateViewValues;
@end

@interface WKStatsViewControllerTests ()
@property (strong, nonatomic) WKStatsViewController *subject;
@property (strong, nonatomic) WKRadical *first;
@property (strong, nonatomic) WKRadical *second;
@end

@implementation WKStatsViewControllerTests

- (void)setUp {
    [super setUp];
    
    NSArray *radicals = [WKRadical requestResult:[WKRadical all] managedObjectContext:mainThreadContext()];
    [radicals enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [mainThreadContext() deleteObject:obj];
    }];
    
    id jsonObject           = [AETestHelpers jsonDataForFixtureFileName:@"radicals"];
    NSArray *radicalDumps   = [jsonObject valueForKey:@"requested_information"];
    self.first              = (WKRadical *)[WKRadical createOrUpdateFromJsonObject:[radicalDumps objectAtIndex:0]
                                                            inManagedObjectContext:mainThreadContext()];
    _first.level            = @(2);
    self.second             = (WKRadical *)[WKRadical createOrUpdateFromJsonObject:[radicalDumps objectAtIndex:1]
                                                            inManagedObjectContext:mainThreadContext()];
    _second.level           = @(3);

    _first.stats.availableDate      = @([[NSDate date] timeIntervalSince1970]);
    _second.stats.availableDate     = @([[NSDate date] timeIntervalSince1970]);
    
    _first.stats.meaningCorrect     = @(0);
    _first.stats.meaningIncorrect   = @(1);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    self.subject = [storyboard instantiateViewControllerWithIdentifier:@"WKStatsViewController"];
    [_subject loadView];
    [_subject viewDidLoad];
}

- (void)tearDown {
    [mainThreadContext() reset];
    
    [super tearDown];
}

- (void)testPrepareInitialValues {
    
    STAssertEqualObjects(@"1",              _subject.apprenticeButton.titleLabel.text,  nil);
    STAssertEqualObjects(@"0",              _subject.guruButton.titleLabel.text,        nil);
    STAssertEqualObjects(@"1",              _subject.masterButton.titleLabel.text,      nil);
    STAssertEqualObjects(@"0",              _subject.enlightenButton.titleLabel.text,   nil);
    STAssertEqualObjects(@"0",              _subject.burnedButton.titleLabel.text,      nil);
    STAssertEqualObjects(@"just now",       _subject.nextReviewLabel.text,              nil);
    
    STAssertEquals(2U, [_subject.statsTableItems count], nil);
}

- (void)testPrepareTableView {
    
    UITableView *tableView = _subject.statsTableView;
    STAssertEquals(2, [_subject numberOfSectionsInTableView:tableView],         nil);
    STAssertEquals(1, [_subject tableView:tableView numberOfRowsInSection:0],   nil);
    STAssertEquals(2, [_subject tableView:tableView numberOfRowsInSection:1],   nil);
    
    STAssertNotNil([_subject tableView:tableView
                 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]], nil);
}

- (void)testShouldAdjustTableViewSize {
    
    [_subject viewDidAppear:NO];
    STAssertEquals(CGSizeMake(0.0f, 309.0f), _subject.contentScrollView.contentSize, nil);
}

- (void)testShouldUpdateViewWithSyncNotification {
    
    id partial = [OCMockObject partialMockForObject:_subject];
    [[partial expect] updateViewValues];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WKSyncMangerDidSyncNotification
                                                        object:[WKSyncManager sharedManager]];
    
    [partial verify];
}

@end
