//
//  PointPaopaoView.m
//  cmm
//
//  Created by Hcat on 15/4/6.
//
//

#import "PointPaopaoView.h"

@implementation PointPaopaoView

#pragma mark - set&&get 

-(void)setIsTakePicture:(BOOL)isTakePicture{
    _isTakePicture = isTakePicture;
    
    if (_isTakePicture == YES) {
        [_imageV_phone setImage:[UIImage imageNamed:@"任务_按钮_现场拍照.png"]];
    }else{
        [_imageV_phone setImage:[UIImage imageNamed:@"icon_task_photo_unselect.png"]];
    }

}

-(void)setIsSMSConfirmation:(BOOL)isSMSConfirmation{
    
    _isSMSConfirmation = isSMSConfirmation;
    
    if (_isSMSConfirmation == YES) {
        [_imageV_SMS setImage:[UIImage imageNamed:@"任务_按钮_短信确认.png"]];
    }else{
         [_imageV_SMS setImage:[UIImage imageNamed:@"icon_task_sms_unselect.png"]];
    }

}

-(void)setIssceneConfirmation:(BOOL)issceneConfirmation{
    
    _issceneConfirmation = issceneConfirmation;
    
    if (_issceneConfirmation == YES) {
        [_imageV_scene setImage:[UIImage imageNamed:@"任务_按钮_现场确认.png"]];
    }else{
        [_imageV_scene setImage:[UIImage imageNamed:@"icon_task_locale_unselect.png"]];
    }


    
    
}


#pragma mark -

+ (PointPaopaoView *)initCustomPaopaoView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PointPaopaoView" owner:self options:nil];
    
    return [nibView objectAtIndex:0];
    
}


- (IBAction)takePictureAction:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(takePictureAction:)]) {
        if (_isTakePicture == NO) {
            return;
        }else{
            [self.delegate takePictureAction:self
             ];
        }
    }
    
}


- (IBAction)SMSConfirmationAction:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(SMSConfirmationAction:)]) {
        if (_isSMSConfirmation == NO) {
            return;
        }else{
            [self.delegate SMSConfirmationAction:self
             ];
        }

    }
    
    
}



- (IBAction)sceneConfirmationAction:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sceneConfirmationAction:)]) {
        if (_issceneConfirmation == NO) {
            return;
        }else{
            [self.delegate sceneConfirmationAction:self
             ];
        }
        
       
    }

}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    _imageV_bg.layer.cornerRadius = 4.0f;
    _imageV_bg.layer.borderWidth = 1.f;
    _imageV_bg.layer.borderColor = [UIColor clearColor].CGColor;
    _imageV_bg.layer.masksToBounds = YES;
    
    if (_isTakePicture == YES) {
        [_imageV_phone setImage:[UIImage imageNamed:@"任务_按钮_现场拍照.png"]];
    }else{
        [_imageV_phone setImage:[UIImage imageNamed:@"icon_task_photo_unselect.png"]];
    }
    
    if (_isSMSConfirmation == YES) {
        [_imageV_SMS setImage:[UIImage imageNamed:@"任务_按钮_短信确认.png"]];
    }else{
        [_imageV_SMS setImage:[UIImage imageNamed:@"icon_task_sms_unselect.png"]];
    }
    
    if (_issceneConfirmation == YES) {
        [_imageV_scene setImage:[UIImage imageNamed:@"任务_按钮_现场确认.png"]];
    }else{
        [_imageV_scene setImage:[UIImage imageNamed:@"icon_task_locale_unselect.png"]];
    }
    
}

@end
