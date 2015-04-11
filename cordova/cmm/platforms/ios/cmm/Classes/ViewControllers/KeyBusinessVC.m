//
//  KeyBusinessVC.m
//  cmm
//
//  Created by Hcat on 15/4/1.
//
//

#import "KeyBusinessVC.h"
#import "SaleAPI.h"
#import "MBProgressHUD+Add.h"
#import "KeyItem.h"
#import "ShareValue.h"

@interface KeyBusinessVC (){
    
    MBProgressHUD * _hud;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *sc_title;

@end

@implementation KeyBusinessVC

#pragma mark - viewLift

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self datarequest];
    

}

#pragma mark - private methods

-(void)datarequest{
    
    __block KeyBusinessVC *weakSelf = self;
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud setLabelText:@"请求中"];
    [_hud show:YES];
    SaleRequest *t_request = [[SaleRequest alloc] init];
    t_request.userId = [ShareValue sharedShareValue].regiterUser.userId;
    t_request.saleType = @"4";
    [SaleAPI getSaleQueryHttpAPI:t_request Success:^(NSArray *response, NSInteger result, NSString *msg) {
        [_hud hide:YES];
        
        if ([response count] > 0) {
        
            [_sc_title setContentInset:UIEdgeInsetsMake(0, CGRectGetWidth(_sc_title.frame)/4, 0, 0)];
            
            for (int i = 0 ; i < [response count]; i++) {
                
                SaleResponse *res = response[i];
//                UILabel *t_lb = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(_sc_title.frame)/2)*i, 0, CGRectGetWidth(_sc_title.frame)/2, CGRectGetHeight(_sc_title.frame))];
//                t_lb.backgroundColor = [UIColor blueColor];
//                [t_lb setTextAlignment:NSTextAlignmentCenter];
//                [t_lb setFont:[UIFont systemFontOfSize:12]];
//                t_lb.text = @"4G销量";
//                [_sc_title addSubview:t_lb];
                
                KeyItem *t_item = [KeyItem initCustomView];
                [t_item setNeedsDisplay];
                t_item.data_sale = res;
                t_item.frame = CGRectMake(i*ScreenWidth, 0, ScreenWidth, CGRectGetHeight(t_item.frame));
                [weakSelf.scrollView addSubview:t_item];
            }
            
            for (int i = 0 ; i < 3; i++) {
                
                UILabel *t_lb = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(_sc_title.frame)/2)*i, 0, CGRectGetWidth(_sc_title.frame)/2, CGRectGetHeight(_sc_title.frame))];
                t_lb.backgroundColor = [UIColor clearColor];
                [t_lb setTextAlignment:NSTextAlignmentCenter];
                [t_lb setTag:i];
                [t_lb setFont:[UIFont systemFontOfSize:12]];
                
                t_lb.text = @"4G销量";
                [_sc_title addSubview:t_lb];
            }
            
            weakSelf.scrollView.contentSize = CGSizeMake(3*ScreenWidth, CGRectGetHeight(weakSelf.scrollView.frame));
            weakSelf.sc_title.contentSize = CGSizeMake(3*CGRectGetWidth(weakSelf.sc_title.frame), CGRectGetHeight(weakSelf.sc_title.frame));
            
            [self setSCTitleColor:0];
        }

    } fail:^(NSString *description) {
        [_hud hide:YES];
    }];
    

}

-(void)setSCTitleColor:(NSInteger)index{
    for (UILabel *t_lb in [_sc_title subviews]) {
        t_lb.textColor = UIColorFromRGB(0xa2a2a2);
    }
    UILabel *t_lb2 = [_sc_title subviews][index];
    t_lb2.textColor = UIColorFromRGB(0xFF7200);
    
}

#pragma mark -ScrollView

-(void) scrollViewDidScroll:(UIScrollView *) scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;

    [self.sc_title setContentOffset:CGPointMake(-CGRectGetWidth(_sc_title.frame)/4+CGRectGetWidth(_sc_title.frame)/2*index, 0) animated:YES];
    [self setSCTitleColor:index];
    
    
    
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
