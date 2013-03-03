//
//  WKItemsHeaderView.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 17/02/13.
//
//

#import "WKItemsHeaderView.h"
#import "WKItem.h"

@interface WKItemsHeaderView ()
@property (strong, nonatomic) IBOutlet PSUICollectionReusableView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelTitleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *percentageProgressBar;
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

- (void)setItems:(NSArray *)items level:(NSNumber *)level {
    
    NSArray *finishedItems  = [items filteredArrayUsingPredicate:[WKItem completedItemsPredicate]];
    
    _levelTitleLabel.text   = [NSLocalizedString(@"Level ", nil) stringByAppendingString:[level stringValue]];
    _percentageLabel.text   = [NSString stringWithFormat:@"%i/%i", [finishedItems count], [items count]];
    
    CGFloat percentage      = (CGFloat)[finishedItems count] / (CGFloat)[items count];
    [_percentageProgressBar setProgress:percentage];
}

#pragma mark - private

- (void)createViewFromNib {
    
    [[NSBundle mainBundle] loadNibNamed:@"WKItemsHeaderView" owner:self options:nil];
    [self addSubview:_headerView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([touches count] == 1 && _headerViewTouched) _headerViewTouched();
}

@end
