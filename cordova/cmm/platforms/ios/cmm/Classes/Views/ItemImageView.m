//
//  ItemImageView.m
//  cmm
//
//  Created by Hcat on 15/4/7.
//
//

#import "ItemImageView.h"

@implementation ItemImageView

+ (ItemImageView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ItemImageView" owner:self options:nil];
    
    return [nibView objectAtIndex:0];
    
}
- (IBAction)deleAction:(id)sender {

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(imageViewDelAction:)]) {
        [self.delegate imageViewDelAction:self];
    }
}


- (IBAction)addAction:(id)sender {
    if (_isAdd == NO) {
        return;
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(imageViewAction:)]) {
        [self.delegate imageViewAction:self];
    }
}

@end
