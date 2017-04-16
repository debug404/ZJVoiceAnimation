//
//  ZVoiceAnimationView.m
//  Medicare
//
//  Created by LYY on 2017/4/10.
//  Copyright © 2017年 medicare. All rights reserved.
//

#import "ZJVoiceAnimationView.h"
//#import "POP.h"

static const CGFloat VOICEBUTTON_WIDTH = 80;
#define kScreenHeight CGRectGetHeight([[UIScreen mainScreen] bounds])
#define kScreenWidth  CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SYS_FONT(x) [UIFont systemFontOfSize:x]  //抽取一个系统字号
#define RGBNUM(r,g,b) [UIColor colorWithRed:r green:g blue:b alpha:1]
#define IMAGE(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]// 图片加载
//static const CGFloat VOICEANIMATION_HEIGHT;
static const CGFloat VOICEANIMATION_MARGIN_BOTTOM = 15;
#define BOTTOM_LABEL_INIT_TEXT  @"点击或长按即可语音录入"
#define BOTTOM_LABEL_LOSE_TEXT  @"松开按钮结束录音"
#define BOTTOM_LABEL_DONE_TEXT  @"点击完成结束录音"
@interface ZJVoiceAnimationView () {
    CGFloat VOICEANIMATION_HEIGHT;
    CGFloat VOICEREMINDLABEL_FONT;
}
@property (nonatomic,assign)ZAnimationDrawType animationType;
@property (nonatomic,assign)NSInteger pointNumber;
@property (nonatomic,assign)CGFloat margin;
@property (nonatomic,assign)CGFloat radius;


@property (nonatomic, assign)NSInteger maxLineHeight;
@property (nonatomic, strong)CADisplayLink *animationDisplayLink;
@property (nonatomic, assign)NSInteger timeCount;


@property (nonatomic, strong)UIButton *voiceButton;
@property (nonatomic, strong)UILongPressGestureRecognizer *longPress;

@property (nonatomic, strong)UILabel *remindLabel;
@end
@implementation ZJVoiceAnimationView
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setup];
    }
    return self;
}

- (void)setup {
    VOICEANIMATION_HEIGHT = 24;
    VOICEREMINDLABEL_FONT = 15;
    self.maxLineHeight = VOICEANIMATION_HEIGHT;
    self.timeCount = 0;
    self.animationType = kNoneAnimationType;
    [self addSubview:self.voiceButton];
    [self addSubview:self.remindLabel];
}

- (void)changeStateToNone {
    self.animationType = kNoneAnimationType;
}

- (void)startAnimation {
    _timeCount = 0;
    self.animationType = kInitAnimationType;
    if (_animationDisplayLink) {
        [_animationDisplayLink invalidate];
    }
    _animationDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationDisplay)];
    _animationDisplayLink.paused = NO;
    _animationDisplayLink.frameInterval = 3;
    [_animationDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [self setNeedsDisplay];
    
    
}

- (void)stopAnimation {
    if (self.animationType != kNoneAnimationType) {
        self.animationType = kEndTransitionAnimationType;
        _timeCount = 0;
        [self setNeedsDisplay];
        self.voiceButton.selected = NO;
    }
}

