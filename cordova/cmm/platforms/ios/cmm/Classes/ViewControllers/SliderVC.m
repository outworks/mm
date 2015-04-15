//
//  SliderVC.m
//  cmm
//
//  Created by Hcat on 15/3/19.
//
//

#import "SliderVC.h"
#import "MainVC.h"


typedef NS_ENUM(NSInteger, MoveDirection){
    MoveDirectionLeft = 0,
    MoveDirectionRight
};


@interface SliderVC ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIView *mainView;
@property(nonatomic,strong)UIView *leftView;
@property(nonatomic,strong)UIView *rightView;

@property(nonatomic,strong)UIImageView *backgroundImageView;

@property(nonatomic,strong) UITapGestureRecognizer * tapGestureRec;
@property(nonatomic,strong) UIPanGestureRecognizer * panGestureRec;

@property(nonatomic,assign) BOOL showingLeft;
@property(nonatomic,assign) BOOL showingRight;

@end

@implementation SliderVC

#pragma mark - set&&get

-(void)setBackgroundImage:(UIImage *)backgroundImage{
    self.backgroundImageView.image = backgroundImage;
}

-(UIImage *)backgroundImage{
    return self.backgroundImageView.image;

}

#pragma mark - instancetype
static SliderVC *sharedSVC = nil;

+(SliderVC *)shareSliderVC{
    
    //static SliderVC *sharedSVC;
    
    if (sharedSVC == nil) {
        sharedSVC = [[self alloc] init];
    }
    

//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//            });
    
    return sharedSVC;
}

-(void)resetShareSliderVC{
    sharedSVC = nil;

}


#pragma mark - initDefault

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])) {
       
        _leftContentOffSet  = 170;
        _rightContentOffSet = 170;
        _leftContentScale   = 0.75;
        _rightContenScale   = 0.75;
        _leftJudgeOffSet    = 110;
        _rightJudgeOffSet   = 110;
        _leftOpenDuration   = 0.4;
        _rightOpenDuration  = 0.4;
        _leftCloseDuration  = 0.3;
        _rightCloseDuration = 0.3;
        _leftTrantY = 40;
        _rightTrantY = 40;
        
        _canShowLeft=YES;
        _canShowRight=YES;
    }
    return self;
}


- (id)init{
    if (self = [super init]){
       
        _leftContentOffSet  = 170;
        _rightContentOffSet = 170;
        _leftContentScale   = 0.75;
        _rightContenScale   = 0.75;
        _leftJudgeOffSet    = 110;
        _rightJudgeOffSet   = 110;
        _leftOpenDuration   = 0.4;
        _rightOpenDuration  = 0.4;
        _leftCloseDuration  = 0.3;
        _rightCloseDuration = 0.3;
        _leftTrantY = 40;
        _rightTrantY = 40;
        
        _canShowLeft=YES;
        _canShowRight=YES;
    }
    
    return self;
}

#pragma mark - viewleft

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBarHidden  = YES;
    
    _dic_controllers = [NSMutableDictionary dictionary];
    
    [self initSubviews];
    [self initChildControllers:_leftVC rightVC:_rightVC];
    [self showContentControllerWithModel:_mainVC != nil?NSStringFromClass([_mainVC class]):@"MainVC"];
    
    _tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideBar)];
    _tapGestureRec.delegate = self;
    [_mainView addGestureRecognizer:_tapGestureRec];
    _tapGestureRec.enabled = NO;
    
    _panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    _panGestureRec.delegate = self;
    [_mainView addGestureRecognizer:_panGestureRec];
    
}

#pragma mark - private methods

-(void)initSubviews{
    _rightView = [[UIView alloc] initWithFrame:self.view.bounds];
    [_rightView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_rightView];
    
    _leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    [_leftView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_leftView];
    
    _mainView = [[UIView alloc] initWithFrame:self.view.bounds];
     [_mainView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_mainView];
}


- (void)initChildControllers:(UIViewController*)leftVC rightVC:(UIViewController*)rightVC
{
    if (_canShowRight&&rightVC!=nil) {
        [self addChildViewController:rightVC];
        rightVC.view.frame=CGRectMake(0, 0, rightVC.view.frame.size.width, rightVC.view.frame.size.height);
        [_rightView addSubview:rightVC.view];
    }
    if (_canShowLeft&&leftVC!=nil) {
        
        [self addChildViewController:leftVC];
        leftVC.view.frame=CGRectMake(0, 0, leftVC.view.frame.size.width, leftVC.view.frame.size.height);
        [_leftView addSubview:leftVC.view];
    }
}

