//
//  CommonTabBar.m
//  PhoneSMS
//
//  Created by Hcat on 13-10-5.
//  Copyright (c) 2013年 Hcat. All rights reserved.
//

#import "CommonTabBar.h"

const CGFloat kAnimationSpeed = 0.20;

@interface CommonTabBar()
{
    BOOL _isAnimation;
    NSMutableArray *_buttons;
    
}

@property(strong, nonatomic)NSArray *itemArray;



@end

@implementation CommonTabBar

-(id)initWithFrame:(CGRect)frame buttonItems:(NSArray *)t_itemArray
  CommonTabBarType:(CommonTabBarType)CommonTabBarType isAnimation:(BOOL) t_isAnimation{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _commonTabBarType = CommonTabBarType;
        _isAnimation = t_isAnimation;
        self.itemArray = t_itemArray;
        
        _isimgAnimation = NO;
        
        _buttons = [[NSMutableArray alloc] initWithCapacity:5];
        _backgroundView = [[UIImageView alloc]initWithFrame:self.bounds];
        [_backgroundView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_backgroundView];
        [self sendSubviewToBack:_backgroundView];
        
        NSInteger count = [self.itemArray count];
		float itemWidth = self.frame.size.width / count;
        
        _selectedBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          itemWidth,
                                                                          self.frame.size.height)];
        _selectedBackgroundImageView = [[UIImageView alloc]initWithFrame:self.selectedBackgroundView.frame];
        [self.selectedBackgroundView addSubview:self.selectedBackgroundImageView];
        _selectedTopBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                            0,
                                                                             self.selectedBackgroundView.frame.size.width-15,
                                                                             _selectedItemTopBackroundColorHeight)];
        
        _selectedTopBackgroundView.center = CGPointMake(CGRectGetMidX(self.selectedBackgroundView.frame),  CGRectGetMaxY(_backgroundView.frame) - _selectedItemTopBackroundColorHeight-2);
        [self.selectedBackgroundView addSubview:self.selectedTopBackgroundView];
        [self addSubview:self.selectedBackgroundView];
        
        _selectedIndex = 0;

    }
    return self;
    
}

-(void)drawItems{
    if (self.itemArray) {
        NSInteger count = [self.itemArray count];
		float itemWidth = self.frame.size.width / count;
		float itemHeight = self.frame.size.height;
        
		for (int i = 0; i <count; i++ ) {
			UIView* itemView = [[UIView alloc] initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, itemHeight)];
            [itemView setBackgroundColor:[UIColor clearColor]];
			
			if (_commonTabBarType == CommonTabBarTypeTitleAndImage) {
				
				UIImageView* itemImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[self.itemArray objectAtIndex:i] objectForKey:@"Default"]]];
                UILabel* itemLabel = [[UILabel alloc] init];
                itemImage.frame = CGRectMake(0, 0, 24, 24);
				itemImage.center = CGPointMake(itemView.frame.size.width/2, itemView.frame.size.height/2-7);
				itemLabel.frame = CGRectMake(0, 5 + itemHeight/2, itemWidth, itemHeight/2-5);
                [itemImage setContentMode:UIViewContentModeScaleAspectFit];
				
                [itemLabel setText:[[self.itemArray objectAtIndex:i] objectForKey:@"Title"]];
                [itemLabel setContentMode:UIViewContentModeScaleAspectFit];
                [itemLabel setFont:self.titlesFont];
                [itemLabel setTextAlignment:kTextAlignmentCenter];
                [itemLabel setBackgroundColor:[UIColor clearColor]];
                [itemLabel setTextColor:self.titleColor];
                [itemLabel setLineBreakMode:kTextLineBreakByTruncatingMiddle];
				
				itemImage.tag = i+10;
				itemLabel.tag = i+100;
                [itemView addSubview:itemLabel];
                [itemView addSubview:itemImage];
				
			}else if (_commonTabBarType == CommonTabBarTypeImageOnly) {
				
				UIImageView* itemImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[self.itemArray objectAtIndex:i] objectForKey:@"Default"]]];
                itemImage.frame = CGRectMake(0, 5, itemWidth, itemHeight-8 );
                [itemImage setContentMode:UIViewContentModeScaleAspectFit];
				itemImage.tag = i+10;
                [itemView addSubview:itemImage];
				
			}else if (_commonTabBarType == CommonTabBarTypeTitleOnly) {
				
				UILabel* itemLabel = [[UILabel alloc] init];
                itemLabel.frame = CGRectMake(10, 5, itemWidth-20, itemHeight - 5);
                itemLabel.center = CGPointMake(itemView.frame.size.width/2, itemView.frame.size.height/2);
                [itemLabel setText:[[self.itemArray objectAtIndex:i] objectForKey:@"Title"]];
                [itemLabel setContentMode:UIViewContentModeScaleAspectFit];
                [itemLabel setFont:self.titlesFont];
                [itemLabel setTextAlignment:kTextAlignmentCenter];
                [itemLabel setBackgroundColor:[UIColor clearColor]];
                [itemLabel setTextColor:self.titleColor];
                [itemLabel setLineBreakMode:kTextLineBreakByTruncatingMiddle];
                itemLabel.tag = i+100;
                [itemView addSubview:itemLabel];
			}
            
			UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
			btn.tag = i;
			btn.frame = CGRectMake(0, 0, itemWidth, itemHeight);
			[btn setBackgroundColor:[UIColor clearColor]];
            btn.showsTouchWhenHighlighted = NO;
			[btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			[itemView addSubview:btn];
			[_buttons addObject:btn];
            
			itemView.tag = i+1000;
			[self addSubview:itemView];
		}
		
	}
}

