//
//  BroadbandVC.m
//  cmm
//
//  Created by Hcat on 15/4/1.
//
//

#import "BroadbandVC.h"

#import "MBProgressHUD+Add.h"
#import "KeyItem.h"

#import "SaleAPI.h"
#import "ShareValue.h"

@interface BroadbandVC (){
    
    MBProgressHUD * _hud;
}


@end

@implementation BroadbandVC

#pragma mark - viewLift

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self datarequest];
    
}


#pragma mark - private methods

-(void)datarequest{
    
    __block BroadbandVC *weakSelf = self;
    

    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud setLabelText:@"请求中"];
    [_hud show:YES];
    SaleRequest *t_request = [[SaleRequest alloc] init];
    t_request.userId = [ShareValue sharedShareValue].regiterUser.userId;
    t_request.saleType = @"3";
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

@end
