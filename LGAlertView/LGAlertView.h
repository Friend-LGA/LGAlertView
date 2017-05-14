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
#import "LGAlertViewShared.h"

@class LGAlertView;
@protocol LGAlertViewDelegate;

#pragma mark - Constants

extern NSString * _Nonnull const LGAlertViewWillShowNotification;
extern NSString * _Nonnull const LGAlertViewDidShowNotification;

extern NSString * _Nonnull const LGAlertViewWillDismissNotification;
extern NSString * _Nonnull const LGAlertViewDidDismissNotification;

extern NSString * _Nonnull const LGAlertViewActionNotification;
extern NSString * _Nonnull const LGAlertViewCancelNotification;
extern NSString * _Nonnull const LGAlertViewDestructiveNotification;

extern NSString * _Nonnull const LGAlertViewDidDismissAfterActionNotification;
extern NSString * _Nonnull const LGAlertViewDidDismissAfterCancelNotification;
extern NSString * _Nonnull const LGAlertViewDidDismissAfterDestructiveNotification;

/** You can use this notification to add some custom animations */
extern NSString * _Nonnull const LGAlertViewShowAnimationsNotification;
/** You can use this notification to add some custom animations */
extern NSString * _Nonnull const LGAlertViewDismissAnimationsNotification;

extern NSString * _Nonnull const kLGAlertViewAnimationDuration;

#pragma mark - Types

typedef void (^ _Nullable LGAlertViewCompletionHandler)();
typedef void (^ _Nullable LGAlertViewHandler)(LGAlertView * _Nonnull alertView);
typedef void (^ _Nullable LGAlertViewActionHandler)(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title);
typedef void (^ _Nullable LGAlertViewTextFieldsSetupHandler)(UITextField * _Nonnull textField, NSUInteger index);
typedef void (^ _Nullable LGAlertViewAnimationsBlock)(LGAlertView * _Nonnull alertView, NSTimeInterval duration);

typedef NS_ENUM(NSUInteger, LGAlertViewStyle) {
    LGAlertViewStyleAlert       = 0,
    LGAlertViewStyleActionSheet = 1
};

typedef NS_ENUM(NSUInteger, LGAlertViewWindowLevel) {
    LGAlertViewWindowLevelAboveStatusBar = 0,
    LGAlertViewWindowLevelBelowStatusBar = 1
};

#pragma mark -

@interface LGAlertView : NSObject <UIAppearance>

/** Is action "show" already had been executed */
@property (assign, nonatomic, readonly, getter=isShowing) BOOL showing;
/** Is alert view visible right now */
@property (assign, nonatomic, readonly, getter=isVisible) BOOL visible;

@property (assign, nonatomic, readonly) LGAlertViewStyle style;

/** Default is LGAlertViewWindowLevelAboveStatusBar */
@property (assign, nonatomic) LGAlertViewWindowLevel windowLevel UI_APPEARANCE_SELECTOR;

/**
 Default:
 if (alert with activityIndicator || progressView || textFields) then NO
 else YES
 */
@property (assign, nonatomic, getter=isCancelOnTouch) BOOL cancelOnTouch UI_APPEARANCE_SELECTOR;

/**
 Dismiss alert view on action, cancel and destructive
 Default is YES
 */
@property (assign, nonatomic, getter=isDismissOnAction) BOOL dismissOnAction UI_APPEARANCE_SELECTOR;

@property (copy, nonatomic, readonly, nullable) NSArray *textFieldsArray;

/** View that you associate to alert view while initialization */
@property (strong, nonatomic, readonly, nullable) UIView *innerView;

/** Default is 0 */
@property (assign, nonatomic) NSInteger tag;

#pragma mark - Style properties

/**
 Set colors of buttons title and highlighted background, cancel button title and highlighted background, activity indicator and progress view
 Default is [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0]
 */
@property (strong, nonatomic, nullable) UIColor *tintColor UI_APPEARANCE_SELECTOR;
/**
 Color hides main view when alert view is showing
 Default is [UIColor colorWithWhite:0.0 alpha:0.35]
 */
