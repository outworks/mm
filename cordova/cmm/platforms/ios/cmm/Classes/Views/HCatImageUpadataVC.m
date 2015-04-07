//
//  HCatImageUpadataVC.m
//  cmm
//
//  Created by Hcat on 15/4/7.
//
//

#import "HCatImageUpadataVC.h"
#import "UIColor+External.h"
#import "ItemImageView.h"
#import "UIImage+External.h"
#import "MBProgressHUD+Add.h"
#import "LK_API.h"
#import "TaskAPI.h"
#import "ShareValue.h"


@implementation ImageFileInfo

-(id)initWithImage:(UIImage *)image;{
    self = [super init];
    if (self) {
        if (image) {
            _image = image;
            _name = @"file";
            _mimeType = @"image/jpg";
            _fileData = UIImageJPEGRepresentation(image, 0.5);
            if (_fileData == nil)
            {
                _fileData = UIImagePNGRepresentation(image);
                _fileName = [NSString stringWithFormat:@"%f.png",[[NSDate date ]timeIntervalSinceNow]];
                _mimeType = @"image/png";
            }
            else
            {
                _fileName = [NSString stringWithFormat:@"%f.jpg",[[NSDate date ]timeIntervalSinceNow]];
            }
            self.filesize = _fileData.length;
        }
    }
    return self;
}

@end



@interface HCatImageUpadataVC (){
    int _updateImageIndex;
    long long _totalfilesize;
    long long _currentWriten;
    NSMutableArray *_aryImgFileid;
    UIImagePickerController *_picker;
    MBProgressHUD *_hud;
}

@property(nonatomic,strong)NSMutableArray *arr_images;

@property(nonatomic,strong)NSMutableArray *images;
@property(nonatomic,strong)NSMutableArray *fileDatas;

@end

@implementation HCatImageUpadataVC

#pragma mark - viewLift
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backgroundColor = HEX_RGB(0x008cec);
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont, nil];
    [[UINavigationBar appearance] setBarTintColor:HEX_RGB(0x008cec)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [item setTintColor:[UIColor whiteColor ]];
    self.navigationItem.leftBarButtonItem = item;
    
    item = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(updataAction)];
    [item setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = item;
    
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"图片上传";
    _arr_images = [NSMutableArray array];
    _aryImgFileid = [NSMutableArray array];
    _images = [[NSMutableArray alloc]init];
    _fileDatas = [[NSMutableArray alloc]init];
    [self loadAddItem];
    
}

#pragma mark - private methods 

-(void)loadAddItem{
    
    ItemImageView *t_addItem = [ItemImageView initCustomView];
    t_addItem.isAdd = YES;
    [t_addItem.imageView setImage:[UIImage imageNamed:@"plus"]];
    t_addItem.btn_close.hidden = YES;
    t_addItem.tag = 0;
    t_addItem.delegate = (id<ItemImageViewDelegate>)self;
    t_addItem.frame = CGRectMake(20, 20, t_addItem.frame.size.width, t_addItem.frame.size.height);
    [self.arr_images addObject:t_addItem];
    [self.view addSubview:t_addItem];
}

-(void)reloadImageView{
    for (UIView *t_view in [self.view subviews]) {
        if ([t_view isKindOfClass:[ItemImageView class]]) {
            [t_view removeFromSuperview];
        }
    }
    
    
    NSArray* reversedArray = [[_arr_images reverseObjectEnumerator] allObjects];
    for (NSUInteger index = 0; index < [reversedArray count]; index++) {
        ItemImageView *item = reversedArray[index];
        NSUInteger i = index%3;
        NSUInteger j = index/3;
        
        [item setFrame:CGRectMake(20+ i*20 +i*item.frame.size.width, 20+j*20+j*item.frame.size.height,item.frame.size.width, item.frame.size.height)];
        [self.view addSubview:item];
    }

}

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


-(void)sendImages{
    
    if (_images.count <= _updateImageIndex) {
        _updateImageIndex = 0;
        [self postAdd];
        return;
    }
    ImageFileInfo *fileInfo = [_fileDatas objectAtIndex:_updateImageIndex];
    
    NSLog(@"chenzftest2: %f,%f",fileInfo.image.size.width,fileInfo.image.size.height);
    
    [LK_APIUtil postFileByImage:fileInfo.image progressBlock:^(NSInteger bytesWritten, long long totalBytesWritten) {
        _currentWriten += bytesWritten;
        dispatch_async(dispatch_get_main_queue(), ^{
            _hud.progress = (float)_currentWriten/_totalfilesize;
        });
    } Success:^(NSString *fileUrl) {
        
        [_aryImgFileid addObject:fileUrl];
        _updateImageIndex ++;
        
        [self sendImages];
        
    } fail:^(NSString *failDescription) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:failDescription toView:self.view];
    }];
    
}

-(void)postAdd{
    
    NSMutableString *strImgIds = [[NSMutableString alloc] init];
    for(NSString *fileid in _aryImgFileid){
        [strImgIds appendString:fileid];
        [strImgIds appendString:@","];
    }
    
    
    SitePhotoRequest *t_request = [[SitePhotoRequest alloc] init];
    
    t_request.userId = @"12";
    t_request.visitTaskId = _temporary_taskid;
    t_request.lon = [NSString stringWithFormat:@"%lf",[ShareValue sharedShareValue].longitude];
    t_request.lat = [NSString stringWithFormat:@"%lf",[ShareValue sharedShareValue].latitude];
    t_request.unitinfoId = _temporary_unitid;
    t_request.filePath = strImgIds;

    [TaskAPI updataSitePhotoHttpAPI:t_request Success:^(NSInteger result, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
        [self backAction];
        
    } fail:^(NSString *description) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:description toView:self.view];
        
    }];

}



#pragma mark - itemImageViewDelegate

-(void)imageViewAction:(ItemImageView *)view{

    [self takePhoto];

}

-(void)imageViewDelAction:(ItemImageView *)view{
    
    [self.arr_images removeObject:view
     ];
    [self reloadImageView];
}

#pragma mark - button Action 

-(void)backAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)updataAction{

    NSArray* reversedArray = [[_arr_images reverseObjectEnumerator] allObjects];
    
    for (NSUInteger index = 0; index < [reversedArray count]-1; index++) {
        ItemImageView *t_item = reversedArray[index];
        UIImage *image = t_item.imageView.image;
        [_images addObject:image];
        ImageFileInfo *imageInfo = [[ImageFileInfo alloc]initWithImage:image];
        [_fileDatas addObject:imageInfo];
        _totalfilesize += imageInfo.filesize;
    }
    
    if(_images.count > 0){
        _hud = [MBProgressHUD showMessag:@"正在上传" toView:self.view];
        [_hud setMode:MBProgressHUDModeDeterminateHorizontalBar];
        _hud.progress = 0.0/ _totalfilesize;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self sendImages];
    });
    
    _updateImageIndex = 0;
    [self sendImages];
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
        image = [image imageByScaleForSize:CGSizeMake([UIScreen mainScreen].bounds.size.width * 1.5, [UIScreen mainScreen].bounds.size.height * 1.5)];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        NSLog(@"HCat------: %f,%f",image.size.width,image.size.height);
        
        ItemImageView *t_addItem = [ItemImageView initCustomView];
        t_addItem.tag = [self.arr_images count];
        [t_addItem.imageView setImage:image];
        [t_addItem setDelegate:(id<ItemImageViewDelegate>)self];
        [self.arr_images addObject:t_addItem];
        
        [self reloadImageView];
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

#pragma mark  - dealloc

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
