//
//  MyWorkVC.m
//  cmm
//
//  Created by Hcat on 15/3/20.
//
//

#import "MyWorkVC.h"
#import "CommonTabBar.h"

#import "ShareFun.h"
#import "ShareValue.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "Menu.h"
#import "ShareValue.h"

#import "MyWorkContentVC.h"

@interface MyWorkVC ()

@property (nonatomic,strong) CommonTabBar *tabBar;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (nonatomic,strong) NSString *str_menu_1;
@property (nonatomic,strong) NSString *menuid_1;
@property (nonatomic,strong) NSMutableArray *arr_menus_2;
@property (nonatomic,strong) NSMutableArray *arr_contens;
@property (nonatomic,strong) MyWorkContentVC *selectedContentVC;


@end

@implementation MyWorkVC


#pragma makr - viewlift

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(updateMenu:) name:NOTIFICATION_UPDATAMENU object:nil];
    
    Menu *t_menu = [Menu searchSingleWithWhere:[NSString stringWithFormat:@"menuId=%@",[ShareValue sharedShareValue].selectedMenuId] orderBy:nil];
    _str_menu_1 = t_menu.menuName;
    _menuid_1 = t_menu.menuId;
    _arr_menus_2 = [NSMutableArray array];
    _arr_contens = [NSMutableArray array];
    __weak MyWorkVC *weakself =  self;
    [self createNavWithTitle:_str_menu_1 withbgImage:nil createMenuItem:^UIView *(int index) {
        
        if (index == 0) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, (self.v_nav.frame.size.height - 32)/2, 32, 32)];
            [btn sd_setImageWithURL:[ShareFun fileUrlFormPath:[ShareValue sharedShareValue].regiterUser.signImgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"登录页_图标_logo"]];
            btn.layer.cornerRadius = btn.frame.size.width/2;
            btn.layer.masksToBounds = YES;
            [btn addTarget:weakself action:@selector(showLeftViewController) forControlEvents:UIControlEventTouchUpInside];
            UIImageView * t_image = [[UIImageView alloc] initWithFrame:CGRectMake(10, (self.v_nav.frame.size.height - 32)/2, 32, 32)];
            [t_image sd_setImageWithURL:[ShareFun fileUrlFormPath:[ShareValue sharedShareValue].regiterUser.signImgUrl] placeholderImage:[UIImage imageNamed:@"登录页_图标_logo"]];
            t_image.layer.cornerRadius = t_image.frame.size.width/2;
            t_image.layer.masksToBounds = YES;
            return btn;
        }
        
        return nil;
        
    }];
    
    CGRect frame = _scrollView.frame;
    frame.size.height = _scrollView.frame.size.height - 49;
    _scrollView.frame = frame;
    
    
    [self reloadView];
    
}

-(void)showLeftViewController{
    [[SliderVC shareSliderVC]showLeftViewController];
}

-(void)reloadView{

    _arr_menus_2 = [Menu searchWithWhere:[NSString stringWithFormat:@"parentId=%@ and level=2",_menuid_1] orderBy:@"menuId" offset:0 count:0];
    NSMutableArray *t_arr_menu = [NSMutableArray array];
    if ([_arr_menus_2 count] != 0) {
        for (Menu *t_menu in _arr_menus_2) {
            NSMutableDictionary *t_dic = [[NSMutableDictionary alloc] init];
            [t_dic setValue:t_menu.menuName forKey:@"Title"];
            [t_arr_menu addObject:t_dic];
        }
    }
    NSArray *t_arr = t_arr_menu;
    if (t_arr.count != 0) {
        
        _tabBar = [[CommonTabBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.v_nav.frame), ScreenWidth, 35) buttonItems:t_arr CommonTabBarType:CommonTabBarTypeTitleOnly isAnimation:YES];
        _tabBar.delegate = (id<CommonTabBarDelegate>)self;
        
        _tabBar.backgroundColor = UIColorFromRGB(0xefefef);
        _tabBar.titleColor = UIColorFromRGB(0x2f2f2f);
        _tabBar.titleSelectColor = UIColorFromRGB(0x1fbbff);
        _tabBar.titlesFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:13];
        _tabBar.titleSelectFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
        _tabBar.selectedItemTopBackgroundColor = UIColorFromRGB(0x1fbbff);
        _tabBar.selectedItemTopBackroundColorHeight = 1.5f;
        
        [_tabBar drawItems];
        [self.view addSubview:_tabBar];
        [_tabBar setSelectedIndex:0];
        
        [_scrollView setContentSize:CGSizeMake([t_arr count]*_scrollView.frame.size.width, _scrollView.frame.size.height)];
    }
}

