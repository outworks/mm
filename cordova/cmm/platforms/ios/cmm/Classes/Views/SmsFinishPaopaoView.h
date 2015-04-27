//
//  PointPaopaoView.h
//  cmm
//
//  Created by Hcat on 15/4/6.
//
//

#import "Unit.h"
#import "Task.h"

@interface SmsFinishPaopaoView : UIView


@property (weak, nonatomic) IBOutlet UILabel *lb_wangdian;
@property (weak, nonatomic) IBOutlet UILabel *lb_contact;
@property (weak, nonatomic) IBOutlet UILabel *lb_task;

@property (weak, nonatomic) IBOutlet UILabel *lb_taskstate;

@property (weak, nonatomic) IBOutlet UILabel *lb_phone;

@property (weak, nonatomic) IBOutlet UILabel *lb_vcode;

@property(nonatomic,strong)Unit *unit;
@property(nonatomic,strong)NSString *taskName;

+ (SmsFinishPaopaoView *)initCustomPaopaoView;

@end



