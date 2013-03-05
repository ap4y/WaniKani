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
#import "WKRadicalViewCell.h"

#import "WKTestHelpers.h"
#import "WKSyncManager.h"

@interface WKRadicalViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *characterImageView;
@property (weak, nonatomic) IBOutlet UILabel *meaningLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lockedImageView;
@end

@interface WKRadicalsViewController ()
@property (strong, nonatomic) NSDictionary *itemsByLevel;
@end

@interface WKRadicalsViewControllerTests ()
@property (strong, nonatomic) WKRadicalsViewController *subject;
@property (strong, nonatomic) WKRadical *radical;
@end

@implementation WKRadicalsViewControllerTests

- (void)setUp {
    [super setUp];
    
    self.radical        = [NSEntityDescription insertNewObjectForEntityForName:@"WKRadical"
                                                        inManagedObjectContext:mainThreadContext()];
    _radical.character  = @"character";
    _radical.id         = @"meaning1, meaning2";
    
    id partial = [OCMockObject partialMockForObject:[WKSyncManager sharedManager]];
    [[partial stub] fetchItems];
    
    UIStoryboard *storyboard    = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    self.subject                = [storyboard instantiateViewControllerWithIdentifier:@"WKRadicalsViewController"];
    [_subject loadView];
}

- (void)tearDown {
    [mainThreadContext() reset];
    [super tearDown];
}

- (void)testControllerConfiguration {
    
    STAssertEqualObjects([WKRadical class],         [_subject itemClass],                                   nil);
    STAssertEqualObjects(@"WKRadicalsCell",         [_subject collectionItemCellViewIdentifier],            nil);
    STAssertEqualObjects(@"WKRadicalsSuppView",     [_subject collectionItemSupplementaryViewIdentifier],   nil);
    STAssertEqualObjects(@"WKRadicalDetailsSegue",  [_subject detailsSegueIdentifier],                      nil);
}

- (void)testCollectionViewCell {
    
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:0 inSection:0];
    WKRadicalViewCell *cell;
    cell = [_subject.itemsCollectionView dequeueReusableCellWithReuseIdentifier:@"WKRadicalsCell"
                                                                   forIndexPath:indexPath];
    [cell setItem:_radical];
    
    STAssertEqualObjects(@"character",  cell.characterLabel.text,   nil);
    STAssertEqualObjects(@"meaning1",   cell.meaningLabel.text,     nil);
    STAssertFalse(cell.lockedImageView.isHidden, nil);
    
    __block BOOL blockCalled = NO;
    [cell setCellViewTouched:^{
        
        blockCalled = YES;
    }];
    [cell touchesEnded:[NSSet setWithArray:@[ @"" ]] withEvent:nil];
    
    STAssertTrue(blockCalled, nil);
}

@end
