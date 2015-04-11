//
//  TaskExecutionVC.m
//  cmm
//
//  Created by Hcat on 15/4/6.
//
//

#import "TaskExecutionVC.h"
#import "UIImage+External.h"
#import "PointPaopaoView.h"
#import "SMSSendPaopaoView.h"
#import "PhotoEditPaopaoView.h"
#import "SMSVerificationView.h"
#import "UnitFinishView.h"

#import "HCatImageUpadataVC.h"

#import "UnitPointAnnotation.h"
#import "TaskAPI.h"
#import "MBProgressHUD+Add.h"
#import "LK_API.h"
#import "LXActionSheet.h"

@interface TaskExecutionVC ()<PhotoEditPaopaoViewDelegate,LXActionSheetDelegate>{
    BMKAnnotationView *_positionAnnotationView;
    BMKPointAnnotation * _positionAnnotation;
   
    NSString *_temporary_taskid;
    NSString *_temporary_unitid;
    
    
    SMSSendPaopaoView *_sendPaopaoView; // 删除发送页面的用处
    PhotoEditPaopaoView *_photoPaopaoView;
    
    UIImagePickerController *_picker;
    
}

@property(nonatomic,strong)NSMutableArray *annotationArrays;
@property(nonatomic,strong)UIImage *headImage;

@property(nonatomic,strong)UnitPointAnnotation * unitPonit;



@end

@implementation TaskExecutionVC


#pragma mark - viewLift 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x008cec)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [item setTintColor:[UIColor whiteColor ]];
    self.navigationItem.leftBarButtonItem = item;
    self.title = @"任务执行";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdataLocationPoint:) name:NOTIFICATION_UPDATALOCATIONPOINT object:nil];
    
    CLLocationCoordinate2D coor;
    coor.latitude = [ShareValue sharedShareValue].latitude;
    coor.longitude = [ShareValue sharedShareValue].longitude;
    [_mapView setCenterCoordinate:coor];
    [_mapView setZoomLevel:13];
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self setLocationPoint];
    [self setUnitPoint];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

#pragma mark - private methods 

