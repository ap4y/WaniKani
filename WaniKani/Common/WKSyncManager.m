//
//  WKSyncManager.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 2/03/13.
//
//

#import "WKSyncManager.h"

#import "WKRadical.h"
#import "WKKanji.h"
#import "WKVocab.h"

@interface WKSyncManager ()
@property (nonatomic) BOOL isSyncing;
@property (nonatomic) NSUInteger finishedBlocksCount;
@end

@implementation WKSyncManager

static const NSUInteger kMaxFinishedBlocksCount = 3;

+ (WKSyncManager *)sharedManager {
    static WKSyncManager *sharedManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        sharedManger = [[WKSyncManager alloc] init];
    });
    return sharedManger;
}

- (BOOL)fetchItems {

    if (_isSyncing) return NO;
    
    _isSyncing              = YES;
    _finishedBlocksCount    = 0;
    void (^successBlock)(NSArray *items) = ^(NSArray *radicals) {
        
        @synchronized(self) { _finishedBlocksCount++; }
        
        if ( _finishedBlocksCount == kMaxFinishedBlocksCount ) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WKSyncMangerDidSyncNotification object:self];
            _isSyncing = NO;
            [self createLocalNotification];
        }
    };
    
    void (^failureBlock)(NSError *error) = ^(NSError *error) {

        [[NSNotificationCenter defaultCenter] postNotificationName:WKSyncMangerDidFailNotification
                                                            object:self
                                                          userInfo:@{ WKSyncMangerFailErrorKey: error }];
        _isSyncing = NO;
    };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WKSyncMangerDidStartNotification object:self];
    
    [WKRadical fetchRadicalsWithSuccess:successBlock failure:failureBlock];
    [WKKanji fetchKanjiWithSuccess:successBlock failure:failureBlock];
    [WKVocab fetchVocabWithSuccess:successBlock failure:failureBlock];
    
    return YES;
}

#pragma mark - private

- (void)createLocalNotification {

    UILocalNotification *localNotification;
    localNotification           = [[UILocalNotification alloc] init];
    localNotification.fireDate  = [WKItem nextReviewDate];
    localNotification.alertBody = NSLocalizedString(@"New Reviews Available", nil);
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
