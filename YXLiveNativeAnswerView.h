//
//  YXLiveNativeAnswerView.h
//  YXLiveKit
//
//  Created by yangzhaokun on 2018/1/13.
//  Copyright © 2018年 YIXIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXLiveMillionModel.h"

@protocol YXLiveNativeAnswerViewDelegate <NSObject>
- (void)didSelectAtIndex:(NSUInteger)index andTitle:(NSString *)title;

@end


@interface YXLiveNativeAnswerView : UIView
@property (nonatomic, weak) id<YXLiveNativeAnswerViewDelegate> delegate;

- (void)setModel:(YXLiveMillionModel *)model;

- (void)showInView:(UIView *)view withAnimation:(BOOL)animation;

- (void)dismissWithAnimation:(BOOL)animation;

@end
