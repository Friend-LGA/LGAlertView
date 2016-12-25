//
//  LGAlertView.h
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
#import "LGAlertViewButtonProperties.h"
#import "LGAlertViewSharedOpen.h"

@class LGAlertView;
@protocol LGAlertViewDelegate;

#pragma mark - Constants

static NSString *_Nonnull const LGAlertViewWillShowNotification = @"LGAlertViewWillShowNotification";
static NSString *_Nonnull const LGAlertViewDidShowNotification  = @"LGAlertViewDidShowNotification";

static NSString *_Nonnull const LGAlertViewWillDismissNotification = @"LGAlertViewWillDismissNotification";
static NSString *_Nonnull const LGAlertViewDidDismissNotification  = @"LGAlertViewDidDismissNotification";

static NSString *_Nonnull const LGAlertViewActionNotification      = @"LGAlertViewActionNotification";
static NSString *_Nonnull const LGAlertViewCancelNotification      = @"LGAlertViewCancelNotification";
static NSString *_Nonnull const LGAlertViewDestructiveNotification = @"LGAlertViewDestructiveNotification";

#pragma mark - Types

typedef void (^ _Nullable LGAlertViewCompletionHandler)();
typedef void (^ _Nullable LGAlertViewHandler)(LGAlertView * _Nonnull alertView);
typedef void (^ _Nullable LGAlertViewActionHandler)(LGAlertView * _Nonnull alertView, NSString * _Nullable title, NSUInteger index);
typedef void (^ _Nullable LGAlertViewTextFieldsSetupHandler)(UITextField * _Nonnull textField, NSUInteger index);

typedef NS_ENUM(NSUInteger, LGAlertViewStyle) {
    LGAlertViewStyleAlert       = 0,
    LGAlertViewStyleActionSheet = 1
};

typedef NS_ENUM(NSUInteger, LGAlertViewWindowLevel) {
    LGAlertViewWindowLevelAboveStatusBar = 0,
    LGAlertViewWindowLevelBelowStatusBar = 1
};

#pragma mark -

@interface LGAlertView : NSObject

/** Is action "show" already had been executed */
@property (assign, nonatomic, readonly, getter=isShowing) BOOL showing;
/** Is alert view visible right now */
@property (assign, nonatomic, readonly, getter=isVisible) BOOL visible;

@property (assign, nonatomic, readonly) LGAlertViewStyle style;

/** Default is LGAlertViewWindowLevelAboveStatusBar */
@property (assign, nonatomic) LGAlertViewWindowLevel windowLevel;
/** Default is LGAlertViewWindowLevelAboveStatusBar */
@property (class, assign, nonatomic) LGAlertViewWindowLevel windowLevel;

/**
 Default:
 if (alert with activityIndicator || progressView || textFields), then NO
 else YES
 */
@property (assign, nonatomic, getter=isCancelOnTouch) BOOL cancelOnTouch;
/** Default is nil */
@property (class, strong, nonatomic, nullable) NSNumber *cancelOnTouch;

/**
 Dismiss alert view on action, cancel and destructive
 Default is YES
 */
@property (assign, nonatomic, getter=isDismissOnAction) BOOL dismissOnAction;
/**
 Dismiss alert view on action, cancel and destructive
 Default is YES
 */
@property (class, assign, nonatomic, getter=isDismissOnAction) BOOL dismissOnAction;

@property (copy, nonatomic, readonly, nullable) NSArray *textFieldsArray;

/** View that you associate to alert view while initialization */
@property (strong, nonatomic, readonly, nullable) UIView *innerView;

// Default is 0
@property (assign, nonatomic) NSInteger tag;

#pragma mark - Style properties

/**
 Set colors of buttons title and highlighted background, cancel button title and highlighted background, activity indicator and progress view
 Default is [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0]
 */
@property (strong, nonatomic, nullable) UIColor *tintColor;
/**
 Set colors of buttons title and highlighted background, cancel button title and highlighted background, activity indicator and progress view
 Default is [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0]
 */
@property (class, strong, nonatomic, nullable) UIColor *tintColor;
/**
 Color hides main view when alert view is showing
 Default is [UIColor colorWithWhite:0.0 alpha:0.4]
 */
@property (strong, nonatomic, nullable) UIColor *coverColor;
/**
 Color hides main view when alert view is showing
 Default is [UIColor colorWithWhite:0.0 alpha:0.4]
 */
