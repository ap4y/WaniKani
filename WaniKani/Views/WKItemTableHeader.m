//
//  WKItemTableHeader.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 24/02/13.
//
//

#import "WKItemTableHeader.h"

@interface WKItemTableHeader ()
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation WKItemTableHeader

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

- (void)setTitle:(NSString *)title {

    _titleLabel.text = title;
}

#pragma mark - private

- (void)createViewFromNib {
    
    [[NSBundle mainBundle] loadNibNamed:@"WKItemTableHeader" owner:self options:nil];
    [self addSubview:_headerView];    
}

@end