//
//  WKItem.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

@class WKItemStats;
@interface WKItem : AEManagedObject
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *character;
@property (strong, nonatomic) NSNumber *level;
@property (strong, nonatomic) WKItemStats *stats;

- (NSString *)meaning;

@end
