//
//  WKVocabViewCell.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 17/02/13.
//
//

#import "WKVocabViewCell.h"
#import "WKVocab.h"

#import "WKCustomization.h"

@interface WKVocabViewCell ()
@property (strong, nonatomic) IBOutlet UICollectionViewCell *cellView;
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@property (weak, nonatomic) IBOutlet UILabel *readingLabel;
@property (weak, nonatomic) IBOutlet UILabel *meaningLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lockedImageView;

@end

@implementation WKVocabViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self createViewFromNib];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    [self createViewFromNib];
    
    return self;
}

- (void)setVocabItem:(WKVocab *)vocabItem {
    
    _characterLabel.text    = vocabItem.character;
    _readingLabel.text      = [[vocabItem.kana componentsSeparatedByString:@","] objectAtIndex:0];
    _meaningLabel.text      = [[vocabItem.meaning componentsSeparatedByString:@","] objectAtIndex:0];
    [_lockedImageView setHidden:(vocabItem.stats != nil)];
}

#pragma mark - private

- (void)createViewFromNib {
    
    [[NSBundle mainBundle] loadNibNamed:@"WKVocabViewCell" owner:self options:nil];
    [self addSubview:_cellView];
    
    _lockedImageView.image = [WKCustomization resizableImageNamed:@"locked"
                                                    withCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [self addSubview:_lockedImageView];
}

@end