- (void)dealloc {
	self.itemArray = nil;
}

-(void)tabBarButtonClicked:(id)sender{
    UIButton *t_button = (UIButton *)sender;
    NSInteger tag = t_button.tag;
    UIView *t_view = (UIView *)[self viewWithTag:tag+1000];
    
    [self setSelectedIndex:t_button.tag];
    
    if (_isimgAnimation == YES) {
        [self  imgAnimate:t_view];
    }
    
}


- (void)imgAnimate:(UIView *)view{
    
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         
         view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.9, 0.9);
         
         
     } completion:^(BOOL finished){//do other thing
         [UIView animateWithDuration:0.2 animations:
          ^(void){
              
              view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.05, 1.05);
              
          } completion:^(BOOL finished){//do other thing
              [UIView animateWithDuration:0.1 animations:
               ^(void){
                   
                   view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
                   
                   
               } completion:^(BOOL finished){//do other thing
               }];
          }];
     }];
    
    
}


#pragma mark - 设置属性

-(void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    [self.backgroundView setImage:_backgroundImage];
}

-(void)setSelectedItemBackgroundImage:(UIImage *)selectedItemBackgroundImage{
    self.selectedItemBackgroundColor = nil;
    self.selectedTopBackgroundView.backgroundColor = nil;
    [self.selectedBackgroundImageView setImage:selectedItemBackgroundImage];
    _selectedItemBackgroundImage = selectedItemBackgroundImage;

}

- (void)setSelectedItemBackgroundColor:(UIColor *)selectedItemBackgroundColor
{
    self.selectedBackgroundImageView.image = nil;
    [self.selectedBackgroundView setBackgroundColor:selectedItemBackgroundColor];
    _selectedItemBackgroundColor = selectedItemBackgroundColor;
}

- (void)setSelectedItemTopBackgroundColor:(UIColor *)selectedItemTopBackgroundColor
{
    [self.selectedTopBackgroundView setBackgroundColor:selectedItemTopBackgroundColor];
    _selectedItemTopBackgroundColor = selectedItemTopBackgroundColor;
}

- (void)setSelectedItemTopBackroundColorHeight:(CGFloat)selectedItemTopBacktroundColorHeight
{
    CGRect frame = self.selectedTopBackgroundView.frame;
    frame.size.height = selectedItemTopBacktroundColorHeight;
    [self.selectedTopBackgroundView setFrame:frame];
    _selectedItemTopBackroundColorHeight = selectedItemTopBacktroundColorHeight;
}

#pragma mark - 设置选中的位置

-(void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    
    for (int i = 0; i < [_buttons count]; i++)
	{
        UIButton *btn = (UIButton *)[_buttons objectAtIndex:i];
		if (i == _selectedIndex) {
                [btn setUserInteractionEnabled:NO];
            }
            else{
                [btn setUserInteractionEnabled:YES];
            }
        }

    NSInteger imageTag =selectedIndex+10;
	NSInteger titleTag =selectedIndex+100;
	NSInteger itemTag = selectedIndex+1000;
	
	NSInteger count = [_itemArray count];
	UIView *item = [self viewWithTag:itemTag];
	
	UIImageView *itemImage = (UIImageView *)[self viewWithTag:imageTag];
	UILabel* itemLabel = (UILabel *)[self viewWithTag:titleTag];
	
	for (int i=0; i<count; i++) {
		UIImageView *t_itemImage = (UIImageView *)[self viewWithTag:i+10];
		UILabel* t_itemLabel = (UILabel *)[self viewWithTag:i+100];
		[t_itemImage setImage:[UIImage imageNamed:[[_itemArray objectAtIndex:i] objectForKey:@"Default"]]];
		t_itemLabel.textColor = self.titleColor;
        [t_itemLabel setFont:_titlesFont];
	}
	
	if (_commonTabBarType == CommonTabBarTypeTitleAndImage) {
		
		itemImage.image =[UIImage imageNamed:[[_itemArray objectAtIndex:selectedIndex] objectForKey:@"Seleted"]];
		itemLabel.textColor = self.titleSelectColor;
		
	}else if (_commonTabBarType == CommonTabBarTypeImageOnly) {
		
		itemImage.image =[UIImage imageNamed:[[_itemArray objectAtIndex:selectedIndex] objectForKey:@"Seleted"]];
		
	}else if (_commonTabBarType == CommonTabBarTypeTitleOnly) {
		
		itemLabel.textColor = self.titleSelectColor;
        itemLabel.font = _titleSelectFont;
		
	}
    
    
    if (_isAnimation) {
        
        CGFloat animationSpeed;
        if ([self.delegate respondsToSelector:@selector(CommonTabBarDisplayAnimatioSpeed:)]) {
            animationSpeed = [self.delegate CommonTabBarDisplayAnimatioSpeed:self];
        }
        else{
            animationSpeed = kAnimationSpeed;
        }
        if ([self.delegate respondsToSelector:
             @selector(CommonTabBarSelectionAnimationDidBegin:)]) {
            [self.delegate
             CommonTabBarSelectionAnimationDidBegin:self];
        }
        [UIView animateWithDuration:animationSpeed
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [self.selectedBackgroundView setFrame:item.frame];
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 if ([self.delegate
                                      respondsToSelector:@selector(CommonTabBarSelectionAnimationDidEnd:)]) {
                                     [self.delegate
                                      CommonTabBarSelectionAnimationDidEnd:self];
                                 }
                             }
                         }];
        if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
        {
            [_delegate tabBar:self didSelectIndex:_selectedIndex];
        }
        
    }else{
        
        [self.selectedBackgroundView setFrame:item.frame];
        if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
        {
            [_delegate tabBar:self didSelectIndex:_selectedIndex];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