-(void)setUnitPoint{
    if (_task != nil) {
        if (_annotationArrays != nil) {
            return;
        }
        _annotationArrays = [NSMutableArray array];
        
        if(_task.unit != nil && [_task.unit count] != 0){
        
            for(NSInteger i = 0 ; i < [_task.unit count]; i++){
                Unit *t_unit = _task.unit[i];
                UnitPointAnnotation *pointAnnotation = [[UnitPointAnnotation alloc]init];
                CLLocationCoordinate2D coor;
                coor.latitude = [t_unit.lat doubleValue];
                coor.longitude = [t_unit.lon doubleValue];
                pointAnnotation.coordinate = coor;
                pointAnnotation.unit = t_unit;
                pointAnnotation.taskName = _task.name;
                pointAnnotation.opetypeid = _task.opetypeid;
                pointAnnotation.taskId = _task.id;
                [_annotationArrays addObject:pointAnnotation];
                
            }
            [_mapView addAnnotations:_annotationArrays];
        }
    }
    
    if (_unit != nil) {
        if(_unitPonit)return;
        UnitPointAnnotation *pointAnnotation = [[UnitPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [_unit.lat doubleValue];
        coor.longitude = [_unit.lon doubleValue];
        pointAnnotation.coordinate = coor;
        pointAnnotation.unit = _unit;
        pointAnnotation.taskName = _taskName;
        pointAnnotation.opetypeid = _opetypeid;
        pointAnnotation.taskId = _taskId;
        [_mapView addAnnotation:pointAnnotation];
        

        coor.latitude = [_unit.lat doubleValue];
        coor.longitude = [_unit.lon doubleValue];
        [_mapView setCenterCoordinate:coor];
        [_mapView setZoomLevel:14.f];
        _unitPonit = pointAnnotation;
    }

}


-(void)setLocationPoint{

    if (_positionAnnotation == nil) {
        _positionAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [ShareValue sharedShareValue].latitude;
        coor.longitude = [ShareValue sharedShareValue].longitude;
        _positionAnnotation.coordinate = coor;
        _positionAnnotation.title = @"你所在的位置";
        [_mapView addAnnotation:_positionAnnotation];
    }
    
}


#pragma mark - buttonAction

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - BMKMapViewDelegate

// 根据 anntation 生成对应的 View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    
    BMKAnnotationView *annotationView =[mapView viewForAnnotation:annotation];
    
    if (annotationView==nil && [annotation isKindOfClass:[UnitPointAnnotation class]])
    {
        UnitPointAnnotation* pointAnnotation = (UnitPointAnnotation*)annotation;
        NSString *AnnotationViewID = [NSString stringWithFormat:@"iAnnotation-%@",pointAnnotation.unit.id];
        NSLog(@"AnnotationViewID:%@",AnnotationViewID);
        NSLog(@"x----------%f,y--------------%f",pointAnnotation.coordinate.latitude,pointAnnotation.coordinate.longitude);
        annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annotationView.tag = [pointAnnotation.unit.id integerValue];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        img.backgroundColor = [UIColor clearColor];
        img.image = [UIImage imageNamed:@"走访地图_图标_坐标.png"];
        [annotationView setImage:[img.image imageByScaleForSize:CGSizeMake(img.frame.size.width, img.frame.size.height)]];
        
        // 泡泡视图
        
        PointPaopaoView *t_paopaoView = [PointPaopaoView initCustomPaopaoView];
        t_paopaoView.unit = pointAnnotation.unit;
        t_paopaoView.taskName = pointAnnotation.taskName;
        t_paopaoView.taskId = pointAnnotation.taskId;
        
        NSArray *b = [pointAnnotation.opetypeid componentsSeparatedByString:@","];
        for (int i = 0 ; i < [b count]; i++ ) {
            NSString *t_str = b[i];
            NSLog(@"%@",t_str);
            if ([t_str isEqualToString:@"2"]) {
                t_paopaoView.isTakePicture  = YES;
            }else if([t_str isEqualToString:@"1"]) {
                t_paopaoView.isSMSConfirmation = YES;
            }else if([t_str isEqualToString:@"3"]) {
                t_paopaoView.issceneConfirmation = YES;
            }
        }
        t_paopaoView.lb_task.text = pointAnnotation.taskName;
        t_paopaoView.lb_contact.text = pointAnnotation.unit.bossname;
        t_paopaoView.lb_wangdian.text = pointAnnotation.unit.unitname;
        
        [t_paopaoView setDelegate:(id<PointPaopaoViewDelegate>)self];
        
        BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc] initWithCustomView:t_paopaoView];
        [annotationView setPaopaoView:paopao];

        [annotationView setSelected:YES animated:YES];
        /*if (![pointAnnotation.unit.isFinish isEqual:@"1"]) {
            PointPaopaoView *t_paopaoView = [PointPaopaoView initCustomPaopaoView];
            t_paopaoView.unit = pointAnnotation.unit;
            t_paopaoView.taskName = pointAnnotation.taskName;
            t_paopaoView.taskId = pointAnnotation.taskId;
            
            NSArray *b = [pointAnnotation.opetypeidLabel componentsSeparatedByString:@","];
            for (int i = 0 ; i < [b count]; i++ ) {
                NSString *t_str = b[i];
                NSLog(@"%@",t_str);
                
                if ([t_str isEqualToString:@"现场拍照"]) {
                    t_paopaoView.isTakePicture  = YES;
                }else if([t_str isEqualToString:@"短信确认"]) {
                    t_paopaoView.isSMSConfirmation = YES;
                }else if([t_str isEqualToString:@"现场确认"]) {
                    t_paopaoView.issceneConfirmation = YES;
                }
            }
            t_paopaoView.lb_task.text = pointAnnotation.taskName;
            t_paopaoView.lb_contact.text = pointAnnotation.unit.bossname;
            t_paopaoView.lb_wangdian.text = pointAnnotation.unit.unitname;
            
            [t_paopaoView setDelegate:(id<PointPaopaoViewDelegate>)self];
            
            BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc] initWithCustomView:t_paopaoView];
            [annotationView setPaopaoView:paopao];
        }else{
            UnitFinishView *t_paopaoView = [UnitFinishView initCustomPaopaoView];
            t_paopaoView.unit = pointAnnotation.unit;
            t_paopaoView.taskName = pointAnnotation.taskName;
            t_paopaoView.taskId = pointAnnotation.taskId;
            t_paopaoView.lb_task.text = pointAnnotation.taskName;
            t_paopaoView.lb_contact.text = pointAnnotation.unit.bossname;
            t_paopaoView.lb_wangdian.text = pointAnnotation.unit.unitname;
            t_paopaoView.lb_taskSatus.text = @"已完成";
            
            BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc] initWithCustomView:t_paopaoView];
            [annotationView setPaopaoView:paopao];
        }
        */
        
//        [annotationView setSelected:YES animated:YES];
        
        
    }else{
        NSString *positionID = @"PositionID";
        if (_positionAnnotationView == nil) {
            _positionAnnotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:positionID];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
            img.backgroundColor = [UIColor clearColor];
            img.image = [UIImage imageNamed:@"走访地图_图标_终点.png"];
            [_positionAnnotationView setImage:[img.image imageByScaleForSize:CGSizeMake(img.frame.size.width, img.frame.size.height)]];
            [_positionAnnotationView setSelected:YES animated:YES];
        }
        annotationView = _positionAnnotationView;
    }
    return annotationView;
    
}


