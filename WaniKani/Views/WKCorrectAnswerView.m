//
//  WKCorrectAnswerView.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 17/03/13.
//
//

#import "WKCorrectAnswerView.h"
#import "WKCustomization.h"

@interface WKCorrectAnswerView () <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *itemView;
@property (weak, nonatomic) IBOutlet UILabel *correctItemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIWebView *mnemonicWebView;

@property (strong, nonatomic) NSString *answerStyle;
@end

@implementation WKCorrectAnswerView

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

- (void)setupCorrectAnswer:(NSDictionary *)questionInfo itemType:(NSString *)itemType questionType:(NSString *)qType {
    
    NSString *title     = @"";
    NSString *mnemonic  = @"";
    
    if ([itemType isEqualToString:@"r"]) {
        
        title               = [questionInfo valueForKey:@"name"];
        mnemonic            = [questionInfo valueForKey:@"name_mnemonic"];
        
    } else if ([itemType isEqualToString:@"k"]) {

        NSString *importantReading, *meaningMnemonic, *readingMnemonic;
        importantReading    = [questionInfo valueForKey:@"important_reading"];
        title               = ( [qType isEqualToString:@"m"] ?
                                [questionInfo valueForKey:@"meaning"] :
                                [questionInfo valueForKey:importantReading] );
        
        meaningMnemonic     = [questionInfo valueForKey:@"meaning_mnemonic"];
        readingMnemonic     = [questionInfo valueForKey:@"reading_mnemonic"];
        mnemonic            = ( [qType isEqualToString:@"m"] ? meaningMnemonic : readingMnemonic );
        
    } else if ([itemType isEqualToString:@"v"]) {
        
        NSString *meaningMnemonic, *readingMnemonic;
        title               = ( [qType isEqualToString:@"m"] ?
                                [questionInfo valueForKey:@"meaning"] :
                                [questionInfo valueForKey:@"reading"] );
        
        meaningMnemonic     = [questionInfo valueForKey:@"meaning_explanation"];
        readingMnemonic     = [questionInfo valueForKey:@"reading_explanation"];
        mnemonic            = ( [qType isEqualToString:@"m"] ? meaningMnemonic : readingMnemonic );
    }
    
    NSString *htmlString    = [NSString stringWithFormat:@"<head><style>%@</style></head>%@", _answerStyle, mnemonic];
    [_mnemonicWebView loadHTMLString:htmlString baseURL:nil];
    
    _correctItemLabel.text      = title;
}

- (void)createViewFromNib {
    
    [[NSBundle mainBundle] loadNibNamed:@"WKCorrectAnswerView" owner:self options:nil];
    [self addSubview:_itemView];
    
    [_backgroundImageView setImage:[WKCustomization defaultViewControllerBackground]];
    
    NSURL *answerStyleUrl   = [[NSBundle mainBundle] URLForResource:@"answer_style" withExtension:@"css"];
    self.answerStyle        = [NSString stringWithContentsOfURL:answerStyleUrl encoding:NSUTF8StringEncoding error:nil];
    
    for (id subview in _mnemonicWebView.subviews) {
        
        if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
            
            ((UIScrollView *)subview).bounces = NO;
            break;
        }
    }
}

@end
