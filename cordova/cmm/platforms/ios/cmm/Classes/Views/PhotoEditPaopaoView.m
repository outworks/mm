//
//  PhotoEditPaopaoView.m
//  cmm
//
//  Created by Hcat on 15/4/7.
//
//

#import "PhotoEditPaopaoView.h"
#import "UIButton+WebCache.h"
#import "ShareFun.h"

@interface PhotoEditPaopaoView()

@property(nonatomic,strong) NSMutableArray *photos;

@property(nonatomic,strong) NSString *waitDelPhoto;

@end

@implementation PhotoEditPaopaoView


+ (PhotoEditPaopaoView *)initCustomPaopaoView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PhotoEditPaopaoView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

+ (PhotoEditPaopaoView *)initFinishPaopaoView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PhotoFinshPaopaoView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

-(NSString *)photoParams{
    return [_photos componentsJoinedByString:@","];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self updateUntPhoto];
}

-(void)setUnit:(Unit *)unit{
    _unit = unit;
    [self updateUntPhoto];
}

-(void)updateUntPhoto{
    if (_unit.sitePhoto) {
        if (!_photos) {
            _photos = [[NSMutableArray alloc]init];
        }
        if (_unit.sitePhoto.length>0) {
            [_photos addObjectsFromArray:[_unit.sitePhoto componentsSeparatedByString:@","]];
        }
        [self reloadUIScrollView];
    }
    if ([_unit.isFinish isEqual:@"1"]) {
        _lb_state.text = [NSString stringWithFormat:@"已完成(%@)",_unit.takeapicturetime];
    }
}

-(id)init{
    self = [super init];
    if (self) {
        _photos = [[NSMutableArray alloc]init];
        [self reloadUIScrollView];
    }
    return self;
}

- (IBAction)sendAction:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sendAction:)]) {
        [self.delegate photoSendAction:self];
    }
}

-(void)addPhotoImage:(NSString *)imageurl{
    [self.photos addObject:imageurl];
    [self reloadUIScrollView];
}

-(void)reloadUIScrollView{
    NSArray *array = _scrollView.subviews;
    for (UIView *view in array) {
        [view removeFromSuperview];
    }
    CGFloat width = CGRectGetHeight(_scrollView.frame);
    CGFloat x = 0;
    int i = 0;
    for (NSString *imageurl in self.photos) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, width, width)];
        [btn setBackgroundColor:[UIColor grayColor]];
        if (![_unit.isFinish isEqual:@"1"]) {
             [btn addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        btn.tag = i;
        x += (width+10);
        btn.contentMode = UIViewContentModeScaleAspectFit;
        [btn sd_setImageWithURL:[ShareFun fileUrlFormPath:imageurl] forState:UIControlStateNormal placeholderImage:nil];
        [self.scrollView addSubview:btn];
        i++;
    }
    if (![_unit.isFinish isEqual:@"1"]) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, width, width)];
        [btn setImage:[UIImage imageNamed:@"icon_addpic"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        x += width;
    }
    self.scrollView.contentSize = CGSizeMake(x, CGRectGetHeight(self.scrollView.frame));
}

-(void)delAction:(UIButton *)btn{
    int tag = btn.tag;
    _waitDelPhoto = [_photos objectAtIndex:tag];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"是否要删除?" delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)addAction:(UIButton *)btn{
    if (_delegate) {
        [_delegate addPhoneAction:self];
    }
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    _imageV_bg.layer.cornerRadius = 4.0f;
    _imageV_bg.layer.borderWidth = 1.f;
    _imageV_bg.layer.borderColor = [UIColor clearColor].CGColor;
    _imageV_bg.layer.masksToBounds = YES;
    _btn_send.layer.cornerRadius = 4.0f;
    _btn_send.layer.borderWidth = 1.f;
    _btn_send.layer.borderColor = [UIColor clearColor].CGColor;
    _btn_send.layer.masksToBounds = YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.photos removeObject:_waitDelPhoto];
        [self reloadUIScrollView];
    }
    
}




@end
