//
//  WKAppDelegate.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 11/02/13.
//
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "WKCustomization.h"
#import "WKSyncManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 *1024
                                                             diskPath:@"WKURLCache"];
    [NSURLCache setSharedURLCache:urlCache];
    
    [WKCustomization prepare];

#if OCUNIT
    self.window         = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
#endif
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[WKSyncManager sharedManager] fetchItems];
}

@end
