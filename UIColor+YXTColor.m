//
//  UIColor+YXTColor.m
//  YXFoundation
//
//  Created by D&Y on 2017/2/20.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UIColor+YXTColor.h"

@implementation UIColor (YXTColor)

+ (UIColor *)yxt_colorWithHex:(NSString *)hex {
    return [self yxt_colorWithHex:hex alpha:1.0f];
}

+ (UIColor *)yxt_colorWithHex:(NSString *)hex alpha:(CGFloat)alpha {
    NSString *cleanString = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:cleanString];
    [scanner setScanLocation:0];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}

+ (UIColor *)yxt_rgbColor:(CGFloat)r g:(CGFloat)g b:(CGFloat)b {
    return [self yxt_rgbColor:r g:g b:b a:1.0f];
}

+ (UIColor *)yxt_rgbColor:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a {
    r = MAX(0.0f, MIN(255.0f, r));
    g = MAX(0.0f, MIN(255.0f, g));
    b = MAX(0.0f, MIN(255.0f, b));
    a = MAX(0.0f, MIN(1.0f, a));
    
    return [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a];
}

+ (UIColor *)yxt_color:(CGFloat)same {
    return [self yxt_color:same alpha:1.0f];
}

+ (UIColor *)yxt_color:(CGFloat)same alpha:(CGFloat)alpha {
    same = MAX(0.0f, MIN(255.0f, same));
    alpha = MAX(0.0f, MIN(1.0f, alpha));
    return [self yxt_rgbColor:same g:same b:same a:alpha];
}

+ (UIColor *)yxt_randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end

