//
//  TaskCell.m
//  cmm
//
//  Created by ilikeido on 15-3-29.
//
//

#import "TaskCell.h"
#import "KACircleProgressView.h"
#import "UIColor+External.h"

@interface TaskCell ()
@property (nonatomic, strong)KACircleProgressView *v_progress;

@property (weak, nonatomic) IBOutlet UILabel *lb_finish;

@property (weak, nonatomic) IBOutlet UILabel *lb_total;

@property (weak, nonatomic) IBOutlet UILabel *lb_progress;

@property (weak, nonatomic) IBOutlet UILabel *lb_state;

@property (weak, nonatomic) IBOutlet UIView *vi_progress;

@property (weak, nonatomic) IBOutlet UILabel *lb_taskname;

@property (weak, nonatomic) IBOutlet UILabel *lb_typename;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;


@end

@implementation TaskCell

- (void)awakeFromNib {
    // Initialization code
    _v_progress = [[KACircleProgressView alloc] initWithSize:_vi_progress.frame.size.width withType:KACircleProgressViewTypeCircleBacked andProgressBarLineWidth:3 andCircleBackLineWidth:3];
    [_v_progress setProgress:.65]; // set progress to 0.3 out of 1.0
    [_v_progress setColorOfBackCircle:HEX_RGB(0xeeeeee)];
    [_v_progress setColorOfProgressBar:HEX_RGB(0xeeeeee)];
    [_v_progress setCenter:_vi_progress.center];
    [self.contentView addSubview:_v_progress];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setTask:(Task *)task{
    _task = task;
    _lb_taskname.text = task.name;
    _lb_state.text = task.stateString;
    _lb_typename.text = [NSString stringWithFormat:@"任务类型:%@",task.opetypeidLabel];
    _lb_time.text = [NSString stringWithFormat:@"时间:%@ ~ %@",task.starttimeString,task.endtimeString];
    _v_progress.progress = (float)task.finishUnitNum/(float)task.totalUnitinfo;
    _lb_progress.text = [NSString stringWithFormat:@"%d",(int)(task.finishUnitNum*100/(float)task.totalUnitinfo)];
    _lb_total.text = [NSString stringWithFormat:@"%d",task.totalUnitinfo];
    _lb_finish.text = [NSString stringWithFormat:@"%d",task.finishUnitNum];
    if ([task.state isEqual:@"1"]) {
         [_v_progress setColorOfProgressBar:HEX_RGB(0xeeeeee)];
    }else if([task.state isEqual:@"2"]){
        [_v_progress setColorOfProgressBar:HEX_RGB(0xfe3535)];
    }else if([task.state isEqual:@"3"]){
        [_v_progress setColorOfProgressBar:HEX_RGB(0x57ef2e5)];
    }else if([task.state isEqual:@"4"]){
        [_v_progress setColorOfProgressBar:HEX_RGB(0x57ef2e)];
    }else if([task.state isEqual:@"5"]){
        [_v_progress setColorOfProgressBar:HEX_RGB(0xfe3535)];
    }
}

@end
