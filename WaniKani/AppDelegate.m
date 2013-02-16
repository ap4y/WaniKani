//
//  WKAppDelegate.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 11/02/13.
//
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 *1024
                                                             diskPath:@"WKURLCache"];
    [NSURLCache setSharedURLCache:urlCache];
    
    return YES;
}

@end
