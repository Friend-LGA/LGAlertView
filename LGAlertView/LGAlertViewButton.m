//
//  LGAlertViewButton.m
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

#import "LGAlertViewButton.h"
#import "LGAlertViewSharedPrivate.h"

@implementation LGAlertViewButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.titleLabel.backgroundColor = UIColor.clearColor;
        self.imageView.backgroundColor = UIColor.clearColor;

        self.contentEdgeInsets = UIEdgeInsetsMake(kLGAlertViewPaddingH,
                                                  kLGAlertViewPaddingW,
                                                  kLGAlertViewPaddingH,
                                                  kLGAlertViewPaddingW);

        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

        self.adjustsImageWhenHighlighted = NO;
        self.adjustsImageWhenDisabled = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!self.imageView.image || !self.titleLabel.text.length) {
        return;
    }

    CGRect imageViewFrame = self.imageView.frame;
    CGRect titleLabelFrame = self.titleLabel.frame;

    if (self.iconPosition == LGAlertViewButtonIconPositionLeft) {
        if (self.titleLabel.textAlignment == NSTextAlignmentLeft) {
            imageViewFrame.origin.x = self.contentEdgeInsets.left;
            titleLabelFrame.origin.x = CGRectGetMaxX(imageViewFrame) + kLGAlertViewButtonImageOffsetFromTitle;
        }
        else if (self.titleLabel.textAlignment == NSTextAlignmentRight) {
            imageViewFrame.origin.x = self.contentEdgeInsets.left;
            titleLabelFrame.origin.x = CGRectGetWidth(self.frame) - self.contentEdgeInsets.right;
        }
        else {
            imageViewFrame.origin.x -= kLGAlertViewButtonImageOffsetFromTitle/2.0;
            titleLabelFrame.origin.x += kLGAlertViewButtonImageOffsetFromTitle/2.0;
        }
    }
    else {
        if (self.titleLabel.textAlignment == NSTextAlignmentLeft) {
            titleLabelFrame.origin.x = self.contentEdgeInsets.left;
            imageViewFrame.origin.x = CGRectGetWidth(self.frame) - self.contentEdgeInsets.right - CGRectGetWidth(imageViewFrame);
        }
        else if (self.titleLabel.textAlignment == NSTextAlignmentRight) {
            imageViewFrame.origin.x = CGRectGetWidth(self.frame) - self.contentEdgeInsets.right - CGRectGetWidth(imageViewFrame);
            titleLabelFrame.origin.x = CGRectGetMinX(imageViewFrame) - kLGAlertViewButtonImageOffsetFromTitle - CGRectGetWidth(titleLabelFrame);
        }
        else {
            imageViewFrame.origin.x += CGRectGetWidth(titleLabelFrame) + kLGAlertViewButtonImageOffsetFromTitle/2.0;
            titleLabelFrame.origin.x -= (CGRectGetWidth(imageViewFrame) + kLGAlertViewButtonImageOffsetFromTitle/2.0);
        }
    }

    if ([UIScreen mainScreen].scale == 1.0) {
        imageViewFrame = CGRectIntegral(imageViewFrame);
    }

    self.imageView.frame = imageViewFrame;

    if ([UIScreen mainScreen].scale == 1.0) {
        titleLabelFrame = CGRectIntegral(imageViewFrame);
    }

    self.titleLabel.frame = titleLabelFrame;
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    [self setBackgroundImage:[self image1x1WithColor:color] forState:state];
}

- (UIImage *)image1x1WithColor:(UIColor *)color {
    if (!color) return nil;

    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);

    UIGraphicsBeginImageContext(rect.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
