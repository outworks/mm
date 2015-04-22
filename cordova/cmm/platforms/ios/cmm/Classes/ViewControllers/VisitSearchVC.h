//
//  VisitSearchVC.h
//  cmm
//
//  Created by Hcat on 15/4/22.
//
//

#import "BasicVC.h"


@protocol  VisitSearchVCDelegate;
@interface VisitSearchVC : BasicVC

@property(nonatomic,weak) id<VisitSearchVCDelegate> delegate;
@property(nonatomic,strong) NSString *startTime;
@property(nonatomic,strong) NSString *endTime;

@end


@protocol VisitSearchVCDelegate <NSObject>

@optional
-(void)searchstartTime:(NSString *)startTime endTime:(NSString *)endTime;

-(void)VisitSearchVCBack:(VisitSearchVC *)vc;


@end