@property (class, strong, nonatomic, nullable) UIColor *coverColor;
/** Default is nil */
@property (strong, nonatomic, nullable) UIBlurEffect *coverBlurEffect;
/** Default is nil */
@property (class, strong, nonatomic, nullable) UIBlurEffect *coverBlurEffect;
/** Default is 1.0 */
@property (assign, nonatomic) CGFloat coverAlpha;
/** Default is 1.0 */
@property (class, assign, nonatomic) CGFloat coverAlpha;
/** Default is [UIColor whiteColor] */
@property (strong, nonatomic, nullable) UIColor *backgroundColor;
/** Default is [UIColor whiteColor] */
@property (class, strong, nonatomic, nullable) UIColor *backgroundColor;
/**
 Default:
 if (style == LGAlertViewStyleAlert || iOS < 9.0), then 44.0
 else 56.0
 */
@property (assign, nonatomic) CGFloat buttonsHeight;
/** Default is NSNotFound */
@property (class, assign, nonatomic) CGFloat buttonsHeight;
/** Default is 44.0 */
@property (assign, nonatomic) CGFloat textFieldsHeight;
/** Default is 44.0 */
@property (class, assign, nonatomic) CGFloat textFieldsHeight;
/**
 Top and bottom offsets from borders of the screen
 Default is 8.0
 */
@property (assign, nonatomic) CGFloat offsetVertical;
/**
 Top and bottom offsets from borders of the screen
 Default is 8.0
 */
@property (class, assign, nonatomic) CGFloat offsetVertical;
/**
 Offset between cancel button and main view when style is LGAlertViewStyleActionSheet
 Default is 8.0
 */
@property (assign, nonatomic) CGFloat cancelButtonOffsetY;
/**
 Offset between cancel button and main view when style is LGAlertViewStyleActionSheet
 Default is 8.0
 */
@property (class, assign, nonatomic) CGFloat cancelButtonOffsetY;
/** Default is NSNotFound */
@property (assign, nonatomic) CGFloat heightMax;
/** Default is NSNotFound */
@property (class, assign, nonatomic) CGFloat heightMax;
/**
 Default:
 if (style == LGAlertViewStyleAlert), then 280.0
 else if (iPad), then 304.0
 else window.width - 16.0
 */
@property (assign, nonatomic) CGFloat width;
/** Default is NSNotFound */
@property (class, assign, nonatomic) CGFloat width;
/** Default is [UIColor colorWithWhite:0.85 alpha:1.0] */
@property (strong, nonatomic, nullable) UIColor *separatorsColor;
/** Default is [UIColor colorWithWhite:0.85 alpha:1.0] */
@property (class, strong, nonatomic, nullable) UIColor *separatorsColor;
/** Default is UIScrollViewIndicatorStyleBlack */
@property (assign, nonatomic) UIScrollViewIndicatorStyle indicatorStyle;
/** Default is UIScrollViewIndicatorStyleBlack */
@property (class, assign, nonatomic) UIScrollViewIndicatorStyle indicatorStyle;
/** Default is NO */
@property (assign, nonatomic, getter=isShowsVerticalScrollIndicator) BOOL showsVerticalScrollIndicator;
/** Default is NO */
@property (class, assign, nonatomic, getter=isShowsVerticalScrollIndicator) BOOL showsVerticalScrollIndicator;
/** Default is NO */
@property (assign, nonatomic, getter=isPadShowsActionSheetFromBottom) BOOL padShowsActionSheetFromBottom;
/** Default is NO */
@property (class, assign, nonatomic, getter=isPadShowsActionSheetFromBottom) BOOL padShowsActionSheetFromBottom;
/** Default is NO */
@property (assign, nonatomic, getter=isOneRowOneButton) BOOL oneRowOneButton;
/** Default is NO */
@property (class, assign, nonatomic, getter=isOneRowOneButton) BOOL oneRowOneButton;

#pragma marl - Layer properties

/**
 Default:
 if (iOS < 9.0), then 6.0
 else 12.0
 */
@property (assign, nonatomic) CGFloat layerCornerRadius;
/**
 Default:
 if (iOS < 9.0), then 6.0
 else 12.0
 */
@property (class, assign, nonatomic) CGFloat layerCornerRadius;
/** Default is nil */
@property (strong, nonatomic, nullable) UIColor *layerBorderColor;
/** Default is nil */
@property (class, strong, nonatomic, nullable) UIColor *layerBorderColor;
/** Default is 0.0 */
@property (assign, nonatomic) CGFloat layerBorderWidth;
/** Default is 0.0 */
@property (class, assign, nonatomic) CGFloat layerBorderWidth;
/** Default is nil */
@property (strong, nonatomic, nullable) UIColor *layerShadowColor;
/** Default is nil */
@property (class, strong, nonatomic, nullable) UIColor *layerShadowColor;
/** Default is 0.0 */
@property (assign, nonatomic) CGFloat layerShadowRadius;
/** Default is 0.0 */
@property (class, assign, nonatomic) CGFloat layerShadowRadius;
/** Default is 0.0 */
@property (assign, nonatomic) CGFloat layerShadowOpacity;
/** Default is 0.0 */
@property (class, assign, nonatomic) CGFloat layerShadowOpacity;
/** Default is CGSizeZero */
@property (assign, nonatomic) CGSize  layerShadowOffset;
/** Default is CGSizeZero */
@property (class, assign, nonatomic) CGSize  layerShadowOffset;

