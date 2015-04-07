//
//  BasicWorkVC.m
//  cmm
//
//  Created by Hcat on 15/3/30.
//
//

#import "BasicWorkVC.h"
#import "ItemView.h"
#import "TaskListVC.h"
#import "MyWorkVC.h"
#import "AppDelegate.h"


#import "TaskExecutionVC.h"

@interface BasicWorkVC ()

@property(nonatomic,strong)NSArray *arr_data;



@end

@implementation BasicWorkVC

- (void)viewDidLoad {
    
    [self initData];
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - private methods 

-(void)initData{

    self.arr_data = @[@[@"点到签到", @"工作台_图标_工单发起.png"],
                      @[@"走访任务", @"工作台_图标_移动网点认证.png"],
                      ];
    
    for (int i = 0; i < [self.arr_data count]; i++) {
        NSArray *arr = [self.arr_data objectAtIndex:i];
        ItemView *t_item = [ItemView initCustomView];
        t_item.frame = CGRectMake(i* ScreenWidth/3, 0, ScreenWidth/3, 127);
        [t_item setDelegate:(id<ItemDelegate>)self];
        [t_item setTag:i];
        [t_item.imageV_item setImage:[UIImage imageNamed:[arr objectAtIndex:1]]];
        t_item.lb_itmeName.text = [arr objectAtIndex:0];
        [self.view addSubview:t_item];
    }
    

}

#pragma mark - ItemDelegate


-(void)ItemButtonAction:(ItemView *)itemView{

    if (itemView.tag == 1) {
        TaskListVC * t_vc =  [[TaskListVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:t_vc];
        [ApplicationDelegate.viewController presentViewController:nav animated:YES completion:nil];
    }else{
        TaskExecutionVC *t_vc = [[TaskExecutionVC alloc] init];
        [ApplicationDelegate.viewController presentViewController:t_vc animated:YES completion:nil];
    }
    


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
