//
//  BasicVC.m
//  cmm
//
//  Created by Hcat on 15/3/19.
//
//

#import "BasicVC.h"

@interface BasicVC ()

@end

@implementation BasicVC

#pragma mark - viewLife

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - set&&get 

-(void)setNavTitle:(NSString *)navTitle{
    if (navTitle) {
        _navTitle = navTitle;
        [self createNavWithTitle:_navTitle withbgImage:nil createMenuItem:nil];
    }

}

#pragma mark - public methods 

- (void)createNavWithTitle:(NSString *)t_title withbgImage:(UIImage *)bgImage createMenuItem:(UIView *(^)(int index))menuItem
{
   
    /* { 导航条 } */
    _v_nav = [[UIView alloc] initWithFrame:CGRectMake(0.f, StatusbarSize, ScreenWidth, 44.f)];
    _v_nav.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_v_nav];
    _v_nav.userInteractionEnabled = YES;
    
    if (bgImage) {
        UIImageView *t_imageV = [[UIImageView alloc] initWithFrame:_v_nav.bounds];
        t_imageV.backgroundColor = UIColorFromRGB(0x008cec);
        [t_imageV setImage:bgImage];
        [_v_nav addSubview:t_imageV];
    }
    
    if (t_title != nil)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        [titleLabel setCenter:CGPointMake(ScreenWidth/2, CGRectGetHeight(_v_nav.frame) -CGRectGetHeight(titleLabel.frame)/2)];
        [titleLabel setText:t_title];
        [titleLabel setTag:150];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [_v_nav addSubview:titleLabel];
    }
    
    UIView *item1 = menuItem(0);
    if (item1 != nil)
    {
        _v_leftItem = item1;
        [_v_nav addSubview:item1];
    }
    UIView *item2 = menuItem(1);
    if (item2 != nil)
    {
        _v_rightItem = item2;
        [_v_nav addSubview:item2];
    }
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;//这里返回哪个值，就看你想支持那几个方向了。这里必须和后面plist文件里面的一致（我感觉是这样的）。
}

- (BOOL)shouldAutorotate {
    return NO;//支持转屏
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