#pragma mark - Title properties

@property (copy, nonatomic, readonly, nullable) NSString *title;

/**
 Default:
 if (style == LGAlertViewStyleAlert), then [UIColor blackColor]
 else [UIColor grayColor]
 */
@property (strong, nonatomic, nullable) UIColor *titleTextColor;
/** Default is nil */
@property (class, strong, nonatomic, nullable) UIColor *titleTextColor;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment titleTextAlignment;
/** Default is NSTextAlignmentCenter */
@property (class, assign, nonatomic) NSTextAlignment titleTextAlignment;
/**
 Default:
 if (style == LGAlertViewStyleAlert), then [UIFont boldSystemFontOfSize:18.0]
 else [UIFont boldSystemFontOfSize:14.0]
 */
@property (strong, nonatomic, nullable) UIFont *titleFont;
/** Default is nil */
@property (class, strong, nonatomic, nullable) UIFont *titleFont;

#pragma mark - Message properties

@property (copy, nonatomic, readonly, nullable) NSString *message;

/**
 Default:
 if (style == LGAlertViewStyleAlert), then [UIColor blackColor]
 else [UIColor grayColor]
 */
@property (strong, nonatomic, nullable) UIColor *messageTextColor;
/** Default is nil */
@property (class, strong, nonatomic, nullable) UIColor *messageTextColor;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment messageTextAlignment;
/** Default is NSTextAlignmentCenter */
@property (class, assign, nonatomic) NSTextAlignment messageTextAlignment;
/** Default is [UIFont systemFontOfSize:14.0] */
@property (class, strong, nonatomic, nullable) UIFont *messageFont;
/** Default is [UIFont systemFontOfSize:14.0] */
@property (strong, nonatomic, nullable) UIFont *messageFont;

#pragma mark - Buttons properties

@property (copy, nonatomic, readonly, nullable) NSArray *buttonTitles;
/** Default is YES */
@property (assign, nonatomic, getter=isCancelButtonEnabled) BOOL buttonsEnabled;
@property (copy, nonatomic, nullable) NSArray *buttonsIconImages;
@property (copy, nonatomic, nullable) NSArray *buttonsIconImagesHighlighted;
@property (copy, nonatomic, nullable) NSArray *buttonsIconImagesDisabled;

/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *buttonsTitleColor;
/** Default is tintColor */
@property (class, strong, nonatomic, nullable) UIColor *buttonsTitleColor;
/** Default is [UIColor whiteColor] */
@property (strong, nonatomic, nullable) UIColor *buttonsTitleColorHighlighted;
/** Default is [UIColor whiteColor] */
@property (class, strong, nonatomic, nullable) UIColor *buttonsTitleColorHighlighted;
/** Default is [UIColor grayColor] */
@property (strong, nonatomic, nullable) UIColor *buttonsTitleColorDisabled;
/** Default is [UIColor grayColor] */
@property (class, strong, nonatomic, nullable) UIColor *buttonsTitleColorDisabled;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment buttonsTextAlignment;
/** Default is NSTextAlignmentCenter */
@property (class, assign, nonatomic) NSTextAlignment buttonsTextAlignment;
/** Default is [UIFont systemFontOfSize:18.0] */
@property (strong, nonatomic, nullable) UIFont *buttonsFont;
/** Default is [UIFont systemFontOfSize:18.0] */
@property (class, strong, nonatomic, nullable) UIFont *buttonsFont;
/** Default is nil */
@property (strong, nonatomic, nullable) UIColor *buttonsBackgroundColor;
/** Default is nil */
@property (class, strong, nonatomic, nullable) UIColor *buttonsBackgroundColor;
/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *buttonsBackgroundColorHighlighted;
/** Default is tintColor */
@property (class, strong, nonatomic, nullable) UIColor *buttonsBackgroundColorHighlighted;
/** Default is nil */
@property (strong, nonatomic, nullable) UIColor *buttonsBackgroundColorDisabled;
/** Default is nil */
@property (class, strong, nonatomic, nullable) UIColor *buttonsBackgroundColorDisabled;
/** Default is 1 */
@property (assign, nonatomic) NSUInteger buttonsNumberOfLines;
/** Default is 1 */
@property (class, assign, nonatomic) NSUInteger buttonsNumberOfLines;
/** Default is NSLineBreakByTruncatingMiddle */
@property (assign, nonatomic) NSLineBreakMode buttonsLineBreakMode;
/** Default is NSLineBreakByTruncatingMiddle */
@property (class, assign, nonatomic) NSLineBreakMode buttonsLineBreakMode;
/** Default is 14.0/18.0 */
@property (assign, nonatomic) CGFloat buttonsMinimumScaleFactor;
/** Default is 14.0/18.0 */
@property (class, assign, nonatomic) CGFloat buttonsMinimumScaleFactor;
/** Default is YES */
@property (assign, nonatomic, getter=isButtonsAdjustsFontSizeToFitWidth) BOOL buttonsAdjustsFontSizeToFitWidth;
/** Default is YES */
@property (class, assign, nonatomic, getter=isButtonsAdjustsFontSizeToFitWidth) BOOL buttonsAdjustsFontSizeToFitWidth;
/** Default is LGAlertViewButtonIconPositionLeft */
@property (assign, nonatomic) LGAlertViewButtonIconPosition buttonsIconPosition;
/** Default is LGAlertViewButtonIconPositionLeft */
@property (class, assign, nonatomic) LGAlertViewButtonIconPosition buttonsIconPosition;

