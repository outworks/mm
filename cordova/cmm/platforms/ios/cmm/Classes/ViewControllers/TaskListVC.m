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
#import "UIColor+External.h"
#import "LXActionSheet.h"

@interface TaskListVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSArray *list;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TaskListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [_tableView registerClass:[TaskCell class] forCellReuseIdentifier:NSStringFromClass([TaskCell class])];
    [self loadDatas];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backgroundColor = HEX_RGB(0x008cec);
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont, nil];
    [[UINavigationBar appearance] setBarTintColor:HEX_RGB(0x008cec)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [item setTintColor:[UIColor whiteColor ]];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"任务列表";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)backAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92.0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TaskCell class])];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"TaskCell" owner:self options:nil];
        cell = [array lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.task = [_list objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - Action

- (IBAction)dateOrderChange:(id)sender {
    
}




@end
