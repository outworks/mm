//
//  HaoKaVC.m
//  cmm
//
//  Created by Hcat on 15/3/20.
//
//

#import "HaoKaVC.h"
#import "KACircleProgressView.h"

@interface HaoKaVC ()


@property (nonatomic, strong)KACircleProgressView *v_progress;

@end

@implementation HaoKaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _v_progress = [[KACircleProgressView alloc] initWithSize:110 withType:KACircleProgressViewTypeCircleBacked andProgressBarLineWidth:6 andCircleBackLineWidth:6];
    [_v_progress setProgress:.65]; // set progress to 0.3 out of 1.0
    [_v_progress setColorOfBackCircle:UIColorFromRGB(0xf2f2f2)];
    [_v_progress setColorOfProgressBar:UIColorFromRGB(0x1fbbff)];
    [self.view addSubview:_v_progress];
    [_v_progress setCenter:CGPointMake(ScreenWidth/2,90)];
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

@end
