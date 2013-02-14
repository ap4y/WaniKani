//
//  WKStatsViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 14/02/13.
//
//

#import "WKStatsViewController.h"

#import "WKRadical.h"
#import "WKKanji.h"
#import "WKVocab.h"

@interface WKStatsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *statsTextView;
@end

@implementation WKStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block NSString *statsString = @"completed items:\n";
    NSMutableArray *completedItems = [NSMutableArray array];
    [completedItems addObjectsFromArray:[WKRadical completedItems]];
    [completedItems addObjectsFromArray:[WKKanji completedItems]];
    [completedItems addObjectsFromArray:[WKVocab completedItems]];
    [completedItems enumerateObjectsUsingBlock:^(WKItem *obj, NSUInteger idx, BOOL *stop) {
        
        statsString = [statsString stringByAppendingFormat:@"%@ - %@\n", obj.character, obj.meaning];
    }];

    statsString = [statsString stringByAppendingFormat:@"unlocked items:\n"];
    NSMutableArray *unlockedItems = [NSMutableArray array];
    [unlockedItems addObjectsFromArray:[WKRadical unlockedItems]];
    [unlockedItems addObjectsFromArray:[WKKanji unlockedItems]];
    [unlockedItems addObjectsFromArray:[WKVocab unlockedItems]];
    [unlockedItems enumerateObjectsUsingBlock:^(WKItem *obj, NSUInteger idx, BOOL *stop) {
        
        statsString = [statsString stringByAppendingFormat:@"%@ - %@\n", obj.character, obj.meaning];
    }];

    statsString = [statsString stringByAppendingFormat:@"critical items:\n"];
    NSMutableArray *criticalItems = [NSMutableArray array];
    [criticalItems addObjectsFromArray:[WKRadical criticalItemsWithPercentage:95.0]];
    [criticalItems addObjectsFromArray:[WKKanji criticalItemsWithPercentage:95.0]];
    [criticalItems addObjectsFromArray:[WKVocab criticalItemsWithPercentage:95.0]];
    [criticalItems enumerateObjectsUsingBlock:^(WKItem *obj, NSUInteger idx, BOOL *stop) {
        
        statsString = [statsString stringByAppendingFormat:@"%@ - %@\n", obj.character, obj.meaning];
    }];
    
    statsString = [statsString stringByAppendingFormat:@"available review items:\n"];
    NSMutableArray *reviewItems = [NSMutableArray array];
    [reviewItems addObjectsFromArray:[WKRadical availableReviews]];
    [reviewItems addObjectsFromArray:[WKKanji availableReviews]];
    [reviewItems addObjectsFromArray:[WKVocab availableReviews]];
    [reviewItems enumerateObjectsUsingBlock:^(WKItem *obj, NSUInteger idx, BOOL *stop) {
        
        statsString = [statsString stringByAppendingFormat:@"%@ - %@\n", obj.character, obj.meaning];
    }];
    
    statsString = [statsString stringByAppendingFormat:@"radical next review date: %@", [WKRadical nextReviewDate]];
    
    _statsTextView.text = statsString;    
}

@end
