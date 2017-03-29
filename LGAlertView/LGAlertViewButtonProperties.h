//
//  LGAlertViewButtonProperties.h
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

#import <UIKit/UIKit.h>
#import "LGAlertViewShared.h"

@interface LGAlertViewButtonProperties : NSObject

@property (strong, nonatomic, nullable) UIColor *titleColor;
@property (strong, nonatomic, nullable) UIColor *titleColorHighlighted;
@property (strong, nonatomic, nullable) UIColor *titleColorDisabled;

@property (strong, nonatomic, nullable) UIColor *backgroundColor;
@property (strong, nonatomic, nullable) UIColor *backgroundColorHighlighted;
@property (strong, nonatomic, nullable) UIColor *backgroundColorDisabled;

@property (strong, nonatomic, nullable) UIImage *iconImage;
@property (strong, nonatomic, nullable) UIImage *iconImageHighlighted;
@property (strong, nonatomic, nullable) UIImage *iconImageDisabled;

@property (assign, nonatomic) NSTextAlignment textAlignment;
@property (strong, nonatomic, nullable) UIFont *font;
@property (assign, nonatomic) NSUInteger numberOfLines;
@property (assign, nonatomic) NSLineBreakMode lineBreakMode;
@property (assign, nonatomic) CGFloat minimumScaleFactor;
@property (assign, nonatomic, getter=isAdjustsFontSizeToFitWidth) BOOL adjustsFontSizeToFitWidth;
@property (assign, nonatomic) LGAlertViewButtonIconPosition iconPosition;

@property (assign, nonatomic, getter=isEnabled) BOOL enabled;

@property (assign, nonatomic, readonly, getter=isUserTitleColor)                 BOOL userTitleColor;
@property (assign, nonatomic, readonly, getter=isUserTitleColorHighlighted)      BOOL userTitleColorHighlighted;
@property (assign, nonatomic, readonly, getter=isUserTitleColorDisabled)         BOOL userTitleColorDisabled;
@property (assign, nonatomic, readonly, getter=isUserBackgroundColor)            BOOL userBackgroundColor;
@property (assign, nonatomic, readonly, getter=isUserBackgroundColorHighlighted) BOOL userBackgroundColorHighlighted;
@property (assign, nonatomic, readonly, getter=isUserBackgroundColorDisabled)    BOOL userBackgroundColorDisabled;
@property (assign, nonatomic, readonly, getter=isUserIconImage)                  BOOL userIconImage;
@property (assign, nonatomic, readonly, getter=isUserIconImageHighlighted)       BOOL userIconImageHighlighted;
@property (assign, nonatomic, readonly, getter=isUserIconImageDisabled)          BOOL userIconImageDisabled;
@property (assign, nonatomic, readonly, getter=isUserTextAlignment)              BOOL userTextAlignment;
@property (assign, nonatomic, readonly, getter=isUserFont)                       BOOL userFont;
@property (assign, nonatomic, readonly, getter=isUserNumberOfLines)              BOOL userNumberOfLines;
@property (assign, nonatomic, readonly, getter=isUserLineBreakMode)              BOOL userLineBreakMode;
@property (assign, nonatomic, readonly, getter=isUserMinimimScaleFactor)         BOOL userMinimumScaleFactor;
@property (assign, nonatomic, readonly, getter=isUserAdjustsFontSizeTofitWidth)  BOOL userAdjustsFontSizeTofitWidth;
@property (assign, nonatomic, readonly, getter=isUserIconPosition)               BOOL userIconPosition;
@property (assign, nonatomic, readonly, getter=isUserEnabled)                    BOOL userEnabled;

@end
