//
//  YXLiveMillionAnswerButton.h
//  YXLiveKit
//
//  Created by yangzhaokun on 2018/1/13.
//  Copyright © 2018年 YIXIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLiveMillionAnswerButton : UIButton
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic ,strong) UILabel *numLabel;

- (void)setNum:(NSInteger)num andProgress:(CGFloat)progress;
- (void)resetButton;



@end
