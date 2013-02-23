//
//  WKStatsViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 14/02/13.
//
//

#import "WKStatsViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "WKRadical.h"
#import "WKKanji.h"
#import "WKVocab.h"

#import "WKGravatarImage.h"
#import "WKCustomization.h"

@interface WKStatsViewController ()
@property (strong, nonatomic) IBOutlet UIView *statsView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *informationBox;
@property (weak, nonatomic) IBOutlet UIView *settingsBox;
@property (weak, nonatomic) IBOutlet UITableView *statsTableView;
@property (weak, nonatomic) IBOutlet UIButton *apprenticeButton;
@property (weak, nonatomic) IBOutlet UIButton *guruButton;
@property (weak, nonatomic) IBOutlet UIButton *masterButton;
@property (weak, nonatomic) IBOutlet UIButton *enlightenButton;
@property (weak, nonatomic) IBOutlet UIButton *burnedButton;
@end

@implementation WKStatsViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;

    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"btn_logo"]
                  withFinishedUnselectedImage:[UIImage imageNamed:@"btn_logo"]];
    [WKGravatarImage gravatarImageForGravatarId:@"f9e852694ab8a659d1edbf438c2bb4ea" success:^(UIImage *image) {
       
        [self.tabBarItem setFinishedSelectedImage:image withFinishedUnselectedImage:image];
    }];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WKCustomization setBackgroundForView:self.view];
    
    [[NSBundle mainBundle] loadNibNamed:@"WKStatsView" owner:self options:nil];
    [_contentScrollView addSubview:_statsView];    
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.contentSize.width, _statsView.bounds.size.height);
    
    _informationBox.layer.cornerRadius  = 5.0f;
    _settingsBox.layer.cornerRadius     = 5.0f;
    _statsTableView.layer.cornerRadius  = 5.0f;
    
    [self setButtonsGradients];
}

#pragma mark - private

- (void)setButtonsGradients {
    
    UIImage *tempGradient;
    NSArray *colors;
    
    colors          = @[ RGBA(255.0, 0.0, 170.0, 1.0), RGBA(221.0, 0.0, 147.0, 1.0) ];
    tempGradient    = [WKCustomization gradientImageWithFrame:_apprenticeButton.bounds
                                                       colors:colors
                                                   startPoint:CGPointMake(0.5f, 0.0f)
                                                     endPoint:CGPointMake(0.5f, 1.0f)];
    [_apprenticeButton setBackgroundImage:tempGradient forState:UIControlStateNormal];
    
    colors          = @[ RGBA(170.0, 56.0, 198.0, 1.0), RGBA(136.0, 45.0, 158.0, 1.0) ];
    tempGradient    = [WKCustomization gradientImageWithFrame:_apprenticeButton.bounds
                                                       colors:colors
                                                   startPoint:CGPointMake(0.5f, 0.0f)
                                                     endPoint:CGPointMake(0.5f, 1.0f)];
    [_guruButton setBackgroundImage:tempGradient forState:UIControlStateNormal];
    
    colors          = @[ RGBA(85.0, 113.0, 226.0, 1.0), RGBA(41.0, 77.0, 219.0, 1.0) ];
    tempGradient    = [WKCustomization gradientImageWithFrame:_apprenticeButton.bounds
                                                       colors:colors
                                                   startPoint:CGPointMake(0.5f, 0.0f)
                                                     endPoint:CGPointMake(0.5f, 1.0f)];
    [_masterButton setBackgroundImage:tempGradient forState:UIControlStateNormal];
    
    colors          = @[ RGBA(0.0, 170.0, 255.0, 1.0), RGBA(0.0, 147.0, 221.0, 1.0) ];
    tempGradient    = [WKCustomization gradientImageWithFrame:_apprenticeButton.bounds
                                                       colors:colors
                                                   startPoint:CGPointMake(0.5f, 0.0f)
                                                     endPoint:CGPointMake(0.5f, 1.0f)];
    [_enlightenButton setBackgroundImage:tempGradient forState:UIControlStateNormal];
    
    colors          = @[ RGBA(85.0, 85.0, 85.0, 1.0), RGBA(67.0, 67.0, 67.0, 1.0) ];
    tempGradient    = [WKCustomization gradientImageWithFrame:_burnedButton.bounds
                                                       colors:colors
                                                   startPoint:CGPointMake(0.5f, 0.0f)
                                                     endPoint:CGPointMake(0.5f, 1.0f)];
    [_burnedButton setBackgroundImage:tempGradient forState:UIControlStateNormal];
}

@end
