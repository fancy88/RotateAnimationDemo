//
//  ViewController.m
//  RotateAnimationDemo
//
//  Created by apple on 2017/7/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"

#define RGB(r,g,b) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0]
#define KSCREENW [[UIScreen mainScreen] bounds].size.width
#define KSCREENH [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()

@property (nonatomic, strong) CAShapeLayer   *aniShapeLayer;
@property (nonatomic, strong) CADisplayLink  *displayLink;
@property (nonatomic, strong) CALayer        *animationImageView;
@property (nonatomic, assign) NSInteger      currentTime;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动画效果";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"动画" style:UIBarButtonItemStylePlain target:self action:@selector(anitionAction)];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated{
    //涂层
    CAShapeLayer *bgShaperLayer = [CAShapeLayer layer];
    bgShaperLayer.strokeColor = RGB(237, 237, 237).CGColor;
    bgShaperLayer.fillColor = [UIColor clearColor].CGColor;
    bgShaperLayer.lineCap = kCALineCapRound;
    bgShaperLayer.lineWidth = 6;
    [self.view.layer addSublayer:bgShaperLayer];
    
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(KSCREENW / 2.0, KSCREENH / 2.0) radius:90 startAngle: -M_PI endAngle: M_PI clockwise:YES];
    bgShaperLayer.path = bgPath.CGPath;
  
}

- (void)anitionAction{
    [self creatAnimatiomView];
}


//创建动画
- (void)creatAnimatiomView{
    self.currentTime = 0;
    if (_aniShapeLayer == nil) {
        UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(KSCREENW / 2.0, KSCREENH / 2.0) radius:90 startAngle: -0.5 * M_PI endAngle:1.5 *M_PI clockwise:YES];
        
        _aniShapeLayer = [CAShapeLayer layer];
        _aniShapeLayer.strokeColor = RGB(48, 158, 92).CGColor;
        _aniShapeLayer.fillColor = [UIColor clearColor].CGColor;
        _aniShapeLayer.lineCap = kCALineCapRound;
        _aniShapeLayer.path = bgPath.CGPath;
        _aniShapeLayer.lineWidth = 6;
        [self.view.layer addSublayer:_aniShapeLayer];
    }
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationStart:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    if (_animationImageView == nil) {
        //中间动画
        _animationImageView = [CALayer layer];
        _animationImageView.bounds = CGRectMake(0, 0, 35, 45);
        _animationImageView.position = CGPointMake(KSCREENW / 2.0, KSCREENH / 2.0);
        _animationImageView.anchorPoint = CGPointMake(0.5, 0.1);
        _animationImageView.contents = (id)[UIImage imageNamed:@"icon_device_lockanimation"].CGImage;
        [self.view.layer addSublayer:_animationImageView];
        _animationImageView.fillMode = kCAFillModeForwards;
        [self setAniShapeLayerTransform];
    }
}

- (void)removeAnimotionLayer{
    [_animationImageView removeFromSuperlayer];
    _animationImageView = nil;
    [_aniShapeLayer removeFromSuperlayer];
    _aniShapeLayer = nil;
    [_displayLink invalidate];
    _displayLink = nil;
    self.currentTime = 0;
}

- (void)animationStart:(CADisplayLink *)link{
    self.currentTime = self.currentTime + 1;
    if (self.currentTime > 3600) {
        self.currentTime = 0;
        [_displayLink invalidate];
        _displayLink = nil;
        [self removeAnimotionLayer];
    }
    [self setAniShapeLayerTransform];
    [self setAimationLayerTransform];
}


- (void)setAimationLayerTransform{
    NSInteger aniTime = 60;
    CGFloat time = (aniTime - self.currentTime % aniTime) / (aniTime * 1.0);
    if (self.currentTime % (aniTime * 2) >= aniTime) {
        time = self.currentTime % aniTime / (aniTime * 1.0);
    }
    CGFloat aniRate = - 0.3 * M_PI + 0.6 * M_PI * time;
    CATransform3D tarns = CATransform3DIdentity;
    _animationImageView.transform = CATransform3DRotate(tarns, aniRate, 0, 0, 1);
}

- (void)setAniShapeLayerTransform{
    CGFloat rate = 1.0 - self.currentTime * 1.0 / (60 * 60);
    self.aniShapeLayer.strokeEnd = rate;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
