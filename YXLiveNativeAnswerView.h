//
//  YXLiveNativeAnswerView.h
//  YXLiveKit
//
//  Created by yangzhaokun on 2018/1/13.
//  Copyright © 2018年 YIXIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXLiveNativeAlertBaseView.h"
#import "YXLiveMillionModel.h"

typedef NS_ENUM(NSUInteger, YXLiveAnswerViewType) {
    YXLiveAnswerViewTypeAnswer,
    YXLiveAnswerViewTypeResult,
};

@interface YXLiveNativeAnswerView : YXLiveNativeAlertBaseView

- (void)setModel:(YXLiveMillionModel *)model isWatch:(BOOL)watch andType:(YXLiveAnswerViewType)type;

//- (instancetype)initWithType:(YXLiveAnswerViewType)type


@end
