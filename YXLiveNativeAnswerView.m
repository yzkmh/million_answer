//
//  YXLiveNativeAnswerView.m
//  YXLiveKit
//
//  Created by yangzhaokun on 2018/1/13.
//  Copyright © 2018年 YIXIA. All rights reserved.
//

#import "YXLiveNativeAnswerView.h"
#import "UIColor+YXTColor.h"
#import "YXLiveMillionAnswerButton.h"
//#import "LOTAnimationView.h"
#import <Lottie/LOTAnimationView.h>
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>
#import "YXLiveTimerNew.h"

#define kXLiveNativeAnswerNum 4

@interface YXLiveNativeAnswerView ()<CAAnimationDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *questionNumView;
@property (nonatomic, strong) UILabel *watchModeLabel;
@property (nonatomic, strong) UILabel *outTostView;
@property (nonatomic, strong) LOTAnimationView *topLottieView;
@property (nonatomic, strong) UIImageView *topImageView;
//@property (nonatomic, strong) LOTAnimationView *topRightView;
//@property (nonatomic, strong) LOTAnimationView *topWrongView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *questionLable;
@property (nonatomic, strong) NSMutableArray *answerBtnArray;
@property (nonatomic, strong) YXLiveMillionModel *model;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) BOOL answerSelected;
@property (nonatomic, assign) NSInteger currentSelected;
@property (nonatomic, assign) NSUInteger validCount;
@property (nonatomic, strong) YXLiveTimerNew *timer;

@end

@implementation YXLiveNativeAnswerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI
{
    _contentView = [[UIView alloc]initWithFrame:self.bounds];
    _contentView.layer.masksToBounds = YES;
    _contentView.layer.cornerRadius = 8.f;
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
    _questionNumView = [[UILabel alloc]initWithFrame:CGRectMake(14, 15, 40, 18)];
    _questionNumView.layer.masksToBounds = YES;
    _questionNumView.layer.cornerRadius = 9;
    _questionNumView.layer.borderWidth = 1;
    _questionNumView.layer.borderColor =  [UIColor yxt_colorWithHex:@"DDDDDD"].CGColor;
    _questionNumView.textAlignment = NSTextAlignmentCenter;
    _questionNumView.font = [UIFont systemFontOfSize:12];
    [_contentView addSubview:_questionNumView];
    
    _outTostView = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_contentView.frame)/2 - 45, 43, 90, 38)];
    _outTostView.layer.masksToBounds = YES;
    _outTostView.layer.cornerRadius = 19.f;
    _outTostView.text = @"已出局";
    _outTostView.backgroundColor = [UIColor yxt_colorWithHex:@"FF91B8"];
    _outTostView.font = [UIFont systemFontOfSize:16];
    _outTostView.textColor = [UIColor whiteColor];
    _outTostView.textAlignment = NSTextAlignmentCenter;
    _outTostView.hidden = YES;
    [self addSubview:_outTostView];
    
    _watchModeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_contentView.frame)-79, 10, 68, 26)];
    _watchModeLabel.backgroundColor = [UIColor yxt_colorWithHex:@"FFD6E5"];
    _watchModeLabel.layer.masksToBounds = YES;
    _watchModeLabel.layer.cornerRadius = 13.f;
    _watchModeLabel.textColor = [UIColor yxt_colorWithHex:@"FF347C"];
    _watchModeLabel.font = [UIFont systemFontOfSize:12];
    _watchModeLabel.text = @"观战模式";
    _watchModeLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_watchModeLabel];
    _watchModeLabel.hidden = YES;
    
    
//    _topLottieView = [[LOTAnimationView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_contentView.frame)/2 - 27.5, 34, 55, 55)];
    _topLottieView = [LOTAnimationView animationNamed:@"million_djs.json"];
    [_topLottieView setFrame:CGRectMake(CGRectGetWidth(_contentView.frame)/2 - 27.5, 34, 55, 55)];
    [_contentView addSubview:_topLottieView];
    _topLottieView.hidden = YES;
    
