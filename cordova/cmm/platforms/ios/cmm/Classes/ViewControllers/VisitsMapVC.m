//
//  VisitsMapVC.m
//  cmm
//
//  Created by Hcat on 15/4/13.
//
//

#import "VisitsMapVC.h"
#import "TrackAPI.h"
#import "ShareValue.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "UnitPointAnnotation.h"
#import "UIImage+External.h"
#import "VisitLocusVC.h"
#import "AppDelegate.h"

#import "VisitReturnVC.h"
#import "UnitPaopaoView.h"
#import "UnitTaskPaopaoView.h"
#import "TaskExecutionVC.h"
#import "UnitListVC.h"

@interface VisitsMapVC ()<UnitTaskPaopaoViewDelegate>{
    
    //定位坐标&&定位圆弧
    BMKAnnotationView *_positionAnnotationView;
    BMKPointAnnotation * _positionAnnotation;
    BMKCircle* _positionCircle;
    BMKCircleView* _positionCircleView;
    
    MBProgressHUD * _hud;
}

@property(nonatomic,strong)NSMutableArray *arr_units;
@property(nonatomic,strong)NSMutableArray *annotationArrays;

@end

@implementation VisitsMapVC

#pragma makr - viewlift

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _arr_units = [NSMutableArray array];
    _annotationArrays = [NSMutableArray array];
    
    [self createNavWithTitle:@"走访地图" withbgImage:nil createMenuItem:^UIView *(int index) {
    
        return nil;
        
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdataLocationPoint:) name:NOTIFICATION_UPDATALOCATIONPOINT object:nil];
   [self loadVisitMap];
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self setLocationPoint];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

#pragma mark - private methods


-(void)loadVisitMap{
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud setLabelText:@"请求中.."];
    [_hud show:YES];
    VisitMapHttpRequest *t_request = [[VisitMapHttpRequest alloc] init];
    t_request.userId = [ShareValue sharedShareValue].regiterUser.userId;
    t_request.lon = [NSString stringWithFormat:@"%lf",[ShareValue sharedShareValue].longitude];
    t_request.lat = [NSString stringWithFormat:@"%lf",[ShareValue sharedShareValue].latitude];
    [TrackAPI visitMapHttpAPIWithRequest:t_request Success:^(NSArray *result) {
        [_hud hide:YES];
        if ([result count] > 0) {
            [_arr_units addObjectsFromArray:result];
            [self setUnitPoint];
        }
        
    } fail:^(NSString *description) {
        [_hud hide:YES];
        [MBProgressHUD showError:description toView:self.view];
    }];
}

