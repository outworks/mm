//
//  SceneFinishPaopaoView.h
//  cmm
//
//  Created by Hcat on 15/4/28.
//
//

#import <UIKit/UIKit.h>
#import "Unit.h"
#import "Task.h"

@interface SceneFinishPaopaoView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lb_wangdian;
@property (weak, nonatomic) IBOutlet UILabel *lb_contact;
@property (weak, nonatomic) IBOutlet UILabel *lb_task;

@property (weak, nonatomic) IBOutlet UILabel *lb_taskstate;

@property (weak, nonatomic) IBOutlet UILabel *lb_addr;

@property(nonatomic,strong)Unit *unit;
@property(nonatomic,strong)NSString *taskName;

+ (SceneFinishPaopaoView *)initCustomPaopaoView;

@end
