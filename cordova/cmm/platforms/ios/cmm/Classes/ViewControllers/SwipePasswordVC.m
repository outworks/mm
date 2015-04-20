//
//  SwipePasswordVC.m
//  cmm
//
//  Created by Hcat on 15/3/22.
//
//

#import "SwipePasswordVC.h"
#import "YLSwipeLockView.h"
#import "LeftSideVC.h"
#import "MainVC.h"
#import "Menu.h"
#import "ShareValue.h"


@interface SwipePasswordVC ()<YLSwipeLockViewDelegate>

@property (strong, nonatomic)  YLSwipeLockView *v_swipe;
@property (nonatomic, strong) NSString *passwordString;

@property (weak, nonatomic) IBOutlet UILabel *lb_info;

@property (weak, nonatomic) IBOutlet UIButton *btn_reset;


@end

@implementation SwipePasswordVC




#pragma mark - viewLift


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.v_swipe = [[YLSwipeLockView alloc] initWithFrame:CGRectMake(20, 140 , ScreenWidth, ScreenWidth - 40)];
    [self.view addSubview:self.v_swipe];
    _lb_info.text = @"设置你的手势密码";
    self.btn_reset.hidden = YES;
    self.v_swipe.delegate = self;
}

#pragma mark -ButtonAction

- (IBAction)otherUserAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
    
    
}

- (IBAction)resetAction:(id)sender
{
    self.passwordString = nil;
    self.lb_info.text = @"设置你的手势密码";
    self.btn_reset.hidden = YES;
}


#pragma mark - YLSwipeLockViewDelegate

-(YLSwipeLockViewState)swipeView:(YLSwipeLockView *)swipeView didEndSwipeWithPassword:(NSString *)password
{
    if (self.passwordString == nil) {
        self.passwordString = password;
        self.lb_info.text = @"请再次确定手势密码";
        return YLSwipeLockViewStateNormal;
    }else if ([self.passwordString isEqualToString:password]){
        self.lb_info.text = @"设置成功";
        self.passwordString = nil;
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:password forKey:@"gesturePassword"];
        
        NSMutableArray *t_arr = [Menu searchWithWhere:[NSString stringWithFormat:@"level=1"] orderBy:@"menuId" offset:0 count:0];
        Menu * t_menu = t_arr[0];
        [ShareValue sharedShareValue].selectedMenuId = t_menu.menuId;
        [[SliderVC shareSliderVC] resetShareSliderVC];
        self.sliderVC = [SliderVC shareSliderVC];
        
        LeftSideVC *leftVC = [[LeftSideVC alloc] initWithNibName:@"LeftSideVC" bundle:nil];
        
        MainVC *mainVC = [[MainVC alloc] init];
        
        
        self.sliderVC.leftVC = leftVC;
        self.sliderVC.mainVC = mainVC;
        
        [self.navigationController pushViewController:self.sliderVC animated:YES];
        
        return YLSwipeLockViewStateSelected;
    }else{
        self.lb_info.text = @"与前次设置的手势密码不同";
        self.btn_reset.hidden = NO;
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
