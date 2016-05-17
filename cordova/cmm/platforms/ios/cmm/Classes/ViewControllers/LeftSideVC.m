//
//  LeftSideVC.m
//  cmm
//
//  Created by Hcat on 15/3/20.
//
//

#import "LeftSideVC.h"
#import "ShareValue.h"
#import "MyInfoVC.h"
#import "AppDelegate.h"
#import "ShareFun.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "LXActionSheet.h"
#import "UIButton+Block.h"
#import "VersionUpdataAPI.h"


#import "Menu.h"

@interface LeftSideVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_bg_info;

@property (strong,nonatomic)NSArray *arr_data;

@property (weak, nonatomic) IBOutlet UITextField *textf_signName;

@property (nonatomic,strong) NSMutableArray *arr_menus;

@property (nonatomic,strong)  VersionUpdataResponse *version;


@end

@implementation LeftSideVC

#pragma mark - init 

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
    }


    return self;
}

#pragma mark - viewLife

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _arr_menus = [Menu searchWithWhere:[NSString stringWithFormat:@"level=1"] orderBy:@"menuId" offset:0 count:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdataImage:) name:NOTIFICATION_UPDATAIMAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdataUser:) name:NOTIFICATION_UPDATAUSERINFO object:nil];
    
    [self resetUI];
    [self addHeadAction];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];


    
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _textf_signName.text = [ShareValue sharedShareValue].regiterUser.signName;
}



#pragma mark - private methods

-(void)resetUI{
    
    _imageV_userIcon.layer.cornerRadius = _imageV_userIcon.frame.size.width/2;
    _imageV_userIcon.layer.masksToBounds = YES;
    [_imageV_userIcon sd_setImageWithURL:[ShareFun fileUrlFormPath:[ShareValue sharedShareValue].regiterUser.signImgUrl]  placeholderImage:[UIImage imageNamed:@"登录页_图标_logo"]];
    _imageV_bg_info.layer.cornerRadius = 3;
    _imageV_bg_info.layer.masksToBounds = YES;
    
    Menu *t_menu = [Menu searchSingleWithWhere:[NSString stringWithFormat:@"menuId=%@",[ShareValue sharedShareValue].selectedMenuId] orderBy:nil];
    
    _lb_menu.text = t_menu.menuName;
    
    self.arr_data = @[@[@"我的收藏", @"首页_图标_我的收藏.png"],
                      @[@"通用设置", @"首页_图标_通用设置.png"],
                      @[@"账号管理", @"首页_图标_账户管理.png"],
                      @[@"提醒通知", @"首页_图标_提醒与通知.png"],
                      @[@"版本更新", @"首页_图标_版本更新.png"],
                      @[@"关于平台", @"首页_图标_关于平台.png"],
                      ];
    _lb_userName.text = [ShareValue sharedShareValue].regiterUser.userName;
    _lb_regional.text = [ShareValue sharedShareValue].regiterUser.jobId;
    _textf_signName.text = [ShareValue sharedShareValue].regiterUser.signName;
    [_btn_qiehuan setEnlargeEdgeWithTop:50 right:400 bottom:50 left:400];

}


-(void)addHeadAction{
    UITapGestureRecognizer *tapGestreRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addHeadImage:)];
    [_imageV_userIcon addGestureRecognizer:tapGestreRecognizer];
}


-(void)addHeadImage:(UITapGestureRecognizer *)tapGestreRecognizer{
    MyInfoVC *vc = [[MyInfoVC alloc]init];
    [ApplicationDelegate.viewController presentViewController:vc animated:YES completion:^{
        
    }];
}

#pragma mark - button Action

- (IBAction)quitAciton:(id)sender {
    NSLog(@"退出账号");
    [ShareValue sharedShareValue].isLoginOut = YES;
    [ApplicationDelegate.viewController popToRootViewControllerAnimated:YES];
    
    
    
}

- (IBAction)workplayChangeAction:(id)sender {
    

    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"菜单切换" delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for(Menu *t_menu in _arr_menus) {
        [sheet addButtonWithTitle:t_menu.menuName];
    }
    [sheet showInView:ApplicationDelegate.viewController.view];

}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdetify = @"left";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    if (indexPath.row == 3) {
        UIImageView *t_imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 49, 154, 1)];
        t_imageV.backgroundColor = [UIColor whiteColor];
        t_imageV.alpha = 0.1f;
        [cell.contentView addSubview:t_imageV];
    }
    
    NSArray *ar = [_arr_data objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[ar objectAtIndex:1]];
    cell.imageView.highlightedImage = [UIImage imageNamed:[ar objectAtIndex:1]];
    cell.textLabel.text = [ar objectAtIndex:0];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 4) {
        VersionUpdataRequest *t_request = [[VersionUpdataRequest alloc] init];
        t_request.clientType = @"ios";
        t_request.userId = @"123456";
        [VersionUpdataAPI versionUpdataHttpAPI:t_request Success:^(VersionUpdataResponse *response, NSInteger result, NSString *msg) {
            
            _version = response;
            
            NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            if ([version compare:_version.nversion] == NSOrderedAscending) {
                //vesion < nversion
                UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"发现新版本:%@,是否更新",_version.nversion] delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"更新", nil];
                t_alertView.tag = 11;
                [t_alertView show];
            };
            
        } fail:^(NSString *description) {
            
        }];
    }
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        return;
    }else{
        Menu *t_menu = _arr_menus[buttonIndex-1];
        _lb_menu.text = t_menu.menuName;
        [ShareValue sharedShareValue].selectedMenuId = t_menu.menuId;
        [[NSNotificationCenter defaultCenter]  postNotificationName:NOTIFICATION_UPDATAMENU object:t_menu];
        [[SliderVC shareSliderVC]closeSideBar];
    }
    
}
#pragma mark - alertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%ld",buttonIndex);
    
    if (alertView.tag == 12) {
        if (buttonIndex == 0) {
            
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_version.filePath]];
            
        }
        
        [self exitApplication];
    }else{
        
        if (buttonIndex == 0) {
            
            NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            if ([version compare:_version.sversion] == NSOrderedAscending) {
                //vesion < nversion
                UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"必须强制更新到%@版本,请更新",_version.sversion] delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"更新", nil];
                t_alertView.tag = 12;
                [t_alertView show];
            };
            
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_version.filePath]];
            
        }
        
    }
    
    
}


#pragma mark - 退出程序

- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    //[UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:ApplicationDelegate.window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    //self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    ApplicationDelegate.window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}



- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
        
    }
    
}



#pragma mark - Notification methods

-(void)handleUpdataImage:(NSNotification *)note{
    
    [_imageV_userIcon sd_setImageWithURL:[ShareFun fileUrlFormPath:[ShareValue sharedShareValue].regiterUser.signImgUrl]  placeholderImage:[UIImage imageNamed:@"登录页_图标_logo"]];
}

-(void)handleUpdataUser:(NSNotification *)note{
    
    [_lb_userName setText:[ShareValue sharedShareValue].regiterUser.userName];
//    [_lb_regional setText:[ShareValue sharedShareValue].regiterUser.jobName];
    [_textf_signName setText:[ShareValue sharedShareValue].regiterUser.signName];
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
