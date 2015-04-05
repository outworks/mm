//
//  TaskSearchVC.h
//  cmm
//
//  Created by ilikeido on 15-4-4.
//
//

#import <UIKit/UIKit.h>
#import "BasicVC.h"

@protocol TaskSearchVCDelegate;

@interface TaskSearchVC : BasicVC

@property(nonatomic,strong) NSString *name;

@property(nonatomic,strong) NSString *state;

@property(nonatomic,strong) NSString *typeId;

@property(nonatomic,strong) NSString *startTime;

@property(nonatomic,strong) NSString *endTime;

@property(nonatomic,weak) id<TaskSearchVCDelegate> delegate;

@end


@protocol TaskSearchVCDelegate <NSObject>

@optional
-(void)searchName:(NSString *)name state:(NSString *)state typeId:(NSString *)typeId startTime:(NSString *)startTime endTime:(NSString *)endTime;

-(void)taskSearchVCBack:(TaskSearchVC *)vc;


@end