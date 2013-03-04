//
//  WKItemStatsTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 4/03/13.
//
//

#import "WKItemStatsTests.h"
#import "WKItemStats.h"

@interface WKItemStatsTests ()
@property (strong, nonatomic) WKItemStats *subject;
@property (strong, nonatomic) NSDate *testDate;
@end

@implementation WKItemStatsTests

const CGFloat eps = 0.001f;

- (void)setUp {
    [super setUp];
    
    self.subject    = [NSEntityDescription insertNewObjectForEntityForName:@"WKItemStats"
                                                    inManagedObjectContext:mainThreadContext()];
    
    self.testDate   = [NSDate date];
    _subject.availableDate  = @([_testDate timeIntervalSince1970]);
    _subject.unlockedDate   = @([_testDate timeIntervalSince1970]);
    
    _subject.readingCorrect     = @(1);
    _subject.readingIncorrect   = @(1);
    _subject.meaningCorrect     = @(1);
    _subject.meaningIncorrect   = @(1);
    
}

- (void)testNextReviewDate {
    
    STAssertEqualsWithAccuracy(0.0, [[_subject nextReviewDate] timeIntervalSinceDate:_testDate], 1.0, nil);
}

- (void)testUnlockDate {

    STAssertEqualsWithAccuracy(0.0, [[_subject unlockDate] timeIntervalSinceDate:_testDate], 1.0, nil);
}

- (void)testReadingCorrectPercentage {
    
    STAssertEqualsWithAccuracy(0.5f, [_subject readingCorrectPercentage], eps, nil);
}

- (void)testMeaningCorrectPercentage {
    
    STAssertEqualsWithAccuracy(0.5f, [_subject meaningCorrectPercentage], eps, nil);
}

- (void)testCombinedCorrectPercentage {
    
    STAssertEqualsWithAccuracy(0.5f, [_subject combinedCorrectPercentage], eps, nil);
}

@end