@property (strong, nonatomic, nullable) UIColor *coverColor UI_APPEARANCE_SELECTOR;
/** Default is nil */
@property (strong, nonatomic, nullable) UIBlurEffect *coverBlurEffect UI_APPEARANCE_SELECTOR;
/** Default is 1.0 */
@property (assign, nonatomic) CGFloat coverAlpha UI_APPEARANCE_SELECTOR;
/** Default is UIColor.whiteColor */
@property (strong, nonatomic, nullable) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;
/** Default is nil */
@property (strong, nonatomic, nullable) UIBlurEffect *backgroundBlurEffect UI_APPEARANCE_SELECTOR;
/**
 Default:
 if (style == LGAlertViewStyleAlert || iOS < 9.0) then 44.0
 else 56.0
 */
@property (assign, nonatomic) CGFloat buttonsHeight UI_APPEARANCE_SELECTOR;
/** Default is 44.0 */
@property (assign, nonatomic) CGFloat textFieldsHeight UI_APPEARANCE_SELECTOR;
/**
 Top and bottom offsets from borders of the screen
 Default is 8.0
 */
@property (assign, nonatomic) CGFloat offsetVertical UI_APPEARANCE_SELECTOR;
/**
 Offset between cancel button and main view when style is LGAlertViewStyleActionSheet
 Default is 8.0
 */
@property (assign, nonatomic) CGFloat cancelButtonOffsetY UI_APPEARANCE_SELECTOR;
/** Default is NSNotFound */
@property (assign, nonatomic) CGFloat heightMax UI_APPEARANCE_SELECTOR;
/**
 Default:
 if (style == LGAlertViewStyleAlert) then 280.0
 else if (iPad) then 304.0
 else window.width - 16.0
 */
@property (assign, nonatomic) CGFloat width UI_APPEARANCE_SELECTOR;
/** Default is [UIColor colorWithWhite:0.85 alpha:1.0] */
@property (strong, nonatomic, nullable) UIColor *separatorsColor UI_APPEARANCE_SELECTOR;
/** Default is UIScrollViewIndicatorStyleBlack */
@property (assign, nonatomic) UIScrollViewIndicatorStyle indicatorStyle UI_APPEARANCE_SELECTOR;
/** Default is NO */
@property (assign, nonatomic, getter=isShowsVerticalScrollIndicator) BOOL showsVerticalScrollIndicator UI_APPEARANCE_SELECTOR;
/** Default is NO */
@property (assign, nonatomic, getter=isPadShowsActionSheetFromBottom) BOOL padShowsActionSheetFromBottom UI_APPEARANCE_SELECTOR;
/** Default is NO */
@property (assign, nonatomic, getter=isOneRowOneButton) BOOL oneRowOneButton UI_APPEARANCE_SELECTOR;
/** Default is YES */
@property (assign, nonatomic) BOOL shouldDismissAnimated UI_APPEARANCE_SELECTOR;

#pragma marl - Layer properties

/**
 Default:
 if (iOS < 9.0) then 6.0
 else 12.0
 */
@property (assign, nonatomic) CGFloat layerCornerRadius UI_APPEARANCE_SELECTOR;
/** Default is nil */
@property (strong, nonatomic, nullable) UIColor *layerBorderColor UI_APPEARANCE_SELECTOR;
/** Default is 0.0 */
@property (assign, nonatomic) CGFloat layerBorderWidth UI_APPEARANCE_SELECTOR;
/** Default is nil */
@property (strong, nonatomic, nullable) UIColor *layerShadowColor UI_APPEARANCE_SELECTOR;
/** Default is 0.0 */
@property (assign, nonatomic) CGFloat layerShadowRadius UI_APPEARANCE_SELECTOR;
/** Default is CGPointZero */
@property (assign, nonatomic) CGPoint layerShadowOffset UI_APPEARANCE_SELECTOR;

#pragma mark - Animation properties

/** Default is 0.5 */
@property (assign, nonatomic) NSTimeInterval animationDuration UI_APPEARANCE_SELECTOR;

/**
 Only if (style == LGAlertViewStyleAlert)
 Default is 1.2
 */
@property (assign, nonatomic) CGFloat initialScale UI_APPEARANCE_SELECTOR;

/**
 Only if (style == LGAlertViewStyleAlert)
 Default is 0.95
 */
@property (assign, nonatomic) CGFloat finalScale UI_APPEARANCE_SELECTOR;

