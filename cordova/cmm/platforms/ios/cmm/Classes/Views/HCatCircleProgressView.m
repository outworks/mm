//
//  HCatCircleProgressView.m
//  cmm
//
//  Created by Hcat on 15/3/22.
//
//

#import "HCatCircleProgressView.h"

@implementation HCatCircleProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _trackLayer = [CAShapeLayer new];
        [self.layer addSublayer:_trackLayer];
        _trackLayer.fillColor = nil;
        _trackLayer.frame = self.bounds;
        [self.layer addSublayer:_trackLayer];
        
        _progressLayer1 = [CAShapeLayer new];
        [self.layer addSublayer:_progressLayer1];
        _progressLayer1.fillColor = nil;
        _progressLayer1.lineCap = kCALineCapRound;
        _progressLayer1.frame = self.bounds;
        [self.layer addSublayer:_progressLayer1];
        
        _progressLayer2 = [CAShapeLayer new];
        [self.layer addSublayer:_progressLayer2];
        _progressLayer2.fillColor = nil;
        _progressLayer2.lineCap = kCALineCapRound;
        _progressLayer2.frame = self.bounds;
        [self.layer addSublayer:_progressLayer2];
        //默认5
        self.progressWidth = 5;
    }
    return self;
}

- (void)setTrack
{
    _trackPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];;
    _trackLayer.path = _trackPath.CGPath;
}

- (void)setProgress1
{
    _progressPath1 = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle: M_PI_2 endAngle: - M_PI_2*_progress clockwise:YES];
    _progressLayer1.path = _progressPath1.CGPath;
}

- (void)setProgress2
{
    _progressPath2 = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle: M_PI_2 endAngle: - M_PI_2*_progress clockwise:NO];
    _progressLayer2.path = _progressPath2.CGPath;
}


- (void)setProgressWidth:(float)progressWidth
{
    _progressWidth = progressWidth;
    _trackLayer.lineWidth = _progressWidth;
    _progressLayer1.lineWidth = _progressWidth;
    
    [self setTrack];
    [self setProgress1];
    [self setProgress2];
}

- (void)setTrackColor:(UIColor *)trackColor
{
    _trackLayer.strokeColor = trackColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressLayer1.strokeColor = progressColor.CGColor;
    _progressLayer2.strokeColor = progressColor.CGColor;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    
    [self setProgress1];
    [self setProgress2];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    [UIView animateWithDuration:4.f animations:^{
        [self setProgress:progress];
    } completion:^(BOOL finished) {
        
    }];
    
    
}


@end
