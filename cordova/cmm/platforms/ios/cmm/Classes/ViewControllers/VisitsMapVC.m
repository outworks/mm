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

@interface VisitsMapVC (){
    
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
    
    
    CLLocationCoordinate2D coor;
    //    coor.latitude = [ShareValue sharedShareValue].latitude;
    //    coor.longitude = [ShareValue sharedShareValue].longitude;
    coor.latitude = 26.070754;
    coor.longitude = 119.306218;
    [_mapView setCenterCoordinate:coor];
    [_mapView setZoomLevel:13];
    
    
    [self loadVisitMap];
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
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
    t_request.lon = @"119.306218";
    t_request.lat = @"26.070754";
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

#pragma mark - buttonAction 

- (IBAction)guijiAction:(id)sender {
    
    VisitLocusVC * t_vc =  [[VisitLocusVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:t_vc];
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
        annotationView.tag = [pointAnnotation.unit.id integerValue];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        img.backgroundColor = [UIColor clearColor];
        img.image = [UIImage imageNamed:@"走访地图_图标_坐标.png"];
        [annotationView setImage:[img.image imageByScaleForSize:CGSizeMake(img.frame.size.width, img.frame.size.height)]];
        
    }
    return annotationView;
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
