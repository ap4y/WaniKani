//
//  WKItemViewCell.h
//  WaniKani
//
//  Created by Arthur Evstifeev on 17/02/13.
//
//

#import <UIKit/UIKit.h>

@class WKKanji;
@interface WKKanjiViewCell : UICollectionViewCell
- (void)setKanjiItem:(WKKanji *)kanjiItem;
@end
