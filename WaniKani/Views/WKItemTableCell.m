//
//  WKItemTableCell.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 24/02/13.
//
//

#import "WKItemTableCell.h"
#import "WKItem.h"

#import "WKRadical.h"
#import "WKKanji.h"
#import "WKVocab.h"

#import "UIImageView+AFNetworking.h"
#import "WKCustomization.h"

@interface WKItemTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *chracterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *characterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailsTextLabel;
@end

@implementation WKItemTableCell

- (void)setItem:(WKItem *)item {
 
    NSString *image = nil;
    if ( [item respondsToSelector:@selector(image)] && (image = [item valueForKey:@"image"]) ) {
        
        [_characterImageView setImageWithURL:[NSURL URLWithString:image]];
        _chracterLabel.text = @"";
        
    } else {
        
        [_characterImageView setImage:nil];
        _chracterLabel.text = item.character;
    }
    
    NSArray *colors = @[ RGBA(0.0, 170.0, 255.0, 1.0), RGBA(0.0, 147.0, 221.0, 1.0) ];
    if ([item isKindOfClass:[WKKanji class]]) {
        
        colors = @[ RGBA(255.0, 0.0, 170.0, 1.0), RGBA(221.0, 0.0, 147.0, 1.0) ];
        
    } else if ([item isKindOfClass:[WKVocab class]]) {
        
        colors = @[ RGBA(170.0, 0.0, 255.0, 1.0), RGBA(147.0, 0.0, 221.0, 1.0) ];
    }
    
    [_backgroundImageView setImage:[WKCustomization gradientImageWithFrame:self.frame
                                                                    colors:colors
                                                                startPoint:CGPointMake(0.5f, 0.0f)
                                                                  endPoint:CGPointMake(0.5f, 1.0f)]];
}

- (void)setDetailsText:(NSString *)detailsText {
    
    _detailsTextLabel.text = detailsText;
}

@end
