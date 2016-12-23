//
//  LGAlertViewCell.h
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

@interface LGAlertViewCell : UITableViewCell

@property (strong, nonatomic, nullable) NSString *title;

@property (strong, nonatomic, nullable) UIColor *titleColor;
@property (strong, nonatomic, nullable) UIColor *titleColorHighlighted;
@property (strong, nonatomic, nullable) UIColor *titleColorDisabled;

@property (strong, nonatomic, nullable) UIColor *backgroundColorNormal;
@property (strong, nonatomic, nullable) UIColor *backgroundColorHighlighted;
@property (strong, nonatomic, nullable) UIColor *backgroundColorDisabled;

@property (assign, nonatomic, getter=isSeparatorVisible) BOOL separatorVisible;
@property (strong, nonatomic, nullable) UIColor *separatorColor_;

@property (strong, nonatomic, nullable) UIFont *font;
@property (assign, nonatomic) NSUInteger numberOfLines;
@property (assign, nonatomic) NSLineBreakMode lineBreakMode;
@property (assign, nonatomic) NSTextAlignment textAlignment;
@property (assign, nonatomic) BOOL adjustsFontSizeToFitWidth;
@property (assign, nonatomic) CGFloat minimumScaleFactor;

@property (assign, nonatomic) BOOL enabled;

@end
