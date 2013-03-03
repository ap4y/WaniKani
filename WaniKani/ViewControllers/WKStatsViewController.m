//
//  WKStatsViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 14/02/13.
//
//

#import "WKStatsViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "WKItem.h"
#import "WKItemStats.h"
#import "WKItemTableCell.h"
#import "WKItemTableHeader.h"

#import "WKGravatarImage.h"
#import "WKCustomization.h"
#import "WKSyncManager.h"

@interface WKStatsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *informationBox;
@property (weak, nonatomic) IBOutlet UITableView *statsTableView;
@property (weak, nonatomic) IBOutlet UIButton *apprenticeButton;
@property (weak, nonatomic) IBOutlet UIButton *guruButton;
@property (weak, nonatomic) IBOutlet UIButton *masterButton;
@property (weak, nonatomic) IBOutlet UIButton *enlightenButton;
@property (weak, nonatomic) IBOutlet UIButton *burnedButton;
@property (weak, nonatomic) IBOutlet UILabel *nextReviewLabel;

@property (strong, nonatomic) NSDictionary *statsTableItems;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation WKStatsViewController

static NSString * const kStatsCellIdentifier        = @"WKStatsCell";
static NSString * const kDetailsSegueIdentifier     = @"WKStatDetailsSegue";
static const CGFloat kCriticalLevelPercentage       = 75.0f;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;

    self.dateFormatter      = [[NSDateFormatter alloc] init];
    NSString *dateFormat    = [NSDateFormatter dateFormatFromTemplate:@"MMMd"
                                                              options:0
                                                               locale:[NSLocale currentLocale]];
    [_dateFormatter setDateFormat:dateFormat];

    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"btn_logo"]
                  withFinishedUnselectedImage:[UIImage imageNamed:@"btn_logo"]];
    [WKGravatarImage gravatarImageForCurrentUserWithSuccess:^(UIImage *image) {
        
        [self.tabBarItem setFinishedSelectedImage:image withFinishedUnselectedImage:image];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:WKSyncMangerDidSyncNotification
                                                      object:[WKSyncManager sharedManager]
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      [self updateViewValues];
                                                      [_statsTableView reloadData];
                                                      [self adjustContentHeight];
                                                  }];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WKCustomization setBackgroundForView:self.view];
    
    _informationBox.layer.cornerRadius  = 5.0f;
    _statsTableView.layer.cornerRadius  = 5.0f;
    
    [self setButtonsGradients];
    [self updateViewValues];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];    
    [self adjustContentHeight];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kDetailsSegueIdentifier]) {
        
        NSIndexPath *indexPath  = [_statsTableView indexPathForCell:sender];
        NSString *itemKey       = [[_statsTableItems allKeys] objectAtIndex:indexPath.section];
        NSArray *statsItems     = [_statsTableItems objectForKey:itemKey];
        WKItem *item            = [statsItems objectAtIndex:indexPath.row];
        
        [segue.destinationViewController setValue:item forKey:@"item"];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_statsTableItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *itemKey   = [[_statsTableItems allKeys] objectAtIndex:section];
    NSArray *statsItems = [_statsTableItems objectForKey:itemKey];
    return [statsItems count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[_statsTableItems allKeys] objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle          = [[_statsTableItems allKeys] objectAtIndex:section];
    WKItemTableHeader *headerView   = [[WKItemTableHeader alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    [headerView setTitle:sectionTitle];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WKItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kStatsCellIdentifier];
    
    NSString *itemKey   = [[_statsTableItems allKeys] objectAtIndex:indexPath.section];
    NSArray *statsItems = [_statsTableItems objectForKey:itemKey];
    WKItem *item        = [statsItems objectAtIndex:indexPath.row];
    
    [cell setItem:item];
    
    if (indexPath.section == 0) {
        
        [cell setDetailsText:[NSString stringWithFormat:@"%.00f%%", [item.stats combinedCorrectPercentage] * 100.0f]];
        
    } else {
        
        [cell setDetailsText:[_dateFormatter stringFromDate:[item.stats nextReviewDate]]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:kDetailsSegueIdentifier sender:[tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - private

- (void)adjustContentHeight {
    
    CGRect statsTableBounds         = _statsTableView.frame;
    statsTableBounds.size           = _statsTableView.contentSize;
    _statsTableView.frame           = statsTableBounds;
    
    _contentScrollView.contentSize  = CGSizeMake(_contentScrollView.contentSize.width,
                                                 statsTableBounds.origin.y + statsTableBounds.size.height + 10.0f);
}

- (void)setButtonsGradients {
    
    UIImage *tempGradient;
    NSArray *colors;
    
    colors          = @[ RGBA(255.0, 0.0, 170.0, 1.0), RGBA(221.0, 0.0, 147.0, 1.0) ];
    tempGradient    = [WKCustomization gradientImageWithFrame:_apprenticeButton.bounds
                                                       colors:colors
                                                   startPoint:CGPointMake(0.5f, 0.0f)
                                                     endPoint:CGPointMake(0.5f, 1.0f)];
    [_apprenticeButton setBackgroundImage:tempGradient forState:UIControlStateNormal];
    
    colors          = @[ RGBA(170.0, 56.0, 198.0, 1.0), RGBA(136.0, 45.0, 158.0, 1.0) ];
    tempGradient    = [WKCustomization gradientImageWithFrame:_apprenticeButton.bounds
                                                       colors:colors
                                                   startPoint:CGPointMake(0.5f, 0.0f)
                                                     endPoint:CGPointMake(0.5f, 1.0f)];
    [_guruButton setBackgroundImage:tempGradient forState:UIControlStateNormal];
    
    colors          = @[ RGBA(85.0, 113.0, 226.0, 1.0), RGBA(41.0, 77.0, 219.0, 1.0) ];
    tempGradient    = [WKCustomization gradientImageWithFrame:_apprenticeButton.bounds
                                                       colors:colors
                                                   startPoint:CGPointMake(0.5f, 0.0f)
                                                     endPoint:CGPointMake(0.5f, 1.0f)];
    [_masterButton setBackgroundImage:tempGradient forState:UIControlStateNormal];
    
    colors          = @[ RGBA(0.0, 170.0, 255.0, 1.0), RGBA(0.0, 147.0, 221.0, 1.0) ];
    tempGradient    = [WKCustomization gradientImageWithFrame:_apprenticeButton.bounds
                                                       colors:colors
                                                   startPoint:CGPointMake(0.5f, 0.0f)
                                                     endPoint:CGPointMake(0.5f, 1.0f)];
    [_enlightenButton setBackgroundImage:tempGradient forState:UIControlStateNormal];
    
    colors          = @[ RGBA(85.0, 85.0, 85.0, 1.0), RGBA(67.0, 67.0, 67.0, 1.0) ];
    tempGradient    = [WKCustomization gradientImageWithFrame:_burnedButton.bounds
                                                       colors:colors
                                                   startPoint:CGPointMake(0.5f, 0.0f)
                                                     endPoint:CGPointMake(0.5f, 1.0f)];
    [_burnedButton setBackgroundImage:tempGradient forState:UIControlStateNormal];
}

- (void)updateViewValues {
    
    _nextReviewLabel.text   = [WKItem nextReviewDateString];
    
    NSArray *burnedItems    = [WKItem combinedItemsWithSRSType:WKItemSRSBurned];
    NSArray *criticalItems  = [WKItem combinedCriticalItemsWithPercentage:kCriticalLevelPercentage];
    NSArray *unlockedItems  = [WKItem combinedUnlockedItems];
    
#define count_as_string(array) [NSString stringWithFormat:@"%i", [array count]]
    [_apprenticeButton setTitle:count_as_string([WKItem combinedItemsWithSRSType:WKItemSRSApprentice])
                       forState:UIControlStateNormal];
    [_guruButton setTitle:count_as_string([WKItem combinedItemsWithSRSType:WKItemSRSGuru])
                 forState:UIControlStateNormal];
    [_masterButton setTitle:count_as_string([WKItem combinedItemsWithSRSType:WKItemSRSMaster])
                   forState:UIControlStateNormal];
    [_enlightenButton setTitle:count_as_string([WKItem combinedItemsWithSRSType:WKItemSRSEnlighten])
                      forState:UIControlStateNormal];
    [_burnedButton setTitle:count_as_string(burnedItems)
                   forState:UIControlStateNormal];
#undef count_as_string
    
    NSMutableDictionary *statsItems = [NSMutableDictionary dictionary];
    
    if ([burnedItems count] > 0)    [statsItems setObject:burnedItems
                                                   forKey:NSLocalizedString(@"Burned Items", nil)];
    if ([criticalItems count] > 0)  [statsItems setObject:criticalItems
                                                   forKey:NSLocalizedString(@"Critical Items", nil)];
    if ([unlockedItems count] > 0)  [statsItems setObject:unlockedItems
                                                   forKey:NSLocalizedString(@"Unlocked Items", nil)];
    
    self.statsTableItems = statsItems;
}

@end