- (void)animationDisplay {
    _timeCount ++;
    if (_timeCount  >  self.pointNumber/2) {
        _timeCount = 1;
    } else {
        
    }
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    [self.backgroundColor set];
    CGContextFillRect(context, rect);
    
    CGContextSetRGBFillColor(context, 0.14f, 0.75f, 0.98, 1.0f);
    CGContextSetRGBStrokeColor(context, 0.14f, 0.75f, 0.98f, 1.0f);
    
    CGContextSetLineWidth(context, 2.0f);
    
    
    CGPoint center = self.voiceButton.center;
    NSInteger centerNumber = self.pointNumber / 2;
    switch (_animationType) {
        case kNoneAnimationType: {
            
        }
            break;
            
        case kInitAnimationType:
        {
            
            
            for (int i = 0; i < self.pointNumber ; i++) {
                
                if (i > ( labs(centerNumber - _timeCount)) && i < (2 *centerNumber - (labs(centerNumber - _timeCount))) && [self isNotContainPoint:i] ) {
                    CGFloat x = i * (CGRectGetWidth(self.frame) / self.pointNumber);
                    CGContextFillRect(context, CGRectMake(x, center.y - [self random]/2, 2.5, [self random]));
                    CGContextStrokePath(context);
                }
            }
            
            int num = 2;
            for (int i = 0; i< 1; i++) {
                NSInteger leftNumber = labs(centerNumber - _timeCount);
                CGFloat x = (leftNumber + i) * (CGRectGetWidth(self.frame) / self.pointNumber);
                
                int contexHeight = 20;
                CGContextFillRect(context, CGRectMake(x, center.y - contexHeight/2, 2.5, contexHeight));
                CGContextStrokePath(context);
                
                NSInteger rightNumber = 2 *centerNumber - leftNumber;
                CGFloat rx = (rightNumber + i) * (CGRectGetWidth(self.frame) / self.pointNumber);
                CGContextFillRect(context, CGRectMake(rx, center.y - contexHeight/2, 2.5, contexHeight));
                CGContextStrokePath(context);
                
                num --;
            }
            if (_timeCount == self.pointNumber/2) {
                self.animationType = kStarAnimationType;
            }
            
            
        }
            break;
        case kStarAnimationType:
        {
            for (int i = 0; i < self.pointNumber ; i++) {
                
                if ([self isNotContainPoint:i]) {
                    CGFloat x = i * (CGRectGetWidth(self.frame) / self.pointNumber);
                    CGContextFillRect(context, CGRectMake(x, center.y - [self random]/2, 2.5, [self random]));
                    CGContextStrokePath(context);
                }
                
            }
            
            int num = 4;
            for (int i = -2; i< 3; i++) {
                NSInteger leftNumber = labs(centerNumber - _timeCount);
                CGFloat x = (leftNumber + i) * (CGRectGetWidth(self.frame) / self.pointNumber);
                
                //y = |cosx|  double cos(double a)
                double maxPercent = fabs(cos(M_PI_2 - M_PI_4* num));
                if (maxPercent - 0.00001 <= 0.0) {
                    maxPercent = 0.3;
                }
                int contexHeight = maxPercent * self.maxLineHeight + [self random];
                CGContextFillRect(context, CGRectMake(x, center.y - contexHeight/2, 2.5, contexHeight));
                CGContextStrokePath(context);
                
                NSInteger rightNumber = 2 *centerNumber - leftNumber;
                CGFloat rx = (rightNumber + i) * (CGRectGetWidth(self.frame) / self.pointNumber);
                CGContextFillRect(context, CGRectMake(rx, center.y - contexHeight/2, 2.5, contexHeight));
                CGContextStrokePath(context);
                
                num --;
            }
            
        }
            break;
        case kEndTransitionAnimationType:
        {
            
            
            for (int i = 0; i < self.pointNumber ; i++) {
                
                if (i > (centerNumber - labs(centerNumber - _timeCount)) && i < (2 *centerNumber - (centerNumber - labs(centerNumber - _timeCount))) && [self isNotContainPoint:i] ) {
                    CGFloat x = i * (CGRectGetWidth(self.frame) / self.pointNumber);
                    CGContextFillRect(context, CGRectMake(x, center.y - [self random]/2, 2.5, [self random]));
                    CGContextStrokePath(context);
                }
            }
            
            int num = 2;
            for (int i = 0; i< 1; i++) {
                NSInteger leftNumber =centerNumber - labs(centerNumber - _timeCount);
                CGFloat x = (leftNumber + i) * (CGRectGetWidth(self.frame) / self.pointNumber);
                
                int contexHeight = 20;
                CGContextFillRect(context, CGRectMake(x, center.y - contexHeight/2, 2.5, contexHeight));
                CGContextStrokePath(context);
                
                NSInteger rightNumber = 2 *centerNumber - leftNumber;
                CGFloat rx = (rightNumber + i) * (CGRectGetWidth(self.frame) / self.pointNumber);
                CGContextFillRect(context, CGRectMake(rx, center.y - contexHeight/2, 2.5, contexHeight));
                CGContextStrokePath(context);
                
                num --;
            }
            if (_timeCount == self.pointNumber/2) {
                self.animationType = kEndAnimationType;
            }
            
        }
            break;
            
        case kEndAnimationType: {
            [_animationDisplayLink invalidate];
            
        }
            break;
            
    }
    
}

- (void)updateAnimationMaxHeightTo:(NSInteger)toHeight {
    toHeight = toHeight * 3;
    NSLog(@"音量   ---   %ld",(long)toHeight);
    if (toHeight < VOICEANIMATION_HEIGHT) {
        toHeight = VOICEANIMATION_HEIGHT;
    }
    self.maxLineHeight = VOICEANIMATION_HEIGHT + (toHeight - VOICEANIMATION_HEIGHT) * 2;
}

- (NSInteger)random {
    return 4;
}

- (NSInteger)pointNumber {
    if (_pointNumber == 0) {
        _pointNumber = 30;
    }
    return _pointNumber;
}

