//
//  VisitsMapVC.h
//  cmm
//
//  Created by Hcat on 15/4/13.
//
//

#import "BasicVC.h"
#import "BMapKit.h"

@interface VisitsMapVC : BasicVC<BMKMapViewDelegate>{
    IBOutlet BMKMapView* _mapView;
}

@end