#pragma mark - paopaoViewDelegate

-(void)takePictureAction:(PointPaopaoView *)view{
    _temporary_taskid = view.taskId;
    _temporary_unitid = view.unit.id;
    //[self takePhoto];
    PhotoEditPaopaoView *t_paopaoView = [PhotoEditPaopaoView initCustomPaopaoView];
    _photoPaopaoView = t_paopaoView;
    t_paopaoView.unit = view.unit;
    t_paopaoView.taskName = view.taskName;
    t_paopaoView.taskId = view.taskId;
    t_paopaoView.lb_task.text = view.taskName;
    t_paopaoView.lb_wangdian.text = view.unit.unitname;
    t_paopaoView.tx_lbname.text = view.unit.bossname;
    [t_paopaoView setDelegate:self];
    t_paopaoView.frame = view.frame;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSmsView:)];
    gestureRecognizer.numberOfTapsRequired = 1;
    [backView addGestureRecognizer:gestureRecognizer];
    t_paopaoView.center = CGPointMake(CGRectGetWidth(backView.frame)/2, CGRectGetHeight(backView.frame)/2);
    [backView addSubview:t_paopaoView];
    [self.view addSubview:backView];
}

#pragma mark - PhotoEditPaopaoViewDelegate
-(void)addPhoneAction:(PhotoEditPaopaoView *)view{
    [self addAction];
}

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

-(void)photoSendAction:(PhotoEditPaopaoView *)view{
    [self postAdd];
}

-(void)SMSConfirmationAction:(PointPaopaoView *)view{
    
    SMSSendPaopaoView *t_paopaoView = [SMSSendPaopaoView initCustomPaopaoView];
    _sendPaopaoView = t_paopaoView;
    t_paopaoView.unit = view.unit;
    t_paopaoView.taskName = view.taskName;
    t_paopaoView.taskId = view.taskId;
    t_paopaoView.lb_task.text = view.taskName;
    t_paopaoView.tx_userName.text = view.unit.bossname;
    t_paopaoView.lb_wangdian.text = view.unit.unitname;
    t_paopaoView.tx_phone.text = view.unit.bossphonenum;
    [t_paopaoView setDelegate:(id<SMSSendPaopaoViewDelegate>)self];
    t_paopaoView.frame = view.frame;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSmsView:)];
    gestureRecognizer.numberOfTapsRequired = 1;
    [backView addGestureRecognizer:gestureRecognizer];
    t_paopaoView.center = CGPointMake(CGRectGetWidth(backView.frame)/2, CGRectGetHeight(backView.frame)/2);
    [backView addSubview:t_paopaoView];
    [self.view addSubview:backView];
//    [view addSubview:t_paopaoView];
    
}

-(void)removeSmsView:(UITapGestureRecognizer *)tapGestureRecognizer{
    UIView *view = tapGestureRecognizer.view;
    [view removeFromSuperview];
}

-(void)sceneConfirmationAction:(PointPaopaoView *)view{
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"确认中..." toView:self.view];
    [hud show:YES];
    SiteConfirmRequest *t_request = [[SiteConfirmRequest alloc] init];
    t_request.userId = @"12";
    t_request.visitTaskId = view.taskId;
    t_request.lon = [NSString stringWithFormat:@"%lf",[ShareValue sharedShareValue].longitude];
    t_request.lat = [NSString stringWithFormat:@"%lf",[ShareValue sharedShareValue].latitude];
    t_request.unitinfoId = view.unit.id;
    
    [TaskAPI updataSiteConfirmHttpAPI:t_request Success:^(NSInteger result, NSString *msg) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
        
    } fail:^(NSString *description) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:description toView:self.view];
    }];


}

#pragma mark - SMSSendPaopaoViewDelegate