#pragma mark - Title properties

@property (copy, nonatomic, readonly, nullable) NSString *title;

/**
 Default:
 if (style == LGAlertViewStyleAlert) then UIColor.blackColor
 else UIColor.grayColor
 */
@property (strong, nonatomic, nullable) UIColor *titleTextColor UI_APPEARANCE_SELECTOR;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment titleTextAlignment UI_APPEARANCE_SELECTOR;
/**
 Default:
 if (style == LGAlertViewStyleAlert) then [UIFont boldSystemFontOfSize:18.0]
 else [UIFont boldSystemFontOfSize:14.0]
 */
@property (strong, nonatomic, nullable) UIFont *titleFont UI_APPEARANCE_SELECTOR;

#pragma mark - Message properties

@property (copy, nonatomic, readonly, nullable) NSString *message;

/**
 Default:
 if (style == LGAlertViewStyleAlert) then UIColor.blackColor
 else UIColor.grayColor
 */
@property (strong, nonatomic, nullable) UIColor *messageTextColor UI_APPEARANCE_SELECTOR;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment messageTextAlignment UI_APPEARANCE_SELECTOR;
/** Default is [UIFont systemFontOfSize:14.0] */
@property (strong, nonatomic, nullable) UIFont *messageFont UI_APPEARANCE_SELECTOR;

#pragma mark - Buttons properties

@property (copy, nonatomic, readonly, nullable) NSArray *buttonTitles;
/** Default is YES */
@property (assign, nonatomic, getter=isCancelButtonEnabled) BOOL buttonsEnabled;
@property (copy, nonatomic, nullable) NSArray *buttonsIconImages;
@property (copy, nonatomic, nullable) NSArray *buttonsIconImagesHighlighted;
@property (copy, nonatomic, nullable) NSArray *buttonsIconImagesDisabled;

/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *buttonsTitleColor UI_APPEARANCE_SELECTOR;
/** Default is UIColor.whiteColor */
@property (strong, nonatomic, nullable) UIColor *buttonsTitleColorHighlighted UI_APPEARANCE_SELECTOR;
/** Default is UIColor.grayColor */
@property (strong, nonatomic, nullable) UIColor *buttonsTitleColorDisabled UI_APPEARANCE_SELECTOR;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment buttonsTextAlignment UI_APPEARANCE_SELECTOR;
/** Default is [UIFont systemFontOfSize:18.0] */
@property (strong, nonatomic, nullable) UIFont *buttonsFont UI_APPEARANCE_SELECTOR;
/** Default is UIColor.clearColor */
@property (strong, nonatomic, nullable) UIColor *buttonsBackgroundColor UI_APPEARANCE_SELECTOR;
/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *buttonsBackgroundColorHighlighted UI_APPEARANCE_SELECTOR;
/** Default is UIColor.clearColor */
@property (strong, nonatomic, nullable) UIColor *buttonsBackgroundColorDisabled UI_APPEARANCE_SELECTOR;
/** Default is 1 */
@property (assign, nonatomic) NSUInteger buttonsNumberOfLines UI_APPEARANCE_SELECTOR;
/** Default is NSLineBreakByTruncatingMiddle */
@property (assign, nonatomic) NSLineBreakMode buttonsLineBreakMode UI_APPEARANCE_SELECTOR;
/** Default is 14.0 / 18.0 */
@property (assign, nonatomic) CGFloat buttonsMinimumScaleFactor UI_APPEARANCE_SELECTOR;
/** Default is YES */
@property (assign, nonatomic, getter=isButtonsAdjustsFontSizeToFitWidth) BOOL buttonsAdjustsFontSizeToFitWidth UI_APPEARANCE_SELECTOR;
/** Default is LGAlertViewButtonIconPositionLeft */
@property (assign, nonatomic) LGAlertViewButtonIconPosition buttonsIconPosition UI_APPEARANCE_SELECTOR;

#pragma mark - Cancel button properties

@property (copy, nonatomic, readonly, nullable) NSString *cancelButtonTitle;
/** Default is YES */
@property (assign, nonatomic, getter=isCancelButtonEnabled) BOOL cancelButtonEnabled;
@property (strong, nonatomic, nullable) UIImage *cancelButtonIconImage;
@property (strong, nonatomic, nullable) UIImage *cancelButtonIconImageHighlighted;
@property (strong, nonatomic, nullable) UIImage *cancelButtonIconImageDisabled;

