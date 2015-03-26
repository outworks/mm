//
//  UIControl+Block.h
//
//
//  Created by Hcat on 14-4-8.
//  Copyright (c) 2014年 Hcat. All rights reserved.
//


/**
 
 
 *  用于实现点击事件的block
 
 
 */

#import <Foundation/Foundation.h>

@interface UIControl (UIControl_Block)

- (void)handleControlEvent:(UIControlEvents)event withBlock:(void(^)(id sender))block;
- (void)removeHandlerForEvent:(UIControlEvents)event;

@end
