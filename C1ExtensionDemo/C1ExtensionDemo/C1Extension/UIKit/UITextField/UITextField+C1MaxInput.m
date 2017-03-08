//
//  UITextField+C1MaxInput.m
//  C1ExtensionDemo
//
//  Created by 李磊 on 2017/3/7.
//  Copyright © 2017年 Classical1956. All rights reserved.
//

#import "UITextField+C1MaxInput.h"
#import <objc/runtime.h>
static char * maxLimitKey;
@implementation UITextField (C1MaxInput)
- (void)setMaxLength:(NSUInteger)maxLength{
    objc_setAssociatedObject(self, &maxLimitKey, @(maxLength), OBJC_ASSOCIATION_COPY);
    
    if (maxLength > 0 ) {
        [self addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventAllEditingEvents];
    }else{
        [self removeTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventAllEditingEvents];
    }
}

- (NSUInteger)maxLength{
    return [objc_getAssociatedObject(self, &maxLimitKey) unsignedIntegerValue];
}

#pragma mark - action

- (void)valueChange:(UITextField *) textField{
    
    if (self.maxLength <= 0) {
        return;
    }
    
    NSUInteger currentLength = textField.text.length;
    
    if (currentLength <= self.maxLength) {
        return;
    }
    
    NSString * subString = [textField.text substringToIndex:self.maxLength];
    
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            textField.text = subString;
            [textField sendActionsForControlEvents:UIControlEventEditingChanged];
        });
    }else{
        textField.text = subString;
        [textField sendActionsForControlEvents:UIControlEventEditingChanged];
    }
}

@end
