//
//  SGSoundEffect.m
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/8.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import "SGSoundEffect.h"
#import <AudioToolbox/AudioServices.h>

@interface SGSoundEffect ()
{
    SystemSoundID _soundID;
}
@end

@implementation SGSoundEffect

- (id)initWithFilepath:(NSString *)path {
    self = [super init];
    
    if (self != nil) {
    
        // 获取声音文件路径
        NSURL *aFileURL = [NSURL fileURLWithPath:path isDirectory:NO];
        
        // 判断声音文件是否存在
        if (aFileURL != nil) {
            // 定义SystemSoundID
            SystemSoundID aSoundID;
            
            // 允许应用程序指定由系统声音服务器播放的音频文件
            /*
             参数1：A CFURLRef for an AudioFile ，一个CFURLRef类型的音频文件
             参数2：Returns a SystemSoundID，返回一个SystemSoundID
             */
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)aFileURL, &aSoundID);
            // 判断 error 是否等于无错误！
            if (error == kAudioServicesNoError) {
                // 赋值：
                _soundID = aSoundID;
            } else {
                NSLog(@"Error :loading sound path, %d, %@", (int)error, path);
                self = nil;
            }
        } else {
            NSLog(@"URL is nil for path %@", path);
            self = nil;
        }
    }
    
    return self;
}

+ (id)soundEffectWithFilepath:(NSString *)path {
    if (path) {
        return [[SGSoundEffect alloc] initWithFilepath:path];
    }
    return nil;
}

- (void)play {
    AudioServicesPlaySystemSound(_soundID);
}

- (void)dealloc {
    AudioServicesDisposeSystemSoundID(_soundID);
}

@end
