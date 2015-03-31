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
#import "MJRefresh.h"
#import "TaskDetailVC.h"

@interface TaskListVC ()<UITableViewDataSource,UITableViewDelegate,LXActionSheetDelegate>

@property(nonatomic,strong) NSMutableArray *list;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btn_timeState;

@property(nonatomic,strong) NSString *timeorder;

@property(nonatomic,assign) int page;

@property(nonatomic,assign) int size;

@property(nonatomic,assign) BOOL isLastPage;

@end

@implementation TaskListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [_tableView registerClass:[TaskCell class] forCellReuseIdentifier:NSStringFromClass([TaskCell class])];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backgroundColor = HEX_RGB(0x008cec);
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont, nil];
    [[UINavigationBar appearance] setBarTintColor:HEX_RGB(0x008cec)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [item setTintColor:[UIColor whiteColor ]];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"任务列表";
    _isLastPage = YES;
    self.list = [[NSMutableArray alloc]init];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [self reloadDatas];
    }];
    [self.tableView.header  beginRefreshing];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        if (!_isLastPage) {
            [self loadNextPageDatas];
        }else{
            [self.tableView.footer noticeNoMoreData];
        }
    }];
    self.tableView.footer.hidden = YES;
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

-(void)reloadDatas{
    self.page = 0;
    [self.list removeAllObjects];
    [self loadDatas];
}

-(void)loadNextPageDatas{
    self.page ++;
    [self loadDatas];
}

-(void)loadDatas{
    TaskRequest *request = [[TaskRequest alloc]init];
    request.userId = @"1024921";
    [TaskAPI getTasksByHttpRequest:request Success:^(NSArray *tasks) {
        [self.tableView.header endRefreshing];
        [self.list addObjectsFromArray:tasks];
        [_tableView reloadData];
        if (!_isLastPage) {
            self.tableView.footer.hidden = NO;
        }else{
            self.tableView.footer.hidden = YES;
        }
    } fail:^(NSString *description) {
        [self.tableView.header endRefreshing];
        [MBProgressHUD showError:description toView:self.view];
    }];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskDetailVC *vc = [[TaskDetailVC alloc]init];
    vc.task = [_list objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc
                                         animated:YES];
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
/**
 *  显示任务状态
 *
 */
- (IBAction)chooseState:(id)sender {
    LXActionSheet *sheet = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"全部" otherButtonTitles:@"未启动",@"进行中",@"已完成",@"超时完成", nil];
    [sheet setdestructiveButtonColor:RGB(86, 170, 14) titleColor:[UIColor whiteColor] icon:nil];
    [sheet setCancelButtonColor:[UIColor whiteColor] titleColor:[UIColor redColor] icon:nil];
    [sheet showInView:self.navigationController.view];
}


/**
 *  显示筛选选项
 *
 */
- (IBAction)showRequire:(id)sender {
    
}

/**
 *  时间排序
 *
 */
- (IBAction)dateOrderChange:(id)sender {
    if (_btn_timeState.tag == 0) {
        _btn_timeState.tag = 1;
        [_btn_timeState setImage:[UIImage imageNamed:@"任务_图标_从低到高"] forState:UIControlStateNormal];
        _timeorder = @"asc";
        
    }else{
        _btn_timeState.tag = 0;
        [_btn_timeState setImage:[UIImage imageNamed:@"任务_图标_从高到低"] forState:UIControlStateNormal];
        _timeorder = @"dec";
        
    }
}


#pragma mark - LXActionSheetDelegate
- (void)lxactionSheet:(LXActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

@end
