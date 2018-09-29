//
//  ViewController.m
//  AVSpeechDemo
//
//  Created by yangrui on 2018/9/28.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *field;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)speechText:(NSString *)text{
    
    // 语音表达 (Utterance 是说话的意思)
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    // 语言
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CH"];
    // 语速(0~1)
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate ;//0.4f;
    // 音调 (0.5 ~ 2.0)
    utterance.pitchMultiplier = 1.0f;
    // 播放下一句有短暂的暂停
    utterance.postUtteranceDelay = 0; //1.0f;
    
     
    
    //语音合成器
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    [synthesizer speakUtterance:utterance];
}



- (IBAction)speechBtn:(id)sender {

    [self speechText:self.field.text];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
