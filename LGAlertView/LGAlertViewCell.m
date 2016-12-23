//
//  LGAlertViewCell.m
//  LGAlertView
//
//
//  The MIT License (MIT)
//
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>
//  (https://github.com/Friend-LGA/LGAlertView)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "LGAlertViewCell.h"

@interface LGAlertViewCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *separatorView;

@end

@implementation LGAlertViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.titleLabel = [UILabel new];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];

        self.separatorView = [UIView new];
        [self addSubview:self.separatorView];

        self.enabled = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.text = self.title;
    self.titleLabel.textAlignment = self.textAlignment;
    self.titleLabel.font = self.font;
    self.titleLabel.numberOfLines = self.numberOfLines;
    self.titleLabel.lineBreakMode = self.lineBreakMode;
    self.titleLabel.adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth;
    self.titleLabel.minimumScaleFactor = self.minimumScaleFactor;

    CGRect titleLabelFrame = CGRectMake(10.0, 0.0, CGRectGetWidth(self.frame)-20.0, CGRectGetHeight(self.frame));

    if ([UIScreen mainScreen].scale == 1.0) {
        titleLabelFrame = CGRectIntegral(titleLabelFrame);
    }

    self.titleLabel.frame = titleLabelFrame;

    if (self.isSeparatorVisible) {
        CGFloat separatorHeight = [UIScreen mainScreen].scale == 1.0 ? 1.0 : 0.5;

        self.separatorView.hidden = NO;
        self.separatorView.backgroundColor = self.separatorColor_;
        self.separatorView.frame = CGRectMake(0.0, CGRectGetHeight(self.frame)-separatorHeight, CGRectGetWidth(self.frame), separatorHeight);
    }
    else {
        self.separatorView.hidden = YES;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];

    if (highlighted) {
        self.titleLabel.textColor = self.titleColorHighlighted;
        self.backgroundColor = self.backgroundColorHighlighted;
    }
    else {
        [self setEnabled:self.enabled];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.titleLabel.textColor = self.titleColorHighlighted;
        self.backgroundColor = self.backgroundColorHighlighted;
    }
    else {
        [self setEnabled:self.enabled];
    }
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;

    self.userInteractionEnabled = enabled;

    if (enabled) {
        self.titleLabel.textColor = self.titleColor;
        self.backgroundColor = self.backgroundColorNormal;
    }
    else {
        self.titleLabel.textColor = self.titleColorDisabled;
        self.backgroundColor = self.backgroundColorDisabled;
    }
}

@end
