//
//  AppDelegate.m
//  AVAudioSessionDemo
//
//  Created by yangrui on 2018/9/28.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


/**
 激活AVAudioSession
 */
-(BOOL)activeAVAudioSession{
    // AVAudioSession 是一个单例
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];

//    AVAudioSessionCategorySoloAmbient 是系统默认的category
    NSError *err = nil;
    [audioSession setCategory:AVAudioSessionCategorySoloAmbient error:&err];
    
    if (err) {
        NSLog(@"err : %@",err);
        return NO ;
    }
    
    // 激活AVAudioSession
    err = nil;
    [audioSession setActive:YES error:&err];
    if (err) {
        NSLog(@"err : %@",err.localizedDescription); //localizedDescription 查看错误描述
        return NO ;
    }
    
   
    return YES;
}



/**
 使用情景: 智能压低
 用过高德地图的都知道，在后台播放QQ音乐的时候，如果导航语音出来，QQ音乐不会停止，而是被智能压低和混音，等导航语音播报完后，QQ音乐正常播放，
 这里我们需要后台播放音乐，所以Category使用AVAudioSessionCategoryPlayback，
 需要混音和智能压低其他APP音量，所以Options选用 AVAudioSessionCategoryOptionMixWithOthers和AVAudioSessionCategoryOptionDuckOthers
 */

-(void)setupAudioSessionAutoDuck{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers |
                              AVAudioSessionCategoryOptionDuckOthers
                        error:&err];
    
    

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    
    [self activeAVAudioSession];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruptionNotice:) name:AVAudioSessionInterruptionNotification object:nil];
    
    return YES;
}


/**
 当音频被打断就会调用这个通知
 */
-(void)audioSessionInterruptionNotice:(NSNotification *)notice{
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
