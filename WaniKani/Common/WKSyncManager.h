//
//  WKSyncManager.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 2/03/13.
//
//

#import <Foundation/Foundation.h>

static NSString * const WKSyncMangerDidSyncNotification = @"WKSyncMangerDidSyncNotification";
static NSString * const WKSyncMangerDidFailNotification = @"WKSyncMangerDidFailNotification";
static NSString * const WKSyncMangerFailErrorKey        = @"WKSyncMangerFailErrorKey";

@interface WKSyncManager : NSObject

+ (WKSyncManager *)sharedManager;
- (void)fetchItems;

@end
