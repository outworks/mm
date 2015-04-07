//
//  TaskDetailVC.m
//  cmm
//
//  Created by ilikeido on 15-3-31.
//
//

#import "TaskDetailVC.h"
#import "ChannelCell.h"
#import "TaskAPI.h"
#import "MBProgressHUD+Add.h"
#import "Unit.h"
#import "UIColor+External.h"

#import "TaskExecutionVC.h"

@interface TaskDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_state;

@property (weak, nonatomic) IBOutlet UILabel *lb_type;

@property(nonatomic,strong) NSArray *channels;

@property (weak, nonatomic) IBOutlet UIButton *btn_beginAction;

@end

@implementation TaskDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _lb_title.text = _task.name;
    _lb_state.text = _task.stateString;
    _lb_time.text = [NSString stringWithFormat:@"%@ ~ %@",_task.starttimeString,_task.endtimeString];
    _lb_type.text = _task.typeidLabel;
    [self loadDatas];
    [[UINavigationBar appearance] setBarTintColor:HEX_RGB(0x008cec)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [item setTintColor:[UIColor whiteColor ]];
    self.navigationItem.leftBarButtonItem = item;
    self.title = @"任务详情";
    if([_task.isfinish isEqual:@"1"]){
        [_btn_beginAction setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadDatas{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    TaskDetailRequest *request = [[TaskDetailRequest alloc]init];
    request.visitId = self.task.id;
    [TaskAPI getDetailByHttpRequest:request Success:^(Task *task) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        _lb_title.text = task.name;
        _lb_state.text = task.stateString;
        _lb_time.text = [NSString stringWithFormat:@"%@ ~ %@",task.stateString,task.endtimeString];
        _lb_type.text = task.typeidLabel;
        self.task = task;
        self.channels = task.unit;
        [self.tableView reloadData];
    } fail:^(NSString *description) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:description toView:self.view];
    }];
    
}

- (IBAction)startTask:(id)sender {
    TaskExecutionVC *t_vc = [[TaskExecutionVC alloc] init];
    t_vc.task = _task;
    [self.navigationController pushViewController:t_vc animated:YES];

}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Unit *t_unit = _channels[indexPath.row];
    TaskExecutionVC *t_vc = [[TaskExecutionVC alloc] init];
    t_vc.unit = t_unit;
    t_vc.taskName = _task.name;
    t_vc.opetypeid = _task.opetypeid;
    t_vc.taskId =_task.id;
    [self.navigationController pushViewController:t_vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _channels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChannelCell class])];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"ChannelCell" owner:self options:nil];
        cell = [array lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.unit = [_task.unit objectAtIndex:indexPath.row];
//    cell. = [_list objectAtIndex:indexPath.row];
    return cell;
}

@end
