//
//  YXLiveTimerNew.h
//  YXFoundation
//
//  Created by Jasper on 17/6/26.
//  Copyright © 2017年 YIXIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXLiveTimerNew : NSObject

@property (nonatomic, readonly) NSTimeInterval interval;
@property (nonatomic, readonly, getter=isValid) BOOL valid;

+ (YXLiveTimerNew *)timerWithTimeInterval:(NSTimeInterval)interval
                                   target:(id)target
                                 selector:(SEL)selector
                                  repeats:(BOOL)repeats;

+ (YXLiveTimerNew *)timerWithTimeInterval:(NSTimeInterval)interval
                                   target:(id)target
                                 selector:(SEL)selector
                                maxRepeat:(NSInteger)count;

- (void)invalidate;
- (void)fire;

@end
