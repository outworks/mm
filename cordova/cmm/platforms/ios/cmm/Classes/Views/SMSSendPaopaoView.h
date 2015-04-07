//
//  SMSSendPaopaoView.h
//  cmm
//
//  Created by Hcat on 15/4/7.
//
//

#import <UIKit/UIKit.h>
#import "Unit.h"

@protocol SMSSendPaopaoViewDelegate;

@interface SMSSendPaopaoView : UIView

@property (weak,nonatomic) id<SMSSendPaopaoViewDelegate>delegate;


@property (weak, nonatomic) IBOutlet UILabel *lb_wangdian;
@property (weak, nonatomic) IBOutlet UITextField * tx_userName;
@property (weak, nonatomic) IBOutlet UITextField * tx_phone;
@property (weak, nonatomic) IBOutlet UILabel *lb_task;

@property (weak, nonatomic) IBOutlet UIButton *btn_send;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_bg;


@property(nonatomic,strong)Unit *unit;
@property(nonatomic,strong)NSString *taskName;
@property(nonatomic,strong)NSString *taskId;

+ (SMSSendPaopaoView *)initCustomPaopaoView;

@end


@protocol SMSSendPaopaoViewDelegate <NSObject>

-(void)sendAction:(SMSSendPaopaoView *)view;

@end

