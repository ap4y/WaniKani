//
//  WKKanjiViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKKanjiViewController.h"
#import "WKKanjiViewCell.h"
#import "WKKanji.h"

#import "WKCustomization.h"

@interface WKKanjiViewController ()
@end

@implementation WKKanjiViewController

static NSString * const kKanjiCellIdentifier        = @"WKKanjiCell";
static NSString * const kKanjiSuppViewIdentifier    = @"WKKanjiSuppView";
static NSString * const kDetailsSegueIdentifier     = @"WKKanjiDetailsSegue";

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"btn_kanji_pressed"]
                  withFinishedUnselectedImage:[UIImage imageNamed:@"btn_kanji_normal"]];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    UIImage *selectionImage = [WKCustomization resizableImageNamed:@"kanji_selection"
                                                     withCapInsets:UIEdgeInsetsMake(2.5f, 2.5f, 2.5f, 2.5f)];
    [self.tabBarController.tabBar setSelectionIndicatorImage:selectionImage];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kDetailsSegueIdentifier]) {
        
        NSIndexPath *indexPath      = [self.itemsCollectionView indexPathForCell:sender];
        NSNumber *levelKey          = [[self.itemsByLevel allKeys] objectAtIndex:indexPath.section];
        NSArray *kanjiForLevel      = [self.itemsByLevel objectForKey:levelKey];
        WKKanji *kanjiItem          = [kanjiForLevel objectAtIndex:indexPath.row];
        
        [segue.destinationViewController setValue:kanjiItem forKey:@"item"];
    }
}

#pragma mark - controller setting

- (Class)itemClass {
    
    return [WKKanji class];
}

- (NSString *)collectionItemCellViewIdentifier {
    
    return kKanjiCellIdentifier;
}

- (NSString *)collectionItemSupplementaryViewIdentifier {
    
    return kKanjiSuppViewIdentifier;
}

- (NSString *)detailsSegueIdentifier {
    
    return kDetailsSegueIdentifier;
}

@end
