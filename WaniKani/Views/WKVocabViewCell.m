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
#import <QuartzCore/QuartzCore.h>

@interface WKVocabViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@property (weak, nonatomic) IBOutlet UILabel *readingLabel;
@property (weak, nonatomic) IBOutlet UILabel *meaningLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lockedImageView;
@end

@implementation WKVocabViewCell

-(void)setItem:(WKItem *)item {
    
    WKVocab *vocabItem      = (WKVocab *)item;
    _characterLabel.text    = vocabItem.character;
    _readingLabel.text      = [[vocabItem.kana componentsSeparatedByString:@","] objectAtIndex:0];
    _meaningLabel.text      = [[vocabItem.meaning componentsSeparatedByString:@","] objectAtIndex:0];
    [_lockedImageView setHidden:(vocabItem.stats != nil)];
}

#pragma mark - private

- (void)createViewFromNib {
    [super createViewFromNib];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.startPoint    = CGPointMake(0.5f, 0.0f);
    gradientLayer.endPoint      = CGPointMake(0.5f, 1.0f);
    gradientLayer.frame         = self.bounds;
    gradientLayer.colors        = @[ (id)[RGBA(170.0, 0.0, 255.0, 1.0) CGColor],
                                     (id)[RGBA(147.0, 0.0, 221.0, 1.0) CGColor] ];
    
    [self.layer insertSublayer:gradientLayer atIndex:0];
    
    _lockedImageView.image = [WKCustomization resizableImageNamed:@"locked"
                                                    withCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [self addSubview:_lockedImageView];
}

@end
