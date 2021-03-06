//
//  HomeVC.m
//  cmm
//
//  Created by Hcat on 15/3/20.
//
//

#import "HomeVC.h"
#import "UIButton+Block.h"
#import "SliderVC.h"
#import "UtilsMacro.h"
#import "CommonTabBar.h"
#import "ShareValue.h"
#import "ShareFun.h"
#import "MyInfoVC.h"
#import "UtilsMacro.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"


#import "HaoKaVC.h"
#import "KeyBusinessVC.h"
#import "TerminalVC.h"
#import "BroadbandVC.h"
#import "TrackHelper.h"

@interface HomeVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *btn_memu;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_userIcon;
@property (weak, nonatomic) IBOutlet UILabel *lb_userName;
@property (weak, nonatomic) IBOutlet UILabel *lb_jop;


@property (weak, nonatomic) IBOutlet UIView *v_top;
@property (weak, nonatomic) IBOutlet UIView *v_bottm;

@property (nonatomic,strong) CommonTabBar *tabBar;


@property (nonatomic,strong)KeyBusinessVC *keyBusinessVC;
@property (nonatomic,strong)HaoKaVC *haokaVC;
@property (nonatomic,strong)BroadbandVC *broadbandVC;
@property (nonatomic,strong)TerminalVC *terminalVC;

@end

@implementation HomeVC



#pragma makr - viewlift

- (void)viewDidLoad {
    [super viewDidLoad];
    [[TrackHelper sharedTrackHelper] saveAndUploadRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdataImage:) name:NOTIFICATION_UPDATAIMAGE object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdataUser:) name:NOTIFICATION_UPDATAUSERINFO object:nil];
    
    [self resetUI];
    
    
}

#pragma mark - private methods

-(BroadbandVC *)broadbandVC{
    if (_broadbandVC == nil) {
        _broadbandVC = [[BroadbandVC alloc] init];
    }
    
    return _broadbandVC;
}

-(TerminalVC *)terminalVC{
    if (_terminalVC == nil) {
        _terminalVC = [[TerminalVC alloc] init];
    }

    return _terminalVC;
}

-(HaoKaVC *)haokaVC{

    if (_haokaVC == nil) {
        _haokaVC = [[HaoKaVC alloc] init];
    }
    
    return _haokaVC;
}


-(KeyBusinessVC *)keyBusinessVC{
    
    if (_keyBusinessVC == nil) {
        _keyBusinessVC = [[KeyBusinessVC alloc] init];
    }
    
    return _keyBusinessVC;
}



-(void)resetUI{
    
    _imageV_userIcon.layer.cornerRadius = _imageV_userIcon.frame.size.width/2;
    _imageV_userIcon.layer.masksToBounds = YES;
    [_btn_memu setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [_imageV_userIcon sd_setImageWithURL:[ShareFun fileUrlFormPath:[ShareValue sharedShareValue].regiterUser.signImgUrl] placeholderImage:[UIImage imageNamed:@"登录页_图标_logo"]];
    NSArray *t_arr = @[@{@"Title":@"号卡"},@{@"Title":@"终端"},@{@"Title":@"宽带"},@{@"Title":@"重点业务"}];
    _tabBar = [[CommonTabBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_v_top.frame), ScreenWidth, 35) buttonItems:t_arr CommonTabBarType:CommonTabBarTypeTitleOnly isAnimation:YES];
    _tabBar.delegate = (id<CommonTabBarDelegate>)self;
    
    _tabBar.backgroundColor = UIColorFromRGB(0xefefef);
    _tabBar.titleColor = UIColorFromRGB(0x2f2f2f);
    _tabBar.titleSelectColor = UIColorFromRGB(0x1fbbff);
    _tabBar.titlesFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:13];
    _tabBar.titleSelectFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
    _tabBar.selectedItemTopBackgroundColor = UIColorFromRGB(0x1fbbff);
    _tabBar.selectedItemTopBackroundColorHeight = 1.5f;
    
    _lb_userName.text = [ShareValue sharedShareValue].regiterUser.userName;
    
    [_tabBar drawItems];
    [self.scrollView addSubview:_tabBar];
    [_tabBar setSelectedIndex:0];

}



#pragma mark - BtnAction

- (IBAction)MemuAction:(id)sender {
    
    [[SliderVC shareSliderVC] showLeftViewController];
    
}

- (IBAction)SignInAction:(id)sender {
    
    
    
}

- (IBAction)todoAction:(id)sender {
    
    
    
}

-(IBAction)userIconAction:(id)sender{
    MyInfoVC *vc = [[MyInfoVC alloc]init];
    
    [ApplicationDelegate.viewController presentViewController:vc animated:YES completion:^{
        
    }];
    
    
}

#pragma mark - commonTabBarDelegate

-(void)tabBar:(CommonTabBar *)tabBar didSelectIndex:(NSInteger)index{
    
    for (UIView *t_view in [_v_bottm subviews]) {
        [t_view removeFromSuperview];
    }
    if (index == 0) {
        [self haokaVC];
        [_v_bottm addSubview:_haokaVC.view];
    }else if(index == 1){
        [self terminalVC];
        [_v_bottm addSubview:_terminalVC.view];
    }else if(index == 2){
        [self broadbandVC];
        [_v_bottm addSubview:_broadbandVC.view];
    }else{
        [self keyBusinessVC];
        [_v_bottm addSubview:_keyBusinessVC.view];
    }
    
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, CGRectGetMaxY(_v_bottm.frame))];
}

#pragma mark - Notification methods 

-(void)handleUpdataImage:(NSNotification *)note{
    [_imageV_userIcon sd_setImageWithURL:[ShareFun fileUrlFormPath:[ShareValue sharedShareValue].regiterUser.signImgUrl]  placeholderImage:[UIImage imageNamed:@"登录页_图标_logo"]];
}


-(void)handleUpdataUser:(NSNotification *)note{
    [_lb_userName setText:[ShareValue sharedShareValue].regiterUser.userName];
    [_lb_jop setText:[ShareValue sharedShareValue].regiterUser.jobName];
    [_imageV_userIcon sd_setImageWithURL:[ShareFun fileUrlFormPath:[ShareValue sharedShareValue].regiterUser.signImgUrl]  placeholderImage:[UIImage imageNamed:@"登录页_图标_logo"]];
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