//
//  LoginVC.m
//  cmm
//
//  Created by nd on 15/3/20.
//
//

#import "LoginVC.h"
#import "SwipePasswordVC.h"
#import "MBProgressHUD+Add.h"
#import "UserAPI.h"
#import "ShareValue.h"
#import "LeftSideVC.h"
#import "MainVC.h"
#import "Menu.h"
#import "ShareFun.h"
#import "UIImageView+WebCache.h"
#import "AESCrypt.h"

@interface LoginVC ()<UITextFieldDelegate>{

    MBProgressHUD * _hud;
}

@property (weak, nonatomic) IBOutlet UITextField *textF_userName;
@property (weak, nonatomic) IBOutlet UITextField *textF_password;

@property (weak, nonatomic) IBOutlet UIButton *btn_login;

@property (weak, nonatomic) IBOutlet UIButton *btn_remenber;
@property(nonatomic,assign) BOOL isSelected;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_logo;

@property (weak, nonatomic) IBOutlet UILabel *lb_info;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_user;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_iconBg;


@end

@implementation LoginVC


#pragma mark -viewLift

- (void)viewDidLoad {
    [super viewDidLoad];
    _btn_login.layer.cornerRadius = 3.f;
    _btn_login.layer.masksToBounds = YES;
    _textF_userName.delegate = self;
    _textF_password.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

//    NSString *savedPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"gesturePassword"];
    if ([ShareValue sharedShareValue].regiterUser.userId != nil) {
        _lb_info.hidden = YES;
        _imageV_logo.hidden = YES;
        _imageV_user.hidden = NO;
        _imageV_iconBg.hidden = NO;
        _imageV_user.layer.cornerRadius = _imageV_user.frame.size.width/2;
        _imageV_user.layer.masksToBounds = YES;
        [_imageV_user sd_setImageWithURL:[ShareFun fileUrlFormPath:[ShareValue sharedShareValue].regiterUser.signImgUrl]  placeholderImage:[UIImage imageNamed:@"登录页_图标_logo"]];
    }else{
        _lb_info.hidden = NO;
        _imageV_logo.hidden = NO;
        _imageV_user.hidden = YES;
        _imageV_iconBg.hidden = YES;
    }
    
    
    _textF_password.text = nil;
    if ([ShareValue sharedShareValue].isRember == YES) {
        _textF_password.text = [ShareValue sharedShareValue].password;
        self.isSelected = YES;
    }
    
    _textF_userName.text = [ShareValue sharedShareValue].loginUserName;
    if (_isSelected == YES) {
        [_btn_remenber setImage:[UIImage imageNamed:@"登录页_背景_复选框_选中"] forState:UIControlStateNormal];
    }else{
        [_btn_remenber setImage:[UIImage imageNamed:@"登录页_背景_复选框_未选中"] forState:UIControlStateNormal];
    }
}


#pragma mark - buttonAciton