#pragma mark - Cancel button properties

@property (copy, nonatomic, readonly, nullable) NSString *cancelButtonTitle;
/** Default is YES */
@property (assign, nonatomic, getter=isCancelButtonEnabled) BOOL cancelButtonEnabled;
@property (strong, nonatomic, nullable) UIImage *cancelButtonIconImage;
@property (strong, nonatomic, nullable) UIImage *cancelButtonIconImageHighlighted;
@property (strong, nonatomic, nullable) UIImage *cancelButtonIconImageDisabled;

/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *cancelButtonTitleColor;
/** Default is tintColor */
@property (class, strong, nonatomic, nullable) UIColor *cancelButtonTitleColor;
/** Default is [UIColor whiteColor] */
@property (strong, nonatomic, nullable) UIColor *cancelButtonTitleColorHighlighted;
/** Default is [UIColor whiteColor] */
@property (class, strong, nonatomic, nullable) UIColor *cancelButtonTitleColorHighlighted;
/** Default is [UIColor grayColor] */
@property (strong, nonatomic, nullable) UIColor *cancelButtonTitleColorDisabled;
/** Default is [UIColor grayColor] */
@property (class, strong, nonatomic, nullable) UIColor *cancelButtonTitleColorDisabled;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment cancelButtonTextAlignment;
/** Default is NSTextAlignmentCenter */
@property (class, assign, nonatomic) NSTextAlignment cancelButtonTextAlignment;
/** Default is [UIFont boldSystemFontOfSize:18.0] */
@property (strong, nonatomic, nullable) UIFont *cancelButtonFont;
/** Default is [UIFont boldSystemFontOfSize:18.0] */
@property (class, strong, nonatomic, nullable) UIFont *cancelButtonFont;
/** Default is nil */
@property (strong, nonatomic, nullable) UIColor *cancelButtonBackgroundColor;
/** Default is nil */
@property (class, strong, nonatomic, nullable) UIColor *cancelButtonBackgroundColor;
/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *cancelButtonBackgroundColorHighlighted;
/** Default is tintColor */
@property (class, strong, nonatomic, nullable) UIColor *cancelButtonBackgroundColorHighlighted;
/** Default is nil */
@property (strong, nonatomic, nullable) UIColor *cancelButtonBackgroundColorDisabled;
/** Default is nil */
@property (class, strong, nonatomic, nullable) UIColor *cancelButtonBackgroundColorDisabled;
/** Default is 1 */
@property (assign, nonatomic) NSUInteger cancelButtonNumberOfLines;
/** Default is 1 */
@property (class, assign, nonatomic) NSUInteger cancelButtonNumberOfLines;
/** Default is NSLineBreakByTruncatingMiddle */
@property (assign, nonatomic) NSLineBreakMode cancelButtonLineBreakMode;
/** Default is NSLineBreakByTruncatingMiddle */
@property (class, assign, nonatomic) NSLineBreakMode cancelButtonLineBreakMode;
/** Default is 14.0/18.0 */
@property (assign, nonatomic) CGFloat cancelButtonMinimumScaleFactor;
/** Default is 14.0/18.0 */
@property (class, assign, nonatomic) CGFloat cancelButtonMinimumScaleFactor;
/** Default is YES */
@property (assign, nonatomic, getter=isCancelButtonAdjustsFontSizeToFitWidth) BOOL cancelButtonAdjustsFontSizeToFitWidth;
/** Default is YES */
@property (class, assign, nonatomic, getter=isCancelButtonAdjustsFontSizeToFitWidth) BOOL cancelButtonAdjustsFontSizeToFitWidth;
/** Default is LGAlertViewButtonIconPositionLeft */
@property (assign, nonatomic) LGAlertViewButtonIconPosition cancelButtonIconPosition;
/** Default is LGAlertViewButtonIconPositionLeft */
@property (class, assign, nonatomic) LGAlertViewButtonIconPosition cancelButtonIconPosition;

