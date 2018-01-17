//
//  GCDDelay.h
//  demo
//
//  Created by yangzhaokun on 2018/1/15.
//  Copyright © 2018年 yangzhaokun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GCDTask)(BOOL cancel);
typedef void(^gcdBlock)();

@interface GCDDelay : NSObject

+(GCDTask)gcdDelay:(NSTimeInterval)time task:(gcdBlock)block;
+(void)gcdCancel:(GCDTask)task;


@end

