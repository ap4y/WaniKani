//
//  WKItemViewCell.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 17/02/13.
//
//

#import "WKKanjiViewCell.h"
#import <QuartzCore/QuartzCore.h>

#import "WKKanji.h"
#import "WKCustomization.h"

@interface WKKanjiViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@property (weak, nonatomic) IBOutlet UILabel *readingLabel;
@property (weak, nonatomic) IBOutlet UILabel *meaningLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lockedImageView;
@end

@implementation WKKanjiViewCell

- (void)setItem:(id)item {
    
    WKKanji *kanjiItem      = (WKKanji *)item;
    _characterLabel.text    = kanjiItem.character;
    _meaningLabel.text      = [[kanjiItem.meaning componentsSeparatedByString:@","] objectAtIndex:0];
    
    NSString *reading       = [kanjiItem valueForKey:kanjiItem.importantReading];
    _readingLabel.text      = [[reading componentsSeparatedByString:@","] objectAtIndex:0];
    
    [_lockedImageView setHidden:(kanjiItem.stats != nil)];
}

#pragma mark - private

- (void)createViewFromNib {
    [super createViewFromNib];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];

    gradientLayer.startPoint    = CGPointMake(0.5f, 0.0f);
    gradientLayer.endPoint      = CGPointMake(0.5f, 1.0f);
    gradientLayer.frame         = self.bounds;
    gradientLayer.colors        = @[ (id)[RGBA(255.0, 0.0, 170.0, 1.0) CGColor],
                                     (id)[RGBA(221.0, 0.0, 147.0, 1.0) CGColor] ];
    
    [self.layer insertSublayer:gradientLayer atIndex:0];
    
    _lockedImageView.image = [WKCustomization resizableImageNamed:@"locked"
                                                    withCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [self addSubview:_lockedImageView];
}

@end
