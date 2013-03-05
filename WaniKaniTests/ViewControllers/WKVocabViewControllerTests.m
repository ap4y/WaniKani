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
#import "WKVocabViewCell.h"

#import "WKTestHelpers.h"
#import "WKSyncManager.h"

@interface WKVocabViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@property (weak, nonatomic) IBOutlet UILabel *readingLabel;
@property (weak, nonatomic) IBOutlet UILabel *meaningLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lockedImageView;
@end

@interface WKVocabViewController ()
@property (strong, nonatomic) NSDictionary *itemsByLevel;
@end

@interface WKVocabViewControllerTests ()
@property (strong, nonatomic) WKVocabViewController *subject;
@property (strong, nonatomic) WKVocab *vocab;
@end

@implementation WKVocabViewControllerTests

- (void)setUp {
    [super setUp];
    
    self.vocab          = [NSEntityDescription insertNewObjectForEntityForName:@"WKVocab"
                                                        inManagedObjectContext:mainThreadContext()];
    _vocab.character    = @"character";
    _vocab.id           = @"meaning1, meaning2";
    _vocab.kana         = @"kana";
    
    id partial = [OCMockObject partialMockForObject:[WKSyncManager sharedManager]];
    [[partial stub] fetchItems];
    
    UIStoryboard *storyboard    = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    self.subject                = [storyboard instantiateViewControllerWithIdentifier:@"WKVocabViewController"];
    [_subject loadView];
}

- (void)tearDown {
    [mainThreadContext() reset];
    [super tearDown];
}

- (void)testControllerConfiguration {
    
    STAssertEqualObjects([WKVocab class],           [_subject itemClass],                                   nil);
    STAssertEqualObjects(@"WKVocabCell",            [_subject collectionItemCellViewIdentifier],            nil);
    STAssertEqualObjects(@"WKVocabSuppView",        [_subject collectionItemSupplementaryViewIdentifier],   nil);
    STAssertEqualObjects(@"WKVocabDetailsSegue",    [_subject detailsSegueIdentifier],                      nil);
}

- (void)testCollectionViewCell {
    
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:0 inSection:0];
    WKVocabViewCell *cell;
    cell = [_subject.itemsCollectionView dequeueReusableCellWithReuseIdentifier:@"WKVocabCell"
                                                                   forIndexPath:indexPath];
    [cell setItem:_vocab];
    
    STAssertEqualObjects(@"character",  cell.characterLabel.text,   nil);
    STAssertEqualObjects(@"meaning1",   cell.meaningLabel.text,     nil);
    STAssertEqualObjects(@"kana",       cell.readingLabel.text,     nil);
    STAssertFalse(cell.lockedImageView.isHidden, nil);
    
    __block BOOL blockCalled = NO;
    [cell setCellViewTouched:^{
        
        blockCalled = YES;
    }];
    [cell touchesEnded:[NSSet setWithArray:@[ @"" ]] withEvent:nil];
    
    STAssertTrue(blockCalled, nil);
}

@end
