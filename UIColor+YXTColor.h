//
//  UIColor+YXTColor.h
//  YXFoundation
//
//  Created by D&Y on 2017/2/20.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YXTColor)


/**
 生成给定Hex字符串的UIColor

 @param hex 取值范围 (#000000 ~ #FFFFFF) 也可以去掉#号
 @return 返回给定Hex字符串的UIColor
 */
+ (UIColor *)yxt_colorWithHex:(NSString *)hex;


/**
 生成给定Hex字符串且带alpha的UIColor

 @param hex 取值范围 (#000000 ~ #FFFFFF) 也可以去掉#号
 @param alpha 取值范围 (0.0f ~ 1.0f)
 @return 返回给定Hex字符串且带alpha的UIColor
 */
+ (UIColor *)yxt_colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;


/**
 生成给定RGB值UIColor

 @param r 取值范围 (0.0f ~ 255.0f)
 @param g 取值范围 (0.0f ~ 255.0f)
 @param b 取值范围 (0.0f ~ 255.0f)
 @return 返回给定RGB值UIColor
 */
+ (UIColor *)yxt_rgbColor:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;


/**
 生成给定RGBA值UIColor

 @param r 取值范围 (0.0f ~ 255.0f)
 @param g 取值范围 (0.0f ~ 255.0f)
 @param b 取值范围 (0.0f ~ 255.0f)
 @param a 取值范围 (0.0f ~ 1.0f)
 @return 返回给定RGBA值UIColor
 */
+ (UIColor *)yxt_rgbColor:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;


/**
 生成RGB值都是same的UIColor

 @param same 取值范围 (0.0f ~ 255.0f)
 @return 返回RGB值都是same的UIColor
 */
+ (UIColor *)yxt_color:(CGFloat)same;


/**
 生成RGB值都是same且带alpha的UIColor

 @param same 取值范围 (0.0f ~ 255.0f)
 @param alpha 取值范围 (0.0f ~ 1.0f)
 @return 返回RGB值都是same且带alpha的UIColor
 */
+ (UIColor *)yxt_color:(CGFloat)same alpha:(CGFloat)alpha;


/**
 生成随机颜色的UIColor

 @return 返回随机颜色的UIColor
 */
+ (UIColor *)yxt_randomColor;

@end
