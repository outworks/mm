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

@interface MainVC ()

@property(nonatomic,assign) BOOL isBack;


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
    
    main = self;
    
    return self;
}

#pragma mark - initTabBar

-(void)initTabBar{
    self.vc_tab = [[UITabBarController alloc] init];
    [_vc_tab.tabBar setBackgroundColor:UIColorFromRGB(0xefefe)];
    [_vc_tab.view setFrame:self.view.frame];
    [_vc_tab.tabBar setTranslucent:NO];
    [_vc_tab setDelegate:(id<UITabBarControllerDelegate>)self];
    [self.view addSubview:_vc_tab.view];
    UIViewController *homeVC = nil;
    UIViewController *visitMapVC = nil;
    UIViewController *mailListVC = nil;
    
//    HomeMenu *menu = [[HomeMenu alloc]init];
//    menu.menuName = @"hello";
//    menu.menuIcon = @"http://www.easyicon.net/api/resizeApi.php?id=1158236&size=128";
//    menu.menuUrl = @"https://www.baidu.com?ii=1";
//    
//    [ShareValue sharedShareValue].module = @[menu];
////    [ShareValue sharedShareValue].regiterUser.isManager = 0;
    
    if ([ShareValue sharedShareValue].module.count > 0) {
        HomeMenu *menu = [ShareValue sharedShareValue].module[0];
        homeVC  = [self controllerWithMenu:menu];
    }else if([ShareValue sharedShareValue].regiterUser.isManager){
        homeVC = [[HomeVC alloc] init];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"主菜单栏_图标_首页_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_首页_选中.png"]];
        homeVC.tabBarItem = item;
    }else{
        homeVC = [[UIViewController alloc]init];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"主菜单栏_图标_首页_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_首页_选中.png"]];
        homeVC.tabBarItem = item;
    }
    
    UIViewController *myWorkVC = [[MyWorkVC alloc] initWithNibName:@"MyWorkVC" bundle:nil];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"我的工作" image:[UIImage imageNamed:@"主菜单栏_图标_我的工作_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_我的工作_选中.png"]];
    myWorkVC.tabBarItem = item;
    
    if ([ShareValue sharedShareValue].module.count >1) {
        HomeMenu *menu = [ShareValue sharedShareValue].module[1];
        visitMapVC  = [self controllerWithMenu:menu];
    }else if([ShareValue sharedShareValue].regiterUser.isManager){
        visitMapVC = [[VisitsMapVC alloc] initWithNibName:@"VisitsMapVC" bundle:nil];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"走访地图" image:[UIImage imageNamed:@"主菜单栏_图标_走访地图_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_走访地图_选中.png"]];
        visitMapVC.tabBarItem = item;
    }
    if ([ShareValue sharedShareValue].module.count >2) {
        HomeMenu *menu = [ShareValue sharedShareValue].module[2];
        mailListVC  = [self controllerWithMenu:menu];
    }else if([ShareValue sharedShareValue].regiterUser.isManager){
        mailListVC = [[MailListVC alloc] init];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"通讯录" image:[UIImage imageNamed:@"主菜单栏_图标_通讯录_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_通讯录_选中.png"]];        mailListVC.tabBarItem = item;
    }
    
    /*
    UINavigationController *homeVCNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    UINavigationController *myWorkVCNav = [[UINavigationController  alloc]initWithRootViewController:myWorkVC];
    UINavigationController *visitMapVNav = [[UINavigationController alloc]initWithRootViewController:visitMapVC];
    UINavigationController *mailListVCNav = [[UINavigationController alloc]initWithRootViewController:mailListVC];
     */
    if([ShareValue sharedShareValue].regiterUser.isManager){
        _vc_tab.viewControllers = @[homeVC, myWorkVC, visitMapVC,mailListVC];
    }else{
        if (visitMapVC == nil) {
            _vc_tab.viewControllers = @[homeVC, myWorkVC];
        }else if(mailListVC == nil){
            _vc_tab.viewControllers = @[homeVC, myWorkVC,visitMapVC];
        }else{
            _vc_tab.viewControllers = @[homeVC, myWorkVC,visitMapVC,mailListVC];
        }
    }
    
    
//    NSArray *ar = _vc_tab.viewControllers;
//    NSMutableArray *arr_t = [NSMutableArray new];
//    [ar enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop)
//     {
//         UITabBarItem *item = nil;
//         switch (idx)
//         {
//             case 0:
//             {
//                 item = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"主菜单栏_图标_首页_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_首页_选中.png"]];
//                 [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:@"http://www.easyicon.net/api/resizeApi.php?id=1158236&size=128"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                     if (!error) {
//                         item.image = [image imageByScaleForSize:CGSizeMake(25, 25)];
//                         item.selectedImage = [image imageByScaleForSize:CGSizeMake(25, 25)];;
//                     }
//                 }];
//                 break;
//             }
//             case 1:
//             {
//                 item = [[UITabBarItem alloc] initWithTitle:@"我的工作" image:[UIImage imageNamed:@"主菜单栏_图标_我的工作_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_我的工作_选中.png"]];
//                 break;
//             }
//             case 2:
//             {
//                 item = [[UITabBarItem alloc] initWithTitle:@"走访地图" image:[UIImage imageNamed:@"主菜单栏_图标_走访地图_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_走访地图_选中.png"]];
//                 break;
//             }
//             case 3:
//             {
//                 item = [[UITabBarItem alloc] initWithTitle:@"通讯录" image:[UIImage imageNamed:@"主菜单栏_图标_通讯录_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_通讯录_选中.png"]];
//                 break;
//             }
//         }
//         viewController.tabBarItem = item;
//         [arr_t addObject:viewController];
//     }];
//    _vc_tab.viewControllers = arr_t;
    
}

-(UIViewController *)controllerWithMenu:(HomeMenu *)menu{
    MyWebVC *webVC = [[MyWebVC alloc]init];
    if ([menu.menuUrl rangeOfString:@"?"].length > 0) {
        webVC.url = [NSString stringWithFormat:@"%@&userid=%@&token=%@",menu.menuUrl,[ShareValue sharedShareValue].regiterUser.userId,[ShareValue sharedShareValue].regiterUser.token];
    }else{
        webVC.url = [NSString stringWithFormat:@"%@?userid=%@&token=%@",menu.menuUrl,[ShareValue sharedShareValue].regiterUser.userId,[ShareValue sharedShareValue].regiterUser.token];
    }
    UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:menu.menuName image:[UIImage imageNamed:@"主菜单栏_图标_首页_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_首页_选中.png"]];
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:menu.menuIcon] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
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
    [self initTabBar];
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