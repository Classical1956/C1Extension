//
//  UITextView+C1MaxLimit.m
//  C1ExtensionDemo
//
//  Created by 李磊 on 2017/3/7.
//  Copyright © 2017年 Classical1956. All rights reserved.
//
#import <objc/runtime.h>
#import "UITextView+C1MaxLimit.h"

@interface MaxHelper : NSObject

@property (nonatomic, assign) NSUInteger maxLength;
@property (nonatomic, weak) UITextView * tempTextView;

- (instancetype)initWithLegth:(NSUInteger) maxLength
             WithTempTextView:(UITextView*) tempTextView;

@end

@implementation MaxHelper

- (instancetype)initWithLegth:(NSUInteger)maxLength WithTempTextView:(UITextView *)tempTextView{
    self = [super init];
    if (self) {
        _tempTextView = tempTextView;
        _maxLength = maxLength;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueChanged:) name:UITextViewTextDidBeginEditingNotification object:tempTextView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueChanged:) name:UITextViewTextDidChangeNotification object:tempTextView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueChanged:) name:UITextViewTextDidEndEditingNotification object:tempTextView];
    }
    return self;
}


- (void)textViewValueChanged:(NSNotification *) noti{
    UITextView *textView = (UITextView *)noti.object;
    
    NSString *toBeString = textView.text;
    
    NSString *lang =  textView.textInputMode.primaryLanguage;
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > self.maxLength) {
                textView.text = [toBeString substringToIndex:self.maxLength];
            }
        }
        else{
        }
    }else{
        if (toBeString.length > self.maxLength) {
            
            textView.text = [toBeString substringToIndex:self.maxLength];
            
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

// ======================================================================

@interface UITextView (MaxLimitHelper)

@property (nonatomic, strong) MaxHelper * helper;

@end

@implementation UITextView (MaxLimitHelper)

static void* dcUITextViewHelperKey = &dcUITextViewHelperKey;

- (void)setHelper:(MaxHelper *)helper{
    objc_setAssociatedObject(self, dcUITextViewHelperKey, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MaxHelper*)helper{
    MaxHelper * tempHelper = objc_getAssociatedObject(self, dcUITextViewHelperKey);
    if (!tempHelper) {
        tempHelper = [[MaxHelper alloc] initWithLegth:self.MaxNumberOfDescriptionChars WithTempTextView:self];
        [self setHelper:tempHelper];
    }
    return tempHelper;
}

@end


// ======================================================================

@implementation UITextView (HTMaxLimit)

static void * dcUITextViewMaxLengthKey = &dcUITextViewMaxLengthKey;

- (void)setMaxNumberOfDescriptionChars:(NSUInteger)MaxNumberOfDescriptionChars{
    objc_setAssociatedObject(self, dcUITextViewMaxLengthKey, @(MaxNumberOfDescriptionChars), OBJC_ASSOCIATION_COPY);
    self.helper.maxLength = MaxNumberOfDescriptionChars;
}

- (NSUInteger)MaxNumberOfDescriptionChars{
    return [objc_getAssociatedObject(self, dcUITextViewMaxLengthKey) unsignedIntegerValue];
}

@end