- (IBAction)loginAction:(id)sender {
    if ([[ShareValue sharedShareValue]isLocked]) {
        [MBProgressHUD showError:@"对不起，您的系统已锁定" toView:self.view];
        return;
    }
    [_textF_password resignFirstResponder];
    [_textF_userName resignFirstResponder];
    
    [LKDBHelper clearTableData:[Menu class]];
    
    if ([_textF_userName.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入用户名" toView:self.view];
        return;
    }
    
    if ([_textF_password.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }
    
    [ShareValue sharedShareValue].isRember = _isSelected;
    
    if ([ShareValue sharedShareValue].isRember == YES) {
        
    }
    
    
    UserRequest * t_request = [[UserRequest alloc] init];
    t_request.username = _textF_userName.text;
    
    NSString *pwd = [AESCrypt encrypt:_textF_password.text password:@"fzyj_10086"];
    t_request.pass = pwd;
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud setLabelText:@"登录中"];
    [_hud show:YES];
    [UserAPI getUserTableHttpAPI:t_request Success:^(UserResponse *response, NSInteger result, NSString *msg) {
        [_hud hide:NO];
        [ShareValue sharedShareValue].isLoginOut = NO;
        NSString *savedPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"gesturePassword"];
        if ([[ShareValue sharedShareValue].loginUserName isEqualToString:_textF_userName.text] && savedPassword != nil) {
            [ShareValue sharedShareValue].regiterUser
            = response.smUser;
            NSMutableArray *t_arr = [Menu searchWithWhere:[NSString stringWithFormat:@"level=1"] orderBy:@"menuCatalog" offset:0 count:0];
            if (t_arr.count>0) {
                Menu * t_menu = t_arr[0];
                [ShareValue sharedShareValue].selectedMenuId = t_menu.menuId;
            }
            [ShareValue sharedShareValue].password = _textF_password.text;
            [[SliderVC shareSliderVC] resetShareSliderVC];
           self.sliderVC = [SliderVC shareSliderVC];
           LeftSideVC *leftVC = [[LeftSideVC alloc] initWithNibName:@"LeftSideVC" bundle:nil];
           MainVC *mainVC = [[MainVC alloc] init];
           [self.sliderVC closeSideBar];
            self.sliderVC.leftVC = leftVC;
           self.sliderVC.mainVC = mainVC;
            [self.navigationController pushViewController:self.sliderVC animated:YES];
        }else{
            [[ShareValue sharedShareValue] clearErrorTime];
            [ShareValue sharedShareValue].password = _textF_password.text;
            [ShareValue sharedShareValue].loginUserName = _textF_userName.text;
            [ShareValue sharedShareValue].regiterUser
            = response.smUser;
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:nil forKey:@"gesturePassword"];
            SwipePasswordVC *t_vc = [[SwipePasswordVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
        }
    } fail:^(NSString *description) {
        if ([description rangeOfString:@"无此"].length > 0 || [description rangeOfString:@"密码"].length > 0) {
            [[ShareValue sharedShareValue]addErrorTimerCount];
            if ([ShareValue sharedShareValue].pwderrorcount == 10) {
                description = [NSString stringWithFormat:@"用户名或密码输入错误超过10次,系统将锁定1小时" ];
            }else{
                description = [NSString stringWithFormat:@"用户名或密码错误!再输错%d次，将锁定1小时",10 - [ShareValue sharedShareValue].pwderrorcount];
            }
        }
        [_hud hide:NO];
       [MBProgressHUD showError:description toView:self.view];
        
    }];
 
}

- (IBAction)remenberAction:(id)sender {
    
    [_textF_userName resignFirstResponder];
    [_textF_password resignFirstResponder];
    
    _isSelected = !_isSelected;
    
    if (_isSelected == YES) {
        
        if (0 == [_textF_userName.text length] ) {
            _isSelected = NO;
            [MBProgressHUD showError:@"请输入账号" toView:self.view];
        }
        else if( 0  == [_textF_password.text length]){
            _isSelected = NO;
            [MBProgressHUD showError:@"请输入密码" toView:self.view];
    
        }else{
           
            [ShareValue sharedShareValue].password = _textF_password.text;
            [_btn_remenber setImage:[UIImage imageNamed:@"登录页_背景_复选框_选中"] forState:UIControlStateNormal];
        }
    }else{
        [_btn_remenber setImage:[UIImage imageNamed:@"登录页_背景_复选框_未选中"] forState:UIControlStateNormal];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _textF_userName) {
        NSString *regex = @"^[a-zA-Z0-9_]{1,}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isValid = [predicate evaluateWithObject:string];
        if (string.length == 0) {
            return YES;
        }
        if ((textField.text.length + string.length)>20 || !isValid ) {
            return NO;
        }
    }else{
        if (string.length == 0) {
            return YES;
        }
        if ((textField.text.length + string.length)>20 ) {
            return NO;
        }
    }
    
    return YES;
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
