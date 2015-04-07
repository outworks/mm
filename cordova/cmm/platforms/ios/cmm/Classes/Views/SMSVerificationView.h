//
//  SMSVerificationView.h
//  cmm
//
//  Created by Hcat on 15/4/7.
//
//

#import <UIKit/UIKit.h>
#import "Unit.h"

@protocol SMSVerificationViewDelegate;

@interface SMSVerificationView : UIView

@property (weak,nonatomic) id<SMSVerificationViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *lb_wangdian;
@property (weak, nonatomic) IBOutlet UILabel *lb_contact;
@property (weak, nonatomic) IBOutlet UILabel *lb_task;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_bg;

@property (weak, nonatomic) IBOutlet UIButton *btn_verification;

@property (weak, nonatomic) IBOutlet UITextField *tx_verification;

@property(nonatomic,strong)Unit *unit;
@property(nonatomic,strong)NSString *taskName;
@property(nonatomic,strong)NSString *taskId;


+ (SMSVerificationView *)initCustomPaopaoView;

@end


@protocol SMSVerificationViewDelegate <NSObject>

-(void)VerificationAction:(SMSVerificationView *)view;

@end
