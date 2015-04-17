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
#import "UnitPointAnnotation.h"
#import "UIImage+External.h"
#import "Track.h"
#import "TrackPolyLine.h"

@interface VisitReturnVC (){

}

@property(nonatomic,strong)NSMutableArray *arr_tracks;
@property(nonatomic,strong)NSMutableArray *arr_units;

@property(nonatomic,strong)NSMutableArray *annotationArrays; // 网店在地图上的点
@property(nonatomic,strong)NSMutableArray *arr_polyline_normal; //地图上的正常点的线
@property(nonatomic,strong)NSMutableArray *arr_polyline_offline; //地图上的离线点的线

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
    _annotationArrays = [NSMutableArray array];
    _arr_polyline_normal = [NSMutableArray array];
    _arr_polyline_offline = [NSMutableArray array];
    
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
        
        [self drawPoint];
        
    } fail:^(NSString *description) {
        
    }];
}

-(void)drawPoint{

    //设置路径
    CLLocationCoordinate2D coor_t;
    Track *t_track = [_arr_tracks objectAtIndex:0];
    coor_t.latitude = [t_track.lat doubleValue];
    coor_t.longitude = [t_track.lon doubleValue];
    [_mapView setCenterCoordinate:coor_t];
    [_mapView setZoomLevel:16.5];

    for (int i = 0 ; i < [_arr_tracks count]; i++) {
        Track *t_track_i = [_arr_tracks objectAtIndex:i];
        int j = i+1;
        if (j == [_arr_tracks count]) {
            
        }else{
            Track *t_track_j = [_arr_tracks objectAtIndex:i+1];
            CLLocationCoordinate2D coors[2] = {0};
            coors[0].latitude = [t_track_i.lat doubleValue];;
            coors[0].longitude = [t_track_i.lon doubleValue];
            coors[1].latitude = [t_track_j.lat doubleValue];
            coors[1].longitude = [t_track_j.lon doubleValue];
            BMKPolyline *t_polyline = [BMKPolyline polylineWithCoordinates:coors count:2];
            if ([t_track_j.type isEqualToString:@"1"]) {
                [_arr_polyline_normal addObject:t_polyline];
            }else{
                [_arr_polyline_offline addObject:t_polyline];
            }
            
        }
    }
    [_mapView addOverlays:_arr_polyline_normal];
    [_mapView addOverlays:_arr_polyline_offline];
    


    
    //设置网店的坐标点

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



#pragma mark - BMKMapViewDelegate

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay] ;
        polylineView.strokeColor = [[UIColor colorWithRed:0.219 green:0.395 blue:0.940 alpha:1.000] colorWithAlphaComponent:0.5];
       
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    
    return nil;
}



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
        
    }
    
    return annotationView;
    
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
