//
//  WKCorrectAnswerView.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 17/03/13.
//
//

#import <UIKit/UIKit.h>

@interface WKCorrectAnswerView : UIView
- (void)setupCorrectAnswer:(NSDictionary *)questionInfo itemType:(NSString *)itemType questionType:(NSString *)qType;
@end
