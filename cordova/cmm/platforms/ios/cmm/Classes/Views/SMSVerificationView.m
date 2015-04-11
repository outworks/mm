//
//  SMSVerificationView.m
//  cmm
//
//  Created by Hcat on 15/4/7.
//
//

#import "SMSVerificationView.h"

@implementation SMSVerificationView

+ (SMSVerificationView *)initCustomPaopaoView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SMSVerificationView" owner:self options:nil];
    
    return [nibView objectAtIndex:0];
    
}

- (IBAction)verificationAction:(id)sender {
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(VerificationAction:)]) {
        [self.delegate VerificationAction:self
         ];
    }
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    _imageV_bg.layer.cornerRadius = 4.0f;
    _imageV_bg.layer.borderWidth = 1.f;
    _imageV_bg.layer.borderColor = [UIColor clearColor].CGColor;
    _imageV_bg.layer.masksToBounds = YES;
 
    _btn_verification.layer.cornerRadius = 4.0f;
    _btn_verification.layer.borderWidth = 1.f;
    _btn_verification.layer.borderColor = [UIColor clearColor].CGColor;
    _btn_verification.layer.masksToBounds = YES;
    
}

@end
