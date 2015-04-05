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

@interface TaskDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_state;

@property (weak, nonatomic) IBOutlet UILabel *lb_type;

@property(nonatomic,strong) NSArray *channels;


@end

@implementation TaskDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _lb_title.text = _task.name;
    _lb_state.text = _task.stateString;
    _lb_time.text = [NSString stringWithFormat:@"%@ ~ %@",_task.stateString,_task.endtimeString];
    _lb_type.text = _task.typeidLabel;
    [self loadDatas];
    [[UINavigationBar appearance] setBarTintColor:HEX_RGB(0x008cec)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [item setTintColor:[UIColor whiteColor ]];
    self.navigationItem.leftBarButtonItem = item;
    self.title = @"任务详情";
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
    
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92.0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _channels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChannelCell class])];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"TaskCell" owner:self options:nil];
        cell = [array lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell. = [_list objectAtIndex:indexPath.row];
    return cell;
}

@end