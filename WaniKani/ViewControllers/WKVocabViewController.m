//
//  WKVocabViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 13/02/13.
//
//

#import "WKVocabViewController.h"
#import "WKVocabViewCell.h"
#import "WKVocab.h"

#import "WKCustomization.h"

@interface WKVocabViewController ()
@end

@implementation WKVocabViewController

static NSString * const kVocabCellIdentifier        = @"WKVocabCell";
static NSString * const kVocabSuppViewIdentifier    = @"WKVocabSuppView";
static NSString * const kDetailsSegueIdentifier     = @"WKVocabDetailsSegue";

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"btn_vocab_pressed"]
                  withFinishedUnselectedImage:[UIImage imageNamed:@"btn_vocab_normal"]];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    UIImage *selectionImage = [WKCustomization resizableImageNamed:@"vocab_selection"
                                                     withCapInsets:UIEdgeInsetsMake(2.5f, 2.5f, 2.5f, 2.5f)];
    [self.tabBarController.tabBar setSelectionIndicatorImage:selectionImage];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kDetailsSegueIdentifier]) {
        
        NSIndexPath *indexPath      = [self.itemsCollectionView indexPathForCell:sender];
        NSNumber *levelKey          = [[self.itemsByLevel allKeys] objectAtIndex:indexPath.section];
        NSArray *vocabForLevel      = [self.itemsByLevel objectForKey:levelKey];
        WKVocab *vocabItem          = [vocabForLevel objectAtIndex:indexPath.row];
        
        [segue.destinationViewController setValue:vocabItem forKey:@"item"];
    }
}

#pragma mark - controller setting

- (Class)itemClass {
    
    return [WKVocab class];
}

- (NSString *)collectionItemCellViewIdentifier {
    
    return kVocabCellIdentifier;
}

- (NSString *)collectionItemSupplementaryViewIdentifier {
    
    return kVocabSuppViewIdentifier;
}

- (NSString *)detailsSegueIdentifier {
    
    return kDetailsSegueIdentifier;
}

@end