#pragma mark - Destructive button properties

@property (copy, nonatomic, readonly, nullable) NSString *destructiveButtonTitle;
/** Default is YES */
@property (assign, nonatomic, getter=isDestructiveButtonEnabled) BOOL destructiveButtonEnabled;
@property (strong, nonatomic, nullable) UIImage *destructiveButtonIconImage;
@property (strong, nonatomic, nullable) UIImage *destructiveButtonIconImageHighlighted;
@property (strong, nonatomic, nullable) UIImage *destructiveButtonIconImageDisabled;

/** Default is [UIColor redColor] */
@property (strong, nonatomic, nullable) UIColor *destructiveButtonTitleColor;
/** Default is [UIColor redColor] */
@property (class, strong, nonatomic, nullable) UIColor *destructiveButtonTitleColor;
/** Default is [UIColor whiteColor] */
@property (strong, nonatomic, nullable) UIColor *destructiveButtonTitleColorHighlighted;
/** Default is [UIColor whiteColor] */
@property (class, strong, nonatomic, nullable) UIColor *destructiveButtonTitleColorHighlighted;
/** Default is [UIColor grayColor] */
@property (strong, nonatomic, nullable) UIColor *destructiveButtonTitleColorDisabled;
/** Default is [UIColor grayColor] */
@property (class, strong, nonatomic, nullable) UIColor *destructiveButtonTitleColorDisabled;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment destructiveButtonTextAlignment;
/** Default is NSTextAlignmentCenter */
@property (class, assign, nonatomic) NSTextAlignment destructiveButtonTextAlignment;
/** Default is [UIFont systemFontOfSize:18.0] */
@property (strong, nonatomic, nullable) UIFont *destructiveButtonFont;
/** Default is [UIFont systemFontOfSize:18.0] */
@property (class, strong, nonatomic, nullable) UIFont *destructiveButtonFont;
/** Default is nil */
@property (strong, nonatomic, nullable) UIColor *destructiveButtonBackgroundColor;
/** Default is nil */
@property (class, strong, nonatomic, nullable) UIColor *destructiveButtonBackgroundColor;
/** Default is [UIColor redColor] */
@property (strong, nonatomic, nullable) UIColor *destructiveButtonBackgroundColorHighlighted;
/** Default is [UIColor redColor] */
@property (class, strong, nonatomic, nullable) UIColor *destructiveButtonBackgroundColorHighlighted;
/** Default is nil */
@property (strong, nonatomic, nullable) UIColor *destructiveButtonBackgroundColorDisabled;
/** Default is nil */
@property (class, strong, nonatomic, nullable) UIColor *destructiveButtonBackgroundColorDisabled;
/** Default is 1 */
@property (assign, nonatomic) NSUInteger destructiveButtonNumberOfLines;
/** Default is 1 */
@property (class, assign, nonatomic) NSUInteger destructiveButtonNumberOfLines;
/** Default is NSLineBreakByTruncatingMiddle */
@property (assign, nonatomic) NSLineBreakMode destructiveButtonLineBreakMode;
/** Default is NSLineBreakByTruncatingMiddle */
@property (class, assign, nonatomic) NSLineBreakMode destructiveButtonLineBreakMode;
/** Default is 14.0/18.0 */
@property (assign, nonatomic) CGFloat destructiveButtonMinimumScaleFactor;
/** Default is 14.0/18.0 */
@property (class, assign, nonatomic) CGFloat destructiveButtonMinimumScaleFactor;
/** Default is YES */
@property (assign, nonatomic, getter=isDestructiveButtonAdjustsFontSizeToFitWidth) BOOL destructiveButtonAdjustsFontSizeToFitWidth;
/** Default is YES */
@property (class, assign, nonatomic, getter=isDestructiveButtonAdjustsFontSizeToFitWidth) BOOL destructiveButtonAdjustsFontSizeToFitWidth;
/** Default is LGAlertViewButtonIconPositionLeft */
@property (assign, nonatomic) LGAlertViewButtonIconPosition destructiveButtonIconPosition;
/** Default is LGAlertViewButtonIconPositionLeft */
@property (class, assign, nonatomic) LGAlertViewButtonIconPosition destructiveButtonIconPosition;

#pragma mark - Activity indicator properties