//    _topRightView = [LOTAnimationView animationNamed:@"million_right.json"];
//    _topRightView.frame = CGRectMake(CGRectGetWidth(_contentView.frame)/2 - 63.5, 32, 127, 60);
//    _topRightView.hidden = YES;
//    [_contentView addSubview:_topRightView];
//
//    _topWrongView = [LOTAnimationView animationNamed:@"million_wrong.json"];
//    _topWrongView.frame = CGRectMake(CGRectGetWidth(_contentView.frame)/2 - 63.5, 32, 127, 60);
//    _topWrongView.hidden = YES;
//    [_contentView addSubview:_topWrongView];
//
//
    _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_contentView.frame)/2 - 63.5, 32, 127, 60)];
    [_contentView addSubview:_topImageView];
    _topImageView.hidden = YES;
    
    _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, CGRectGetWidth(_contentView.frame), 36)];
    [_topLabel setFont:[UIFont boldSystemFontOfSize:25]];
    [_contentView addSubview:_topLabel];
    _topLabel.textColor = [UIColor blackColor];
    _topLabel.text = @"公布答案";
    _topLabel.textAlignment = NSTextAlignmentCenter;
    _topLabel.hidden = YES;
    [_contentView addSubview:_topLabel];
    
    _questionLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 110, CGRectGetWidth(_contentView.frame) - 40, 60) ];
    _questionLable.font = [UIFont boldSystemFontOfSize:20];
    _questionLable.textAlignment = NSTextAlignmentCenter;
    _questionLable.numberOfLines = 0;
    [_contentView addSubview:_questionLable];
    
    CGFloat offsetY = 228.f;
    _answerBtnArray = [[NSMutableArray alloc]initWithCapacity:kXLiveNativeAnswerNum];
    
    for (int i = 0; i < kXLiveNativeAnswerNum; i++) {
        YXLiveMillionAnswerButton *button = [YXLiveMillionAnswerButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(30, offsetY, CGRectGetWidth(_contentView.frame) - 60, 44);
        button.tag = i;
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
        [_answerBtnArray addObject:button];
        offsetY += 44 + 10;
    }
    _validCount = kXLiveNativeAnswerNum;
    [self reset];
}
- (void)resetFrame
{
    
    CGSize infoSize = CGSizeMake(_questionLable.frame.size.width, MAXFLOAT);
    
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:20.f ]};
    
    CGRect newFrame =  [_model.topicString boundingRectWithSize:infoSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect labelFrame = _questionLable.frame;
    labelFrame.size.height = newFrame.size.height;
    [_questionLable setFrame:labelFrame];
    
    CGFloat offsetY = 140 + newFrame.size.height;
    
    for (int i = 0; i < _validCount; i++) {
        UIButton *button = [_answerBtnArray objectAtIndex:i];
        button.frame = CGRectMake(30, offsetY, CGRectGetWidth(_contentView.frame) - 60, 44);
        offsetY += 44 + 10;
    }
    offsetY += 20;
    CGRect frame = self.frame;
    frame.size.height = offsetY;
    self.frame = frame;
    self.contentView.frame = self.bounds;
}

- (void)setModel:(YXLiveMillionModel *)model
{
    _model = model;
    _validCount = model.answersStr.count;
    [self reset];
    [self setModel:model andWatch:model.watchMode andType:model.type];
}

- (void)reset
{
    _currentSelected = - 1;
    [_topLottieView stop];
    [_timer invalidate];
    [self resetUI];
    [self resetBtn];
    [self resetFrame];
}

- (void)resetBtn
{
    for (YXLiveMillionAnswerButton *button in _answerBtnArray) {
        if (button.tag == _currentSelected) {
            button.backgroundColor = [UIColor yxt_colorWithHex:@"FF347C"];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            button.backgroundColor = [UIColor clearColor];
            [button setTitleColor:[UIColor yxt_colorWithHex:@"DDDDDD"] forState:UIControlStateNormal];
        }
        button.userInteractionEnabled = _currentSelected >= 0 ? NO : YES;
        
        if (button.tag < _validCount) {
            button.hidden = NO;
        }else{
            button.hidden = YES;
        }
    }
}

- (void)resetUI
{
    self.outTostView.hidden = YES;
    for (YXLiveMillionAnswerButton *button in _answerBtnArray) {
        [button resetButton];
    }
}


