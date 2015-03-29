//
//  MyInfoVC.m
//  cmm
//
//  Created by ilikeido on 15-3-29.
//
//

#import "MyInfoVC.h"
#import "ShareValue.h"
#import "UIImageView+WebCache.h"
#import "LXActionSheet.h"
#import "UIColor+External.h"
#import "UIImage+External.h"
#import "LK_API.h"
#import "UserAPI.h"
#import "MBProgressHUD+Add.h"

@interface MyInfoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,LXActionSheetDelegate>{
    UIImagePickerController *_picker;
}

@property (weak, nonatomic) IBOutlet UILabel *lb_mobile;

@property (weak, nonatomic) IBOutlet UILabel *lb_nickname;

@property (weak, nonatomic) IBOutlet UILabel *lb_job;

@property (weak, nonatomic) IBOutlet UILabel *lb_sign;

@property (weak, nonatomic) IBOutlet UIImageView *iv_head;

@property(nonatomic,strong) UIImage *headImage;

@end

@implementation MyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _lb_mobile.text = [ShareValue sharedShareValue].regiterUser.mobilePhone;
    
    _lb_nickname.text = [ShareValue sharedShareValue].regiterUser.userName;
    
    _lb_sign.text = [ShareValue sharedShareValue].regiterUser.signName;
    
    _iv_head.layer.cornerRadius = _iv_head.frame.size.width/2;
    _iv_head.layer.masksToBounds = YES;
    _iv_head.userInteractionEnabled = YES;
    [_iv_head sd_setImageWithURL:[NSURL URLWithString:[ShareValue sharedShareValue].regiterUser.signImgUrl] placeholderImage:[UIImage imageNamed:@"登录页_图标_logo"]];
    [self addHeadAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addHeadAction{
    UITapGestureRecognizer *tapGestreRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAction)];
    [_iv_head addGestureRecognizer:tapGestreRecognizer];
}



- (IBAction)dimissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 

-(void)addAction{
    LXActionSheet *sheet = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"立即拍照" otherButtonTitles:@"相册选择",nil];
    sheet.tag = 12;
    [sheet setdestructiveButtonColor:RGB(86, 170, 14) titleColor:[UIColor whiteColor] icon:[UIImage imageNamed:@"micon-camera"]];
    [sheet setCancelButtonColor:[UIColor whiteColor] titleColor:[UIColor redColor] icon:nil];
    [sheet setButtonIndex:1 buttonColor:[UIColor whiteColor] titleColor:[UIColor darkTextColor] icon:[UIImage imageNamed:@"micon-album"]];
    [sheet showInView:self.view];
}



#pragma mark - LXActionSheetDelegate
- (void)lxactionSheet:(LXActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;{
    if (actionSheet.tag == 11) {
        
    }else if (actionSheet.tag == 12){
        if (buttonIndex == 0) {
            [self takePhoto];
        }else if (buttonIndex == 1){
            [self LocalPhoto];
        }
    }
}


//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        //设置拍照后的图片可被编辑
        _picker.allowsEditing = YES;
        _picker.sourceType = sourceType;
        [self presentViewController:_picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    _picker = [[UIImagePickerController alloc] init];
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker.delegate = self;
    //设置选择后的图片可被编辑
    _picker.allowsEditing = NO;
    [self presentViewController:_picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [image imageByScaleForSize:CGSizeMake(self.view.frame.size.width * 1.5, self.view.frame.size.height * 1.5)];
        self.headImage = image;
    }
    [_picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImage];
    }];
    _picker = nil;
    
}

-(void)uploadImage{
    UserSignRequest *request = [[UserSignRequest alloc]init];
    request.userId = [ShareValue sharedShareValue].regiterUser.userId;
    request.signName = @"测试";
    if (self.headImage) {
        [request appendImage:self.headImage name:nil];
    }
    [MBProgressHUD showMessag:@"正在上传" toView:self.view];
    [UserAPI updataSignNameHttpAPI:request Success:^(NSInteger result, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } fail:^(NSString *description) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:description toView:self.view];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    _picker = nil;
}


@end
