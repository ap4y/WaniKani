//
//  WKItemCollectionCell.m
//  WaniKani
//
//  Created by Arthur Evstifeev on 2/03/13.
//
//

#import "WKItemCollectionCell.h"
#import "WKItem.h"

@interface WKItemCollectionCell ()

@end

@implementation WKItemCollectionCell

- (void)setItem:(WKItem *)item {
    
}

#pragma mark - private

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([touches count] == 1 && _cellViewTouched) _cellViewTouched();
}

@end
