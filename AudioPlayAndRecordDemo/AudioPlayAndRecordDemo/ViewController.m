//
//  ViewController.m
//  AudioPlayAndRecordDemo
//
//  Created by yangrui on 2018/10/8.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

/**
 注意:
 player 必须使用强指针引用
 */
@property (strong, nonatomic) AVAudioPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加中断通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruptionNotice:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    
    
    // 音频线路改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionRouteChangeNotice:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    
}


/**
 音频中断的通知事件
 */
-(void)audioSessionInterruptionNotice:(NSNotification *)notice{
    
    
    NSDictionary *infoDic = notice.userInfo;
    
    AVAudioSessionInterruptionType interruptType = [infoDic[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    
    // 判断中断的类型
    if(interruptType == AVAudioSessionInterruptionTypeBegan){
        // 中断开始, 设置停止音乐
        [self.player pause];
    }
    else{
        
        // 中断结束, 判断是否允许继续播放
        AVAudioSessionInterruptionOptions interruptOption = [infoDic[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (interruptOption == AVAudioSessionInterruptionOptionShouldResume) {
            // 允许继续播放, 则继续播放
            [self.player play];
        }
    
    }
    
}


/**
 音频线路变化通知
 
 播放音频期间插入耳机, 音频输出线路变成耳机插孔并继续播放.
 断开耳机连接,音频线路再次回到设备的内置扬声器播放.
 虽然线路变化和预期一样,不过按照苹果官方文档,认为该音频应该处于静音状态.
 */
-(void)audioSessionRouteChangeNotice:(NSNotification *)notice{
    
    NSDictionary *infoDic = notice.userInfo;
    AVAudioSessionRouteChangeReason routerChangeReason = [infoDic[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    
    if (routerChangeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        
        AVAudioSessionRouteDescription *previousRoute = infoDic[AVAudioSessionRouteChangePreviousRouteKey];
        
        AVAudioSessionPortDescription *previousOutput = [previousRoute.outputs firstObject];
        
        if ([previousOutput.portType isEqualToString:AVAudioSessionPortHeadphones]) {
            
            // 停止播放音乐
            [self.player stop];
        }
    }
}


-(void)initSetupPlayer{
    
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"" withExtension:@""];
    NSError *err = nil;
    //   注意: player 必须使用强指针引用
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&err];
    
    if (self.player != nil) {
        self.player.numberOfLoops = -1; // 循环播放
        // 说明: prepareToPlay 方法是可选的, 在调用 player 的 play 方法前 也会自动调用, 作用是取得需要的音频硬件并预加载
        // Audio Queue 的缓冲区, 降低调用 play 方法后的延时
        [self.player prepareToPlay]; // 缓冲
    }
    
}


-(void)play{
    
   
    [self.player play];
}




-(void)pause{
    [self.player pause];
}

-(void)stop{
    [self.player stop];
    self.player.currentTime = 0.0f;
    
}
/**
 通过pause 和 stop 方法停止的音频会继续播放.
 最主要的区别在底层处理上, 调用 stop 方法会撤销调用 prepareToPlay时所作的设置, 而调用 pause 方法则不会.
 */


/**
 音量 0~1
 */
-(void)voiceSlider:(UISlider *)slider{
    self.player.volume = slider.value;
}

/**
 声道 -1~1
 */
-(void)vocalTractSlider:(UISlider *)slider{
    
    self.player.pan = slider.value * 2.0 -1.0;
}

/**
 速率 0.5 ~ 2
 */
-(void)speedSlider:(UISlider *)slider{
    self.player.rate = slider.value * 1.5 + 0.5;
    // 注意:
    // 如果要改变速率, 在初始化AVAudioPlayer 时, 应该做出如下设置
    // self.player.enableRate = YES;
}






@end
