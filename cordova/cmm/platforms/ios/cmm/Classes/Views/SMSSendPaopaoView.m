//
//  SMSSendPaopaoView.m
//  cmm
//
//  Created by Hcat on 15/4/7.
//
//

#import "SMSSendPaopaoView.h"

@implementation SMSSendPaopaoView


+ (SMSSendPaopaoView *)initCustomPaopaoView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SMSSendPaopaoView" owner:self options:nil];
    
    return [nibView objectAtIndex:0];
    
}


- (IBAction)sendAction:(id)sender {

    
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sendAction:)]) {
        [self.delegate sendAction:self
         ];
    }
}




- (void)drawRect:(CGRect)rect {
    // Drawing code
    _imageV_bg.layer.cornerRadius = 4.0f;
    _imageV_bg.layer.borderWidth = 1.f;
    _imageV_bg.layer.borderColor = [UIColor clearColor].CGColor;
    _imageV_bg.layer.masksToBounds = YES;
    
    _btn_send.layer.cornerRadius = 4.0f;
    _btn_send.layer.borderWidth = 1.f;
    _btn_send.layer.borderColor = [UIColor clearColor].CGColor;
    _btn_send.layer.masksToBounds = YES;

}

@end
