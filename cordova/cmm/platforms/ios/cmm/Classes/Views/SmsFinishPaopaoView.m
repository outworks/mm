//
//  PointPaopaoView.m
//  cmm
//
//  Created by Hcat on 15/4/6.
//
//

#import "SmsFinishPaopaoView.h"

@implementation SmsFinishPaopaoView

#pragma mark -

+ (SmsFinishPaopaoView *)initCustomPaopaoView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SmsFinishPaopaoView" owner:self options:nil];
    
    return [nibView objectAtIndex:0];
}


-(void)setUnit:(Unit *)unit{
    _unit = unit;
    _lb_wangdian.text = unit.unitname;
    _lb_contact.text = [NSString stringWithFormat:@"%@(%@)",unit.bossname,unit.bossphonenum];
    _lb_phone.text = unit.busiinformsmsPhone;
    _lb_task.text = [NSString stringWithFormat:@"%@",[self telecomName]];
    if (unit.busiinformtime) {
        _lb_taskstate.text = [NSString stringWithFormat:@"已完成(%@)",unit.busiinformtime];
    }else{
        _lb_taskstate.text = @"已完成";
    }
    _lb_vcode.text = unit.busiinformsmscode;
}

-(NSString *)telecomName{
    if ([_unit.telecomsOperator isEqual:@"1"]) {
        return @"移动";
    }
    if ([_unit.telecomsOperator isEqual:@"2"]) {
        return @"联通";
    }
    if ([_unit.telecomsOperator isEqual:@"3"]) {
        return @"电信";
    }
    return @"未知";
}

@end
