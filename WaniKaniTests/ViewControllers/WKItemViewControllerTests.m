//
//  WKItemViewControllerTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 5/03/13.
//
//

#import "WKItemViewControllerTests.h"
#import "WKItemViewController.h"
#import "WKSyncManager.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "WKRadical.h"

#import "WKTestHelpers.h"


@interface WKItemViewController ()
@property (strong, nonatomic) NSMutableDictionary *collapsedItemsByLevel;

- (void)updateItemCollectionsWithCollapsedRefresh:(BOOL)withCollapsedRefresh;
@end

@interface WKItemViewControllerTests ()
@property (strong, nonatomic) WKItemViewController *subject;
@property (strong, nonatomic) WKRadical *first;
@property (strong, nonatomic) WKRadical *second;
@end

@implementation WKItemViewControllerTests

- (void)setUp {
    [super setUp];
    
    id jsonObject           = [AETestHelpers jsonDataForFixtureFileName:@"radicals"];
    NSArray *radicalDumps   = [jsonObject valueForKey:@"requested_information"];
    self.first              = (WKRadical *)[WKRadical createOrUpdateFromJsonObject:[radicalDumps objectAtIndex:0]
                                                            inManagedObjectContext:mainThreadContext()];
    _first.level            = @(2);
    self.second             = (WKRadical *)[WKRadical createOrUpdateFromJsonObject:[radicalDumps objectAtIndex:1]
                                                            inManagedObjectContext:mainThreadContext()];
    _second.level           = @(3);
    
    id partial = [OCMockObject partialMockForObject:[WKSyncManager sharedManager]];
    [[partial stub] fetchItems];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    self.subject = [storyboard instantiateViewControllerWithIdentifier:@"WKRadicalsViewController"];
    [_subject loadView];
    [_subject viewDidLoad];
}

- (void)tearDown {
    [mainThreadContext() reset];
    
    [super tearDown];
}

- (void)testShouldPrepareInitialValue {
    
    NSDictionary *items     = @{ @(2): @[_first], @(3): @[_second] };
    NSDictionary *collapsed = @{ @(3): @[_second] };
    STAssertEqualObjects(items,     _subject.itemsByLevel,          nil);
    STAssertEqualObjects(collapsed, _subject.collapsedItemsByLevel, nil);
}

- (void)testShouldRefreshWithPull {
    
    id partial = [OCMockObject partialMockForObject:[WKSyncManager sharedManager]];
    [[partial expect] fetchItems];
    
    [_subject.itemsCollectionView triggerPullToRefresh];
    
    [partial verify];
}

- (void)testShouldUpdateViewWithSyncNotification {
    
    id partial = [OCMockObject partialMockForObject:_subject];
    [[partial expect] updateItemCollectionsWithCollapsedRefresh:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WKSyncMangerDidSyncNotification
                                                        object:[WKSyncManager sharedManager]];
    
    [partial verify];
}

- (void)testShouldUpdateCollections {
    
    NSDictionary *collapsed         = @{ @(2): @[_first], @(3): @[_second] };
    _subject.collapsedItemsByLevel  = [collapsed mutableCopy];
    
    [_subject updateItemCollectionsWithCollapsedRefresh:YES];
    STAssertEqualObjects(collapsed, _subject.collapsedItemsByLevel, nil);
    
    collapsed                       = @{ @(3): @[_second] };
    [_subject updateItemCollectionsWithCollapsedRefresh:NO];
    STAssertEqualObjects(collapsed, _subject.collapsedItemsByLevel, nil);
}

- (void)testShouldFillCollectionView {
 
    PSUICollectionView *collectionView = _subject.itemsCollectionView;
    STAssertEquals(2, [_subject numberOfSectionsInCollectionView:collectionView], nil);
    STAssertEquals(1, [_subject collectionView:collectionView numberOfItemsInSection:0], nil);
    STAssertEquals(0, [_subject collectionView:collectionView numberOfItemsInSection:1], nil);
    
    STAssertNotNil([_subject collectionView:collectionView
                     cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]], nil);
}

@end
