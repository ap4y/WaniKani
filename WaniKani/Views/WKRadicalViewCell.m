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
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *characterImageView;
@property (weak, nonatomic) IBOutlet UILabel *meaningLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lockedImageView;
@end

@implementation WKRadicalViewCell

- (void)setItem:(WKItem *)item {
    
    WKRadical *radical = (WKRadical *)item;    
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

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.startPoint    = CGPointMake(0.5f, 0.0f);
    gradientLayer.endPoint      = CGPointMake(0.5f, 1.0f);
    gradientLayer.frame         = self.bounds;
    gradientLayer.colors        = @[ (id)[RGBA(0.0, 170.0, 255.0, 1.0) CGColor],
                                     (id)[RGBA(0.0, 147.0, 221.0, 1.0) CGColor] ];
    
    [self.layer insertSublayer:gradientLayer atIndex:0];
    
    _lockedImageView.image = [WKCustomization resizableImageNamed:@"locked"
                                                    withCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
}

@end
