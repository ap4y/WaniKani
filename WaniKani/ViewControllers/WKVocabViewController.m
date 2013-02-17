//
//  WKVocabViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKVocabViewController.h"
#import "WKVocab.h"

#import "WKCustomization.h"

@interface WKVocabViewController ()
@property (strong, nonatomic) IBOutlet UITableView *vocabTableView;

@property (strong, nonatomic) NSArray *vocab;
@end

@implementation WKVocabViewController

static NSString * const kVocabCellIdentifier = @"WKVocabCell";

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"btn_vocab_pressed"]
                  withFinishedUnselectedImage:[UIImage imageNamed:@"btn_vocab_normal"]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vocab = [WKVocab requestResult:[[WKVocab all] orderBy:@"synchronizedAt", nil]
                   managedObjectContext:mainThreadContext()];
    
    [WKVocab fetchVocabWithSuccess:^(NSArray *vocab) {
        
        self.vocab = vocab;
        [_vocabTableView reloadData];
        
    } failure:^(NSError *error) {
        
        /**
         TODO: Add error handling
         */
        NSLog(@"%@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    UIImage *selectionImage = [WKCustomization resizableImageNamed:@"vocab_selection"
                                                     withCapInsets:UIEdgeInsetsMake(2.5f, 2.5f, 2.5f, 2.5f)];
    [self.tabBarController.tabBar setSelectionIndicatorImage:selectionImage];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_vocab count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kVocabCellIdentifier];
    
    WKVocab *vocabItem  = [_vocab objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@ - %@",
                           vocabItem.character, vocabItem.kana, vocabItem.meaning];
    
    return cell;
}

@end
