//
//  TaskExecutionVC.h
//  cmm
//
//  Created by Hcat on 15/4/6.
//
//

#import "BasicVC.h"
#import "BMapKit.h"
#import "ShareValue.h"
#import "Task.h"
#import "Unit.h"

@interface TaskExecutionVC : BasicVC<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>{
    IBOutlet BMKMapView* _mapView;
    BMKGeoCodeSearch* _geocodesearch;
}

@property(nonatomic,strong)Task *task; // 传的是整个任务的时候调用

// 传的是只有一个网点的时候调用
@property(nonatomic,strong)Unit *unit;
@property(nonatomic,strong)NSString *taskName;
@property(nonatomic,strong)NSString *opetypeid;
@property(nonatomic,strong)NSString *taskId;

@end
