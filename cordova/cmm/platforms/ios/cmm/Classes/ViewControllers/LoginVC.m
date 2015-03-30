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

@interface LoginVC (){

    MBProgressHUD * _hud;
}

@property (weak, nonatomic) IBOutlet UITextField *textF_userName;
@property (weak, nonatomic) IBOutlet UITextField *textF_password;

@property (weak, nonatomic) IBOutlet UIButton *btn_login;

@property (weak, nonatomic) IBOutlet UIButton *btn_remenber;
@property(nonatomic,assign) BOOL isSelected;


@end

@implementation LoginVC


#pragma mark -viewLift

- (void)viewDidLoad {
    [super viewDidLoad];
    _btn_login.layer.cornerRadius = 3.f;
    _btn_login.layer.masksToBounds = YES;
    
    if ([ShareValue sharedShareValue].isRember == NO) {
        self.isSelected = NO;
    }else{
        self.isSelected = YES;
    }
    
    _textF_userName.text = [ShareValue sharedShareValue].loginUserName;
    if (_isSelected == YES) {
        _textF_password.text = [ShareValue sharedShareValue].password;
        [_btn_remenber setImage:[UIImage imageNamed:@"登录页_背景_复选框_选中"] forState:UIControlStateNormal];
    }else{
        [_btn_remenber setImage:[UIImage imageNamed:@"登录页_背景_复选框_未选中"] forState:UIControlStateNormal];
    }
}

#pragma mark - buttonAciton

- (IBAction)loginAction:(id)sender {
    
    if ([_textF_userName.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入用户名" toView:self.view];
        return;
    }
    
    if ([_textF_password.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }
    
    if (_isSelected == YES) {
        [ShareValue sharedShareValue].password = _textF_password.text;
    }
    
    
    UserRequest * t_request = [[UserRequest alloc] init];
    t_request.username = _textF_userName.text;
    t_request.pass = _textF_password.text;
    
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud setLabelText:@"登录中"];
    [_hud show:YES];
    [UserAPI getUserTableHttpAPI:t_request Success:^(UserResponse *response, NSInteger result, NSString *msg) {
        [_hud hide:NO];
        [ShareValue sharedShareValue].password = _textF_password.text;
        [ShareValue sharedShareValue].loginUserName = _textF_userName.text;
        [ShareValue sharedShareValue].regiterUser
        = response.smUser;
        [ShareValue sharedShareValue].positionTimeInterval = response.config.positionTimeInterval;
        [ShareValue sharedShareValue].fileBaseUrl = response.config.serverUrl;
        SwipePasswordVC *t_vc = [[SwipePasswordVC alloc] init];
        [self.navigationController pushViewController:t_vc animated:YES];
        
    } fail:^(NSString *description) {
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
    
    [ShareValue sharedShareValue].isRember = _isSelected;
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