/** Default is UIActivityIndicatorViewStyleWhiteLarge */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
/** Default is UIActivityIndicatorViewStyleWhiteLarge */
@property (class, assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *activityIndicatorViewColor;
/** Default is tintColor */
@property (class, strong, nonatomic, nullable) UIColor *activityIndicatorViewColor;

#pragma mark - Progress view properties

@property (assign, nonatomic, readonly) float progress;

/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *progressViewProgressTintColor;
/** Default is tintColor */
@property (class, strong, nonatomic, nullable) UIColor *progressViewProgressTintColor;
/** Default is [UIColor colorWithWhite:0.8 alpha:1.0] */
@property (strong, nonatomic, nullable) UIColor *progressViewTrackTintColor;
/** Default is [UIColor colorWithWhite:0.8 alpha:1.0] */
@property (class, strong, nonatomic, nullable) UIColor *progressViewTrackTintColor;
/** Default is nil */
@property (strong, nonatomic, nullable) UIImage *progressViewProgressImage;
/** Default is nil */
@property (class, strong, nonatomic, nullable) UIImage *progressViewProgressImage;
/** Default is nil */
@property (strong, nonatomic, nullable) UIImage *progressViewTrackImage;
/** Default is nil */
@property (class, strong, nonatomic, nullable) UIImage *progressViewTrackImage;
/** Default is [UIColor blackColor] */
@property (strong, nonatomic, nullable) UIColor *progressLabelTextColor;
/** Default is [UIColor blackColor] */
@property (class, strong, nonatomic, nullable) UIColor *progressLabelTextColor;
/** Defailt is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment progressLabelTextAlignment;
/** Defailt is NSTextAlignmentCenter */
@property (class, assign, nonatomic) NSTextAlignment progressLabelTextAlignment;
/** Default is [UIFont systemFontOfSize:14.0] */
@property (strong, nonatomic, nullable) UIFont *progressLabelFont;
/** Default is [UIFont systemFontOfSize:14.0] */
@property (class, strong, nonatomic, nullable) UIFont *progressLabelFont;

#pragma mark - Callbacks

/** Do not forget about weak reference to self */
@property (strong, nonatomic) LGAlertViewHandler willShowHandler;
/** Do not forget about weak reference to self */
@property (strong, nonatomic) LGAlertViewHandler didShowHandler;

/** Do not forget about weak reference to self */
@property (strong, nonatomic) LGAlertViewHandler willDismissHandler;
/** Do not forget about weak reference to self */
@property (strong, nonatomic) LGAlertViewHandler didDismissHandler;

/** Do not forget about weak reference to self */
@property (strong, nonatomic) LGAlertViewActionHandler actionHandler;
/** Do not forget about weak reference to self */
@property (strong, nonatomic) LGAlertViewHandler cancelHandler;
/** Do not forget about weak reference to self */
@property (strong, nonatomic) LGAlertViewHandler destructiveHandler;

#pragma mark - Delegate

@property (weak, nonatomic, nullable) id <LGAlertViewDelegate> delegate;

#pragma mark - Initialization

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                                style:(LGAlertViewStyle)style
                         buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
               destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle;

- (nonnull instancetype)initWithViewAndTitle:(nullable NSString *)title
                                     message:(nullable NSString *)message
                                       style:(LGAlertViewStyle)style
                                        view:(nullable UIView *)view
                                buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                           cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                      destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle;

- (nonnull instancetype)initWithActivityIndicatorAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle;

- (nonnull instancetype)initWithProgressViewAndTitle:(nullable NSString *)title
                                             message:(nullable NSString *)message
                                               style:(LGAlertViewStyle)style
                                   progressLabelText:(nullable NSString *)progressLabelText
                                        buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                              destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle;

- (nonnull instancetype)initWithTextFieldsAndTitle:(nullable NSString *)title
                                           message:(nullable NSString *)message
                                numberOfTextFields:(NSUInteger)numberOfTextFields
                            textFieldsSetupHandler:(LGAlertViewTextFieldsSetupHandler)textFieldsSetupHandler
                                      buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                 cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                            destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle;

+ (nonnull instancetype)alertViewWithTitle:(nullable NSString *)title
                                   message:(nullable NSString *)message
                                     style:(LGAlertViewStyle)style
                              buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                         cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                    destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle;

+ (nonnull instancetype)alertViewWithViewAndTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                            style:(LGAlertViewStyle)style
                                             view:(nullable UIView *)view
                                     buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                           destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle;

+ (nonnull instancetype)alertViewWithActivityIndicatorAndTitle:(nullable NSString *)title
                                                       message:(nullable NSString *)message
                                                         style:(LGAlertViewStyle)style
                                                  buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                        destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle;

+ (nonnull instancetype)alertViewWithProgressViewAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                        progressLabelText:(nullable NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle;

+ (nonnull instancetype)alertViewWithTextFieldsAndTitle:(nullable NSString *)title
                                                message:(nullable NSString *)message
                                     numberOfTextFields:(NSUInteger)numberOfTextFields
                                 textFieldsSetupHandler:(LGAlertViewTextFieldsSetupHandler)textFieldsSetupHandler
                                           buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle;

#pragma mark -

/** Do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                                style:(LGAlertViewStyle)style
                         buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
               destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                        actionHandler:(LGAlertViewActionHandler)actionHandler
                        cancelHandler:(LGAlertViewHandler)cancelHandler
                   destructiveHandler:(LGAlertViewHandler)destructiveHandler;

/** Do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
- (nonnull instancetype)initWithViewAndTitle:(nullable NSString *)title
                                     message:(nullable NSString *)message
                                       style:(LGAlertViewStyle)style
                                        view:(nullable UIView *)view
                                buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                           cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                      destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                               actionHandler:(LGAlertViewActionHandler)actionHandler
                               cancelHandler:(LGAlertViewHandler)cancelHandler
                          destructiveHandler:(LGAlertViewHandler)destructiveHandler;

/** Do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
- (nonnull instancetype)initWithActivityIndicatorAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                            actionHandler:(LGAlertViewActionHandler)actionHandler
                                            cancelHandler:(LGAlertViewHandler)cancelHandler
                                       destructiveHandler:(LGAlertViewHandler)destructiveHandler;

/** Do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
- (nonnull instancetype)initWithProgressViewAndTitle:(nullable NSString *)title
                                             message:(nullable NSString *)message
                                               style:(LGAlertViewStyle)style
                                   progressLabelText:(nullable NSString *)progressLabelText
                                        buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                              destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                       actionHandler:(LGAlertViewActionHandler)actionHandler
                                       cancelHandler:(LGAlertViewHandler)cancelHandler
                                  destructiveHandler:(LGAlertViewHandler)destructiveHandler;

/** Do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
- (nonnull instancetype)initWithTextFieldsAndTitle:(nullable NSString *)title
                                           message:(nullable NSString *)message
                                numberOfTextFields:(NSUInteger)numberOfTextFields
                            textFieldsSetupHandler:(LGAlertViewTextFieldsSetupHandler)textFieldsSetupHandler
                                      buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                 cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                            destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                     actionHandler:(LGAlertViewActionHandler)actionHandler
                                     cancelHandler:(LGAlertViewHandler)cancelHandler
                                destructiveHandler:(LGAlertViewHandler)destructiveHandler;

/** Do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (nonnull instancetype)alertViewWithTitle:(nullable NSString *)title
                                   message:(nullable NSString *)message
                                     style:(LGAlertViewStyle)style
                              buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                         cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                    destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                             actionHandler:(LGAlertViewActionHandler)actionHandler
                             cancelHandler:(LGAlertViewHandler)cancelHandler
                        destructiveHandler:(LGAlertViewHandler)destructiveHandler;

/** Do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (nonnull instancetype)alertViewWithViewAndTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                            style:(LGAlertViewStyle)style
                                             view:(nullable UIView *)view
                                     buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                           destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                    actionHandler:(LGAlertViewActionHandler)actionHandler
                                    cancelHandler:(LGAlertViewHandler)cancelHandler
                               destructiveHandler:(LGAlertViewHandler)destructiveHandler;

/** Do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (nonnull instancetype)alertViewWithActivityIndicatorAndTitle:(nullable NSString *)title
                                                       message:(nullable NSString *)message
                                                         style:(LGAlertViewStyle)style
                                                  buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                        destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                                 actionHandler:(LGAlertViewActionHandler)actionHandler
                                                 cancelHandler:(LGAlertViewHandler)cancelHandler
                                            destructiveHandler:(LGAlertViewHandler)destructiveHandler;

/** Do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (nonnull instancetype)alertViewWithProgressViewAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                        progressLabelText:(nullable NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                            actionHandler:(LGAlertViewActionHandler)actionHandler
                                            cancelHandler:(LGAlertViewHandler)cancelHandler
                                       destructiveHandler:(LGAlertViewHandler)destructiveHandler;

/** Do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (nonnull instancetype)alertViewWithTextFieldsAndTitle:(nullable NSString *)title
                                                message:(nullable NSString *)message
                                     numberOfTextFields:(NSUInteger)numberOfTextFields
                                 textFieldsSetupHandler:(LGAlertViewTextFieldsSetupHandler)textFieldsSetupHandler
                                           buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                          actionHandler:(LGAlertViewActionHandler)actionHandler
                                          cancelHandler:(LGAlertViewHandler)cancelHandler
                                     destructiveHandler:(LGAlertViewHandler)destructiveHandler;

#pragma mark -

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                                style:(LGAlertViewStyle)style
                         buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
               destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                             delegate:(nullable id<LGAlertViewDelegate>)delegate;

/** View can not be subclass of UIScrollView */
- (nonnull instancetype)initWithViewAndTitle:(nullable NSString *)title
                                     message:(nullable NSString *)message
                                       style:(LGAlertViewStyle)style
                                        view:(nullable UIView *)view
                                buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                           cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                      destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                    delegate:(nullable id<LGAlertViewDelegate>)delegate;

- (nonnull instancetype)initWithActivityIndicatorAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                                 delegate:(nullable id<LGAlertViewDelegate>)delegate;

- (nonnull instancetype)initWithProgressViewAndTitle:(nullable NSString *)title
                                             message:(nullable NSString *)message
                                               style:(LGAlertViewStyle)style
                                   progressLabelText:(nullable NSString *)progressLabelText
                                        buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                              destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                            delegate:(nullable id<LGAlertViewDelegate>)delegate;

- (nonnull instancetype)initWithTextFieldsAndTitle:(nullable NSString *)title
                                           message:(nullable NSString *)message
                                numberOfTextFields:(NSUInteger)numberOfTextFields
                            textFieldsSetupHandler:(LGAlertViewTextFieldsSetupHandler)textFieldsSetupHandler
                                      buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                 cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                            destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                          delegate:(nullable id<LGAlertViewDelegate>)delegate;

+ (nonnull instancetype)alertViewWithTitle:(nullable NSString *)title
                                   message:(nullable NSString *)message
                                     style:(LGAlertViewStyle)style
                              buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                         cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                    destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                  delegate:(nullable id<LGAlertViewDelegate>)delegate;

/** View can not be subclass of UIScrollView */
+ (nonnull instancetype)alertViewWithViewAndTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                            style:(LGAlertViewStyle)style
                                             view:(nullable UIView *)view
                                     buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                           destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                         delegate:(nullable id<LGAlertViewDelegate>)delegate;

+ (nonnull instancetype)alertViewWithActivityIndicatorAndTitle:(nullable NSString *)title
                                                       message:(nullable NSString *)message
                                                         style:(LGAlertViewStyle)style
                                                  buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                        destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                                      delegate:(nullable id<LGAlertViewDelegate>)delegate;

+ (nonnull instancetype)alertViewWithProgressViewAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                        progressLabelText:(nullable NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                                 delegate:(nullable id<LGAlertViewDelegate>)delegate;

+ (nonnull instancetype)alertViewWithTextFieldsAndTitle:(nullable NSString *)title
                                                message:(nullable NSString *)message
                                     numberOfTextFields:(NSUInteger)numberOfTextFields
                                 textFieldsSetupHandler:(LGAlertViewTextFieldsSetupHandler)textFieldsSetupHandler
                                           buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                               delegate:(nullable id<LGAlertViewDelegate>)delegate;

#pragma mark -

- (void)showAnimated:(BOOL)animated completionHandler:(LGAlertViewCompletionHandler)completionHandler;
- (void)showAnimated;
- (void)show;

- (void)dismissAnimated:(BOOL)animated completionHandler:(LGAlertViewCompletionHandler)completionHandler;
- (void)dismissAnimated;
- (void)dismiss;

- (void)transitionToAlertView:(nonnull LGAlertView *)alertView completionHandler:(LGAlertViewCompletionHandler)completionHandler;
- (void)transitionToAlertView:(nonnull LGAlertView *)alertView;

- (void)setProgress:(float)progress progressLabelText:(nullable NSString *)progressLabelText;

- (void)setButtonPropertiesAtIndex:(NSUInteger)index handler:(void(^ _Nonnull)(LGAlertViewButtonProperties * _Nonnull properties))handler;

- (void)setButtonEnabled:(BOOL)enabled atIndex:(NSUInteger)index;
- (BOOL)isButtonEnabledAtIndex:(NSUInteger)index;

- (void)layoutValidateWithSize:(CGSize)size;

- (void)forceCancel;
- (void)forceDestructive;
- (void)forceActionAtIndex:(NSUInteger)index;

+ (nonnull NSArray *)alertViewsArray;

#pragma mark -

- (nonnull instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;

@end

#pragma mark - Delegate

@protocol LGAlertViewDelegate <NSObject>

@optional

- (void)alertViewWillShow:(nonnull LGAlertView *)alertView;
- (void)alertViewDidShow:(nonnull LGAlertView *)alertView;

- (void)alertViewWillDismiss:(nonnull LGAlertView *)alertView;
- (void)alertViewDidDismiss:(nonnull LGAlertView *)alertView;

- (void)alertView:(nonnull LGAlertView *)alertView buttonPressedWithTitle:(nullable NSString *)title index:(NSUInteger)index;
- (void)alertViewCancelled:(nonnull LGAlertView *)alertView;
- (void)alertViewDestructiveButtonPressed:(nonnull LGAlertView *)alertView;

@end

#pragma mark - Deprecated

@interface LGAlertView (Deprecated)

- (void)setButtonAtIndex:(NSUInteger)index enabled:(BOOL)enabled DEPRECATED_MSG_ATTRIBUTE("use setButtonEnabled:atIndex instead");

@end
