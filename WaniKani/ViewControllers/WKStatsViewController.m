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
#import "WKItemTableCell.h"
#import "WKItemTableHeader.h"

#import "WKGravatarImage.h"
#import "WKCustomization.h"

@interface WKStatsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *statsView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *informationBox;
@property (weak, nonatomic) IBOutlet UIView *settingsBox;
@property (weak, nonatomic) IBOutlet UITableView *statsTableView;
@property (weak, nonatomic) IBOutlet UIButton *apprenticeButton;
@property (weak, nonatomic) IBOutlet UIButton *guruButton;
@property (weak, nonatomic) IBOutlet UIButton *masterButton;
@property (weak, nonatomic) IBOutlet UIButton *enlightenButton;
@property (weak, nonatomic) IBOutlet UIButton *burnedButton;
@property (weak, nonatomic) IBOutlet UILabel *nextReviewLabel;

@property (strong, nonatomic) NSDictionary *statsTableItems;
@end

@implementation WKStatsViewController

static NSString * const kStatsCellIdentifier = @"WKStatsCell";

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;

    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"btn_logo"]
                  withFinishedUnselectedImage:[UIImage imageNamed:@"btn_logo"]];
    [WKGravatarImage gravatarImageForGravatarId:@"f9e852694ab8a659d1edbf438c2bb4ea" success:^(UIImage *image) {
       
        [self.tabBarItem setFinishedSelectedImage:image withFinishedUnselectedImage:image];
    }];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WKCustomization setBackgroundForView:self.view];
    
    [[NSBundle mainBundle] loadNibNamed:@"WKStatsView" owner:self options:nil];
    [_contentScrollView addSubview:_statsView];    
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.contentSize.width, _statsView.bounds.size.height);
    
    _informationBox.layer.cornerRadius  = 5.0f;
    _settingsBox.layer.cornerRadius     = 5.0f;
    _statsTableView.layer.cornerRadius  = 5.0f;
    
    [self setButtonsGradients];
    
    _nextReviewLabel.text   = [WKItem nextReviewDateString];
    
    NSArray *burnedItems    = [WKItem combinedItemsWithSRSType:WKItemSRSBurned];
    NSArray *criticalItems  = [WKItem combinedCriticalItemsWithPercentage:75.0f];
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
    
    [_statsTableView registerClass:[WKItemTableCell class] forCellReuseIdentifier:kStatsCellIdentifier];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];    
    [self adjustContentHeight];
}

- (IBAction)onlyCriticalsDidChanged:(id)sender {
}

- (IBAction)criticalPercentageDidChanged:(id)sender {
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
    
    return cell;
}

#pragma mark - private

- (void)adjustContentHeight {
    
    CGRect statsTableBounds         = _statsTableView.frame;
    statsTableBounds.size           = _statsTableView.contentSize;
    _statsTableView.frame           = statsTableBounds;
    
    _contentScrollView.contentSize  = CGSizeMake(_contentScrollView.contentSize.width,
                                                 statsTableBounds.origin.y + statsTableBounds.size.height + 20.0f);
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

@end
