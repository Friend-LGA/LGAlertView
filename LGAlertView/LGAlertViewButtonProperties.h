//
//  LGAlertViewButtonProperties.h
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

#import <UIKit/UIKit.h>

@interface LGAlertViewButtonProperties : NSObject

@property (strong, nonatomic) UIColor         *titleColor;
@property (strong, nonatomic) UIColor         *titleColorHighlighted;
@property (strong, nonatomic) UIColor         *titleColorDisabled;
@property (assign, nonatomic) NSTextAlignment textAlignment;
@property (strong, nonatomic) UIFont          *font;
@property (strong, nonatomic) UIColor         *backgroundColor;
@property (strong, nonatomic) UIColor         *backgroundColorHighlighted;
@property (strong, nonatomic) UIColor         *backgroundColorDisabled;
@property (assign, nonatomic) NSUInteger      numberOfLines;
@property (assign, nonatomic) NSLineBreakMode lineBreakMode;
@property (assign, nonatomic) CGFloat         minimumScaleFactor;
@property (assign, nonatomic, getter=isAdjustsFontSizeToFitWidth) BOOL adjustsFontSizeToFitWidth;
@property (assign, nonatomic, getter=isEnabled) BOOL enabled;

@property (assign, nonatomic, readonly, getter=isUserTitleColor)                 BOOL userTitleColor;
@property (assign, nonatomic, readonly, getter=isUserTitleColorHighlighted)      BOOL userTitleColorHighlighted;
@property (assign, nonatomic, readonly, getter=isUserTitleColorDisabled)         BOOL userTitleColorDisabled;
@property (assign, nonatomic, readonly, getter=isUserTextAlignment)              BOOL userTextAlignment;
@property (assign, nonatomic, readonly, getter=isUserFont)                       BOOL userFont;
@property (assign, nonatomic, readonly, getter=isUserBackgroundColor)            BOOL userBackgroundColor;
@property (assign, nonatomic, readonly, getter=isUserBackgroundColorHighlighted) BOOL userBackgroundColorHighlighted;
@property (assign, nonatomic, readonly, getter=isUserBackgroundColorDisabled)    BOOL userBackgroundColorDisabled;
@property (assign, nonatomic, readonly, getter=isUserNumberOfLines)              BOOL userNumberOfLines;
@property (assign, nonatomic, readonly, getter=isUserLineBreakMode)              BOOL userLineBreakMode;
@property (assign, nonatomic, readonly, getter=isUserMinimimScaleFactor)         BOOL userMinimumScaleFactor;
@property (assign, nonatomic, readonly, getter=isUserAdjustsFontSizeTofitWidth)  BOOL userAdjustsFontSizeTofitWidth;
@property (assign, nonatomic, readonly, getter=isUserEnabled)                    BOOL userEnabled;

@end