/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *cancelButtonTitleColor UI_APPEARANCE_SELECTOR;
/** Default is UIColor.whiteColor */
@property (strong, nonatomic, nullable) UIColor *cancelButtonTitleColorHighlighted UI_APPEARANCE_SELECTOR;
/** Default is UIColor.grayColor */
@property (strong, nonatomic, nullable) UIColor *cancelButtonTitleColorDisabled UI_APPEARANCE_SELECTOR;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment cancelButtonTextAlignment UI_APPEARANCE_SELECTOR;
/** Default is [UIFont boldSystemFontOfSize:18.0] */
@property (strong, nonatomic, nullable) UIFont *cancelButtonFont UI_APPEARANCE_SELECTOR;
/** Default is UIColor.clearColor */
@property (strong, nonatomic, nullable) UIColor *cancelButtonBackgroundColor UI_APPEARANCE_SELECTOR;
/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *cancelButtonBackgroundColorHighlighted UI_APPEARANCE_SELECTOR;
/** Default is UIColor.clearColor */
@property (strong, nonatomic, nullable) UIColor *cancelButtonBackgroundColorDisabled UI_APPEARANCE_SELECTOR;
/** Default is 1 */
@property (assign, nonatomic) NSUInteger cancelButtonNumberOfLines UI_APPEARANCE_SELECTOR;
/** Default is NSLineBreakByTruncatingMiddle */
@property (assign, nonatomic) NSLineBreakMode cancelButtonLineBreakMode UI_APPEARANCE_SELECTOR;
/** Default is 14.0 / 18.0 */
@property (assign, nonatomic) CGFloat cancelButtonMinimumScaleFactor UI_APPEARANCE_SELECTOR;
/** Default is YES */
@property (assign, nonatomic, getter=isCancelButtonAdjustsFontSizeToFitWidth) BOOL cancelButtonAdjustsFontSizeToFitWidth UI_APPEARANCE_SELECTOR;
/** Default is LGAlertViewButtonIconPositionLeft */
@property (assign, nonatomic) LGAlertViewButtonIconPosition cancelButtonIconPosition UI_APPEARANCE_SELECTOR;

#pragma mark - Destructive button properties

@property (copy, nonatomic, readonly, nullable) NSString *destructiveButtonTitle;
/** Default is YES */
@property (assign, nonatomic, getter=isDestructiveButtonEnabled) BOOL destructiveButtonEnabled;
@property (strong, nonatomic, nullable) UIImage *destructiveButtonIconImage;
@property (strong, nonatomic, nullable) UIImage *destructiveButtonIconImageHighlighted;
@property (strong, nonatomic, nullable) UIImage *destructiveButtonIconImageDisabled;

/** Default is UIColor.redColor */
@property (strong, nonatomic, nullable) UIColor *destructiveButtonTitleColor UI_APPEARANCE_SELECTOR;
/** Default is UIColor.whiteColor */
@property (strong, nonatomic, nullable) UIColor *destructiveButtonTitleColorHighlighted UI_APPEARANCE_SELECTOR;
/** Default is UIColor.grayColor */
@property (strong, nonatomic, nullable) UIColor *destructiveButtonTitleColorDisabled UI_APPEARANCE_SELECTOR;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment destructiveButtonTextAlignment UI_APPEARANCE_SELECTOR;
/** Default is [UIFont systemFontOfSize:18.0] */
@property (strong, nonatomic, nullable) UIFont *destructiveButtonFont UI_APPEARANCE_SELECTOR;
/** Default is UIColor.clearColor */
@property (strong, nonatomic, nullable) UIColor *destructiveButtonBackgroundColor UI_APPEARANCE_SELECTOR;
/** Default is UIColor.redColor */
@property (strong, nonatomic, nullable) UIColor *destructiveButtonBackgroundColorHighlighted UI_APPEARANCE_SELECTOR;
/** Default is UIColor.clearColor */
@property (strong, nonatomic, nullable) UIColor *destructiveButtonBackgroundColorDisabled UI_APPEARANCE_SELECTOR;
/** Default is 1 */
@property (assign, nonatomic) NSUInteger destructiveButtonNumberOfLines UI_APPEARANCE_SELECTOR;
/** Default is NSLineBreakByTruncatingMiddle */
@property (assign, nonatomic) NSLineBreakMode destructiveButtonLineBreakMode UI_APPEARANCE_SELECTOR;
/** Default is 14.0 / 18.0 */
@property (assign, nonatomic) CGFloat destructiveButtonMinimumScaleFactor UI_APPEARANCE_SELECTOR;
/** Default is YES */
@property (assign, nonatomic, getter=isDestructiveButtonAdjustsFontSizeToFitWidth) BOOL destructiveButtonAdjustsFontSizeToFitWidth UI_APPEARANCE_SELECTOR;
/** Default is LGAlertViewButtonIconPositionLeft */
@property (assign, nonatomic) LGAlertViewButtonIconPosition destructiveButtonIconPosition UI_APPEARANCE_SELECTOR;