-(CGAffineTransform)transformWithDirection:(MoveDirection)direction{

    CGFloat translateX = 0;
    CGFloat transcale = 0;
    
    CGAffineTransform transT;
    switch (direction) {
        case MoveDirectionLeft:
            translateX = - _rightContentOffSet;
            transcale = _rightContenScale;
            transT = CGAffineTransformMakeTranslation(translateX, _rightTrantY);
            break;
        case MoveDirectionRight:
            translateX = _leftContentOffSet;
            transcale = _leftContentScale;
            transT = CGAffineTransformMakeTranslation(translateX, _leftTrantY);
            break;
        default:
            break;
    }
    
    CGAffineTransform scaleT = CGAffineTransformMakeScale(transcale, transcale); //缩放
    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
    
    return conT;

}

-(void)confiureViewShadowWithDirection:(MoveDirection)direction{


    CGFloat w_shadow;
    switch (direction) {
        case MoveDirectionLeft:
            w_shadow = 2.0f;
            break;
        case MoveDirectionRight:
            w_shadow = - 2.0f;
            break;
        default:
            break;
    }
    
    _mainView.layer.shadowOffset = CGSizeMake(w_shadow, 1.0);
    _mainView.layer.shadowColor = [UIColor blackColor].CGColor;
    _mainView.layer.shadowOpacity = 0.8f;

}


#pragma mark - public methods


-(void)showContentControllerWithModel:(NSString *)className{
    
    [self closeSideBar];

    UIViewController *controller = _dic_controllers[className];
    
    if (!controller) {
        Class c = NSClassFromString(className);
        
#if __has_feature(objc_arc)
        controller = [[c alloc] init];
#else
        controller = [[[c alloc] init] autorelease];
#endif
        [_dic_controllers setObject:controller forKey:className];
        
    }
    
    if (_mainView.subviews.count > 0) {
        UIView *view = [_mainView.subviews firstObject];
        [view removeFromSuperview];
    }
    
    controller.view.frame = self.mainView.frame;
    [_mainView addSubview:controller.view];

    self.mainVC = controller;
    
}

-(void)showLeftViewController{

    if (self.showingLeft) {
        [self closeSideBar];
        return;
    }
    
    if (!_canShowLeft || _leftVC == nil) {
        return;
    }
    
    CGAffineTransform conT = [self transformWithDirection:MoveDirectionRight];
    [self.view sendSubviewToBack:_rightView];
    [self confiureViewShadowWithDirection:MoveDirectionRight];
    
    
    [UIView animateWithDuration:_leftOpenDuration animations:^{
        self.mainView.transform = conT;
    } completion:^(BOOL finished) {
        _tapGestureRec.enabled = YES;
        self.showingLeft = YES;
        _mainVC.view.userInteractionEnabled = NO;
    }];

}

-(void)showRightViewController{
    
    if (_showingRight) {
        [self closeSideBar];
        return;
    }

    if (!_canShowRight || _rightVC == nil) {
        return;
    }

    CGAffineTransform conT = [self transformWithDirection:MoveDirectionLeft];
    [self.view sendSubviewToBack:_leftView];
    [self confiureViewShadowWithDirection:MoveDirectionLeft];
    
    [UIView animateWithDuration:_rightOpenDuration animations:^{
        _mainView.transform = conT;
    } completion:^(BOOL finished) {
        _tapGestureRec.enabled = YES;
        self.showingRight = YES;
        _mainVC.view.userInteractionEnabled = NO;
    }];
}

-(void)closeSideBar{
    [self closeSideBarWithAnimate:YES complete:^(BOOL finished){}];
}

-(void)closeSideBarWithAnimate:(BOOL)bAnimate complete:(void(^)(BOOL finished))complete{
    
    CGAffineTransform oriT = CGAffineTransformIdentity;

    if (bAnimate) {
        [UIView animateWithDuration:_mainView.transform.tx == _leftContentOffSet ? _leftCloseDuration : _rightCloseDuration animations:^{
            _mainView.transform = oriT;
        } completion:^(BOOL finished) {
            _tapGestureRec.enabled = NO;
            _showingRight = NO;
            _showingLeft = NO;
            _mainVC.view.userInteractionEnabled = YES;
            complete(finished);
        }];
    }else{

        _mainView.transform = oriT;
        _tapGestureRec.enabled = NO;
        _showingRight = NO;
        _showingLeft = NO;
        _mainVC.view.userInteractionEnabled = YES;
        complete(YES);
    }
}

