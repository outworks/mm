//
//  LKOpenUrl.m
//  cmm
//
//  Created by ilikeido's mac on 15/3/10.
//
//

#import "LKNavPlugin.h"
#import <Cordova/CDVViewController.h>
#import "LKNavController.h"

@implementation LKNavPlugin

-(void)openPage:(CDVInvokedUrlCommand*)command{
    CDVPluginResult* pluginResult = nil;
    NSString* url = [command.arguments objectAtIndex:0];
    NSString * title = [command.arguments objectAtIndex:1];
    NSString * arg3 = [command.arguments objectAtIndex:2];
    if (url != nil) {
        BOOL flag =[self openWebOrNavPage:url title:title hiddenNav:arg3];
        if (flag) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)closePage:(CDVInvokedUrlCommand*)command;{
    [self closePage];
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)backToPage:(CDVInvokedUrlCommand*)command{
    CDVPluginResult* pluginResult = nil;
    NSString* url = [command.arguments objectAtIndex:0];
    if (url != nil) {
        UIViewController * vc =[self indexPage:url];
        if (vc) {
            [self.viewController.navigationController popToViewController:vc
                                                                 animated:YES];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)notifiNavtive:(CDVInvokedUrlCommand*)command{
    CDVPluginResult* pluginResult = nil;
    NSString* params = [command.arguments objectAtIndex:0];
    if (params != nil) {
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[params dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTICATION_LKPARAM object:nil userInfo:dict];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK ];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was fails"];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


-(BOOL)isWebPage:(NSString *)url{
    return  [url rangeOfString:@".html"].length > 0 ;
}

-(UIViewController *)indexPage:(NSString *)url{
    UIViewController *vcResult = nil;
    if (self.viewController.navigationController) {
        NSArray *array = self.viewController.navigationController.childViewControllers;
        BOOL flag = [self isWebPage:url];
        Class clazz = nil;
        if (!flag) {
            clazz = NSClassFromString(url);
            if (!clazz) {
                return nil;
            }
        }
        for (UIViewController *vc in array) {
            if (flag && [vc isKindOfClass:[LKNavController class]]) {
                LKNavController *navVc = (LKNavController *)vc;
                NSString *urltemp = navVc.webView.request.URL.relativeString;
                if ([urltemp rangeOfString:url].length > 0) {
                    vcResult = vc;
                }
            }else if(!flag){
                if ([vc isKindOfClass:clazz]) {
                    vcResult = vc;
                }
            }
        }
    }
    return vcResult;
}

-(BOOL)openWebOrNavPage:(NSString *)url title:(NSString *)title hiddenNav:(NSString *)hiddenNav{
    UIViewController *vc = nil;
    if ([url rangeOfString:@".html"].length > 0 ) {
        LKNavController *vc1 = [[LKNavController alloc]init];
        if (hiddenNav) {
            if([hiddenNav isEqual:@"NO"]){
                vc1.navHidden = NO;
            }else if([hiddenNav isEqual:@"YES"]){
                vc1.navHidden = YES;
            }
        }
        vc1.startPage = url;
        vc  = vc1;
    }else{
        Class class = NSClassFromString(url);
        if (class) {
            if ([class isSubclassOfClass:[UIViewController class]]) {
                vc = [(UIViewController *)[class alloc]init];
                if (hiddenNav) {
                    if([hiddenNav isEqual:@"NO"]){
                        self.viewController.navigationController.navigationBarHidden = NO;
                    }else if([hiddenNav isEqual:@"YES"]){
                        self.viewController.navigationController.navigationBarHidden  = YES;
                    }
                }
            }else{
                return NO;
            }
        }else{
            return NO;
        }
    }
    if (title.length >0) {
        vc.title = title;
    }
    if (self.viewController.navigationController) {
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }else{
        [self.viewController presentViewController:vc animated:YES completion:^{
            
        }];
    }
    return YES;
}

-(void)closePage{
    if (self.viewController.navigationController) {
        [self.viewController.navigationController popViewControllerAnimated:YES];
    }else{
        [self.viewController dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }
}

@end
