//
//  MainVC.m
//  cmm
//
//  Created by Hcat on 15/3/20.
//
//

#import "MainVC.h"
#import "UtilsMacro.h"
#import "HomeVC.h" // 首页
#import "MyWorkVC.h" // 我的工作
#import "VisitsMapVC.h" //走访地图
#import "MailListVC.h" // 通讯录
#import "UserAPI.h"
#import "ShareValue.h"
#import "SDWebImageManager.h"
#import "UIImage+External.h"
#import "MyWebVC.h"
#import "HomeMenu.h"
#import "ShareFun.h"

@interface MainVC ()

@property(nonatomic,assign) BOOL isBack;
@property(nonatomic,strong) NSMutableDictionary *tabDic;

@end

@implementation MainVC


static MainVC *main;

#pragma mark - instancetype

+ (MainVC *)getMain
{
    return main;
}

- (id)init
{
    self = [super init];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(updateMenu:) name:NOTIFICATION_UPDATAMENU object:nil];
    main = self;
    _tabDic = [[NSMutableDictionary alloc]init];
    return self;
}

#pragma mark - initTabBar

-(UITabBarController *)currentTabBarController{
    UITabBarController *obj = [_tabDic objectForKey:[ShareValue sharedShareValue].selectedMenuId];
    if (!obj) {
        obj = [self newTabBar];
        [_tabDic setObject:obj forKey:[ShareValue sharedShareValue].selectedMenuId];
    }
    return obj;
}

-(BOOL)isManagerSelected{
    Menu *menu = [Menu searchSingleWithWhere:[NSString stringWithFormat:@"menuId=%@",[ShareValue sharedShareValue].selectedMenuId] orderBy:nil];
    if ([menu.menuName isEqual:@"营销经理工作台"]) {
        return YES;
    }
    return NO;
}

-(void)updateUI{
    self.vc_tab = [self currentTabBarController];
    if (_vc_tab.view.superview) {
        [self.view bringSubviewToFront:_vc_tab.view];
    }else{
        [self.view addSubview:_vc_tab.view];
    }
    
}
-(void)updateMenu:(NSNotification *)note{
    [self updateUI];
}

-(UITabBarController *)newTabBar{
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController.tabBar setBackgroundColor:UIColorFromRGB(0xefefe)];
    [tabBarController.view setFrame:self.view.frame];
    [tabBarController.tabBar setTranslucent:NO];
    [tabBarController setDelegate:(id<UITabBarControllerDelegate>)self];
    UIViewController *homeVC = nil;
    UIViewController *visitMapVC = nil;
    UIViewController *mailListVC = nil;
    
    if ([ShareValue sharedShareValue].getCurrentModules.count > 0) {
        HomeMenu *menu = [ShareValue sharedShareValue].getCurrentModules[0];
        homeVC  = [self controllerWithMenu:menu];
    }else if([self isManagerSelected]){
        homeVC = [[HomeVC alloc] init];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"主菜单栏_图标_首页_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_首页_选中.png"]];
        homeVC.tabBarItem = item;
    }else{
        homeVC = [[UIViewController alloc]init];
        homeVC.view.backgroundColor = [UIColor whiteColor];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"主菜单栏_图标_首页_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_首页_选中.png"]];
        homeVC.tabBarItem = item;
    }
    
    UIViewController *myWorkVC = [[MyWorkVC alloc] initWithNibName:@"MyWorkVC" bundle:nil];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"我的工作" image:[UIImage imageNamed:@"主菜单栏_图标_我的工作_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_我的工作_选中.png"]];
    myWorkVC.tabBarItem = item;
    if ([ShareValue sharedShareValue].getCurrentModules.count >1) {
        HomeMenu *menu = [ShareValue sharedShareValue].getCurrentModules[1];
        visitMapVC  = [self controllerWithMenu:menu];
    }else if([self isManagerSelected]){
        visitMapVC = [[VisitsMapVC alloc] initWithNibName:@"VisitsMapVC" bundle:nil];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"走访地图" image:[UIImage imageNamed:@"主菜单栏_图标_走访地图_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_走访地图_选中.png"]];
        visitMapVC.tabBarItem = item;
    }
    if ([ShareValue sharedShareValue].getCurrentModules.count >2) {
        HomeMenu *menu = [ShareValue sharedShareValue].getCurrentModules[2];
        mailListVC  = [self controllerWithMenu:menu];
    }else if([self isManagerSelected]){
        mailListVC = [[MailListVC alloc] init];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"通讯录" image:[UIImage imageNamed:@"主菜单栏_图标_通讯录_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_通讯录_选中.png"]];
        mailListVC.tabBarItem = item;
    }
    if([self isManagerSelected]){
        tabBarController.viewControllers = @[homeVC, myWorkVC, visitMapVC,mailListVC];
    }else{
        if (visitMapVC == nil) {
            tabBarController.viewControllers = @[homeVC, myWorkVC];
        }else if(mailListVC == nil){
            tabBarController.viewControllers = @[homeVC, myWorkVC,visitMapVC];
        }else{
            tabBarController.viewControllers = @[homeVC, myWorkVC,visitMapVC,mailListVC];
        }
    }
    return tabBarController;
}

-(UIViewController *)controllerWithMenu:(HomeMenu *)menu{
    MyWebVC *webVC = [[MyWebVC alloc]init];
    webVC.view.backgroundColor = [UIColor whiteColor];
    if ([menu.menuUrl rangeOfString:@"?"].length > 0) {
        webVC.url = [NSString stringWithFormat:@"%@&userId=%@&token=%@",menu.menuUrl,[ShareValue sharedShareValue].regiterUser.userId,[ShareValue sharedShareValue].regiterUser.key];
    }else{
        webVC.url = [NSString stringWithFormat:@"%@?userId=%@&token=%@",menu.menuUrl,[ShareValue sharedShareValue].regiterUser.userId,[ShareValue sharedShareValue].regiterUser.key];
    }
    UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:menu.menuName image:[UIImage imageNamed:@"主菜单栏_图标_首页_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_首页_选中.png"]];
    [[SDWebImageManager sharedManager]downloadImageWithURL:[ShareFun fileUrlFormPath:menu.menuIcon] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!error) {
            UIImage *scaleImage = [image imageByScaleForSize:CGSizeMake(25, 25)];
            item.image = scaleImage;
            item.selectedImage = scaleImage;
        }
    }];
    webVC.tabBarItem = item;
    return webVC;
}


#pragma mark - UITabBarController

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    
//    if ([viewController isKindOfClass:[VisitsMapVC class]]) {
//        [(VisitsMapVC *)viewController loadVisitMap];
//    }

}


#pragma makr - viewlift

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillBack) name:NOTIFICATION_APPWILLBACK object:nil];
    [self updateUI];
    [_vc_tab setSelectedIndex:0];
    // Do any additional setup after loading the view from its nib.
    [UserAPI getMenuHttpAPIWithRequest:^(NSArray *result) {
        NSLog(@"%lu",(unsigned long)result.count);
    } fail:^(NSString *description) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    if (_isBack) {
        [self.sliderVC.navigationController popViewControllerAnimated:NO];
    }
}


-(void)applicationWillBack{
    _isBack = YES;
    
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