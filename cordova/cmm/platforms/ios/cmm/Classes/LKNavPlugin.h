//
//  LKOpenUrl.h
//  cmm
//
//  Created by ilikeido's mac on 15/3/10.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <Cordova/CDVPlugin.h>

@interface LKNavPlugin : CDVPlugin

-(void)openPage:(CDVInvokedUrlCommand*)command;

-(void)closePage:(CDVInvokedUrlCommand*)command;

-(void)backToPage:(CDVInvokedUrlCommand*)command;

@end
