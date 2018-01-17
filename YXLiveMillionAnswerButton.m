//
//  YXLiveMillionAnswerButton.m
//  YXLiveKit
//
//  Created by yangzhaokun on 2018/1/13.
//  Copyright © 2018年 YIXIA. All rights reserved.
//

#import "YXLiveMillionAnswerButton.h"
static CGFloat const kLineWidth = 2.5f;

@interface YXLiveMillionAnswerButton ()
{
    UIColor *_progressColor;
}
@property (nonatomic ,strong) UILabel *numLabel;
@property (nonatomic, strong) CAShapeLayer *progressLayer; //进度条
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation YXLiveMillionAnswerButton


+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    YXLiveMillionAnswerButton *button = [super buttonWithType:buttonType];
    if (button) {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    }
    return button;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self addSubview:self.numLabel];
    self.numLabel.hidden = YES;
}


- (void)setNum:(NSInteger)num andProgress:(CGFloat)progress
{
    self.numLabel.hidden = NO;
    [self.numLabel setText:[NSString stringWithFormat:@"%ld",(long)num]];
    _progressColor = [UIColor colorWithRed:66/255. green:204/255. blue:118/255. alpha:1];
    [self.layer addSublayer:self.progressLayer];
    [UIView animateWithDuration:0.3 animations:^{
        [self setProgress:progress];
    }];
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.frame)/2 - 10, CGRectGetWidth(self.frame) - 20, 20)];
        _numLabel.font = [UIFont systemFontOfSize:14];
        _numLabel.textAlignment = NSTextAlignmentRight;
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

/**
 进度条路径
 
 @return 进度条
 */
- (UIBezierPath *)progressPathWithProgress:(CGFloat)progress
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(self.frame.size.width*progress, 0);
    //    NSLog(@"%f",progress);
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
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.frame = self.bounds;
    layer.lineWidth = kLineWidth;
    return layer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
