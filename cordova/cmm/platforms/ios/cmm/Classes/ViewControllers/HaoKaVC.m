//
//  HaoKaVC.m
//  cmm
//
//  Created by Hcat on 15/3/20.
//
//

#import "HaoKaVC.h"

#import "MBProgressHUD+Add.h"

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