#pragma mark - UIPanGestureRecognizer

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes{

    static CGFloat currentTranslateX;
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        currentTranslateX = _mainView.transform.tx;
    }

    if (panGes.state == UIGestureRecognizerStateChanged){
    
        CGFloat transX = [panGes translationInView:_mainView].x; //滑动的X
        transX = transX + currentTranslateX;
        //NSLog(@"transX====%f-----",transX);
        
        CGFloat transY = 0;
        
        CGFloat sca = 0;
        
        
        //向右测滑动
        
        if (transX > 0) {
            if (!_canShowLeft || _leftVC == nil) {
                return;
            }
            
            [self.view sendSubviewToBack:_rightView];
            [self confiureViewShadowWithDirection:MoveDirectionRight];
            
            if (_mainView.frame.origin.x < _leftContentOffSet) {
                
                //滑动放大缩小的变化
                sca = 1 - (_mainView.frame.origin.x/_leftContentOffSet) * (1-_leftContentScale);
            
        
                transY = (_mainView.frame.origin.x/_leftContentOffSet) * _leftTrantY;
                
            }else{
                sca = _leftContentScale;
                transY = _leftTrantY;
            }
            
        }else{
            
            // 向左侧滑动
            
            if (!_canShowRight || _rightVC == nil) {
                return;
            }
        
            [self.view sendSubviewToBack:_leftView];
            [self confiureViewShadowWithDirection:MoveDirectionLeft];
            if (_mainView.frame.origin.x > - _rightContentOffSet) {
                sca = 1 - (-_mainView.frame.origin.x/_rightContentOffSet) * (1-_rightContenScale);
                
                transY = (_mainView.frame.origin.x/_rightContentOffSet) * _rightTrantY;
            }else{
                sca = _rightContenScale;
                transY = _rightTrantY;
            }
        }
        
        CGAffineTransform transS = CGAffineTransformMakeScale(sca, sca);
        CGAffineTransform transT = CGAffineTransformMakeTranslation(transX, transY);
        CGAffineTransform conT = CGAffineTransformConcat(transT, transS);
        _mainView.transform = conT;
        
    }
    
    
    
    if (panGes.state == UIGestureRecognizerStateEnded){
        
        CGFloat panX = [panGes translationInView:_mainView].x;
        CGFloat finaX = currentTranslateX + panX;
        
        if (finaX > _leftJudgeOffSet) {
            
            if (!_canShowLeft || _leftVC == nil) {
                return;
            }
            
            CGAffineTransform conT = [self transformWithDirection:MoveDirectionRight];
            [UIView beginAnimations:nil context:nil];
            _mainView.transform = conT;
            [UIView commitAnimations];
            
            _showingLeft = YES;
            _mainVC.view.userInteractionEnabled = NO;
            _tapGestureRec.enabled = YES;
            
            #warning 这里可做左边栏的动画处理
            
            return;
        }else if (finaX < - _rightContentOffSet) {
            
            if (!_canShowRight || _rightVC == nil) {
                return;
            }
            
            CGAffineTransform conT = [self transformWithDirection:MoveDirectionLeft];
            [UIView beginAnimations:nil context:nil];
            _mainView.transform = conT;
            [UIView commitAnimations];
            
            _showingRight = YES;
            _mainVC.view.userInteractionEnabled = NO;
            _tapGestureRec.enabled = YES;
            
            #warning 这里可做右边栏的动画处理
            
            return;
        }else{
        
            CGAffineTransform oriT = CGAffineTransformIdentity;
            [UIView beginAnimations:nil context:nil];
            _mainView.transform = oriT;
            [UIView commitAnimations];
            
            _showingRight = NO;
            _showingLeft = NO;
            _mainVC.view.userInteractionEnabled = YES;
            _tapGestureRec.enabled = NO;
    
        }
    
    }
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    //判断不可点击区域

    NSLog(@"%@",NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }else if([NSStringFromClass([touch.view class]) isEqualToString:@"TapDetectingView"]){
        return NO;
    }
    return  YES;
}



#pragma mark - dealloc


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
#if __has_feature(objc_arc)
   
    _mainView = nil;
    _leftView = nil;
    _rightView = nil;
    
    _dic_controllers = nil;
    
    _tapGestureRec = nil;
    _panGestureRec = nil;
    
    _leftVC = nil;
    _rightVC = nil;
    _mainVC = nil;
#else

    [_mainView release];
    [_leftView release];
    [_rightView release];
    
    [_dic_controllers release];
    
    [_tapGestureRec release];
    [_panGestureRec release];
    
    [_leftVC release];
    [_rightVC release];
    [_mainVC release];
    [super dealloc];
#endif
    
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
