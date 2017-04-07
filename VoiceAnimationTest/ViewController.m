//
//  ViewController.m
//  VoiceAnimationTest
//
//  Created by LYY on 2017/4/7.
//  Copyright © 2017年 iflytek. All rights reserved.
//

#import "ViewController.h"
#import "ZJVoiceAnimationView.h"

@interface ViewController ()
@property (nonatomic,strong)ZJVoiceAnimationView *zjAnimation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.zjAnimation];

    [self.zjAnimation startAnimation];
}
- (IBAction)randomClick:(UIButton *)sender {
    
    NSLog(@"%ld",[self random] + 18);
    
    [self.zjAnimation updateAnimationMaxHeightTo:[self random] + 18];
}
- (IBAction)stopAnimation:(UIButton *)sender {
    [self.zjAnimation stopAnimation];
}
- (IBAction)playAnimation:(UIButton *)sender {
    [self.zjAnimation startAnimation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (ZJVoiceAnimationView *)zjAnimation {
    if (!_zjAnimation) {
        _zjAnimation = [[ZJVoiceAnimationView alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 100)];
    }
    
    return _zjAnimation;
    
}

- (NSInteger)random {
    int x = arc4random() % 60;
    return x;
}



@end
