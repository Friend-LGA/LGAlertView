//
//  LGAlertViewButtonProperties.h
//  Pods
//
//  Created by Grigory Lutkov on 09.11.15.
//
//

#import <Foundation/Foundation.h>

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

@property (assign, nonatomic, readonly, getter=isUserTitleColor) BOOL userTitleColor;
@property (assign, nonatomic, readonly, getter=isUserTitleColorHighlighted) BOOL userTitleColorHighlighted;
@property (assign, nonatomic, readonly, getter=isUserTitleColorDisabled) BOOL userTitleColorDisabled;
@property (assign, nonatomic, readonly, getter=isUserTextAlignment) BOOL userTextAlignment;
@property (assign, nonatomic, readonly, getter=isUserFont) BOOL userFont;
@property (assign, nonatomic, readonly, getter=isUserBackgroundColor) BOOL userBackgroundColor;
@property (assign, nonatomic, readonly, getter=isUserBackgroundColorHighlighted) BOOL userBackgroundColorHighlighted;
@property (assign, nonatomic, readonly, getter=isUserBackgroundColorDisabled) BOOL userBackgroundColorDisabled;
@property (assign, nonatomic, readonly, getter=isUserNumberOfLines) BOOL userNumberOfLines;
@property (assign, nonatomic, readonly, getter=isUserLineBreakMode) BOOL userLineBreakMode;
@property (assign, nonatomic, readonly, getter=isUserMinimimScaleFactor) BOOL userMinimumScaleFactor;
@property (assign, nonatomic, readonly, getter=isUserAdjustsFontSizeTofitWidth) BOOL userAdjustsFontSizeTofitWidth;
@property (assign, nonatomic, readonly, getter=isUserEnabled) BOOL userEnabled;

@end