- (void)setModel:(YXLiveMillionModel *)model andWatch:(BOOL)watch andType:(YXLiveMillionModelType)type
{
    self.questionNumView.text = [NSString stringWithFormat:@"%ld/%ld",(unsigned long)model.count,(unsigned long)model.totalCount];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.questionNumView.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,[NSString stringWithFormat:@"%ld",(unsigned long)model.count].length)];
    self.questionNumView.attributedText = str;
    self.questionLable.text = model.topicString;
    [self showOrHideWithType:type andWatch:watch];
    
    BOOL isResultMode = (type == YXLiveMillionModelTypeResult);
    float totalNum = 0.0;
    if (isResultMode) {
        for (int i = 0; i < model.answersNum.count; i++) {
            NSNumber *number = [model.answersNum objectAtIndex:i];
            totalNum += [number intValue];
        }
    }
    
    if (watch && type == YXLiveMillionModelTypeAnswer) {
        
        for (int i = 0 ; i < _validCount; i++) {
            YXLiveMillionAnswerButton *button = [_answerBtnArray objectAtIndex:i];
            NSString *answerStr = [model.answersStr objectAtIndex:i];
            [button setTitle:answerStr forState:UIControlStateNormal];
            [button setTitleColor:[UIColor yxt_colorWithHex:@"999999"] forState:UIControlStateNormal];
            button.userInteractionEnabled = YES;
            button.numLabel.hidden = YES;
        }
        [self.topLottieView stop];
        kWeakSelf(self);
        [self.topLottieView playFromProgress:0 toProgress:1 withCompletion:^(BOOL animationFinished) {
            if (animationFinished) {
                [weakself dismissWithAnimation:YES];
            }
        }];
        [self playNamed:@"million_init" withType:@"wav"];
        _timer = [YXLiveTimerNew timerWithTimeInterval:5.8 target:self selector:@selector(playCountdownMusic) repeats:NO];
        [_timer fire];
        
    }else if (watch && type == YXLiveMillionModelTypeResult){
        
        for (int i = 0 ; i < _validCount; i++) {
            YXLiveMillionAnswerButton *button = [_answerBtnArray objectAtIndex:i];
            NSString *answerStr = [model.answersStr objectAtIndex:i];
            [button setTitle:answerStr forState:UIControlStateNormal];
            [button setTitleColor:[UIColor yxt_colorWithHex:@"333333"] forState:UIControlStateNormal];
            
            NSNumber *num = [model.answersNum objectAtIndex:i];
            
            if (i == model.rightAnswer) {
                button.progressColor = [UIColor yxt_colorWithHex:@"00DF75"];
            }else{
                button.progressColor = [UIColor yxt_colorWithHex:@"DDDDDD"];
            }
            [button setNum:[num integerValue] andProgress:[num integerValue]/totalNum];
            button.userInteractionEnabled = NO;
            button.numLabel.hidden = NO;
        }
        
        _timer = [YXLiveTimerNew timerWithTimeInterval:6 target:self selector:@selector(dismissResultView) repeats:NO];
        [_timer fire];
        
    }else if (!watch && type == YXLiveMillionModelTypeAnswer){
        
        for (int i = 0 ; i < _validCount; i++) {
            YXLiveMillionAnswerButton *button = [_answerBtnArray objectAtIndex:i];
            NSString *answerStr = [model.answersStr objectAtIndex:i];
            [button setTitle:answerStr forState:UIControlStateNormal];
            [button setTitleColor:[UIColor yxt_colorWithHex:@"333333"] forState:UIControlStateNormal];
            button.userInteractionEnabled = YES;
            button.numLabel.hidden = YES;
        }
        [self.topLottieView stop];
        kWeakSelf(self);
        [self.topLottieView playFromProgress:0 toProgress:1 withCompletion:^(BOOL animationFinished) {
            if (animationFinished) {
                [weakself dismissWithAnimation:YES];
            }
        }];
        [self playNamed:@"million_init" withType:@"wav"];
        _timer = [YXLiveTimerNew timerWithTimeInterval:5.8 target:self selector:@selector(playCountdownMusic) repeats:NO];
        [_timer fire];
        
    }else if (!watch && type == YXLiveMillionModelTypeResult){
        
        for (int i = 0 ; i < _validCount; i++) {
            YXLiveMillionAnswerButton *button = [_answerBtnArray objectAtIndex:i];
            NSString *answerStr = [model.answersStr objectAtIndex:i];
            [button setTitle:answerStr forState:UIControlStateNormal];
            [button setTitleColor:[UIColor yxt_colorWithHex:@"333333"] forState:UIControlStateNormal];
            
            NSNumber *num = [model.answersNum objectAtIndex:i];
            
            if (i == model.rightAnswer) {
                button.progressColor = [UIColor yxt_colorWithHex:@"00DF75"];
            }else if(i == model.mineAnswer){
                button.progressColor = [UIColor yxt_colorWithHex:@"FF91B8"];
            }else{
                button.progressColor = [UIColor yxt_colorWithHex:@"DDDDDD"];
            }
            [button setNum:[num integerValue] andProgress:[num integerValue]/totalNum];
            button.userInteractionEnabled = NO;
            button.numLabel.hidden = NO;
        }
        BOOL result = model.mineAnswer == model.rightAnswer;
        if (result) {
            [self.topImageView setImage:[UIImage imageNamed:@"million_answer_right"]];
            [self playNamed:@"million_right" withType:@"mp3"];
        }else{
            [self.topImageView setImage:[UIImage imageNamed:@"million_answer_wrong"]];
            [self playNamed:@"million_wrong" withType:@"mp3"];
        }
        _timer = [YXLiveTimerNew timerWithTimeInterval:6 target:self selector:@selector(dismissResultView) repeats:NO];
        [_timer fire];
    }
}

