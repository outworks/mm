//
//  SwipeLoginVC.m
//  cmm
//
//  Created by Hcat on 15/3/22.
//
//

#import "SwipeLoginVC.h"
#import "YLSwipeLockView.h"
#import "LeftSideVC.h"
#import "MainVC.h"
#import "MBProgressHUD+Add.h"
#import "UserAPI.h"
#import "ShareValue.h"

@interface SwipeLoginVC ()<YLSwipeLockViewDelegate>{

    MBProgressHUD *_hud;
}

@property (strong, nonatomic)  YLSwipeLockView *v_swipe;
@property (nonatomic, strong) NSString *passwordString;

@property (weak, nonatomic) IBOutlet UILabel *lb_info;

@property (weak, nonatomic) IBOutlet UIButton *btn_forgetPassword;
@property (nonatomic) NSUInteger unmatchCounter;

@end

@implementation SwipeLoginVC

#pragma mark - viewLift

- (void)viewDidLoad {
    [super viewDidLoad];
    self.v_swipe = [[YLSwipeLockView alloc] initWithFrame:CGRectMake(20, 140 , ScreenWidth, ScreenWidth - 40)];
    [self.view addSubview:self.v_swipe];
    
    self.v_swipe.delegate = self;
    self.lb_info.hidden = YES;
    self.unmatchCounter = 4;
}

#pragma mark - button Action 

- (IBAction)forgetAction:(id)sender {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:nil forKey:@"gesturePassword"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)otherUserAction:(id)sender {
    
     [self.navigationController popToRootViewControllerAnimated:YES];
    
}


#pragma mark - YLSwipeLockViewDelegate

-(YLSwipeLockViewState)swipeView:(YLSwipeLockView *)swipeView didEndSwipeWithPassword:(NSString *)password
{
    NSString *savedPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"gesturePassword"];
    if ([savedPassword isEqualToString:password]) {
        self.sliderVC = [SliderVC shareSliderVC];
        
        
        UserRequest * t_request = [[UserRequest alloc] init];
        t_request.username = [ShareValue sharedShareValue].loginUserName;
        t_request.pass = [ShareValue sharedShareValue].password;
        
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_hud setLabelText:@"登录中"];
        [_hud show:YES];
        
        [UserAPI getUserTableHttpAPI:t_request Success:^(UserResponse *response, NSInteger result, NSString *msg) {
            NSLog(@"更新成功！！！！！！！！！");
            [_hud hide:YES];
            [ShareValue sharedShareValue].regiterUser
            = response.smUser;
            
            NSMutableArray *t_arr = [Menu searchWithWhere:[NSString stringWithFormat:@"level=1"] orderBy:@"menuId" offset:0 count:0];
            if (t_arr.count>0) {
                Menu * t_menu = t_arr[0];
                [ShareValue sharedShareValue].selectedMenuId = t_menu.menuId;
            }
        } fail:^(NSString *description) {
            [_hud hide:NO];
            [MBProgressHUD showError:description toView:self.view];
            
        }];
        
        LeftSideVC *leftVC = [[LeftSideVC alloc] initWithNibName:@"LeftSideVC" bundle:nil];
        MainVC *mainVC = [[MainVC alloc] init];
        self.sliderVC.leftVC = leftVC;
        self.sliderVC.mainVC = mainVC;
        [self.navigationController pushViewController:self.sliderVC animated:YES];
        
        return YLSwipeLockViewStateNormal;
    }else{
        self.unmatchCounter--;
        if (self.unmatchCounter == 0) {
            self.lb_info.text = @"4次密码错误,请重新登录";
            self.lb_info.hidden = NO;
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else {
            self.lb_info.text = [NSString stringWithFormat:@"密码错误,还可以再输入%ld次", (unsigned long)self.unmatchCounter];
            self.lb_info.hidden = NO;
        }
        return YLSwipeLockViewStateWarning;
    }
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
