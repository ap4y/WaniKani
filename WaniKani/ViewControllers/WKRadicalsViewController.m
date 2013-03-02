//
//  WKRadicalsViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKRadicalsViewController.h"
#import "WKRadicalViewCell.h"
#import "WKRadical.h"

#import "WKCustomization.h"

@interface WKRadicalsViewController ()

@end

@implementation WKRadicalsViewController

static NSString * const kRadicalsCellIdentifier     = @"WKRadicalsCell";
static NSString * const kRadicalsSuppViewIdentifier = @"WKRadicalsSuppView";
static NSString * const kDetailsSegueIdentifier     = @"WKRadicalDetailsSegue";

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"btn_radicals_pressed"]
                  withFinishedUnselectedImage:[UIImage imageNamed:@"btn_radicals_normal"]];
    self.navigationController.viewControllers = (self.parentViewController ? @[ self.parentViewController ] : @[]);
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    UIImage *selectionImage = [WKCustomization resizableImageNamed:@"radicals_selection"
                                                     withCapInsets:UIEdgeInsetsMake(2.5f, 2.5f, 2.5f, 2.5f)];
    [self.tabBarController.tabBar setSelectionIndicatorImage:selectionImage];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kDetailsSegueIdentifier]) {
    
        NSIndexPath *indexPath      = [self.itemsCollectionView indexPathForCell:sender];
        NSNumber *levelKey          = [[self.itemsByLevel allKeys] objectAtIndex:indexPath.section];
        NSArray *radicalsForLevel   = [self.itemsByLevel objectForKey:levelKey];
        WKRadical *radical          = [radicalsForLevel objectAtIndex:indexPath.row];

        [segue.destinationViewController setValue:radical forKey:@"item"];
    }
}

#pragma mark - controller setting

- (Class)itemClass {
    
    return [WKRadical class];
}

- (NSString *)collectionItemCellViewIdentifier {
    
    return kRadicalsCellIdentifier;
}

- (NSString *)collectionItemSupplementaryViewIdentifier {
    
    return kRadicalsSuppViewIdentifier;
}

- (void)configureCollectionItemCell:(UICollectionViewCell *)cell forItem:(WKItem *)item {
 
    [(WKRadicalViewCell *)cell setRadical:(WKRadical *)item];
}

@end