-(void)setUnitPoint{
    if (_annotationArrays == nil) {
        return;
    }
    
    if(_arr_units != nil && [_arr_units count] != 0){
        
        for(NSInteger i = 0 ; i < [_arr_units count]; i++){
            Unit *t_unit = _arr_units[i];
            UnitPointAnnotation *pointAnnotation = [[UnitPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = [t_unit.lat doubleValue];
            coor.longitude = [t_unit.lon doubleValue];
            pointAnnotation.coordinate = coor;
            pointAnnotation.unit = t_unit;
            [_annotationArrays addObject:pointAnnotation];
            
        }
        [_mapView addAnnotations:_annotationArrays];
    }
}


-(void)setLocationPoint{
    
    CLLocationCoordinate2D coor_t;
    coor_t.latitude = [ShareValue sharedShareValue].latitude;
    coor_t.longitude = [ShareValue sharedShareValue].longitude;
    [_mapView setCenterCoordinate:coor_t];
    [_mapView setZoomLevel:16.5];
    
    if (_positionAnnotation == nil) {
        _positionAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [ShareValue sharedShareValue].latitude;
        coor.longitude = [ShareValue sharedShareValue].longitude;
        _positionAnnotation.coordinate = coor;
        _positionAnnotation.title = @"你所在的位置";
        [_mapView addAnnotation:_positionAnnotation];
    }
    
    if (_positionCircle == nil) {
        CLLocationCoordinate2D coor_circle;
        coor_circle.latitude = [ShareValue sharedShareValue].latitude;
        coor_circle.longitude = [ShareValue sharedShareValue].longitude;
        _positionCircle = [BMKCircle circleWithCenterCoordinate:coor_circle radius:500];
        [_mapView addOverlay:_positionCircle];
    }
    
}

#pragma mark - buttonAction 

- (IBAction)guijiAction:(id)sender {
    
    VisitLocusVC * t_vc =  [[VisitLocusVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:t_vc];
    [ApplicationDelegate.viewController presentViewController:nav animated:YES completion:nil];
}

-(IBAction)listMode:(id)sender{
    UnitListVC *vc = [[ UnitListVC alloc]init];
    vc.units = _arr_units;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [ApplicationDelegate.viewController presentViewController:nav animated:YES completion:nil];
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
        annotationView.tag = [_annotationArrays indexOfObject:pointAnnotation];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        img.backgroundColor = [UIColor clearColor];
        if ([pointAnnotation.unit.isTask isEqual:@"1"]) {
            img.image = [UIImage imageNamed:@"走访地图_图标_坐标!.png"];
        }else{
            img.image = [UIImage imageNamed:@"走访地图_图标_坐标.png"];
        }
        [annotationView setImage:[img.image imageByScaleForSize:CGSizeMake(img.frame.size.width, img.frame.size.height)]];
        if ([pointAnnotation.unit.isTask isEqual:@"1"]) {
            UnitTaskPaopaoView *t_paopaoView = [UnitTaskPaopaoView initCustomPaopaoView];
            t_paopaoView.unit = pointAnnotation.unit;
            t_paopaoView.delegate = self;
            BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc] initWithCustomView:t_paopaoView];
            [annotationView setPaopaoView:paopao];
        }else{
            UnitPaopaoView *t_paopaoView = [UnitPaopaoView initCustomPaopaoView];
            t_paopaoView.unit = pointAnnotation.unit;
            
            BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc] initWithCustomView:t_paopaoView];
            [annotationView setPaopaoView:paopao];
        }
        
        
    }else{
        NSString *positionID = @"PositionID";
        if (_positionAnnotationView == nil) {
            _positionAnnotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:positionID];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
            img.backgroundColor = [UIColor clearColor];
            img.image = [UIImage imageNamed:@"location_fixed.png"];
            [_positionAnnotationView setImage:[img.image imageByScaleForSize:CGSizeMake(img.frame.size.width, img.frame.size.height)]];
            //[_positionAnnotationView setSelected:YES animated:YES];
        }
        annotationView = _positionAnnotationView;
    }
    
    return annotationView;
    
}

#pragma mark - UnitTaskPaopaoViewDelegate
-(void)beginTask:(UnitTaskPaopaoView *)unitTaskPaopaoView{
    TaskExecutionVC *vc = [[TaskExecutionVC alloc]init];
    vc.unit = unitTaskPaopaoView.unit;
    NSArray *tasks = unitTaskPaopaoView.unit.task;
    Task *task = [tasks firstObject];
    vc.taskId = task.id;
    vc.taskName = task.name;
    vc.opetypeid = task.opetypeid;
    UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [ApplicationDelegate.viewController presentViewController:t_nav animated:YES completion:nil];
}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKCircle class]])
    {
        _positionCircleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        _positionCircleView.fillColor = [UIColorFromRGB(0x008cec) colorWithAlphaComponent:0.3];
        _positionCircleView.strokeColor = [UIColorFromRGB(0xffffff) colorWithAlphaComponent:0.3];
        _positionCircleView.lineWidth = 1.0;
    
        return _positionCircleView;
    }
    
    return nil;
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    if (view !=_positionAnnotationView) {
        
    }
}

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 取消选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    
}

#pragma mark - Notification methods

-(void)handleUpdataLocationPoint:(NSNotification *)note{
    
    _positionAnnotation = nil;
    [_mapView removeOverlay:_positionCircle];
    _positionCircle = nil;
    [self setLocationPoint];
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
