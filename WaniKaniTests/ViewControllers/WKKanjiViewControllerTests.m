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
#import "WKKanjiViewCell.h"

#import "WKTestHelpers.h"
#import "WKSyncManager.h"

@interface WKKanjiViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@property (weak, nonatomic) IBOutlet UILabel *readingLabel;
@property (weak, nonatomic) IBOutlet UILabel *meaningLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lockedImageView;
@end

@interface WKKanjiViewController ()
@property (strong, nonatomic) NSDictionary *itemsByLevel;
@end

@interface WKKanjiViewControllerTests ()
@property (strong, nonatomic) WKKanjiViewController *subject;
@property (strong, nonatomic) WKKanji *kanji;
@end

@implementation WKKanjiViewControllerTests

- (void)setUp {
    [super setUp];
    
    self.kanji              = [NSEntityDescription insertNewObjectForEntityForName:@"WKKanji"
                                                            inManagedObjectContext:mainThreadContext()];
    _kanji.character        = @"character";
    _kanji.id               = @"meaning1, meaning2";
    _kanji.onyomi           = @"onyomi";
    _kanji.kunyomi          = @"kunyomi";
    _kanji.importantReading = @"kunyomi";
    
    id partial = [OCMockObject partialMockForObject:[WKSyncManager sharedManager]];
    [[partial stub] fetchItems];
    
    UIStoryboard *storyboard    = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    self.subject                = [storyboard instantiateViewControllerWithIdentifier:@"WKKanjiViewController"];
    [_subject loadView];
}

- (void)tearDown {
    [mainThreadContext() reset];
    [super tearDown];
}

- (void)testControllerConfiguration {
    
    STAssertEqualObjects([WKKanji class],           [_subject itemClass],                                   nil);
    STAssertEqualObjects(@"WKKanjiCell",            [_subject collectionItemCellViewIdentifier],            nil);
    STAssertEqualObjects(@"WKKanjiSuppView",        [_subject collectionItemSupplementaryViewIdentifier],   nil);
    STAssertEqualObjects(@"WKKanjiDetailsSegue",    [_subject detailsSegueIdentifier],                      nil);
}

- (void)testCollectionViewCell {

    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:0 inSection:0];
    WKKanjiViewCell *cell;
    cell = [_subject.itemsCollectionView dequeueReusableCellWithReuseIdentifier:@"WKKanjiCell" forIndexPath:indexPath];
    [cell setItem:_kanji];
    
    STAssertEqualObjects(@"character",  cell.characterLabel.text,   nil);
    STAssertEqualObjects(@"meaning1",   cell.meaningLabel.text,     nil);
    STAssertEqualObjects(@"kunyomi",    cell.readingLabel.text,     nil);
    STAssertFalse(cell.lockedImageView.isHidden, nil);
    
    __block BOOL blockCalled = NO;
    [cell setCellViewTouched:^{
        
        blockCalled = YES;
    }];
    [cell touchesEnded:[NSSet setWithArray:@[ @"" ]] withEvent:nil];
    
    STAssertTrue(blockCalled, nil);
}

@end
