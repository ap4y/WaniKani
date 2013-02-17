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

@interface WKKanjiViewCell ()
@property (strong, nonatomic) IBOutlet UICollectionViewCell *cellView;
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@property (weak, nonatomic) IBOutlet UILabel *readingLabel;
@property (weak, nonatomic) IBOutlet UILabel *meaningLabel;

@end

@implementation WKKanjiViewCell

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

- (void)setKanjiItem:(WKKanji *)kanjiItem {
    
    _characterLabel.text    = kanjiItem.character;
    _meaningLabel.text      = [[kanjiItem.meaning componentsSeparatedByString:@","] objectAtIndex:0];
    
    NSString *reading       = [kanjiItem valueForKey:kanjiItem.importantReading];
    _readingLabel.text      = [[reading componentsSeparatedByString:@","] objectAtIndex:0];
}

#pragma mark - private

- (void)createViewFromNib {
    
    [[NSBundle mainBundle] loadNibNamed:@"WKKanjiViewCell" owner:self options:nil];
    [self addSubview:_cellView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];

    gradientLayer.startPoint    = CGPointMake(0.5f, 0.0f);
    gradientLayer.endPoint      = CGPointMake(0.5f, 1.0f);
    gradientLayer.frame         = self.bounds;
    gradientLayer.colors        = @[ (id)[RGBA(255.0, 0.0, 170.0, 1.0) CGColor],
                                     (id)[RGBA(221.0, 0.0, 147.0, 1.0) CGColor] ];
    
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

@end