#pragma -mark 按钮事件


- (void)voiceClick:(UIButton *)sender {
    self.animationType = kInitAnimationType;
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.remindLabel.text = BOTTOM_LABEL_DONE_TEXT;
        [self begin];
    } else {
        [self stop];
    }
    
}

- (void)buttonLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        [_voiceButton setBackgroundImage:IMAGE(@"voice_selected") forState:UIControlStateNormal];
        [self begin];
        self.remindLabel.text = BOTTOM_LABEL_LOSE_TEXT;
    }
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        [self stop];
        [_voiceButton setBackgroundImage:IMAGE(@"voice_normal") forState:UIControlStateNormal];
        self.remindLabel.text = BOTTOM_LABEL_INIT_TEXT;
    }
}

- (void)begin {
//    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animation];
//    scaleAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];//宽高改变
//    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.1, 1.1)];//放大
//    [self.voiceButton pop_addAnimation:scaleAnimation forKey:@"scaleAnimationKey"];//执行动画
//    scaleAnimation.completionBlock = ^(POPAnimation *animation,BOOL finish) { //动画回调
//        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animation];
//        scaleAnimation.springBounciness = 16;
//        scaleAnimation.springSpeed = 14;
//        scaleAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
//        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
//        [self.voiceButton pop_addAnimation:scaleAnimation forKey:@"scaleAnimationKey"];
//    };
    
    if ([self.delegate respondsToSelector:@selector(z_begin)]) {
        [self.delegate z_begin];
    }
    _timeCount = 0;
    self.animationType = kInitAnimationType;
    if (_animationDisplayLink) {
        [_animationDisplayLink invalidate];
    }
    _animationDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationDisplay)];
    _animationDisplayLink.paused = NO;
    _animationDisplayLink.frameInterval = 3;
    [_animationDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self setNeedsDisplay];
}

- (void)stop {
    self.remindLabel.text = BOTTOM_LABEL_INIT_TEXT;
//    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animation];
//    scaleAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];//宽高
//    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.85, 0.85)];//缩放
//    [self.voiceButton pop_addAnimation:scaleAnimation forKey:@"scaleAnimationKey"];//执行动画
//    scaleAnimation.completionBlock = ^(POPAnimation *animation,BOOL finish) { //动画回调
//        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animation];
//        scaleAnimation.springBounciness = 16;
//        scaleAnimation.springSpeed = 14;
//        scaleAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
//        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
//        [self.voiceButton pop_addAnimation:scaleAnimation forKey:@"scaleAnimationKey"];
//    };
    
    if ([self.delegate respondsToSelector:@selector(z_stop)]) {
        [self.delegate z_stop];
    }
    self.animationType = kEndTransitionAnimationType;
    _timeCount = 0;
    [self setNeedsDisplay];
}

#pragma -mark 懒加载
- (UIButton *)voiceButton {
    if (!_voiceButton) {
        _voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - VOICEBUTTON_WIDTH/2, CGRectGetHeight(self.frame) - VOICEBUTTON_WIDTH - VOICEANIMATION_MARGIN_BOTTOM, VOICEBUTTON_WIDTH, VOICEBUTTON_WIDTH)];
        [_voiceButton setBackgroundImage:IMAGE(@"voice_normal") forState:UIControlStateNormal];
        [_voiceButton setBackgroundImage:IMAGE(@"voice_selected") forState:UIControlStateHighlighted];
        [_voiceButton setBackgroundImage:IMAGE(@"voice_done") forState:UIControlStateSelected];
        [_voiceButton addTarget:self action:@selector(voiceClick:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceButton addGestureRecognizer:self.longPress];
    }
    return _voiceButton;
}

- (UILongPressGestureRecognizer *)longPress {
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPress:)];
        _longPress.minimumPressDuration = 0.2; //定义按的时间
    }
    return _longPress;
}

- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,  CGRectGetHeight(self.frame) - VOICEBUTTON_WIDTH - VOICEANIMATION_MARGIN_BOTTOM - 22 - 6, kScreenWidth, 22)];
        _remindLabel.text = BOTTOM_LABEL_INIT_TEXT;
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.font = SYS_FONT(VOICEREMINDLABEL_FONT);
        _remindLabel.textColor = RGBNUM(0.4, 0.4, 0.4);
    }
    return _remindLabel;
}

- (BOOL)isNotContainPoint:(NSInteger)point{
    NSArray *points = @[@"11",@"12",@"13",@"15",@"16",@"17",@"18",@"19"];
    return ![points containsObject:[NSString stringWithFormat:@"%ld",(long)point]];
}

@end
