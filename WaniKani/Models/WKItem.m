//
//  WKItem.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKItem.h"
#import "WKItemStats.h"

@implementation WKItem
@dynamic character;
@dynamic level;
@dynamic meaning;
@dynamic stats;

#pragma mark - entity settings

+ (NSString *)jsonRoot {
    return @"requested_information";
}

@end
