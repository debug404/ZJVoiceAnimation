//
//  ZJVoiceAnimationView.m
//  VoiceAnimationTest
//
//  Created by LYY on 2017/4/7.
//  Copyright © 2017年 iflytek. All rights reserved.
//

#import "ZJVoiceAnimationView.h"

@interface ZJVoiceAnimationView () {
    CGFloat _percent;
}
@property (nonatomic,assign)AnimationDrawType animationType;
@property (nonatomic,assign)NSInteger pointNumber;
@property (nonatomic,assign)CGFloat margin;
@property (nonatomic,assign)CGFloat radius;


@property (nonatomic, assign)NSInteger maxLineHeight;
@property (nonatomic, strong)CADisplayLink *animationDisplayLink;
@property (nonatomic, assign)NSInteger timeCount;
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
    self.maxLineHeight = 18;
    self.timeCount = 0;
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
    self.animationType = kEndTransitionAnimationType;
    _timeCount = 0;
    [self setNeedsDisplay];
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
    
    CGContextSetRGBFillColor(context, 0x22/255.0f, 0xCC/255.0f, 0xCA/255.0f, 1.0f);
    CGContextSetRGBStrokeColor(context, 0x22/255.0f, 0xCC/255.0f, 0xCA/255.0f, 1.0f);
    
    CGContextSetLineWidth(context, 2.0f);

    CGRect frame = self.frame;
    CGPoint center = CGPointMake(frame.size.width * 0.5f, frame.size.height * 0.5f);
    NSInteger centerNumber = self.pointNumber / 2;
    switch (_animationType) {
        case kInitAnimationType:
        {
            
            
            for (int i = 0; i < self.pointNumber ; i++) {
                
                if (i > ( labs(centerNumber - _timeCount)) && i < (2 *centerNumber - (labs(centerNumber - _timeCount)))) {
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
                CGFloat x = i * (CGRectGetWidth(self.frame) / self.pointNumber);
                CGContextFillRect(context, CGRectMake(x, center.y - [self random]/2, 2.5, [self random]));
                CGContextStrokePath(context);
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
                
                if (i > (centerNumber - labs(centerNumber - _timeCount)) && i < (2 *centerNumber - (centerNumber - labs(centerNumber - _timeCount)))) {
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
    self.maxLineHeight = toHeight;
}

- (NSInteger)random {
    int x = arc4random() % 2 ;
    return 4;
}

- (NSInteger)pointNumber {
    if (_pointNumber == 0) {
        _pointNumber = 30;
    }
    return _pointNumber;
}


@end
