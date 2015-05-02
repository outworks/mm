//
//  PhotoPreviewVC.m
//  cmm
//
//  Created by ilikeido on 15/5/2.
//
//

#import "PhotoPreviewVC.h"
#import "Unit.h"
#import "Task.h"
#import "ShareValue.h"
#import "NSDate+Helper.h"
#import "UIColor+External.h"

@interface PhotoPreviewVC ()

@property (weak, nonatomic) IBOutlet UILabel *lb_content;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoPreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *content = [NSString stringWithFormat:@"区县:%@\n机构号:%@\n渠道名称:%@\n任务名称:%@\n营销经理:%@\n时间:%@",self.unit.districtname,self.unit.unitnum,self.unit.unitname,_taskName,[ShareValue sharedShareValue].regiterUser.userName,[[NSDate date]stringWithFormat:@"yyyy-MM-dd HH:mm:ss" ]];
    _lb_content.text = content;
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backgroundColor = HEX_RGB(0x008cec);
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont, nil];
    [[UINavigationBar appearance] setBarTintColor:HEX_RGB(0x008cec)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [item setTintColor:[UIColor whiteColor ]];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"预览";
    [_imageView setImage:_image];
}

-(void)backAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(IBAction)sendAction:(id)sender{
   UIImage *newImage = [self imageFromView:self.view atFrame:_imageView.frame];
    if (_delegate) {
        [_delegate willUploadImage:newImage];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


//获得某个范围内的屏幕图像
- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
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
