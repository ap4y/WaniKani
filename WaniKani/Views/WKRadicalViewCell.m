//
//  WKRadicalCell.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 17/02/13.
//
//

#import "WKRadicalViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

#import "WKRadical.h"
#import "WKCustomization.h"

@interface WKRadicalViewCell ()
@property (strong, nonatomic) IBOutlet UICollectionViewCell *cellView;
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *characterImageView;
@property (weak, nonatomic) IBOutlet UILabel *meaningLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lockedImageView;

@end

@implementation WKRadicalViewCell

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

- (void)setRadical:(WKRadical *)radical {
    
    if (radical.character) {
        
        _characterLabel.text        = radical.character;
        _characterImageView.image   = nil;
        
    } else {
        
        _characterLabel.text        = nil;
        [_characterImageView setImageWithURL:[NSURL URLWithString:radical.image]];
    }
    
    _meaningLabel.text = [[radical.meaning componentsSeparatedByString:@","] objectAtIndex:0];
    [_lockedImageView setHidden:(radical.stats != nil)];
}

#pragma mark - private

- (void)createViewFromNib {
    
    [[NSBundle mainBundle] loadNibNamed:@"WKRadicalViewCell" owner:self options:nil];
    [self addSubview:_cellView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.startPoint    = CGPointMake(0.5f, 0.0f);
    gradientLayer.endPoint      = CGPointMake(0.5f, 1.0f);
    gradientLayer.frame         = self.bounds;
    gradientLayer.colors        = @[ (id)[RGBA(0.0, 170.0, 255.0, 1.0) CGColor],
                                     (id)[RGBA(0.0, 147.0, 221.0, 1.0) CGColor] ];
    
    [self.layer insertSublayer:gradientLayer atIndex:0];
    
    _lockedImageView.image = [WKCustomization resizableImageNamed:@"locked"
                                                    withCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [self addSubview:_lockedImageView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([touches count] == 1 && _cellViewTouched) _cellViewTouched();
}

@end
