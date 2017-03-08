//
//  UITextView+C1Placeholder.h
//  C1ExtensionDemo
//
//  Created by 李磊 on 2017/3/7.
//  Copyright © 2017年 Classical1956. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (C1Placeholder)
@property (nonatomic, readonly) UILabel *placeholderLabel;

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@end
