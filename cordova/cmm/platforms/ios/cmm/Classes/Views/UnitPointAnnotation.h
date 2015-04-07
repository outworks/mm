//
//  UnitPointAnnotation.h
//  cmm
//
//  Created by Hcat on 15/4/7.
//
//

#import "BMKPointAnnotation.h"
#import "Unit.h"

@interface UnitPointAnnotation : BMKPointAnnotation
@property(nonatomic,strong)Unit *unit;
@property(nonatomic,strong)NSString *taskName;
@property(nonatomic,strong)NSString *opetypeid;
@property(nonatomic,strong)NSString *taskId;


@end
