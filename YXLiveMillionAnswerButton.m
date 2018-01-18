//
//  YXLiveMillionAnswerButton.m
//  YXLiveKit
//
//  Created by yangzhaokun on 2018/1/13.
//  Copyright © 2018年 YIXIA. All rights reserved.
//

#import "YXLiveMillionAnswerButton.h"
#import "UIColor+YXTColor.h"

@interface YXLiveMillionAnswerButton ()

@property (nonatomic, strong) CAShapeLayer *progressLayer; //进度条
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGFloat animationProgress;
@property (nonatomic, assign) CGFloat progress;
@end

@implementation YXLiveMillionAnswerButton


+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    YXLiveMillionAnswerButton *button = [super buttonWithType:buttonType];
    if (button) {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return button;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
//    // 加载图片
//    UIImage *image = [UIImage imageNamed:@"million_btn_rect"];
//
//    // 设置左边端盖宽度
//    NSInteger leftCapWidth = image.size.width * 0.5;
//    // 设置上边端盖高度
//    NSInteger topCapHeight = image.size.height * 0.5;
//
//    UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
//
//
//    [self setBackgroundImage:newImage forState:UIControlStateNormal];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = frame.size.height/2;
    self.layer.borderColor = [UIColor yxt_colorWithHex:@"DDDDDD"].CGColor;
    self.layer.borderWidth = 0.6f;
//    _progressColor = [UIColor colorWithRed:66/255. green:204/255. blue:118/255. alpha:1];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateUI)];
    self.displayLink.paused = YES;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)updateUI
{
    _animationProgress += 1/60.f;
    if (_animationProgress > _progress) {
        _animationProgress = _progress;
        _displayLink.paused = YES;
    }
    [self setProgress:_animationProgress];
}

- (void)setNum:(NSInteger)num andProgress:(CGFloat)progress
{
    if (progress > 0 && progress < 0.01) {
        progress = 0.01;
    }
    [self addSubview:self.numLabel];
    self.numLabel.hidden = NO;
    [self.numLabel setText:[NSString stringWithFormat:@"%ld",(long)num]];
    
    [self.layer insertSublayer:self.progressLayer atIndex:0];
    
    _animationProgress = 0;
    _progress = progress;
    self.displayLink.paused = NO;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.frame)/2 - 10, CGRectGetWidth(self.frame) - 20, 20)];
        _numLabel.font = [UIFont systemFontOfSize:14];
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.textColor = [UIColor blackColor];
    }
    return _numLabel;
}

- (void)setProgress:(CGFloat)progress
{
    progress = MIN(MAX(progress, 0.0), 1.0);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressLayer.path = [self progressPathWithProgress:progress].CGPath;
    });
}

- (void)resetButton
{
    if (self.progressLayer.superlayer) {
        [self.progressLayer removeFromSuperlayer];
    }
    self.backgroundColor = [UIColor clearColor];
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    if (_progressLayer) {
        _progressLayer.strokeColor = _progressColor.CGColor;
    }
}

/**
 进度条路径
 
 @return 进度条
 */
- (UIBezierPath *)progressPathWithProgress:(CGFloat)progress
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(0, self.frame.size.height/2);
    CGPoint endPoint = CGPointMake(self.frame.size.width*progress, self.frame.size.height/2);
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    return path;
}

- (CAShapeLayer *)progressLayer
{
    if (!_progressLayer) {
        _progressLayer = [self defaultShapeLayer];
        _progressLayer.strokeColor = _progressColor.CGColor;
    }
    return _progressLayer;
}

- (CAShapeLayer *)defaultShapeLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor grayColor].CGColor;
//    layer.lineCap = kCALineCapRound;
//    layer.lineJoin = kCALineJoinRound;
    layer.frame = self.bounds;
    layer.lineWidth = self.frame.size.height;
    return layer;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
