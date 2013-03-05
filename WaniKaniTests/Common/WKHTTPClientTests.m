//
//  WKHTTPClientTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 6/03/13.
//
//

#import "WKHTTPClientTests.h"
#import "WKHTTPClient.h"

@interface WKHTTPClientTests ()
@property (strong, nonatomic) WKHTTPClient *subject;
@end

@implementation WKHTTPClientTests

- (void)setUp {
    [super setUp];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"1234" forKey:@"WKUserKey"];
    [userDefaults setObject:@"5678" forKey:@"WKGravatarIdKey"];
    [userDefaults synchronize];

    _subject = [[WKHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.wanikani.com/api"]];
}

- (void)testShouldSaveGravatarIdAndUserKey {
    
    STAssertEqualObjects(@"1234", _subject.userKey, nil);
    STAssertEqualObjects(@"5678", _subject.gravatarId, nil);
}

- (void)testShouldRestoreGravatarIdAndUserKey {
    
    [_subject setGravatarId:@"0987"];
    [_subject setUserKey:@"6543"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    STAssertEqualObjects(@"0987", [userDefaults valueForKey:@"WKGravatarIdKey"], nil);
    STAssertEqualObjects(@"6543", [userDefaults valueForKey:@"WKUserKey"], nil);    
}

@end
