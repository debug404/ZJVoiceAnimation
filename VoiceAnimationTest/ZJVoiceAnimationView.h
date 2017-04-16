//
//  ZJVoiceAnimationView.h
//  VoiceAnimationTest
//
//  Created by LYY on 2017/4/7.
//  Copyright © 2017年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZAnimationDrawType) {
    kNoneAnimationType,//无动画动画
    kInitAnimationType,//初始化动画
    kStarAnimationType,//开始动画
    kEndTransitionAnimationType,//停止过渡过程
    kEndAnimationType,//停止
};

typedef NS_ENUM(NSUInteger, ZAnimationDrawButtonType) {
    kNormalType,//默认状态
    kSelectedType,//长按选中状态
    kDoneType,//点击状态
};

@protocol ZVoiceDelegate <NSObject>

- (void)z_begin;
- (void)z_stop;

@end

@interface ZJVoiceAnimationView : UIView


@property (nonatomic,weak) id<ZVoiceDelegate> delegate;
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
