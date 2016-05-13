//
//  MyWorkContentVC.m
//  cmm
//
//  Created by Hcat on 15/4/15.
//
//

#import "MyWorkContentVC.h"
#import "MyWorkCollectionCell.h"
#import "Menu.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "ShareFun.h"
#import "LKNavController.h"
#import "ShareValue.h"
#import "Main.h"
#import "TaskListVC.h"
#import "OfflineMenu.h"
#import "MBProgressHUD+Add.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "MyWebVC.h"

@interface MyWorkContentVC ()<UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) MBProgressHUD *HUD;

@end

@implementation MyWorkContentVC


#pragma mark - viewLift
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[MyWorkCollectionCell class] forCellWithReuseIdentifier:@"MyWorkCollectionCell"];
    
   
   
}

-(void)viewWillAppear:(BOOL)animated{
    if (_arr_item == nil || [_arr_item count] == 0) {
        _lb_info.hidden = NO;
    }

}

#pragma mark - private methods 


#pragma mark - UICollectionViewDataSource 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [self.arr_item count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier = @"MyWorkCollectionCell";
    MyWorkCollectionCell *cell = (MyWorkCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (self.arr_item != nil && [self.arr_item count] != 0) {
        Menu *t_menu = _arr_item[indexPath.row];
        cell.lb_content.text = t_menu.menuName;
        [cell.imageV_icon sd_setImageWithURL:[ShareFun fileUrlFormPath:t_menu.menuIcon] placeholderImage:[UIImage imageNamed:@"工作台_图标_移动网点认证.png"]];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    
    Menu *t_menu = _arr_item[indexPath.row];
    if ([t_menu.menuName isEqualToString:@"走访任务"]) {
        TaskListVC *t_vc = [[TaskListVC alloc] init];
        UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:t_vc];
        [ApplicationDelegate.viewController presentViewController:t_nav animated:YES completion:nil];
    }else if ([t_menu.menuName isEqualToString:@"问题反馈"]){
        LKNavController *nav = [[LKNavController alloc]init];
        nav.startPage = [NSString stringWithFormat:@"index.html?userId=%@",[ShareValue sharedShareValue].regiterUser.userId];
        UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:nav];
        nav.navHidden = YES;
         [ApplicationDelegate.viewController presentViewController:t_nav animated:YES completion:nil];
    }else{
        if ([@"3" isEqual:t_menu.isnavtive]) {
            if (t_menu.menuUrl.length>0) {
                [self openWebUrl:t_menu.menuUrl];
            }
        }
        else if ([@"2" isEqual:t_menu.isnavtive]) {
            if (t_menu.iosurl.length > 0 && [t_menu.iosurl.lastPathComponent.pathExtension isEqual:@"zip"]) {
                OfflineMenu *offlineMenu = [OfflineMenu searchSingleWithWhere:[NSString stringWithFormat:@"menuid='%@'",t_menu.menuId] orderBy:nil];
                if (offlineMenu && [offlineMenu.version isEqual:t_menu.version]) {
                    [self openOfflineMenu:t_menu];
                    return;
                }
                if (!offlineMenu || ![offlineMenu.version isEqual:t_menu.version]) {
                    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    if (!offlineMenu) {
                        _HUD.labelText = @"正在下载";
                    }else{
                        _HUD.labelText = @"正在更新";
                    }
                    NSURL *URL = [NSURL URLWithString:t_menu.iosurl];
                    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
                    NSString *docPath = [path objectAtIndex:0];
                    NSString *docFilePath = [NSString stringWithFormat:@"%@/%@",docPath,t_menu.menuId];
                    NSString *temp = NSTemporaryDirectory( );
                    NSString *tempFilePath = [NSString stringWithFormat:@"%@/%@.zip",temp,t_menu.menuId];
                    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:tempFilePath append:YES];
                    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                        float progress = ((float)totalBytesRead) / (totalBytesExpectedToRead);
                        _HUD.progress = progress;
                    }];
                    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        _HUD.labelText = @"正在解压文件";
                        _HUD.progress = 0;
                        [Main unzipFileAtPath:tempFilePath toDestination:docFilePath overwrite:YES password:nil error:nil delegate:nil progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
                            _HUD.progress = (float)entryNumber/total;
                        } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
                            [_HUD hide:YES];
                            if (!succeeded) {
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"解压失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                [alert show];
                            }else {
                                if (!offlineMenu) {
                                    OfflineMenu *_offlineMenu = [[OfflineMenu alloc]init];
                                    _offlineMenu.menuId = t_menu.menuId;
                                    _offlineMenu.version = t_menu.version;
                                    _offlineMenu.filePath = docFilePath;
                                    [_offlineMenu saveToDB];

                                }else{
                                    offlineMenu.version = t_menu.version;
                                    [offlineMenu updateToDB];
                                }
                                [self openOfflineMenu:t_menu];
                            }
                        }];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [_HUD hide:YES];
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"下载失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                    }];
                    [operation start];
                }
            }
        }
    }
}

-(void)openOfflineMenu:(Menu *)menu{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    NSURL *fileUrl = [[NSURL alloc]initFileURLWithPath:[NSString stringWithFormat:@"%@/%@",docPath,menu.menuId] isDirectory:YES];
    NSString *startPage = [NSString stringWithFormat:@"%@?userId=%@",@"index.html",[ShareValue sharedShareValue].regiterUser.userId];
    LKNavController *nav = [[LKNavController alloc]init];
    nav.wwwFolderName = fileUrl.absoluteString;
    nav.startPage = startPage;
    UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:nav];
    nav.navHidden = YES;
    [ApplicationDelegate.viewController presentViewController:t_nav animated:YES completion:nil];
}

-(void)openWebUrl:(NSString *)url{
    MyWebVC *webVC = [[MyWebVC alloc]init];
    webVC.view.backgroundColor = [UIColor whiteColor];
    if ([url rangeOfString:@"?"].length > 0) {
        webVC.url = [NSString stringWithFormat:@"%@&userId=%@&token=%@",url,[ShareValue sharedShareValue].regiterUser.userId,[ShareValue sharedShareValue].regiterUser.key];
    }else{
        webVC.url = [NSString stringWithFormat:@"%@?userId=%@&token=%@",url,[ShareValue sharedShareValue].regiterUser.userId,[ShareValue sharedShareValue].regiterUser.key];
    }
   [ApplicationDelegate.viewController presentViewController:webVC animated:YES completion:nil];
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
