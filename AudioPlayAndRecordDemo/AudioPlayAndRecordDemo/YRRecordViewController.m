//
//  YRRecordViewController.m
//  AudioPlayAndRecordDemo
//
//  Created by yangrui on 2018/10/8.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import "YRRecordViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface YRRecordViewController ()<AVAudioRecorderDelegate> 

@property (strong, nonatomic) CADisplayLink *link;
@property (strong, nonatomic) AVAudioRecorder *recorder;
@end

@implementation YRRecordViewController



#pragma mark- 音频测量

-(void)startMeterTimer{
    [self.link invalidate];
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeter)];
    link.frameInterval = 4;   // 间隔时间为刷帧率的 1/4
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.link = link;
}

-(void)stopMeterTimer{
    [self.link invalidate];
    self.link = nil;
}

/**
 返回用于表示声音分贝（dB）等级的浮点值，这个值的范围是 -160dB ~ 0dB
 */
-(void)updateMeter{
    
    [self.recorder updateMeters];
    CGFloat num1 = [self.recorder averagePowerForChannel:0];
    CGFloat num2 = [self.recorder peakPowerForChannel:0];
    NSLog(@"录音平均分贝: %f, 峰值分贝: %f",num1, num2);
    
    
    
//    [self.player updateMeters];  // 刷新
//
//    CGFloat num1 = [self.player averagePowerForChannel:0];
//    CGFloat num2 = [self.player peakPowerForChannel:0];
//
//    NSLog(@"播放平均分贝：%f, 峰值分贝：%f", num1, num2);
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
   
    
   
    NSURL *fileUrl =  [NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"record.caf"]];
    
    /**
     在录制过程中,Core Audio Format (caf) 通常是最好的容器格式,因为他和内容无关可以保存Core Audio 支持的任何音频格式.
     在设置字典中是定的键值信息也是值得讨论一番的
     */
    NSDictionary *settting = @{
                               AVFormatIDKey : @(kAudioFormatAppleIMA4),
                               AVSampleRateKey : @(22050.0f),
                               AVNumberOfChannelsKey : @(1)
                               };
    
    NSError *err = nil;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:fileUrl settings:settting error:&err];
    
    if (self.recorder) {
        
        self.recorder.delegate = self;
        
        [self.recorder prepareToRecord];
    }
}



-(void)startRecord{
    
    [self.recorder record];
}


-(void)recordFinish{
    [self.recorder stop];
}



#pragma mark- AVAudioRecorderDelegate
/**
 音频录制完成调用
 */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    if(flag){
        
        // 一般把录制好的音频复制或者剪切到目录的文件夹下
        NSURL *sourceUrl = self.recorder.url;
        
        NSURL *targetUrl = [NSURL fileURLWithPath:@"目标文件夹/音频文件名.caf"];
        
        NSError *err = nil;
        [[NSFileManager defaultManager] copyItemAtURL:sourceUrl toURL:targetUrl error:&err];
        
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
    
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags {
    
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags {
    
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder {
    
    
}

@end
