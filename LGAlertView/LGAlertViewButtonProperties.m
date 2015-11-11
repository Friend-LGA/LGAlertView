//
//  LGAlertViewButtonProperties.m
//  LGAlertView
//
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Grigory Lutkov <Friend.LGA@gmail.com>
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

@implementation LGAlertViewButtonProperties

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        _titleColor = [coder decodeObjectForKey:@"titleColor"];
        _titleColorHighlighted = [coder decodeObjectForKey:@"titleColorHighlighted"];
        _titleColorDisabled = [coder decodeObjectForKey:@"titleColorDisabled"];
        _font = [coder decodeObjectForKey:@"font"];
        _backgroundColor = [coder decodeObjectForKey:@"backgroundColor"];
        _backgroundColorHighlighted = [coder decodeObjectForKey:@"backgroundColorHighlighted"];
        _backgroundColorDisabled = [coder decodeObjectForKey:@"backgroundColorDisabled"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_titleColor forKey:@"titleColor"];
    [coder encodeObject:_titleColorHighlighted forKey:@"titleColorHighlighted"];
    [coder encodeObject:_titleColorDisabled forKey:@"titleColorDisabled"];
    [coder encodeObject:_font forKey:@"font"];
    [coder encodeObject:_backgroundColor forKey:@"backgroundColor"];
    [coder encodeObject:_backgroundColorHighlighted forKey:@"backgroundColorHighlighted"];
    [coder encodeObject:_backgroundColorDisabled forKey:@"backgroundColorDisabled"];
}

#pragma mark -

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;

    _userTitleColor = YES;
}

- (void)setTitleColorHighlighted:(UIColor *)titleColorHighlighted
{
    _titleColorHighlighted = titleColorHighlighted;

    _userTitleColorHighlighted = YES;
}

- (void)setTitleColorDisabled:(UIColor *)titleColorDisabled
{
    _titleColorDisabled = titleColorDisabled;

    _userTitleColorDisabled = YES;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;

    _userTextAlignment = YES;
}

- (void)setFont:(UIFont *)font
{
    _font = font;

    _userFont = YES;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;

    _userBackgroundColor = YES;
}

- (void)setBackgroundColorHighlighted:(UIColor *)backgroundColorHighlighted
{
    _backgroundColorHighlighted = backgroundColorHighlighted;

    _userBackgroundColorHighlighted = YES;
}

- (void)setBackgroundColorDisabled:(UIColor *)backgroundColorDisabled
{
    _backgroundColorDisabled = backgroundColorDisabled;

    _userBackgroundColorDisabled = YES;
}

- (void)setNumberOfLines:(NSUInteger)numberOfLines
{
    _numberOfLines = numberOfLines;

    _userNumberOfLines = YES;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    _lineBreakMode = lineBreakMode;

    _userLineBreakMode = YES;
}

- (void)setMinimumScaleFactor:(CGFloat)minimumScaleFactor
{
    _minimumScaleFactor = minimumScaleFactor;

    _userMinimumScaleFactor = YES;
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth
{
    _adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;

    _userAdjustsFontSizeTofitWidth = YES;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;

    _userEnabled = YES;
}

@end
