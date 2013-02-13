//
//  WKKanjiViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKKanjiViewController.h"
#import "WKKanji.h"

@interface WKKanjiViewController ()
@property (strong, nonatomic) IBOutlet UITableView *kanjiTableView;

@property (strong, nonatomic) NSArray *kanji;
@end

@implementation WKKanjiViewController

static NSString * const kKanjiCellIdentifier = @"WKKanjiCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.kanji = [WKKanji requestResult:[[WKKanji all] orderBy:@"synchronizedAt", nil]
                   managedObjectContext:mainThreadContext()];
    
    [WKKanji fetchKanjiWithSuccess:^(NSArray *kanji) {
        
        self.kanji = kanji;
        [_kanjiTableView reloadData];
        
    } failure:^(NSError *error) {
        
        /**
         TODO: Add error handling
         */
        NSLog(@"%@", error);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_kanji count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kKanjiCellIdentifier];
    
    WKKanji *kanjiItem  = [_kanji objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@,%@ - %@",
                           kanjiItem.character, kanjiItem.onyomi,
                           kanjiItem.kunyomi, kanjiItem.meaning];
    
    return cell;
}

@end
