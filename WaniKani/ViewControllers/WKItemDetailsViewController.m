//
//  WKItemDetailsViewController.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 26/02/13.
//
//

#import "WKItemDetailsViewController.h"
#import "WKItem.h"

#import "WKRadical.h"
#import "WKKanji.h"
#import "WKVocab.h"
#import "WKItemStats.h"

#import "WKCustomization.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

@interface WKItemDetailsViewController ()
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIView *meaningsView;
@property (strong, nonatomic) IBOutlet UIView *readingView;
@property (strong, nonatomic) IBOutlet UIView *kanjiReadingView;
@property (strong, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UIView *radicalProgressView;
@property (strong, nonatomic) IBOutlet UIView *progressHeaderView;
@property (strong, nonatomic) IBOutlet UIView *progressFooterView;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *namingProgressView;
@property (weak, nonatomic) IBOutlet UILabel *namingPercentLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *readingProgressView;
@property (weak, nonatomic) IBOutlet UILabel *readingPercentLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *meaningProgressView;
@property (weak, nonatomic) IBOutlet UILabel *meaningPercentLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *combinedProgressView;
@property (weak, nonatomic) IBOutlet UILabel *combinedPercentLabel;

@property (weak, nonatomic) IBOutlet UILabel *nextReviewDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *unlockedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *srsLevelLabel;

@property (weak, nonatomic) IBOutlet UILabel *meaningsLabel;

@property (weak, nonatomic) IBOutlet UILabel *onReadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *kunReadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *readingLabel;

@property (weak, nonatomic) IBOutlet UIImageView *levelBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *characterBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *characterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *srsBackgroundView;
@end

@implementation WKItemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WKCustomization setBackgroundForView:self.view];
    
    [[NSBundle mainBundle] loadNibNamed:@"WKItemDetailViews" owner:self options:nil];
    [_contentScrollView addSubview:_titleView];

    UIView *readingView = [self prepareMainViews];    
    if (_item.stats) {
        
        [self prepareStatsViewsBelowReadingView:readingView];
        
        WKItemStats *stats          = _item.stats;
                
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        _unlockedDateLabel.text     = [dateFormatter stringFromDate:[stats unlockDate]];
        _nextReviewDateLabel.text   = [dateFormatter stringFromDate:[stats nextReviewDate]];
        
        [self fillStatsValuesFromItemStats:stats];
    }
    
    _contentScrollView.contentSize = [WKCustomization sizeThatFitsView:_progressFooterView];

    NSArray *meanings       = [_item.meaning componentsSeparatedByString:@", "];
    self.title              = [[meanings objectAtIndex:0] capitalizedString];
    _meaningsLabel.text     = [_item.meaning capitalizedString];
    
    _levelLabel.text        = [_item.level stringValue];
    NSArray *colors         = @[ RGBA(166.0, 166.0, 166.0, 1.0), RGBA(153.0, 153.0, 153.0, 1.0) ];
    UIImage* levelGradient  = [WKCustomization gradientImageWithFrame:_levelBackgroundView.bounds
                                                       colors:colors
                                                   startPoint:CGPointMake(0.5f, 0.0f)
                                                     endPoint:CGPointMake(0.5f, 1.0f)];    
    [_levelBackgroundView setImage:levelGradient];
    _levelBackgroundView.layer.cornerRadius = 3.0f;
    
    [self fillReadingValues];
    [self fillCharacterValue];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - private

- (UIView *)prepareMainViews {
 
    UIView *readingView = _titleView;
    if (![_item isKindOfClass:[WKRadical class]]) {
        
        [WKCustomization insertView:_meaningsView into:_contentScrollView positionedBelow:_titleView];
        
        if ([_item isKindOfClass:[WKKanji class]]) {
            
            [WKCustomization insertView:_kanjiReadingView into:_contentScrollView positionedBelow:_meaningsView];
            readingView = _kanjiReadingView;
            
        } else {
            
            [WKCustomization insertView:_readingView into:_contentScrollView positionedBelow:_meaningsView];
            readingView = _readingView;
        }
    }
    
    return readingView;
}

- (void)prepareStatsViewsBelowReadingView:(UIView *)readingView {
    
    UIView *belowView;
    [WKCustomization insertView:_progressHeaderView into:_contentScrollView positionedBelow:readingView];
    if ([_item isKindOfClass:[WKRadical class]]) {
        
        [WKCustomization insertView:_radicalProgressView into:_contentScrollView positionedBelow:_progressHeaderView];
        belowView = _radicalProgressView;
        
    } else {
        
        [WKCustomization insertView:_progressView into:_contentScrollView positionedBelow:_progressHeaderView];
        belowView = _progressView;
    }
    [WKCustomization insertView:_progressFooterView into:_contentScrollView positionedBelow:belowView];
}

- (void)fillReadingValues {
    
    if ([_item isKindOfClass:[WKKanji class]]) {
        
        WKKanji *kanjiItem      = (WKKanji *)_item;
        _onReadingLabel.text    = kanjiItem.onyomi;
        _kunReadingLabel.text   = kanjiItem.kunyomi;
        
        if ([kanjiItem.importantReading isEqualToString:@"onyomi"]) {
            
            _kunReadingLabel.alpha  = 0.3f;
            
        } else {
            
            _onReadingLabel.alpha   = 0.3f;
        }
        
    } else if ([_item isKindOfClass:[WKVocab class]]) {
        
        WKVocab *vocabItem  = (WKVocab *)_item;
        _readingLabel.text  = vocabItem.kana;
    }
}

