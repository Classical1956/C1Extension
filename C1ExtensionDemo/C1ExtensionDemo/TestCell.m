//
//  TestCell.m
//  C1ExtensionDemo
//
//  Created by 李磊 on 2017/3/7.
//  Copyright © 2017年 Classical1956. All rights reserved.
//

#import "TestCell.h"
#import "UIColor+Random.h"

@interface TestCell ()

@property (nonatomic, strong) UIView *testView;

@end

@implementation TestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configure{
    if (self.testView) {
        [self.testView removeFromSuperview];
    }
    self.testView = [[UIView alloc] initWithFrame:self.bounds];
    self.testView.backgroundColor = [UIColor RandomColor];
    [self.contentView addSubview:self.testView];
}
@end
