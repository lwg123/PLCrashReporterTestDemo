//
//  AppDelegate.m
//  test
//
//  Created by weiguang on 2019/7/1.
//  Copyright © 2019 duia. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworking.h>
#import <NSLogger.h>

#ifdef DEBUG
#import <DoraemonKit/DoraemonManager.h>
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
#ifdef DEBUG
   
    // 默认
   // [[DoraemonManager shareInstance] install];
#endif

    
    //LoggerSetupBonjourForBuildUser();
    // 保存本地日志
//    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *logPath = [cacheDirectory stringByAppendingPathComponent:@"log.rawnsloggerdata"];
//    LoggerSetBufferFile(NULL, (__bridge CFStringRef)logPath);
    
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [self backgroundHandler];
}


- (void)backgroundHandler {
    
    NSLog(@"### -->backgroundinghandler");
    UIApplication *app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(),^{
            if( bgTask != UIBackgroundTaskInvalid){
                //                bgTask = UIBackgroundTaskInvalid;
            }
        });
        NSLog(@"====任务完成了。。。。。。。。。。。。。。。===>");
        // [app endBackgroundTask:bgTask];
        
    }];
    
    // Start the long-running task
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (true) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSDictionary *parameters = @{@"email":@"849430904@qq.com",@"password":@"85252"};
            [manager POST:@"http://192.168.20.215:8080/v1/email/login" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"success:%@",responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error:%@", error.userInfo);
            }];
            
            sleep(5);
        }
        
    });
}




@end
