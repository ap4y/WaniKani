//
//  WKItemsHeaderView.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 17/02/13.
//
//

#import "WKItemsHeaderView.h"

@interface WKItemsHeaderView ()
@property (strong, nonatomic) IBOutlet UICollectionReusableView *headerView;

@end

@implementation WKItemsHeaderView

- (id)initWithFrame:(CGRect)frame{
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

#pragma mark - private

- (void)createViewFromNib {
    
    [[NSBundle mainBundle] loadNibNamed:@"WKItemsHeaderView" owner:self options:nil];
    [self addSubview:_headerView];
}

@end
