//
//  ZJVoiceAnimationView.h
//  VoiceAnimationTest
//
//  Created by LYY on 2017/4/7.
//  Copyright © 2017年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AnimationDrawType) {
    kInitAnimationType,//初始化动画
    kStarAnimationType,//开始动画
    kEndTransitionAnimationType,//停止过渡过程
    kEndAnimationType,//停止
};

@interface ZJVoiceAnimationView : UIView


/**
 开始动画
 */
- (void)startAnimation;

/**
 停止动画
 */
- (void)stopAnimation;

- (void)updateAnimationMaxHeightTo:(NSInteger)toHeight;

@end
