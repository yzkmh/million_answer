//
//  YXLiveMillionModel.h
//  YXLiveKit
//
//  Created by yangzhaokun on 2018/1/13.
//  Copyright © 2018年 YIXIA. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YXLiveMillionModelType) {
    YXLiveMillionModelTypeAnswer,
    YXLiveMillionModelTypeResult,
};

@interface YXLiveMillionModel : NSObject
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSUInteger totalCount;
@property (nonatomic, assign) BOOL  watchMode;
@property (nonatomic, strong) NSString *topicString;
@property (nonatomic, strong) NSMutableArray<NSString *> *answersStr;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *answersNum;
@property (nonatomic, assign) NSUInteger rightAnswer;
@property (nonatomic, assign) NSUInteger mineAnswer;
@property (nonatomic, assign) YXLiveMillionModelType type;

@end
