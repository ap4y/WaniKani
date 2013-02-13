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
@dynamic id;
@dynamic character;
@dynamic level;
@dynamic stats;

- (NSString *)meaning {
    return self.id;
}

#pragma mark - entity settings

+ (NSString *)jsonRoot {
    return @"requested_information";
}

+ (NSDictionary *)propertyMappings {
    return @{ @"id": @"meaning" };
}

@end
