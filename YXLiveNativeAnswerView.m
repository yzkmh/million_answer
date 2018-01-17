//
//  YXLiveNativeAnswerView.m
//  YXLiveKit
//
//  Created by yangzhaokun on 2018/1/13.
//  Copyright © 2018年 YIXIA. All rights reserved.
//

#import "YXLiveNativeAnswerView.h"

#define kXLiveNativeAnswerNum 3

@interface YXLiveNativeAnswerView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *questionNumView;
@property (nonatomic, strong) UILabel *watchModeLabel;
@property (nonatomic, strong) UIView *topLottieView;
@property (nonatomic, strong) UIView *topImageView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *questionLable;
@property (nonatomic, strong) NSMutableArray *answerBtnArray;

@end

@implementation YXLiveNativeAnswerView



- (void)setupUI
{
    _contentView = [[UIView alloc]initWithFrame:self.bounds];
    _contentView.layer.masksToBounds = YES;
    _contentView.layer.cornerRadius = 8.f;
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
    _questionNumView = [[UIView alloc]initWithFrame:CGRectMake(14, 15, 40, 18)];
    _questionNumView.layer.masksToBounds = YES;
    _questionNumView.layer.borderWidth = 1;
    _questionNumView.layer.borderColor = [UIColor yxt_colorWithHex:@"DDDDDD"].CGColor;
    [_contentView addSubview:_questionNumView];
    
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
    
    _topLottieView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_contentView.frame)/2 - 27.5, 34, 55, 55)];
    [_contentView addSubview:_topLottieView];
    _topLottieView.hidden = YES;
    
    _topImageView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_contentView.frame)/2 - 63.5, 32, 127, 60)];
    [_contentView addSubview:_topImageView];
    _topImageView.hidden = YES;
    
    _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, CGRectGetWidth(_contentView.frame), 36)];
    [_topLabel setFont:[UIFont boldSystemFontOfSize:25]];
    [_contentView addSubview:_topLabel];
    _topLabel.textColor = [UIColor blackColor];
    _topLabel.text = @"公布答案";
    _topLabel.hidden = YES;
    [_contentView addSubview:_topLabel];
    
    _questionLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, CGRectGetWidth(_contentView.frame), 56)];
    _questionLable.font = [UIFont boldSystemFontOfSize:20];
    _questionLable.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_questionLable];
    
    CGFloat offsetY = 228.f;
    _answerBtnArray = [[NSMutableArray alloc]initWithCapacity:kXLiveNativeAnswerNum];
    
    for (int i = 0; i < kXLiveNativeAnswerNum; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, offsetY, CGRectGetWidth(_contentView.frame), 44)];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 22.f;
        button.layer.borderColor = [UIColor yxt_colorWithHex:@"DDDDDD"].CGColor;
        button.tag = i;
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
        [_answerBtnArray addObject:button];
        offsetY += 44 + 10;
    }
}


- (void)setModel:(YXLiveMillionModel *)model isWatch:(BOOL)watch andType:(YXLiveAnswerViewType)type
{
    [self showOrHideWithType:type andWatch:watch];
    
}

- (void)showOrHideWithType:(YXLiveAnswerViewType)type andWatch:(BOOL)watch
{
    if (watch && type == YXLiveAnswerViewTypeAnswer) {
        _watchModeLabel.hidden = NO;
        _topLottieView.hidden = NO;
        _topImageView.hidden = YES;
        _topLabel.hidden = YES;
    }else if (watch && type == YXLiveAnswerViewTypeResult){
        _watchModeLabel.hidden = NO;
        _topLabel.hidden = NO;
        _topLottieView.hidden = YES;
        _topImageView.hidden = YES;
    }else if (!watch && type == YXLiveAnswerViewTypeAnswer){
        _watchModeLabel.hidden = YES;
        _topLottieView.hidden = NO;
        _topImageView.hidden = YES;
        _topLabel.hidden = YES;
    }else if (!watch && type == YXLiveAnswerViewTypeResult){
        _watchModeLabel.hidden = YES;
        _topLabel.hidden = YES;
        _topLottieView.hidden = YES;
        _topImageView.hidden = NO;
    }
}



- (void)btnAction:(UIButton *)button
{
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
