//
//  UnitFinishView.h
//  cmm
//
//  Created by Hcat on 15/4/7.
//
//

#import <UIKit/UIKit.h>
#import "Unit.h"

@interface UnitFinishView : UIView


@property (weak, nonatomic) IBOutlet UILabel *lb_wangdian;
@property (weak, nonatomic) IBOutlet UILabel *lb_contact;
@property (weak, nonatomic) IBOutlet UILabel *lb_task;
@property (weak, nonatomic) IBOutlet UIView *v_content;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_bg;
@property (weak, nonatomic) IBOutlet UILabel *lb_taskSatus;
@property (weak, nonatomic) IBOutlet UIScrollView *sc_imagev;

@property(nonatomic,strong)Unit *unit;
@property(nonatomic,strong)NSString *taskName;
@property(nonatomic,strong)NSString *taskId;


+ (UnitFinishView *)initCustomPaopaoView;


@end
