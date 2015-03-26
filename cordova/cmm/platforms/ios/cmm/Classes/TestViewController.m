//
//  TestViewController.m
//  cmm
//
//  Created by ilikeido's mac on 15/3/11.
//
//

#import "TestViewController.h"
#import "LKNavController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

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
- (IBAction)openPage:(id)sender {
   LKNavController *vc = [[LKNavController alloc]init];
    vc.startPage = @"test3.html";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