-(void)sendAction:(SMSSendPaopaoView *)view{
   
    if ([view.tx_phone.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"手机号码不能为空" toView:self.view];
        
        return;
    }

    
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"发送中..." toView:self.view];
    [hud show:YES];
    
    BusiNotifyRequest *t_request = [[BusiNotifyRequest alloc] init];
    t_request.userId = @"12";
    t_request.visitTaskId = view.taskId;
    t_request.unitinfoId = view.unit.id;
    t_request.telNum = view.tx_phone.text;
    [TaskAPI updataBusiNotifyHttpAPI:t_request Success:^(NSInteger result, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"发送成功" toView:self.view];
        
        SMSVerificationView *t_paopaoView = [SMSVerificationView initCustomPaopaoView];
        
        t_paopaoView.unit = view.unit;
        t_paopaoView.taskName = view.taskName;
        t_paopaoView.taskId = view.taskId;
        
        t_paopaoView.lb_task.text = view.taskName;
        t_paopaoView.lb_contact.text = [NSString stringWithFormat:@"%@(%@)",view.unit.bossname,view.unit.bossphonenum];
        t_paopaoView.lb_wangdian.text = view.unit.unitname;
        [t_paopaoView setDelegate:(id<SMSVerificationViewDelegate>)self];
        
        [view addSubview:t_paopaoView];
        
    } fail:^(NSString *description) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:description toView:self.view];
    }];
    
    

}


#pragma mark - SMSVerificationViewDelegate


-(void)VerificationAction:(SMSVerificationView *)view{
    if ([view.tx_verification.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"验证码不能为空" toView:self.view];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"验证中..." toView:self.view];
    [hud show:YES];
    
    BusiNotifyCheckRequest *t_request = [[BusiNotifyCheckRequest alloc] init];
    t_request.userId = @"12";
    t_request.visitTaskId = view.taskId;
    t_request.unitinfoId = view.unit.id;
    t_request.lon = [NSString stringWithFormat:@"%lf",[ShareValue sharedShareValue].longitude];
    t_request.lat = [NSString stringWithFormat:@"%lf",[ShareValue sharedShareValue].latitude];
    t_request.msgCheckCode = view.tx_verification.text;
    
    [TaskAPI updataBusiNotifyCheckHttpAPI:t_request Success:^(NSInteger result, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"验证成功" toView:self.view];
        [view removeFromSuperview];
        [_sendPaopaoView removeFromSuperview];
        
    } fail:^(NSString *description) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:description toView:self.view];
    }];


}

#pragma mark - Notification methods

-(void)handleUpdataLocationPoint:(NSNotification *)note{

    _positionAnnotation = nil;
    [self setLocationPoint];
   
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



//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        _picker = [[UIImagePickerController alloc] init];
        [_picker setDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)self];
        //设置拍照后的图片可被编辑
        _picker.allowsEditing = NO;
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
    [_picker setDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)self];
    //设置选择后的图片可被编辑
    _picker.allowsEditing = NO;
    [self presentViewController:_picker animated:YES completion:nil];
}


-(void)sendImage:(UIImage *)image{
   MBProgressHUD * _hud = [MBProgressHUD showMessag:@"正在上传" toView:self.view];
    [_hud setMode:MBProgressHUDModeDeterminateHorizontalBar];
    ImageFileInfo *fileInfo = [[ImageFileInfo alloc]initWithImage:image];
    NSLog(@"chenzftest2: %f,%f",fileInfo.image.size.width,fileInfo.image.size.height);
    [LK_APIUtil postFileByImage:fileInfo.image progressBlock:^(NSInteger bytesWritten, long long totalBytesWritten) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _hud.progress = (float)bytesWritten/totalBytesWritten;
        });
    } Success:^(NSString *fileUrl) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [_photoPaopaoView addPhotoImage:fileUrl];
    } fail:^(NSString *failDescription) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:failDescription toView:self.view];
    }];
    
}

-(void)postAdd{
    NSString *photoParams = _photoPaopaoView.photoParams;
    if (photoParams.length == 0) {
       UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"请添加照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    SitePhotoRequest *t_request = [[SitePhotoRequest alloc] init];
    t_request.userId = [ShareValue sharedShareValue].regiterUser.userId;
    t_request.visitTaskId = _temporary_taskid;
    t_request.lon = [NSString stringWithFormat:@"%lf",[ShareValue sharedShareValue].longitude];
    t_request.lat = [NSString stringWithFormat:@"%lf",[ShareValue sharedShareValue].latitude];
    t_request.unitinfoId = _temporary_unitid;
    t_request.filePath = photoParams;
    [MBProgressHUD showMessag:@"正在提交" toView:self.view];
    [TaskAPI updataSitePhotoHttpAPI:t_request Success:^(NSInteger result, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
        self.unit.sitePhoto = photoParams;
        [_photoPaopaoView.superview removeFromSuperview];
    } fail:^(NSString *description) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:description toView:self.view];
    }];
    
}



#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    UIImage* image = nil;
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [image fixOrientation];
        NSLog(@"%f-%f",image.size.width,image.size.height);
        image = [image imageByScaleForSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/image.size.width*image.size.height)];
        [self sendImage:image];
    }
    [picker dismissViewControllerAnimated:NO completion:^{
        
    }];
    _picker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    _picker = nil;
}


@end