- (void)showOrHideWithType:(YXLiveMillionModelType)type andWatch:(BOOL)watch
{
    if (watch && type == YXLiveMillionModelTypeAnswer) {
        _watchModeLabel.hidden = NO;
        _topLottieView.hidden = NO;
        _topImageView.hidden = YES;
        _topLabel.hidden = YES;
        
    }else if (watch && type == YXLiveMillionModelTypeResult){
        _watchModeLabel.hidden = NO;
        _topLabel.hidden = NO;
        _topLottieView.hidden = YES;
        _topImageView.hidden = YES;

    }else if (!watch && type == YXLiveMillionModelTypeAnswer){
        _watchModeLabel.hidden = YES;
        _topLottieView.hidden = NO;
        _topImageView.hidden = YES;
        _topLabel.hidden = YES;
    }else if (!watch && type == YXLiveMillionModelTypeResult){
        _watchModeLabel.hidden = YES;
        _topLabel.hidden = YES;
        _topLottieView.hidden = YES;
        _topImageView.hidden = NO;
    }
}

- (void)showInView:(UIView *)view withAnimation:(BOOL)animation
{
    if (view && !self.superview) {
        [view addSubview:self];
    }else if ([self.superview isEqual:view]){
        
    }
    if (animation) {
        [self showAnimation];
    }
}

- (void)showAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 动画选项的设定
    animation.duration = 0.3; // 持续时间
    animation.repeatCount = 1; // 重复次数
    
    CGPoint center = self.layer.position;
    center.y = -center.y;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:center]; // 起始帧
    animation.toValue = [NSValue valueWithCGPoint:self.layer.position]; // 终了帧
    
    // 添加动画
    [self.layer addAnimation:animation forKey:@"show-layer"];
}

- (void)dismissResultView
{
    [self dismissWithAnimation:YES];
}

- (void)dismissWithAnimation:(BOOL)animation
{
    if (animation && self.superview) {
        [self hideAnimation];
    }
}

- (void)hideAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 动画选项的设定
    animation.duration = 0.3; // 持续时间
    animation.repeatCount = 1; // 重复次数
    
    
    CGPoint center = self.layer.position;
    center.y = -center.y;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:self.layer.position]; // 起始帧
    animation.toValue = [NSValue valueWithCGPoint:center]; // 终了帧
    animation.delegate = self;
    // 添加动画
    [self.layer addAnimation:animation forKey:@"hide-layer"];
}

/* Called when the animation begins its active duration. */

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[self.layer animationForKey:@"hide-layer"] isEqual:anim]) {
        [self removeFromSuperview];
    }
}

- (void)btnAction:(UIButton *)button
{
    if (self.model.watchMode) {
        [self shakeAnimationForView:self.outTostView];
        [self playNamed:@"million_invalid" withType:@"mp3"];
        return;
    }
    _currentSelected = button.tag;
    [self resetBtn];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectAtIndex:andTitle:)]) {
        [_delegate didSelectAtIndex:button.tag andTitle:button.titleLabel.text];
    }
}

- (void)playNamed:(NSString *)name withType:(NSString *)type
{
    if (!name || !type) {
        return;
    }
    NSURL *fileURL = [[NSBundle mainBundle]URLForResource:name withExtension:@"m4a"];
    // 2.创建 AVAudioPlayer 对象
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    // 5.开始播放
    [self.audioPlayer play];
}

#pragma mark private

- (void)playCountdownMusic
{
    [self playNamed:@"million_countdown" withType:@"mp3"];
}

/**
 *  抖动效果
 *
 *  @param view 要抖动的view
 */
- (void)shakeAnimationForView:(UIView *) view {
    view.hidden = NO;
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint x = CGPointMake(position.x + 3, position.y);
    CGPoint y = CGPointMake(position.x - 3, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:.06];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

