//
//  SGSoundEffect.h
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/8.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SGSoundEffect : NSObject
/// 对象方法获取音效文件
- (id)initWithFilepath:(NSString *)path;

/// 类方法获取音效文件
+ (id)soundEffectWithFilepath:(NSString *)path;

/// 开始播放音效
- (void)play;

@end

NS_ASSUME_NONNULL_END
