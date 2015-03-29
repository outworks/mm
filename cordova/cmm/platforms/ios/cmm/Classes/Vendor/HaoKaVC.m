//
//  HaoKaVC.m
//  cmm
//
//  Created by Hcat on 15/3/20.
//
//

#import "HaoKaVC.h"
#import "KACircleProgressView.h"
#import "SaleAPI.h"
#import "MBProgressHUD+Add.h"

@interface HaoKaVC (){
    
    MBProgressHUD * _hud;
}
@property (nonatomic, strong)KACircleProgressView *v_progress;

@property (weak, nonatomic) IBOutlet UILabel *lb_curMonthCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_wancheng;
@property (weak, nonatomic) IBOutlet UILabel *lb_doneCount;

@property (weak, nonatomic) IBOutlet UILabel *lb_todayCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_lastCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_wangdianCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_pingjunCount;

@end

@implementation HaoKaVC

#pragma mark - viewLift

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _v_progress = [[KACircleProgressView alloc] initWithSize:110 withType:KACircleProgressViewTypeCircleBacked andProgressBarLineWidth:6 andCircleBackLineWidth:6];
    [_v_progress setProgress:0.000001];
    [_v_progress setColorOfBackCircle:UIColorFromRGB(0xf2f2f2)];
    [_v_progress setColorOfProgressBar:UIColorFromRGB(0x1fbbff)];
    [self.view addSubview:_v_progress];
    [_v_progress setCenter:CGPointMake(ScreenWidth/2,90)];
    
    [self datarequest];
    
}

#pragma mark - private methods

-(void)datarequest{

    __block HaoKaVC *weakSelf = self;
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud setLabelText:@"请求中"];
    [_hud show:YES];
    SaleRequest *t_request = [[SaleRequest alloc] init];
    t_request.userId = @"11";
    [SaleAPI getSaleQueryHttpAPI:t_request Success:^(SaleResponse *response, NSInteger result, NSString *msg) {
        [_hud hide:YES];
        weakSelf.lb_curMonthCount.text =  [response.curMonthTargetCount stringValue];
        weakSelf.lb_doneCount.text = [response.totalCount stringValue];
        weakSelf.lb_wancheng.text = [NSString stringWithFormat:@"%ld%%",[response.totalCount integerValue]/[response.curMonthTargetCount integerValue]*100];
        [weakSelf.v_progress setProgress:[response.totalCount integerValue]/[response.curMonthTargetCount integerValue]*100]; // set progress to 0.3 out of 1.0
        
        weakSelf.lb_todayCount.text = [response.curDayCount stringValue];
        weakSelf.lb_lastCount.text = [NSString stringWithFormat:@"%ld",[response.curMonthTargetCount integerValue]-[response.totalCount integerValue]];
        weakSelf.lb_wangdianCount.text = [NSString stringWithFormat:@"%ld/%ld",[response.saleCount integerValue],[response.unitCount integerValue]];;
        weakSelf.lb_pingjunCount.text = [NSString stringWithFormat:@"%ld/%ld",[response.avgSaleCount integerValue],[response.highestSaleCount integerValue]];
        
    } fail:^(NSString *description) {
        [_hud hide:YES];
    }];
    
    


    
    

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
