//
//  PhotoPreviewVC.h
//  cmm
//
//  Created by ilikeido on 15/5/2.
//
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "Unit.h"

@protocol PhotoPreviewVCDelegate;

@interface PhotoPreviewVC : UIViewController

@property(nonatomic,strong)NSString *taskName;
@property(nonatomic,strong)
Unit *unit;
@property(nonatomic,strong) UIImage *image;

@property(weak,nonatomic) id<PhotoPreviewVCDelegate> delegate;

@end


@protocol PhotoPreviewVCDelegate <NSObject>

-(void)willUploadImage:(UIImage *)image;

@end