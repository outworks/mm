//
//  VisitReturnVC.m
//  cmm
//
//  Created by Hcat on 15/4/13.
//
//

#import "VisitReturnVC.h"
#import "UIColor+External.h"
#import "TrackAPI.h"
#import "ShareValue.h"

@interface VisitReturnVC ()

@property(nonatomic,strong)NSMutableArray *arr_tracks;
@property(nonatomic,strong)NSMutableArray *arr_units;

@end

@implementation VisitReturnVC


#pragma mark - viewLift
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.backgroundColor = HEX_RGB(0x008cec);
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont, nil];
    [[UINavigationBar appearance] setBarTintColor:HEX_RGB(0x008cec)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [item setTintColor:[UIColor whiteColor ]];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"走访回访";
    
    _arr_tracks = [NSMutableArray array];
    _arr_units = [NSMutableArray array];
    
    [self loadTrackList];
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
}

#pragma mark - private Action 

-(void)loadTrackList{
    
    TrackListHttpRequest *request = [[TrackListHttpRequest alloc] init];
    request.correctDate = _correctDate;
    request.userId = [ShareValue sharedShareValue].regiterUser.userId;
    [TrackAPI trackListHttpAPIWithRequest:request Success:^(TrackListHttpResponse *response,NSInteger result,NSString *msg) {
        if ([response.track count] != 0) {
            [_arr_tracks addObjectsFromArray:response.track];
        }
        
        if ([response.unit count] != 0) {
            [_arr_units addObjectsFromArray:response.unit];
        }
        
        
    } fail:^(NSString *description) {
        
    }];
    


}

#pragma mark - buttonAction 

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];

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
