//
//  UnitFinishView.m
//  cmm
//
//  Created by Hcat on 15/4/7.
//
//

#import "UnitFinishView.h"

@implementation UnitFinishView

+ (UnitFinishView *)initCustomPaopaoView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"UnitFinishView" owner:self options:nil];
    
    return [nibView objectAtIndex:0];
    
}




- (void)drawRect:(CGRect)rect {
    // Drawing code
    _imageV_bg.layer.cornerRadius = 4.0f;
    _imageV_bg.layer.borderWidth = 1.f;
    _imageV_bg.layer.borderColor = [UIColor clearColor].CGColor;
    _imageV_bg.layer.masksToBounds = YES;
    
    _sc_imagev.layer.cornerRadius = 4.0f;
    _sc_imagev.layer.borderWidth = 1.f;
    _sc_imagev.layer.borderColor = [UIColor grayColor].CGColor;
    _sc_imagev.layer.masksToBounds = YES;

}

@end
