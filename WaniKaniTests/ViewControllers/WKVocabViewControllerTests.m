//
//  WKVocabViewControllerTests.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 14/02/13.
//
//

#import "WKVocabViewControllerTests.h"
#import "WKVocabViewController.h"
#import "WKVocab.h"

#import "WKTestHelpers.h"

@interface WKVocabViewController ()
@property (strong, nonatomic) NSArray *vocab;
@end

@interface WKVocabViewControllerTests ()
@property (strong, nonatomic) WKVocabViewController *subject;
@property (strong, nonatomic) WKVocab *vocabItem;
@end

@implementation WKVocabViewControllerTests

- (void)setUp {
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    self.subject = [storyboard instantiateViewControllerWithIdentifier:@"WKVocabViewController"];
    [_subject loadView];
    
    NSArray *vocab = [WKVocab requestResult:[WKVocab all] managedObjectContext:mainThreadContext()];
    [vocab enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [mainThreadContext() deleteObject:obj];
    }];
    
    self.vocabItem = [NSEntityDescription insertNewObjectForEntityForName:@"WKVocab"
                                                   inManagedObjectContext:mainThreadContext()];
    _vocabItem.id         = @"one";
    _vocabItem.character  = @"一";    
}

- (void)tearDown {
    [OHHTTPStubs removeAllRequestHandlers];
    
    [super tearDown];
}

- (void)testFetchRadicals {
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
        return [OHHTTPStubsResponse responseWithFile:@"vocabulary.json"
                                         contentType:@"application/json"
                                        responseTime:0.0];
    }];
    
    [AETestHelpers runAsyncTest:^(BOOL *endCondition) {
        
        [_subject viewDidLoad];
        STAssertEqualObjects(@[ _vocabItem ], _subject.vocab, nil);
        
    } interval:0.1];
    
    STAssertEquals(41U, [_subject.vocab count], nil);
}

@end
