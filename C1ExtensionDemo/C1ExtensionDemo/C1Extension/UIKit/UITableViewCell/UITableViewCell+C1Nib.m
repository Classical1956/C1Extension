//
//  UITableViewCell+C1Nib.m
//  C1ExtensionDemo
//
//  Created by 李磊 on 2017/3/7.
//  Copyright © 2017年 Classical1956. All rights reserved.
//

#import "UITableViewCell+C1Nib.h"

@implementation UITableViewCell (C1Nib)
+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}
@end
