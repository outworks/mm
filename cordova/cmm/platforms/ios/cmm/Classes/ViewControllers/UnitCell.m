//
//  UnitCell.m
//  cmm
//
//  Created by ilikeido on 15/4/19.
//
//

#import "UnitCell.h"

@implementation UnitCell

-(void)setUnit:(Unit *)unit{
    _unit = unit;
    _lb_contact.text = [NSString stringWithFormat:@"%@(%@)",unit.bossname,unit.bossphonenum];
    _lb_name.text = unit.unitname;
    _lb_telecom.text = [self telecomName];
    if (unit.isTask) {
        self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
    }
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
    return @"未识别";
}

@end
