//
//  TaskListVC.m
//  cmm
//
//  Created by ilikeido on 15-3-29.
//
//

#import "TaskListVC.h"
#import "TaskAPI.h"
#import "TaskCell.h"
#import "MBProgressHUD+Add.h"

@interface TaskListVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSArray *list;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TaskListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_tableView registerClass:[TaskCell class] forCellReuseIdentifier:NSStringFromClass([TaskCell class])];
    [self loadDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loadDatas{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    TaskRequest *request = [[TaskRequest alloc]init];
    request.userId = @"1024921";
    [TaskAPI getTasksByHttpRequest:request Success:^(NSArray *tasks) {
        self.list = tasks;
        [_tableView reloadData];
    } fail:^(NSString *description) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    }];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TaskCell class])];
    cell.task = [_list objectAtIndex:indexPath.row];
    return cell;
}

@end
