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
@dynamic synchronizedAt;
@dynamic stats;

- (NSString *)meaning {
    return self.id;
}

+ (NSArray *)itemsWithSRSType:(WKItemSRSType)srsType {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stats.srs == %@", WKItemSRSTypeStrings[srsType]];
    return [self requestResult:[self where:predicate] managedObjectContext:mainThreadContext()];
}
    
#pragma mark - entity settings

- (void)updateFromJSONObject:(id)jsonObject withRelations:(BOOL)withRelations {
    [super updateFromJSONObject:jsonObject withRelations:withRelations];
    
    self.synchronizedAt = [NSDate date];
}

+ (NSString *)jsonRoot {
    return @"requested_information";
}

+ (NSDictionary *)propertyMappings {
    return @{ @"id": @"meaning" };
}

@end
