//
//  WKRadicalsViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKRadicalsViewController.h"

@interface WKRadicalsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *radicalsTableView;

@property (strong, nonatomic) NSArray *radicals;
@end

@implementation WKRadicalsViewController

static NSString * const kRadicalsCellIdentifier = @"WKRadicalsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.viewControllers = @[ self.parentViewController ];
    
    [WKRadical fetchRadicalsWithSuccess:^(NSArray *radicals) {
       
        self.radicals = radicals;
        [_radicalsTableView reloadData];
        
    } failure:^(NSError *error) {
        
        /**
         TODO: Add error handling
         */
        NSLog(@"%@", error);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_radicals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRadicalsCellIdentifier];
    
    WKRadical *radical  = [_radicals objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", radical.character, radical.meaning];
    
    return cell;
}

@end
