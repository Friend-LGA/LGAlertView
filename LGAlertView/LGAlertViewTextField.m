//
//  LGAlertViewTextField.m
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

#import "LGAlertViewTextField.h"
#import "LGAlertViewShared.h"

@implementation LGAlertViewTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
        self.textColor = [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:16.0];
        self.clearButtonMode = UITextFieldViewModeAlways;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    bounds.origin.x += kLGAlertViewPaddingW;
    bounds.size.width -= kLGAlertViewPaddingW*2;

    if (self.leftView) {
        bounds.origin.x += (CGRectGetWidth(self.leftView.frame)+kLGAlertViewPaddingW);
        bounds.size.width -= (CGRectGetWidth(self.leftView.frame)+kLGAlertViewPaddingW);
    }

    if (self.rightView) {
        bounds.size.width -= (CGRectGetWidth(self.rightView.frame)+kLGAlertViewPaddingW);
    }
    else if (self.clearButtonMode == UITextFieldViewModeAlways) {
        bounds.size.width -= 20.0;
    }

    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    bounds.origin.x += kLGAlertViewPaddingW;
    bounds.size.width -= kLGAlertViewPaddingW*2;

    if (self.leftView) {
        bounds.origin.x += (CGRectGetWidth(self.leftView.frame)+kLGAlertViewPaddingW);
        bounds.size.width -= (CGRectGetWidth(self.leftView.frame)+kLGAlertViewPaddingW);
    }

    if (self.rightView) {
        bounds.size.width -= (CGRectGetWidth(self.rightView.frame)+kLGAlertViewPaddingW);
    }
    else if (self.clearButtonMode == UITextFieldViewModeAlways) {
        bounds.size.width -= 20.0;
    }

    return bounds;
}

@end
