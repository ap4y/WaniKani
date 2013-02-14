//
//  WKKanjiViewControllerTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 14/02/13.
//
//

#import "WKKanjiViewControllerTests.h"
#import "WKKanjiViewController.h"
#import "WKKanji.h"

#import "WKTestHelpers.h"

@interface WKKanjiViewController ()
@property (strong, nonatomic) NSArray *kanji;
@end

@interface WKKanjiViewControllerTests ()
@property (strong, nonatomic) WKKanjiViewController *subject;
@property (strong, nonatomic) WKKanji *kanjiItem;
@end

@implementation WKKanjiViewControllerTests

- (void)setUp {
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    self.subject = [storyboard instantiateViewControllerWithIdentifier:@"WKKanjiViewControllerTests"];
    [_subject loadView];
    
    NSArray *kanji = [WKKanji requestResult:[WKKanji all] managedObjectContext:mainThreadContext()];
    [kanji enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [mainThreadContext() deleteObject:obj];
    }];
    
    self.kanjiItem = [NSEntityDescription insertNewObjectForEntityForName:@"WKKanji"
                                                   inManagedObjectContext:mainThreadContext()];
    _kanjiItem.id         = @"seven";
    _kanjiItem.character  = @"七";    
}

- (void)tearDown {
    [OHHTTPStubs removeAllRequestHandlers];
    
    [super tearDown];
}

- (void)testFetchKanji {
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
        return [OHHTTPStubsResponse responseWithFile:@"kanji.json"
                                         contentType:@"application/json"
                                        responseTime:0.0];
    }];
    
    [AETestHelpers runAsyncTest:^(BOOL *endCondition) {
        
        [_subject viewDidLoad];
        STAssertEqualObjects(@[ _kanjiItem ], _subject.kanji, nil);
        
    } interval:0.1];
    
    STAssertEquals(18U, [_subject.kanji count], nil);
}

@end
