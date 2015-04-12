//
//  VisitReturnVC.h
//  cmm
//
//  Created by Hcat on 15/4/13.
//
//

#import "BasicVC.h"
#import "BMapKit.h"

@interface VisitReturnVC : BasicVC<BMKMapViewDelegate>{
    IBOutlet BMKMapView* _mapView;
}

@property(nonatomic,strong)NSString *correctDate;

@end
