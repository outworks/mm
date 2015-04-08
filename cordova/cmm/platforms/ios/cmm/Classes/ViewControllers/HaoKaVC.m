//
//  HaoKaVC.m
//  cmm
//
//  Created by Hcat on 15/3/20.
//
//

#import "HaoKaVC.h"

#import "MBProgressHUD+Add.h"
#import "KeyItem.h"

#import "SaleAPI.h"
#import "ShareValue.h"

@interface HaoKaVC (){
    
    MBProgressHUD * _hud;
}

@end

@implementation HaoKaVC

#pragma mark - viewLift

- (void)viewDidLoad {
    [super viewDidLoad];
   
  
    
    [self datarequest];
    
}


#pragma mark - private methods

-(void)datarequest{
    
    __block HaoKaVC *weakSelf = self;
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud setLabelText:@"请求中"];
    [_hud show:YES];
    SaleRequest *t_request = [[SaleRequest alloc] init];
    t_request.userId = [ShareValue sharedShareValue].regiterUser.userId;
    [SaleAPI getSaleQueryHttpAPI:t_request Success:^(NSArray *response, NSInteger result, NSString *msg) {
        [_hud hide:YES];
        
        if ([response count] > 0) {
            
            for (int i = 0 ; i < [response count]; i++) {
                
                SaleResponse *res = response[i];

                KeyItem *t_item = [KeyItem initCustomView];
                [t_item setNeedsDisplay];
                t_item.data_sale = res;
                t_item.frame = CGRectMake(i*ScreenWidth, 0, ScreenWidth, CGRectGetHeight(t_item.frame));
                [weakSelf.view addSubview:t_item];
            }
        
        }
        
    } fail:^(NSString *description) {
        [_hud hide:YES];
    }];
    
    
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
