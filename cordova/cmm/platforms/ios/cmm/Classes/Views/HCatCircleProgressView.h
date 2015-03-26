//
//  HCatCircleProgressView.h
//  cmm
//
//  Created by Hcat on 15/3/22.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface HCatCircleProgressView : UIView{
    
    CAShapeLayer *_trackLayer;
    UIBezierPath *_trackPath;
    CAShapeLayer *_progressLayer1;
    UIBezierPath *_progressPath1;
    CAShapeLayer *_progressLayer2;
    UIBezierPath *_progressPath2;

}


@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic) float progress;//0~1之间的数
@property (nonatomic) float progressWidth;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
