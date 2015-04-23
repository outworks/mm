//
//  VisitLocusVC.m
//  cmm
//
//  Created by Hcat on 15/4/13.
//
//

#import "VisitLocusVC.h"
#import "MJRefresh.h"
#import "VisitLocusCell.h"
#import "TrackAPI.h"
#import "ShareValue.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "VisitReturnVC.h"
#import "VisitSearchVC.h"
#import "AppDelegate.h"
#import "NSDate+Helper.h"


#define TASKLISTPAGESIZE 20


@interface VisitLocusVC ()


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn_timeState;
@property(nonatomic,strong) NSString *timeorder;
@property (weak, nonatomic) IBOutlet UIView *v_top;

@property(nonatomic,assign) BOOL isLastPage;
@property(nonatomic,assign) int curPageNum;
@property(nonatomic,assign) int pageSize;

@property(nonatomic,strong) NSString *startTime;

@property(nonatomic,strong) NSString *endTime;


@property(nonatomic,strong) NSMutableArray *list;
@property(nonatomic,strong) VisitSearchVC *searchVC;
@end

@implementation VisitLocusVC


#pragma mark - viewLift
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavWithTitle:@"走访轨迹" withbgImage:nil createMenuItem:^UIView *(int index) {
        
        if (index == 0) {
            UIButton *t_button = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 44, 44)];
            [t_button.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [t_button setTitle:@"返回" forState:UIControlStateNormal];
            [t_button setTitle:@"返回" forState:UIControlStateHighlighted];
            [t_button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
            
            return t_button;
        }
        return nil;
    }];
    
    _v_top.layer.shadowColor = [UIColor blackColor].CGColor;
    [_v_top.layer setShadowOffset:CGSizeMake(0, 1)];
    _v_top.layer.shadowOpacity = 0.80;
    
    
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
    NSDate *theDate = [[NSDate date] initWithTimeIntervalSinceNow: -24*60*60*4 ];
    _startTime = [NSDate stringFromDate:theDate withFormat:@"yyyy-MM-dd"];
    _endTime = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
    _timeorder = @"DESC";
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}

#pragma mark - private methods

-(void)reloadDatas{
    self.curPageNum = 0;
    self.pageSize = TASKLISTPAGESIZE;
    [self loadNextPageDatas];
}

-(void)loadNextPageDatas{
    self.curPageNum ++;
    [self loadDatas];
}

-(void)loadDatas{
    TrackQueryHttpRequest *request = [[TrackQueryHttpRequest alloc] init];
     request.userId = [ShareValue sharedShareValue].regiterUser.userId;
    request.orderDirection = _timeorder;
    if (_startTime) {
        request.startTime = [NSString stringWithFormat:@"%@ 00:00:00",_startTime];
    }
    if (_endTime) {
        request.endTime = [NSString stringWithFormat:@"%@ 23:59:59",_endTime];
    }
    [TrackAPI trackQueryHttpAPIWithRequest:request Success:^(NSArray *result, BOOL isLastPage) {
        [self.tableView.header endRefreshing];
        if (_curPageNum == 1) {
            [self.list removeAllObjects];
        }
        [self.list addObjectsFromArray:result];
        [_tableView reloadData];
        _isLastPage = isLastPage;
        if (!isLastPage) {
            self.tableView.footer.hidden = NO;
        }else{
            self.tableView.footer.hidden = YES;
        }
    } fail:^(NSString *description) {
        [self.tableView.header endRefreshing];
        [MBProgressHUD showError:description toView:self.view];
    }];
    
    
}

#pragma mark - buttton Action 

-(void)backAction:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    

}

- (IBAction)dateOrderChange:(id)sender {
    if (_btn_timeState.tag == 0) {
        _btn_timeState.tag = 1;
        [_btn_timeState setImage:[UIImage imageNamed:@"任务_图标_从低到高"] forState:UIControlStateNormal];
        _timeorder = @"DESC";
    }else{
        _btn_timeState.tag = 0;
        [_btn_timeState setImage:[UIImage imageNamed:@"任务_图标_从高到低"] forState:UIControlStateNormal];
        _timeorder = @"ASC";
    }
    [self.tableView.header  beginRefreshing];
}

- (IBAction)showRequire:(id)sender {
    if (!self.searchVC) {
        self.searchVC = [[VisitSearchVC alloc]init];
        self.searchVC.delegate = (id<VisitSearchVCDelegate>)self;
    }
    self.searchVC.startTime = _startTime;
    self.searchVC.endTime = _endTime;
    __weak VisitSearchVC *weakVc = self.searchVC;
    CGRect rect = self.searchVC.view.frame;
    CGRect realRect = CGRectMake(CGRectGetWidth(rect), 0,CGRectGetWidth(rect),CGRectGetHeight(rect));
    self.searchVC.view.frame= realRect;
    self.searchVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [ApplicationDelegate.window addSubview:self.searchVC.view];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect resultRect = CGRectInset(rect, 0, 0);
        weakVc.view.frame =resultRect;
    }];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VisitTrack *t_track = _list[indexPath.row];
    
    VisitReturnVC *t_vc = [[VisitReturnVC alloc] init];
    t_vc.correctDate = t_track.correctDate;
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 73.0f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VisitLocusCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VisitLocusCell class])];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"VisitLocusCell" owner:self options:nil];
        cell = [array lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.track = [_list objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - TaskSearchVCDelegate
-(void)VisitSearchVCBack:(VisitSearchVC *)vc{
    self.searchVC.delegate = nil;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect resultRect = CGRectMake(CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.searchVC.view.frame), CGRectGetHeight(self.searchVC.view.frame));
        self.searchVC.view.frame =resultRect;
    } completion:^(BOOL finished) {
        [self.searchVC.view removeFromSuperview];
        self.searchVC = nil;
    }];
}

-(void)searchstartTime:(NSString *)startTime endTime:(NSString *)endTime;{
    self.startTime = startTime;
    self.endTime = endTime;
    [self.tableView.header  beginRefreshing];
    [self VisitSearchVCBack:nil];
}

#pragma mark - dealloc

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

@end
