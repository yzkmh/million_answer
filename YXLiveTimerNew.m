//
//  YXLiveTimerNew.m
//  YXFoundation
//
//  Created by Jasper on 17/6/26.
//  Copyright © 2017年 YIXIA. All rights reserved.
//

#import "YXLiveTimerNew.h"
#import <CoreGraphics/CoreGraphics.h>

#pragma mark YXLiveTimerManager

@interface YXLiveTimerManager : NSObject {
    NSMutableArray<YXLiveTimerNew *> *_timers_level1; //秒级
    dispatch_source_t _timer_source_level1;
    BOOL _queueIsRunning_level1;
    
    NSMutableArray<YXLiveTimerNew *> *_timers_level2; //0.1秒级
    dispatch_source_t _timer_source_level2;
    BOOL _queueIsRunning_level2;
}

- (NSInteger)findTimerLevel:(YXLiveTimerNew *)timer;

@end

@implementation YXLiveTimerManager

+ (YXLiveTimerManager *)sharedInstance {
    static YXLiveTimerManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YXLiveTimerManager alloc] init];
    });
    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
        if (!_timers_level1) {
            _timers_level1 = [[NSMutableArray alloc] init];
        }
        if (!_timers_level2) {
            _timers_level2 = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSInteger)findTimerLevel:(YXLiveTimerNew *)timer {
    NSNumber *timeNumber = [NSNumber numberWithDouble:timer.interval];
    CGFloat time_float = [timeNumber floatValue];
    NSInteger time_int = [timeNumber integerValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf",time_float]];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    time_float = [[decNumber decimalNumberByRoundingAccordingToBehavior:roundingBehavior] floatValue];
    if (time_float > time_int) {
        return 2;
    } else {
        return 1;
    }
}

- (dispatch_source_t)findTimerSource:(NSInteger)level {
    switch (level) {
        case 1: {
            if (!_timer_source_level1) {
                NSString *queueIdentifier = [NSString stringWithFormat:@"YXLiveGCDTimeQueue_level%ld", level];
                const char *queueName = [queueIdentifier UTF8String];
                dispatch_queue_t queue = dispatch_queue_create(queueName, 0);
                _timer_source_level1 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            }
            return _timer_source_level1;
        }
            break;
            
        case 2: {
            if (!_timer_source_level2) {
                NSString *queueIdentifier = [NSString stringWithFormat:@"YXLiveGCDTimeQueue_level%ld", level];
                const char *queueName = [queueIdentifier UTF8String];
                dispatch_queue_t queue = dispatch_queue_create(queueName, 0);
                _timer_source_level2 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            }
            return _timer_source_level2;
        }
            break;
            
        default: {
            return nil;
        }
            break;
    }
}

- (NSMutableArray<YXLiveTimerNew *> *)findTimersArr:(NSInteger)level {
    switch (level) {
        case 1: {
            return _timers_level1;
        }
            break;
            
        case 2: {
            return _timers_level2;
        }
            break;
            
        default: {
            return nil;
        }
            break;
    }
}

- (BOOL)checkTimerRegistered:(YXLiveTimerNew *)timer {
    return [_timers_level1 containsObject:timer];
}

- (void)registerTimer:(YXLiveTimerNew *)timer {
    NSInteger timerLevel = [self findTimerLevel:timer];
    NSMutableArray<YXLiveTimerNew *> *timers = [self findTimersArr:timerLevel];
    
    if (timers) {
        if (![timers containsObject:timer]) {
            [timers addObject:timer];
        }
        
        BOOL timerIsRunning;
        switch (timerLevel) {
            case 1: {
                timerIsRunning = _queueIsRunning_level1;
            }
                break;
                
            case 2: {
                timerIsRunning = _queueIsRunning_level2;
            }
                break;
                
            default: {
                timerIsRunning = NO;
            }
                break;
        }
        
        if (!timerIsRunning) {
            [self startTimerSource:timerLevel];
        }
    }
}

- (void)unRegisterTimer:(YXLiveTimerNew *)timer {
    NSInteger timerLevel = [self findTimerLevel:timer];
    NSMutableArray<YXLiveTimerNew *> *timers = [self findTimersArr:timerLevel];
    
    if (timers) {
        if ([timers containsObject:timer]) {
            [timers removeObject:timer];
        }
        
        BOOL timerIsRunning;
        switch (timerLevel) {
            case 1: {
                timerIsRunning = _queueIsRunning_level1;
            }
                break;
                
            case 2: {
                timerIsRunning = _queueIsRunning_level2;
            }
                break;
                
            default: {
                timerIsRunning = NO;
            }
                break;
        }
        
        if (timers.count == 0 && timerIsRunning) {
            [self stopTimerSource:timerLevel];
        }
    }
}

- (void)startTimerSource:(NSInteger)level {
    NSLog(@"%@-startTimerSource-%@",NSStringFromClass([self class]),[NSThread currentThread]);
    uint64_t interval = NSEC_PER_SEC * 1;
    if (level == 1) {
        _queueIsRunning_level1 = YES;
    }
    if (level == 2) {
        interval = NSEC_PER_SEC * 0.1;
        _queueIsRunning_level2 = YES;
    }
    dispatch_source_t timer_source = [self findTimerSource:level];
    
    dispatch_source_set_timer(timer_source, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    dispatch_source_set_event_handler(timer_source, ^{
        if (level == 1) {
            [self hitsTimerHandlerLeve1];
        }
        if (level == 2) {
            [self hitsTimerHandlerLeve2];
        }
    });
    dispatch_source_set_cancel_handler(timer_source, ^{
        NSLog(@"YXLiveGCDTimeHandler Cancel");
    });
    dispatch_resume(timer_source);
}

- (void)stopTimerSource:(NSInteger)level {
    NSLog(@"%@-stopTimerSource-%@",NSStringFromClass([self class]),[NSThread currentThread]);
    dispatch_source_t timer_source = [self findTimerSource:level];
    
    if (timer_source) {
        dispatch_source_cancel(timer_source);
        timer_source = nil;
        if (level == 1) {
            _queueIsRunning_level1 = NO;
            _timer_source_level1 = nil;
        }
        if (level == 2) {
            _queueIsRunning_level2 = NO;
            _timer_source_level2 = nil;
        }
    }
}

- (void)hitsTimerHandlerLeve1 {
    [_timers_level1 enumerateObjectsUsingBlock:^(YXLiveTimerNew * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([obj respondsToSelector:@selector(hitsTimerHandler)]) {
            [obj performSelector:@selector(hitsTimerHandler)];
        }
#pragma clang diagnostic pop
    }];
}

- (void)hitsTimerHandlerLeve2 {
    [_timers_level2 enumerateObjectsUsingBlock:^(YXLiveTimerNew * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([obj respondsToSelector:@selector(hitsTimerHandler)]) {
            [obj performSelector:@selector(hitsTimerHandler)];
        }
#pragma clang diagnostic pop
    }];
}

@end

#pragma mark YXLiveTimer

@interface YXLiveTimerNew() {
    NSThread *_operationThread;
    
    BOOL _repeats;
    __weak id _target;
    SEL _selector;
    NSInteger _maxCount;
    
    NSInteger _hitsTime; ///< 计时用，精度秒级
    NSInteger _hitsTimeCount; ///< 计时用，打点累加器
    NSInteger _repeatCount; ///< 记循环次数用
}

@property (nonatomic, readwrite) NSTimeInterval interval;

- (void)hitsTimerHandler;

@end

@implementation YXLiveTimerNew

+ (YXLiveTimerNew *)timerWithTimeInterval:(NSTimeInterval)interval
                                   target:(id)target
                                 selector:(SEL)selector
                                  repeats:(BOOL)repeats {
    YXLiveTimerNew *timer = [[YXLiveTimerNew alloc] initWithTimeInterval:interval target:target selector:selector repeats:repeats];
    
    return timer;
}

+ (YXLiveTimerNew *)timerWithTimeInterval:(NSTimeInterval)interval
                                   target:(id)target
                                 selector:(SEL)selector
                                maxRepeat:(NSInteger)count {
    YXLiveTimerNew *timer = [[YXLiveTimerNew alloc] initWithTimeInterval:interval target:target selector:selector maxRepeat:count];
    return timer;
}

- (id)initWithTimeInterval:(NSTimeInterval)interval
                    target:(id)target
                  selector:(SEL)selector
                   repeats:(BOOL)repeats {
    self = [super init];
    if (self) {
        _operationThread = [NSThread currentThread];
        _interval = interval;
        _target = target;
        _selector = selector;
        _repeats = repeats;
    }
    return self;
}

- (id)initWithTimeInterval:(NSTimeInterval)interval
                    target:(id)target
                  selector:(SEL)selector
                 maxRepeat:(NSInteger)count {
    self = [super init];
    if (self) {
        _operationThread = [NSThread currentThread];
        _interval = interval;
        _target = target;
        _selector = selector;
        _maxCount = count;
    }
    return self;
}

- (void)hitsTimerHandler {
    //计时
    _hitsTime++;
    if (_hitsTime >= _hitsTimeCount) {
        _hitsTime = 0;
    } else {
        return;
    }
    
//    if ([_target respondsToSelector:_selector]) {
//        [_target performSelector:_selector onThread:_operationThread withObject:self waitUntilDone:YES];
//    }
    if ([_target respondsToSelector:_selector]) {
        if (_operationThread.isExecuting) {
            [_target performSelector:_selector onThread:_operationThread withObject:self waitUntilDone:NO];
        }
    }
    
    if (_maxCount > 0) {
        //有次数循环
        _repeatCount++;
        if (_repeatCount >= _maxCount) {
            [self invalidate];
        }
    } else if(_repeats) {
        //无次数限制的循环
        
    } else {
        //不循环
        [self invalidate];
    }
}

- (NSTimeInterval)interval {
    return _interval;
}

- (BOOL)isValid {
    return [[YXLiveTimerManager sharedInstance] checkTimerRegistered:self];
}

- (void)invalidate {
    [[YXLiveTimerManager sharedInstance] unRegisterTimer:self];
}

- (void)fire {
    [self countHitsTimeNum];
    [[YXLiveTimerManager sharedInstance] registerTimer:self];
}

- (void)countHitsTimeNum {
    NSInteger level = [[YXLiveTimerManager sharedInstance] findTimerLevel:self];
    if (level == 1) {
        _hitsTimeCount = _interval;
    }
    if (level == 2) {
        NSNumber *timeNumber = [NSNumber numberWithDouble:self.interval];
        CGFloat time_float = [timeNumber floatValue];
        NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf",time_float]];
        NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSString *intervalString = [[decNumber decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
        intervalString = [intervalString stringByReplacingOccurrencesOfString:@"." withString:@""];
        _hitsTimeCount = intervalString.integerValue;
    }
}

- (void)dealloc {
    if ([self isValid]) {
        [self invalidate];
    }
    NSLog(@"%@-销毁了-%@",NSStringFromClass([self class]),[NSThread currentThread]);
}

@end
