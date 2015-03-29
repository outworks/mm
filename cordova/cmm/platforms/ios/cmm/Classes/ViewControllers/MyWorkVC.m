//
//  MyWorkVC.m
//  cmm
//
//  Created by Hcat on 15/3/20.
//
//

#import "MyWorkVC.h"
#import "CommonTabBar.h"
#import "BasicWorkVC.h"

@interface MyWorkVC ()

@property (nonatomic,strong) CommonTabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIView *v_content;

@property (nonatomic,strong) BasicWorkVC *v_basicWork;

@end

@implementation MyWorkVC


#pragma makr - viewlift

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavWithTitle:@"销售经理工作台" withbgImage:nil createMenuItem:^UIView *(int index) {
        
        if (index == 0) {
            UIImageView * t_image = [[UIImageView alloc] initWithFrame:CGRectMake(10, (self.v_nav.frame.size.height - 32)/2, 32, 32)];
            [t_image setImage:[UIImage imageNamed:@"头像.jpg"]];
            t_image.layer.cornerRadius = t_image.frame.size.width/2;
            t_image.layer.masksToBounds = YES;
            return t_image;
        }
        
        return nil;
        
    }];
    
    
    NSArray *t_arr = @[@{@"Title":@"基础工作"},@{@"Title":@"走访支撑"},@{@"Title":@"四进促销"},@{@"Title":@"业绩查询"}];
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
    
    [self buildBasicWorkVC];
}

#pragma mark - private methods

-(void)buildBasicWorkVC{
    _v_basicWork = [[BasicWorkVC alloc] initWithNibName:@"BasicWorkVC" bundle:nil];
    _v_basicWork.view.frame = CGRectMake(0, 0, _v_content.frame.size.width, _v_content.frame.size.height);
    [_v_content addSubview:_v_basicWork.view];
    
}



#pragma mark - commonTabBarDelegate

-(void)tabBar:(CommonTabBar *)tabBar didSelectIndex:(NSInteger)index{
    
    
    
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