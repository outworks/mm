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
#import "VisitSupportVC.h"
#import "FourPromotionVC.h"
#import "PerformanceQuery.h"
#import "ShareFun.h"
#import "ShareValue.h"
#import "UIImageView+WebCache.h"

@interface MyWorkVC ()

@property (nonatomic,strong) CommonTabBar *tabBar;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;



@property (nonatomic,strong) BasicWorkVC *v_basicWork;
@property (nonatomic,strong) VisitSupportVC *v_visitSupport;
@property (nonatomic,strong) FourPromotionVC *v_fourPromotion;
@property (nonatomic,strong) PerformanceQuery *v_performanceQuery;


@end

@implementation MyWorkVC


#pragma makr - viewlift

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavWithTitle:@"销售经理工作台" withbgImage:nil createMenuItem:^UIView *(int index) {
        
        if (index == 0) {
            UIImageView * t_image = [[UIImageView alloc] initWithFrame:CGRectMake(10, (self.v_nav.frame.size.height - 32)/2, 32, 32)];
            [t_image sd_setImageWithURL:[ShareFun fileUrlFormPath:[ShareValue sharedShareValue].regiterUser.signImgUrl] placeholderImage:[UIImage imageNamed:@"登录页_图标_logo"]];
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
    
    [_scrollView setContentSize:CGSizeMake([t_arr count]*_scrollView.frame.size.width, _scrollView.frame.size.height)];
    
    
}

#pragma mark - private methods

-(void)buildBasicWorkVC{
    if (_v_basicWork == nil) {
         _v_basicWork = [[BasicWorkVC alloc] initWithNibName:@"BasicWorkVC" bundle:nil];
        _v_basicWork.view.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        [_scrollView addSubview:_v_basicWork.view];
    }
}

-(void)buildVisitSupportVC{
    _v_visitSupport = [[VisitSupportVC alloc] initWithNibName:@"VisitSupportVC" bundle:nil];
    _v_visitSupport.view.frame = CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView addSubview:_v_visitSupport.view];
    
}

-(void)buildFourPromotionVC{
    
    _v_fourPromotion = [[FourPromotionVC alloc] initWithNibName:@"FourPromotionVC" bundle:nil];
    _v_fourPromotion.view.frame = CGRectMake(2*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView addSubview:_v_fourPromotion.view];
}
-(void)buildPerformanceQuery{
    _v_performanceQuery = [[PerformanceQuery alloc] initWithNibName:@"PerformanceQuery" bundle:nil];
    _v_performanceQuery.view.frame = CGRectMake(3*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView addSubview:_v_performanceQuery.view];

}



#pragma mark - commonTabBarDelegate

-(void)tabBar:(CommonTabBar *)tabBar didSelectIndex:(NSInteger)index{
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*index, 0) animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (index == 0) {
                [self buildBasicWorkVC];
            }else if (index == 1) {
                [self buildVisitSupportVC];
            }else if(index == 2){
                [self buildFourPromotionVC];
            }else if(index == 3){
                [self buildPerformanceQuery];
                
            }
        });
    });
    
    
}

#pragma mark -ScrollView

-(void) scrollViewDidScroll:(UIScrollView *) scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    NSLog(@"%d",index);
    
    [self.tabBar setSelectedIndex:index];
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    
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