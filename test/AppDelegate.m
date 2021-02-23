//
//  AppDelegate.m
//  test
//
//  Created by 马浩萌 on 2021/1/3.
//

#import "AppDelegate.h"

#import "GCDWebDAVServer.h"
#import "GCDWebUploader.h"

@interface AppDelegate ()

@end

static NSString * const kCurrentViewControllerName = @"CutImageViewController";

@implementation AppDelegate
{
    GCDWebDAVServer* _davServer;
    GCDWebUploader* _webUploader;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor systemGray5Color];
    UINavigationController * rootNavigationController = [[UINavigationController alloc]initWithRootViewController:[NSClassFromString(kCurrentViewControllerName) new]];
    [rootNavigationController.navigationBar setTintColor:[UIColor labelColor]];
    rootNavigationController.navigationBar.barTintColor = [UIColor systemGray5Color];
    self.window.rootViewController = rootNavigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
