//
//  PointPaopaoView.m
//  cmm
//
//  Created by Hcat on 15/4/6.
//
//

#import "UnitTaskPaopaoView.h"

@implementation UnitTaskPaopaoView

#pragma mark -

+ (UnitTaskPaopaoView *)initCustomPaopaoView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"UnitPaopaoView" owner:self options:nil];
    
    return [nibView objectAtIndex:0];
}


-(void)setUnit:(Unit *)unit{
    _unit = unit;
    _lb_wangdian.text = unit.unitname;
    _lb_contact.text = [NSString stringWithFormat:@"%@(%@)",unit.bossname,unit.bossphonenum];
    _lb_task.text = [NSString stringWithFormat:@"%@",[self telecomName]];
    
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

- (IBAction)beginAction:(id)sender {
    if(_delegate){
        [_delegate beginTask:self];
    }
}

@end
