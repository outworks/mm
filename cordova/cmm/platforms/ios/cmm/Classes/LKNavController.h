//
//  LKNavController.h
//  cmm
//
//  Created by ilikeido's mac on 15/3/11.
//
//

#import <Cordova/CDVViewController.h>
#import <Cordova/CDVCommandDelegateImpl.h>
#import <Cordova/CDVCommandQueue.h>

@interface LKNavController : CDVViewController

@property(nonatomic,assign) BOOL navHidden;

@end

@interface LKNavCommandDelegate : CDVCommandDelegateImpl
@end

@interface LKNavCommandQueue : CDVCommandQueue
@end