#pragma mark - Activity indicator properties

/** Default is UIActivityIndicatorViewStyleWhiteLarge */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle UI_APPEARANCE_SELECTOR;
/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *activityIndicatorViewColor UI_APPEARANCE_SELECTOR;

#pragma mark - Progress view properties

@property (assign, nonatomic) float progress;

/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *progressViewProgressTintColor UI_APPEARANCE_SELECTOR;
/** Default is [UIColor colorWithWhite:0.8 alpha:1.0] */
@property (strong, nonatomic, nullable) UIColor *progressViewTrackTintColor UI_APPEARANCE_SELECTOR;
/** Default is nil */
@property (strong, nonatomic, nullable) UIImage *progressViewProgressImage UI_APPEARANCE_SELECTOR;
/** Default is nil */
@property (strong, nonatomic, nullable) UIImage *progressViewTrackImage UI_APPEARANCE_SELECTOR;

#pragma mark - Progress label properties

@property (strong, nonatomic, nullable) NSString *progressLabelText;

/** Default is UIColor.blackColor */
@property (strong, nonatomic, nullable) UIColor *progressLabelTextColor UI_APPEARANCE_SELECTOR;
/** Defailt is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment progressLabelTextAlignment UI_APPEARANCE_SELECTOR;
/** Default is [UIFont systemFontOfSize:14.0] */
@property (strong, nonatomic, nullable) UIFont *progressLabelFont UI_APPEARANCE_SELECTOR;
/** Default is 1 */
@property (assign, nonatomic) NSUInteger progressLabelNumberOfLines UI_APPEARANCE_SELECTOR;
/** Default is NSLineBreakByTruncatingTail */
@property (assign, nonatomic) NSLineBreakMode progressLabelLineBreakMode UI_APPEARANCE_SELECTOR;

#pragma mark - Text fields properties

/** Default is [UIColor colorWithWhite:0.97 alpha:1.0] */
@property (strong, nonatomic, nullable) UIColor *textFieldsBackgroundColor UI_APPEARANCE_SELECTOR;
/** Default is UIColor.blackColor */
@property (strong, nonatomic, nullable) UIColor *textFieldsTextColor UI_APPEARANCE_SELECTOR;
/** Default is [UIFont systemFontOfSize:16.0] */
@property (strong, nonatomic, nullable) UIFont *textFieldsFont UI_APPEARANCE_SELECTOR;
/** Default is NSTextAlignmentLeft */
@property (assign, nonatomic) NSTextAlignment textFieldsTextAlignment UI_APPEARANCE_SELECTOR;
/** Default is NO */
@property (assign, nonatomic) BOOL textFieldsClearsOnBeginEditing UI_APPEARANCE_SELECTOR;
/** Default is NO */
@property (assign, nonatomic) BOOL textFieldsAdjustsFontSizeToFitWidth UI_APPEARANCE_SELECTOR;
/** Default is 12.0 */
@property (assign, nonatomic) CGFloat textFieldsMinimumFontSize UI_APPEARANCE_SELECTOR;
/** Default is UITextFieldViewModeAlways */
@property (assign, nonatomic) UITextFieldViewMode textFieldsClearButtonMode UI_APPEARANCE_SELECTOR;

#pragma mark - Callbacks

