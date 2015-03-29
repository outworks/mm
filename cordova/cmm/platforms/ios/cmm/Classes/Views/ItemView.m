//
//  ItemView.m
//  cmm
//
//  Created by Hcat on 15/3/30.
//
//

#import "ItemView.h"

@implementation ItemView

+ (ItemView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ItemView" owner:self options:nil];
    
    return [nibView objectAtIndex:0];
    
}


-(IBAction)buttonAciton:(id)sender{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(ItemButtonAction:)]) {
        [self.delegate ItemButtonAction:self
         ];
    }
}

@end
