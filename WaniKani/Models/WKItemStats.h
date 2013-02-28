//
//  WKItemStats.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "AEManagedObject.h"

@class WKItem;
@interface WKItemStats : AEManagedObject
@property (strong, nonatomic) NSString *srs;
@property (strong, nonatomic) NSNumber *unlockedDate;
@property (strong, nonatomic) NSNumber *availableDate;
@property (strong, nonatomic) NSNumber *burned;
@property (strong, nonatomic) NSNumber *burnedDate;
@property (strong, nonatomic) NSNumber *meaningCorrect;
@property (strong, nonatomic) NSNumber *meaningIncorrect;
@property (strong, nonatomic) NSNumber *meaningMaxStreak;
@property (strong, nonatomic) NSNumber *meaningCurrentStreak;
@property (strong, nonatomic) NSNumber *readingCorrect;
@property (strong, nonatomic) NSNumber *readingIncorrect;
@property (strong, nonatomic) NSNumber *readingMaxStreak;
@property (strong, nonatomic) NSNumber *readingCurrentStreak;
@property (strong, nonatomic) WKItem *item;

- (NSDate *)nextReviewDate;
- (NSDate *)unlockDate;

@end