- (void)fillCharacterValue {
    
    if ( [_item.character length] <= 0 && [_item isKindOfClass:[WKRadical class]] ) {
        
        [_characterLabel sizeToFit];
        [_characterLabel setHidden:YES];
        
        [_characterImageView setImageWithURL:[NSURL URLWithString:[_item valueForKey:@"image"]]];
        
    } else {
        
        _characterLabel.text = _item.character;
        [_characterLabel sizeToFit];
    }
    
    CGRect characterLabelFrame       = _characterLabel.frame;
    characterLabelFrame.size.width  += 16.0f;
    characterLabelFrame.size.height += 8.0f;
    _characterLabel.frame            = characterLabelFrame;    
    _characterBackgroundView.frame   = characterLabelFrame;
    _characterImageView.frame        = CGRectInset(characterLabelFrame, 8.0f, 0.0f);
    
    _characterBackgroundView.layer.cornerRadius = 3.0f;
    NSArray *colors = @[ RGBA(0.0, 170.0, 255.0, 1.0), RGBA(0.0, 147.0, 221.0, 1.0) ];
    if ([_item isKindOfClass:[WKKanji class]]) {
        
        colors      = @[ RGBA(255.0, 0.0, 170.0, 1.0), RGBA(221.0, 0.0, 147.0, 1.0) ];
        
    } else if ([_item isKindOfClass:[WKVocab class]]) {
        
        colors      = @[ RGBA(170.0, 0.0, 255.0, 1.0), RGBA(147.0, 0.0, 221.0, 1.0) ];
    }    
    UIImage* itemGradient   = [WKCustomization gradientImageWithFrame:_levelBackgroundView.bounds
                                                               colors:colors
                                                           startPoint:CGPointMake(0.5f, 0.0f)
                                                             endPoint:CGPointMake(0.5f, 1.0f)];
    [_characterBackgroundView setImage:itemGradient];
}

- (void)fillStatsValuesFromItemStats:(WKItemStats *)stats {
    
    _srsLevelLabel.text         = [stats.srs capitalizedString];
    [_srsLevelLabel sizeToFit];
    _srsLevelLabel.frame        = CGRectInset(_srsLevelLabel.frame, -10.0f, 0.0f);
    _srsBackgroundView.frame    = _srsLevelLabel.frame;
    _srsBackgroundView.layer.cornerRadius = 2.0f;
    
    NSArray *colors = @[ RGBA(0.0, 170.0, 255.0, 1.0), RGBA(0.0, 147.0, 221.0, 1.0) ];
    if ([_item isKindOfClass:[WKKanji class]]) {
        
        colors      = @[ RGBA(255.0, 0.0, 170.0, 1.0), RGBA(221.0, 0.0, 147.0, 1.0) ];
        
    } else if ([_item isKindOfClass:[WKVocab class]]) {
        
        colors      = @[ RGBA(170.0, 0.0, 255.0, 1.0), RGBA(147.0, 0.0, 221.0, 1.0) ];
    }
    UIImage* itemGradient   = [WKCustomization gradientImageWithFrame:_levelBackgroundView.bounds
                                                               colors:colors
                                                           startPoint:CGPointMake(0.5f, 0.0f)
                                                             endPoint:CGPointMake(0.5f, 1.0f)];
    [_srsBackgroundView setImage:itemGradient];
    
    CGFloat meaningCorrect, meaningIncorrect, meaningPercentage,
    readingCorrect, readingIncorrect, readingPercentage,
    correctPercentage;
    
    meaningCorrect      = [stats.meaningCorrect floatValue];
    meaningIncorrect    = [stats.meaningIncorrect floatValue];
    readingCorrect      = [stats.readingCorrect floatValue];
    readingIncorrect    = [stats.readingIncorrect floatValue];
    
    meaningPercentage   = meaningCorrect / ( meaningCorrect + meaningIncorrect );
    readingPercentage   = readingCorrect / ( readingCorrect + readingIncorrect );
    correctPercentage   = ( (readingCorrect + meaningCorrect) /
                            (meaningCorrect + meaningIncorrect + readingCorrect + readingIncorrect) );
    
    _namingPercentLabel.text        = [NSString stringWithFormat:@"%.00f/%.00f",
                                       meaningCorrect, ( meaningCorrect + meaningIncorrect )];
    _namingProgressView.progress    = meaningPercentage;
    
    _readingPercentLabel.text       = [NSString stringWithFormat:@"%.00f/%.00f",
                                       readingCorrect, ( readingCorrect + readingIncorrect )];
    _readingProgressView.progress   = readingPercentage;

    _meaningPercentLabel.text       = [NSString stringWithFormat:@"%.00f/%.00f",
                                       meaningCorrect, ( meaningCorrect + meaningIncorrect )];
    _meaningProgressView.progress   = meaningPercentage;

    _combinedPercentLabel.text      = [NSString stringWithFormat:@"%.00f%%", correctPercentage * 100.0f];
    _combinedProgressView.progress  = correctPercentage;
}

@end
