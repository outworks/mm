//
//  SceneFinishPaopaoView.m
//  cmm
//
//  Created by Hcat on 15/4/28.
//
//

#import "SceneFinishPaopaoView.h"

@implementation SceneFinishPaopaoView


+ (SceneFinishPaopaoView *)initCustomPaopaoView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SceneFinishPaopaoView" owner:self options:nil];
    
    return [nibView objectAtIndex:0];
}


-(void)setUnit:(Unit *)unit{
    _unit = unit;
    _lb_wangdian.text = unit.unitname;
    _lb_contact.text = [NSString stringWithFormat:@"%@(%@)",unit.bossname,unit.bossphonenum];
    _lb_task.text = [NSString stringWithFormat:@"%@",[self telecomName]];
    _lb_addr.text = [NSString stringWithFormat:@"经度：%@，纬度:%@",unit.affirmLon,unit.affirmLat];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