#pragma mark - private methods

-(void)buildContentVC:(NSMutableArray *)arr with:(Menu *)menu withIndex:(NSInteger)index{
    
    if ([_arr_contens count] == 0) {
        NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
        MyWorkContentVC *t_vc = [[MyWorkContentVC alloc] init];
        t_vc.view.frame =CGRectMake(index*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        t_vc.arr_item = arr;
        t_vc.menu_p = menu;
        _selectedContentVC = t_vc;
        [t_dic setObject:t_vc forKey:@"vc"];
        [t_dic setObject:[NSNumber numberWithInteger:index] forKey:@"index"];
        [_arr_contens addObject:t_dic];
        [_scrollView addSubview:t_vc.view];
        
        return;
    }
    
    for (int i = 0 ; i < [_arr_contens count]; i++) {
        
        NSMutableDictionary *t_dic = _arr_contens[i];
        NSNumber *dic_index = [t_dic objectForKey:@"index"];
        if ([dic_index integerValue] == index) {
            MyWorkContentVC *t_vc = [t_dic objectForKey:@"vc"];
            _selectedContentVC = t_vc;
            
            return;
        }
        
        
    }
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    MyWorkContentVC *t_vc = [[MyWorkContentVC alloc] init];
    t_vc.view.frame =CGRectMake(index*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    t_vc.arr_item = arr;
    t_vc.menu_p = menu;
    _selectedContentVC = t_vc;
    [t_dic setObject:t_vc forKey:@"vc"];
    [t_dic setObject:[NSNumber numberWithInteger:index] forKey:@"index"];
    [_arr_contens addObject:t_dic];
    [_scrollView addSubview:t_vc.view];
    
}


#pragma mark - commonTabBarDelegate

-(void)tabBar:(CommonTabBar *)tabBar didSelectIndex:(NSInteger)index{
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*index, 0) animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            Menu *t_menu = _arr_menus_2[index];
            NSMutableArray *t_arr = [Menu searchWithWhere:[NSString stringWithFormat:@"parentId=%@ and level=3",t_menu.menuId] orderBy:@"menuId" offset:0 count:0];
            [self buildContentVC:t_arr with:t_menu withIndex:index];
           
        });
    });
    
    
}

#pragma mark -ScrollView


-(void) scrollViewDidScroll:(UIScrollView *) scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    NSLog(@"%d",index);
    
    if (self.tabBar != nil) {
        [self.tabBar setSelectedIndex:index];
    }
    
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    
}

#pragma mark - NSNotification

-(void)updateMenu:(NSNotification *)note{
    Menu *t_menu = [note object];
    
    [_tabBar removeFromSuperview];
    _tabBar = nil;
    for (UIView *t_view in [_scrollView subviews]) {
        [t_view removeFromSuperview];
    }
     [_arr_contens removeAllObjects];
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height)];
    //导航栏title
    
    UILabel *t_lable = (UILabel *)[self.view viewWithTag:150];
    t_lable.text = t_menu.menuName;
    _str_menu_1 = t_menu.menuName;
    _menuid_1 = t_menu.menuId;
    
   
    
    [self reloadView];

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