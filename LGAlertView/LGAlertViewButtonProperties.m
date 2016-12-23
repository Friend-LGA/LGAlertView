//
//  LGAlertViewButtonProperties.m
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

#import "LGAlertViewButtonProperties.h"

@interface LGAlertViewButtonProperties ()

@property (assign, nonatomic, getter=isUserTitleColor)                 BOOL userTitleColor;
@property (assign, nonatomic, getter=isUserTitleColorHighlighted)      BOOL userTitleColorHighlighted;
@property (assign, nonatomic, getter=isUserTitleColorDisabled)         BOOL userTitleColorDisabled;
@property (assign, nonatomic, getter=isUserTextAlignment)              BOOL userTextAlignment;
@property (assign, nonatomic, getter=isUserFont)                       BOOL userFont;
@property (assign, nonatomic, getter=isUserBackgroundColor)            BOOL userBackgroundColor;
@property (assign, nonatomic, getter=isUserBackgroundColorHighlighted) BOOL userBackgroundColorHighlighted;
@property (assign, nonatomic, getter=isUserBackgroundColorDisabled)    BOOL userBackgroundColorDisabled;
@property (assign, nonatomic, getter=isUserNumberOfLines)              BOOL userNumberOfLines;
@property (assign, nonatomic, getter=isUserLineBreakMode)              BOOL userLineBreakMode;
@property (assign, nonatomic, getter=isUserMinimimScaleFactor)         BOOL userMinimumScaleFactor;
@property (assign, nonatomic, getter=isUserAdjustsFontSizeTofitWidth)  BOOL userAdjustsFontSizeTofitWidth;
@property (assign, nonatomic, getter=isUserEnabled)                    BOOL userEnabled;

@end

@implementation LGAlertViewButtonProperties

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.titleColor = [coder decodeObjectForKey:@"titleColor"];
        self.titleColorHighlighted = [coder decodeObjectForKey:@"titleColorHighlighted"];
        self.titleColorDisabled = [coder decodeObjectForKey:@"titleColorDisabled"];
        self.font = [coder decodeObjectForKey:@"font"];
        self.backgroundColor = [coder decodeObjectForKey:@"backgroundColor"];
        self.backgroundColorHighlighted = [coder decodeObjectForKey:@"backgroundColorHighlighted"];
        self.backgroundColorDisabled = [coder decodeObjectForKey:@"backgroundColorDisabled"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.titleColor forKey:@"titleColor"];
    [coder encodeObject:self.titleColorHighlighted forKey:@"titleColorHighlighted"];
    [coder encodeObject:self.titleColorDisabled forKey:@"titleColorDisabled"];
    [coder encodeObject:self.font forKey:@"font"];
    [coder encodeObject:self.backgroundColor forKey:@"backgroundColor"];
    [coder encodeObject:self.backgroundColorHighlighted forKey:@"backgroundColorHighlighted"];
    [coder encodeObject:self.backgroundColorDisabled forKey:@"backgroundColorDisabled"];
}

#pragma mark -

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.userTitleColor = YES;
}

- (void)setTitleColorHighlighted:(UIColor *)titleColorHighlighted {
    _titleColorHighlighted = titleColorHighlighted;
    self.userTitleColorHighlighted = YES;
}

- (void)setTitleColorDisabled:(UIColor *)titleColorDisabled {
    _titleColorDisabled = titleColorDisabled;
    self.userTitleColorDisabled = YES;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    self.userTextAlignment = YES;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.userFont = YES;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    self.userBackgroundColor = YES;
}

- (void)setBackgroundColorHighlighted:(UIColor *)backgroundColorHighlighted {
    _backgroundColorHighlighted = backgroundColorHighlighted;
    self.userBackgroundColorHighlighted = YES;
}

- (void)setBackgroundColorDisabled:(UIColor *)backgroundColorDisabled {
    _backgroundColorDisabled = backgroundColorDisabled;
    self.userBackgroundColorDisabled = YES;
}

- (void)setNumberOfLines:(NSUInteger)numberOfLines {
    _numberOfLines = numberOfLines;
    self.userNumberOfLines = YES;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    _lineBreakMode = lineBreakMode;
    self.userLineBreakMode = YES;
}

- (void)setMinimumScaleFactor:(CGFloat)minimumScaleFactor {
    _minimumScaleFactor = minimumScaleFactor;
    self.userMinimumScaleFactor = YES;
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    _adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
    self.userAdjustsFontSizeTofitWidth = YES;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.userEnabled = YES;
}

@end