/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) LGAlertViewHandler willShowHandler;
/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) LGAlertViewHandler didShowHandler;

/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) LGAlertViewHandler willDismissHandler;
/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) LGAlertViewHandler didDismissHandler;

/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) LGAlertViewActionHandler actionHandler;
/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) LGAlertViewHandler cancelHandler;
/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) LGAlertViewHandler destructiveHandler;

/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) LGAlertViewActionHandler didDismissAfterActionHandler;
/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) LGAlertViewHandler didDismissAfterCancelHandler;
/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) LGAlertViewHandler didDismissAfterDestructiveHandler;

/**
 You can use this block to add some custom animations
 To avoid retain cycle, do not forget about weak reference to self
 */
@property (copy, nonatomic, nullable) LGAlertViewAnimationsBlock showAnimationsBlock;
/**
 You can use this block to add some custom animations
 To avoid retain cycle, do not forget about weak reference to self
 */
@property (copy, nonatomic, nullable) LGAlertViewAnimationsBlock dismissAnimationsBlock;

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
                                        progressLabelText:(nullable NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle;

- (nonnull instancetype)initWithProgressViewAndTitle:(nullable NSString *)title
                                             message:(nullable NSString *)message
                                               style:(LGAlertViewStyle)style
                                            progress:(float)progress
                                   progressLabelText:(nullable NSString *)progressLabelText
                                        buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                              destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle;

/** To avoid retain cycle, do not forget about weak reference to self for textFieldsSetupHandler block */
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
                                             progressLabelText:(nullable NSString *)progressLabelText
                                                  buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                        destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle;

+ (nonnull instancetype)alertViewWithProgressViewAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                                 progress:(float)progress
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

/** To avoid retain cycle, do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                                style:(LGAlertViewStyle)style
                         buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
               destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                        actionHandler:(LGAlertViewActionHandler)actionHandler
                        cancelHandler:(LGAlertViewHandler)cancelHandler
                   destructiveHandler:(LGAlertViewHandler)destructiveHandler;

/** To avoid retain cycle, do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
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

/** To avoid retain cycle, do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
- (nonnull instancetype)initWithActivityIndicatorAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                        progressLabelText:(nullable NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                            actionHandler:(LGAlertViewActionHandler)actionHandler
                                            cancelHandler:(LGAlertViewHandler)cancelHandler
                                       destructiveHandler:(LGAlertViewHandler)destructiveHandler;

/** To avoid retain cycle, do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
- (nonnull instancetype)initWithProgressViewAndTitle:(nullable NSString *)title
                                             message:(nullable NSString *)message
                                               style:(LGAlertViewStyle)style
                                            progress:(float)progress
                                   progressLabelText:(nullable NSString *)progressLabelText
                                        buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                              destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                       actionHandler:(LGAlertViewActionHandler)actionHandler
                                       cancelHandler:(LGAlertViewHandler)cancelHandler
                                  destructiveHandler:(LGAlertViewHandler)destructiveHandler;

/** To avoid retain cycle, do not forget about weak reference to self for textFieldsSetupHandler, actionHandler, cancelHandler and destructiveHandler blocks */
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

/** To avoid retain cycle, do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (nonnull instancetype)alertViewWithTitle:(nullable NSString *)title
                                   message:(nullable NSString *)message
                                     style:(LGAlertViewStyle)style
                              buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                         cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                    destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                             actionHandler:(LGAlertViewActionHandler)actionHandler
                             cancelHandler:(LGAlertViewHandler)cancelHandler
                        destructiveHandler:(LGAlertViewHandler)destructiveHandler;

/** To avoid retain cycle, do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
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

/** To avoid retain cycle, do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (nonnull instancetype)alertViewWithActivityIndicatorAndTitle:(nullable NSString *)title
                                                       message:(nullable NSString *)message
                                                         style:(LGAlertViewStyle)style
                                             progressLabelText:(nullable NSString *)progressLabelText
                                                  buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                        destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                                 actionHandler:(LGAlertViewActionHandler)actionHandler
                                                 cancelHandler:(LGAlertViewHandler)cancelHandler
                                            destructiveHandler:(LGAlertViewHandler)destructiveHandler;

/** To avoid retain cycle, do not forget about weak reference to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (nonnull instancetype)alertViewWithProgressViewAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                                 progress:(float)progress
                                        progressLabelText:(nullable NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                            actionHandler:(LGAlertViewActionHandler)actionHandler
                                            cancelHandler:(LGAlertViewHandler)cancelHandler
                                       destructiveHandler:(LGAlertViewHandler)destructiveHandler;

/** To avoid retain cycle, do not forget about weak reference to self for textFieldsSetupHandler, actionHandler, cancelHandler and destructiveHandler blocks */
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
                                        progressLabelText:(nullable NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                                 delegate:(nullable id<LGAlertViewDelegate>)delegate;

- (nonnull instancetype)initWithProgressViewAndTitle:(nullable NSString *)title
                                             message:(nullable NSString *)message
                                               style:(LGAlertViewStyle)style
                                            progress:(float)progress
                                   progressLabelText:(nullable NSString *)progressLabelText
                                        buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                              destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                            delegate:(nullable id<LGAlertViewDelegate>)delegate;

/** To avoid retain cycle, do not forget about weak reference to self for textFieldsSetupHandler block */
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
                                             progressLabelText:(nullable NSString *)progressLabelText
                                                  buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                        destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                                      delegate:(nullable id<LGAlertViewDelegate>)delegate;

+ (nonnull instancetype)alertViewWithProgressViewAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                                 progress:(float)progress
                                        progressLabelText:(nullable NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                                 delegate:(nullable id<LGAlertViewDelegate>)delegate;

/** To avoid retain cycle, do not forget about weak reference to self for textFieldsSetupHandler block */
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

#pragma mark - Unavailable

- (nonnull instancetype)init __attribute__((unavailable("use \"- initWith...\" instead")));
+ (nonnull instancetype)new __attribute__((unavailable("use \"+ alertViewWith...\" instead")));

@end

#pragma mark - Delegate

@protocol LGAlertViewDelegate <NSObject>

@optional

- (void)alertViewWillShow:(nonnull LGAlertView *)alertView;
- (void)alertViewDidShow:(nonnull LGAlertView *)alertView;

- (void)alertViewWillDismiss:(nonnull LGAlertView *)alertView;
- (void)alertViewDidDismiss:(nonnull LGAlertView *)alertView;

- (void)alertView:(nonnull LGAlertView *)alertView clickedButtonAtIndex:(NSUInteger)index title:(nullable NSString *)title;
- (void)alertViewCancelled:(nonnull LGAlertView *)alertView;
- (void)alertViewDestructed:(nonnull LGAlertView *)alertView;

- (void)alertView:(nonnull LGAlertView *)alertView didDismissAfterClickedButtonAtIndex:(NSUInteger)index title:(nullable NSString *)title;
- (void)alertViewDidDismissAfterCancelled:(nonnull LGAlertView *)alertView;
- (void)alertViewDidDismissAfterDestructed:(nonnull LGAlertView *)alertView;

/** You can use this method to add some custom animations */
- (void)showAnimationsForAlertView:(nonnull LGAlertView *)alertView duration:(NSTimeInterval)duration;
/** You can use this method to add some custom animations */
- (void)dismissAnimationsForAlertView:(nonnull LGAlertView *)alertView duration:(NSTimeInterval)duration;

// DEPRECATED

- (void)alertView:(nonnull LGAlertView *)alertView buttonPressedWithTitle:(nullable NSString *)title index:(NSUInteger)index
DEPRECATED_MSG_ATTRIBUTE("use alertView:clickedButtonAtIndex:title: instead");
- (void)alertViewDestructiveButtonPressed:(nonnull LGAlertView *)alertView
DEPRECATED_MSG_ATTRIBUTE("use alertViewDidDismissAfterDestructed: instead");

@end

#pragma mark - Deprecated

@interface LGAlertView (Deprecated)

@property (assign, nonatomic) CGFloat layerShadowOpacity
DEPRECATED_MSG_ATTRIBUTE("use layerShadowColor alpha component instead");

- (void)setButtonAtIndex:(NSUInteger)index enabled:(BOOL)enabled
DEPRECATED_MSG_ATTRIBUTE("use setButtonEnabled:atIndex: instead");

@end
