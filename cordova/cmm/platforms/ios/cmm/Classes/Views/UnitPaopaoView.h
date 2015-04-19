//
//  PointPaopaoView.h
//  cmm
//
//  Created by Hcat on 15/4/6.
//
//

#import "Unit.h"


@interface UnitPaopaoView : UIView


@property (weak, nonatomic) IBOutlet UILabel *lb_wangdian;
@property (weak, nonatomic) IBOutlet UILabel *lb_contact;
@property (weak, nonatomic) IBOutlet UILabel *lb_task;


@property(nonatomic,strong)Unit *unit;


+ (UnitPaopaoView *)initCustomPaopaoView;


@end



