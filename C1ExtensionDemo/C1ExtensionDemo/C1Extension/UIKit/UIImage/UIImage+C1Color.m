//
//  UIImage+C1Color.m
//  C1ExtensionDemo
//
//  Created by 李磊 on 2017/3/7.
//  Copyright © 2017年 Classical1956. All rights reserved.
//

#import "UIImage+C1Color.h"

@implementation UIImage (C1Color)
+ (UIImage *)c1_imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
