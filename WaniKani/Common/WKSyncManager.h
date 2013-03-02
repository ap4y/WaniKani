//
//  WKSyncManager.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 2/03/13.
//
//

#import <Foundation/Foundation.h>

NSString * const WKSyncMangerDidSyncNotification;
NSString * const WKSyncMangerDidFailNotification;
NSString * const WKSyncMangerFailErrorKey;

@interface WKSyncManager : NSObject

+ (WKSyncManager *)sharedManager;
- (void)fetchItems;

@end
