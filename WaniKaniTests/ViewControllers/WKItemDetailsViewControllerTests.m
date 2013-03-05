//
//  WKItemDetailsViewControllerTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 5/03/13.
//
//

#import "WKItemDetailsViewControllerTests.h"
#import "WKItemDetailsViewController.h"

#import "WKRadical.h"
#import "WKKanji.h"
#import "WKVocab.h"
#import "WKItemStats.h"

@interface WKItemDetailsViewController ()
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIView *meaningsView;
@property (strong, nonatomic) IBOutlet UIView *readingView;
@property (strong, nonatomic) IBOutlet UIView *kanjiReadingView;
@property (strong, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UIView *radicalProgressView;
@property (strong, nonatomic) IBOutlet UIView *progressHeaderView;
@property (strong, nonatomic) IBOutlet UIView *progressFooterView;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *namingProgressView;
@property (weak, nonatomic) IBOutlet UILabel *namingPercentLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *readingProgressView;
@property (weak, nonatomic) IBOutlet UILabel *readingPercentLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *meaningProgressView;
@property (weak, nonatomic) IBOutlet UILabel *meaningPercentLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *combinedProgressView;
@property (weak, nonatomic) IBOutlet UILabel *combinedPercentLabel;

@property (weak, nonatomic) IBOutlet UILabel *nextReviewDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *unlockedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *srsLevelLabel;

@property (weak, nonatomic) IBOutlet UILabel *meaningsLabel;

@property (weak, nonatomic) IBOutlet UILabel *onReadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *kunReadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *readingLabel;

@property (weak, nonatomic) IBOutlet UIImageView *levelBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *characterBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *characterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *srsBackgroundView;
@end

@interface WKItemDetailsViewControllerTests ()
@property (strong, nonatomic) WKItemDetailsViewController *subject;
@property (strong, nonatomic) WKItemStats *stats;
@end

@implementation WKItemDetailsViewControllerTests

- (void)setUp {
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    self.subject = [storyboard instantiateViewControllerWithIdentifier:@"WKItemDetailsViewController"];
    [_subject loadView];
    
    self.stats              = [NSEntityDescription insertNewObjectForEntityForName:@"WKItemStats"
                                                            inManagedObjectContext:mainThreadContext()];
    NSDate *testDate        = [NSDate date];    
    _stats.availableDate    = @([testDate timeIntervalSince1970]);
    _stats.unlockedDate     = @([testDate timeIntervalSince1970]);
    _stats.srs              = @"guru";
    
    _stats.readingCorrect     = @(1);
    _stats.readingIncorrect   = @(1);
    _stats.meaningCorrect     = @(1);
    _stats.meaningIncorrect   = @(1);
}

- (void)tearDown {
    [mainThreadContext() reset];
    
    [super tearDown];
}

- (void)testPresentRadicalDetails {
    
    WKRadical *radical  = [NSEntityDescription insertNewObjectForEntityForName:@"WKRadical"
                                                        inManagedObjectContext:mainThreadContext()];
    radical.character   = @"character";
    radical.id          = @"meaning";
    radical.level       = @(1);
    radical.stats       = _stats;
    
    _subject.item       = radical;
    [_subject viewDidLoad];
    
    STAssertEqualObjects(@"1",              _subject.levelLabel.text,               nil);
    STAssertEqualObjects(@"character",      _subject.characterLabel.text,           nil);
    STAssertEqualObjects(@"character",      _subject.characterLabel.text,           nil);
    
    STAssertEqualObjects(@"1/2",            _subject.namingPercentLabel.text,       nil);
    STAssertEquals(0.5f,                    _subject.namingProgressView.progress,   nil);
    
    STAssertEqualObjects(@"Mar 5, 2013",    _subject.nextReviewDateLabel.text,      nil);
    STAssertEqualObjects(@"Mar 5, 2013",    _subject.unlockedDateLabel.text,        nil);
    STAssertEqualObjects(@"Guru",           _subject.srsLevelLabel.text,            nil);

    STAssertEqualObjects(@"Meaning",        _subject.meaningsLabel.text,            nil);        
}

- (void)testPresentKanjiDetails {
    
    WKKanji *kanji      = [NSEntityDescription insertNewObjectForEntityForName:@"WKKanji"
                                                        inManagedObjectContext:mainThreadContext()];
    kanji.character     = @"character";
    kanji.id            = @"meaning";
    kanji.level         = @(1);
    kanji.stats         = _stats;

    kanji.onyomi            = @"onyomi";
    kanji.kunyomi           = @"kunyomi";
    kanji.importantReading  = @"onyomi";
    
    _subject.item       = kanji;
    [_subject viewDidLoad];
    
    STAssertEqualObjects(@"1",              _subject.levelLabel.text,               nil);
    STAssertEqualObjects(@"character",      _subject.characterLabel.text,           nil);
    STAssertEqualObjects(@"character",      _subject.characterLabel.text,           nil);
    
    STAssertEqualObjects(@"1/2",            _subject.meaningPercentLabel.text,      nil);
    STAssertEquals(0.5f,                    _subject.meaningProgressView.progress,  nil);
    STAssertEqualObjects(@"1/2",            _subject.readingPercentLabel.text,      nil);
    STAssertEquals(0.5f,                    _subject.readingProgressView.progress,  nil);
    STAssertEqualObjects(@"50%",            _subject.combinedPercentLabel.text,     nil);
    STAssertEquals(0.5f,                    _subject.combinedProgressView.progress, nil);
    
    STAssertEqualObjects(@"Mar 5, 2013",    _subject.nextReviewDateLabel.text,      nil);
    STAssertEqualObjects(@"Mar 5, 2013",    _subject.unlockedDateLabel.text,        nil);
    STAssertEqualObjects(@"Guru",           _subject.srsLevelLabel.text,            nil);
    
    STAssertEqualObjects(@"Meaning",        _subject.meaningsLabel.text,            nil);
    
    STAssertEqualObjects(@"onyomi",         _subject.onReadingLabel.text,           nil);
    STAssertEqualObjects(@"kunyomi",        _subject.kunReadingLabel.text,          nil);
    STAssertEquals(0.3f,                    _subject.kunReadingLabel.alpha,         nil);
}

- (void)testPresentVocabDetails {
    
    WKVocab *vocab      = [NSEntityDescription insertNewObjectForEntityForName:@"WKVocab"
                                                        inManagedObjectContext:mainThreadContext()];
    vocab.character     = @"character";
    vocab.id            = @"meaning";
    vocab.level         = @(1);
    vocab.stats         = _stats;

    vocab.kana          = @"kana";
    
    _subject.item       = vocab;
    [_subject viewDidLoad];
    
    STAssertEqualObjects(@"1",              _subject.levelLabel.text,               nil);
    STAssertEqualObjects(@"character",      _subject.characterLabel.text,           nil);
    STAssertEqualObjects(@"character",      _subject.characterLabel.text,           nil);
    
    STAssertEqualObjects(@"1/2",            _subject.meaningPercentLabel.text,      nil);
    STAssertEquals(0.5f,                    _subject.meaningProgressView.progress,  nil);
    STAssertEqualObjects(@"1/2",            _subject.readingPercentLabel.text,      nil);
    STAssertEquals(0.5f,                    _subject.readingProgressView.progress,  nil);
    STAssertEqualObjects(@"50%",            _subject.combinedPercentLabel.text,     nil);
    STAssertEquals(0.5f,                    _subject.combinedProgressView.progress, nil);
    
    STAssertEqualObjects(@"Mar 5, 2013",    _subject.nextReviewDateLabel.text,      nil);
    STAssertEqualObjects(@"Mar 5, 2013",    _subject.unlockedDateLabel.text,        nil);
    STAssertEqualObjects(@"Guru",           _subject.srsLevelLabel.text,            nil);
    
    STAssertEqualObjects(@"Meaning",        _subject.meaningsLabel.text,            nil);
    
    STAssertEqualObjects(@"kana",           _subject.readingLabel.text,             nil);
}

@end
