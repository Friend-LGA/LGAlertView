//
//  LGActionView.h
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
#import "LGAlertViewButtonProperties.h"

@class LGAlertView;

static NSString *const kLGAlertViewWillShowNotification    = @"LGAlertViewWillShowNotification";
static NSString *const kLGAlertViewWillDismissNotification = @"LGAlertViewWillDismissNotification";
static NSString *const kLGAlertViewDidShowNotification     = @"LGAlertViewDidShowNotification";
static NSString *const kLGAlertViewDidDismissNotification  = @"LGAlertViewDidDismissNotification";
static NSString *const kLGAlertViewActionNotification      = @"LGAlertViewActionNotification";
static NSString *const kLGAlertViewCancelNotification      = @"LGAlertViewCancelNotification";
static NSString *const kLGAlertViewDestructiveNotification = @"LGAlertViewDestructiveNotification";

@protocol LGAlertViewDelegate <NSObject>

@optional

- (void)alertViewWillShow:(LGAlertView *)alertView;
- (void)alertViewWillDismiss:(LGAlertView *)alertView;
- (void)alertViewDidShow:(LGAlertView *)alertView;
- (void)alertViewDidDismiss:(LGAlertView *)alertView;
- (void)alertView:(LGAlertView *)alertView buttonPressedWithTitle:(NSString *)title index:(NSUInteger)index;
- (void)alertViewCancelled:(LGAlertView *)alertView;
- (void)alertViewDestructiveButtonPressed:(LGAlertView *)alertView;

@end

@interface LGAlertView : NSObject

typedef NS_ENUM(NSUInteger, LGAlertViewStyle)
{
    LGAlertViewStyleAlert       = 0,
    LGAlertViewStyleActionSheet = 1
};

typedef NS_ENUM(NSUInteger, LGAlertViewWindowLevel)
{
    LGAlertViewWindowLevelAboveStatusBar = 0,
    LGAlertViewWindowLevelBelowStatusBar = 1
};

@property (assign, nonatomic, getter=isShowing) BOOL showing;
/** Default is LGAlertViewWindowLevelAboveStatusBar */
@property (assign, nonatomic) LGAlertViewWindowLevel windowLevel;
/** Default is YES */
@property (assign, nonatomic, getter=isCancelOnTouch) BOOL cancelOnTouch;
/** Dismiss alert view on action, cancel and destructive */
@property (assign, nonatomic, getter=isDismissOnAction) BOOL dismissOnAction;
/** Set highlighted buttons background color to blue, and set highlighted destructive button background color to red. Default is YES */
@property (assign, nonatomic, getter=isColorful) BOOL colorful;
/** Set colors of buttons title and background, cancel button title and background, activity indicator and progress view */
@property (strong, nonatomic) UIColor *tintColor;
@property (strong, nonatomic) UIColor *coverColor;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (assign, nonatomic) CGFloat buttonsHeight;
@property (assign, nonatomic) CGFloat textFieldsHeight;
/** Top and bottom offsets from borders of the screen */
@property (assign, nonatomic) CGFloat offsetVertical;
/** Offset between cancel button and main view when style is LGAlertViewStyleActionSheet. Default is 8.f */
@property (assign, nonatomic) CGFloat cancelButtonOffsetY;
@property (assign, nonatomic) CGFloat heightMax;
@property (assign, nonatomic) CGFloat width;

@property (assign, nonatomic) CGFloat layerCornerRadius;
@property (strong, nonatomic) UIColor *layerBorderColor;
@property (assign, nonatomic) CGFloat layerBorderWidth;
@property (strong, nonatomic) UIColor *layerShadowColor;
@property (assign, nonatomic) CGFloat layerShadowRadius;
@property (assign, nonatomic) CGFloat layerShadowOpacity;
@property (assign, nonatomic) CGSize  layerShadowOffset;

@property (strong, nonatomic) UIColor         *titleTextColor;
@property (assign, nonatomic) NSTextAlignment titleTextAlignment;
@property (strong, nonatomic) UIFont          *titleFont;

@property (strong, nonatomic) UIColor         *messageTextColor;
@property (assign, nonatomic) NSTextAlignment messageTextAlignment;
@property (strong, nonatomic) UIFont          *messageFont;

@property (strong, nonatomic) UIColor         *buttonsTitleColor;
@property (strong, nonatomic) UIColor         *buttonsTitleColorHighlighted;
@property (strong, nonatomic) UIColor         *buttonsTitleColorDisabled;
@property (assign, nonatomic) NSTextAlignment buttonsTextAlignment;
@property (strong, nonatomic) UIFont          *buttonsFont;
@property (strong, nonatomic) UIColor         *buttonsBackgroundColor;
@property (strong, nonatomic) UIColor         *buttonsBackgroundColorHighlighted;
@property (strong, nonatomic) UIColor         *buttonsBackgroundColorDisabled;
@property (assign, nonatomic) NSUInteger      buttonsNumberOfLines;
@property (assign, nonatomic) NSLineBreakMode buttonsLineBreakMode;
@property (assign, nonatomic) CGFloat         buttonsMinimumScaleFactor;
@property (assign, nonatomic, getter=isButtonsAdjustsFontSizeToFitWidth) BOOL buttonsAdjustsFontSizeToFitWidth;
@property (assign, nonatomic, getter=isCancelButtonEnabled) BOOL buttonsEnabled;

@property (strong, nonatomic) UIColor         *cancelButtonTitleColor;
@property (strong, nonatomic) UIColor         *cancelButtonTitleColorHighlighted;
@property (strong, nonatomic) UIColor         *cancelButtonTitleColorDisabled;
@property (assign, nonatomic) NSTextAlignment cancelButtonTextAlignment;
@property (strong, nonatomic) UIFont          *cancelButtonFont;
@property (strong, nonatomic) UIColor         *cancelButtonBackgroundColor;
@property (strong, nonatomic) UIColor         *cancelButtonBackgroundColorHighlighted;
@property (strong, nonatomic) UIColor         *cancelButtonBackgroundColorDisabled;
@property (assign, nonatomic) NSUInteger      cancelButtonNumberOfLines;
@property (assign, nonatomic) NSLineBreakMode cancelButtonLineBreakMode;
@property (assign, nonatomic) CGFloat         cancelButtonMinimumScaleFactor;
@property (assign, nonatomic, getter=isCancelButtonAdjustsFontSizeToFitWidth) BOOL cancelButtonAdjustsFontSizeToFitWidth;
@property (assign, nonatomic, getter=isCancelButtonEnabled) BOOL cancelButtonEnabled;

@property (strong, nonatomic) UIColor         *destructiveButtonTitleColor;
@property (strong, nonatomic) UIColor         *destructiveButtonTitleColorHighlighted;
@property (strong, nonatomic) UIColor         *destructiveButtonTitleColorDisabled;
@property (assign, nonatomic) NSTextAlignment destructiveButtonTextAlignment;
@property (strong, nonatomic) UIFont          *destructiveButtonFont;
@property (strong, nonatomic) UIColor         *destructiveButtonBackgroundColor;
@property (strong, nonatomic) UIColor         *destructiveButtonBackgroundColorHighlighted;
@property (strong, nonatomic) UIColor         *destructiveButtonBackgroundColorDisabled;
@property (assign, nonatomic) NSUInteger      destructiveButtonNumberOfLines;
@property (assign, nonatomic) NSLineBreakMode destructiveButtonLineBreakMode;
@property (assign, nonatomic) CGFloat         destructiveButtonMinimumScaleFactor;
@property (assign, nonatomic, getter=isDestructiveButtonAdjustsFontSizeToFitWidth) BOOL destructiveButtonAdjustsFontSizeToFitWidth;
@property (assign, nonatomic, getter=isDestructiveButtonEnabled) BOOL destructiveButtonEnabled;

@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (strong, nonatomic) UIColor                      *activityIndicatorViewColor;

@property (strong, nonatomic) UIColor         *progressViewProgressTintColor;
@property (strong, nonatomic) UIColor         *progressViewTrackTintColor;
@property (strong, nonatomic) UIImage         *progressViewProgressImage;
@property (strong, nonatomic) UIImage         *progressViewTrackImage;
@property (strong, nonatomic) UIColor         *progressLabelTextColor;
@property (assign, nonatomic) NSTextAlignment progressLabelTextAlignment;
@property (strong, nonatomic) UIFont          *progressLabelFont;
@property (assign, nonatomic, readonly) float progress;

@property (strong, nonatomic) UIColor *separatorsColor;
@property (assign, nonatomic) UIScrollViewIndicatorStyle indicatorStyle;
@property (assign, nonatomic, getter=isShowsVerticalScrollIndicator) BOOL showsVerticalScrollIndicator;
@property (assign, nonatomic, getter=isPadShowActionSheetFromBottom) BOOL padShowsActionSheetFromBottom;
@property (assign, nonatomic, getter=isOneRowOneButton) BOOL oneRowOneButton;

@property (strong, nonatomic, readonly) NSMutableArray *textFieldsArray;

/** Do not forget about weak referens to self */
@property (strong, nonatomic) void (^willShowHandler)(LGAlertView *alertView);
/** Do not forget about weak referens to self */
@property (strong, nonatomic) void (^willDismissHandler)(LGAlertView *alertView);
/** Do not forget about weak referens to self */
@property (strong, nonatomic) void (^didShowHandler)(LGAlertView *alertView);
/** Do not forget about weak referens to self */
@property (strong, nonatomic) void (^didDismissHandler)(LGAlertView *alertView);

/** Do not forget about weak referens to self */
@property (strong, nonatomic) void (^actionHandler)(LGAlertView *alertView, NSString *title, NSUInteger index);
/** Do not forget about weak referens to self */
@property (strong, nonatomic) void (^cancelHandler)(LGAlertView *alertView);
/** Do not forget about weak referens to self */
@property (strong, nonatomic) void (^destructiveHandler)(LGAlertView *alertView);

@property (assign, nonatomic) id<LGAlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                        style:(LGAlertViewStyle)style
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle;

- (instancetype)initWithViewAndTitle:(NSString *)title
                             message:(NSString *)message
                               style:(LGAlertViewStyle)style
                                view:(UIView *)view
                        buttonTitles:(NSArray *)buttonTitles
                   cancelButtonTitle:(NSString *)cancelButtonTitle
              destructiveButtonTitle:(NSString *)destructiveButtonTitle;

- (instancetype)initWithActivityIndicatorAndTitle:(NSString *)title
                                          message:(NSString *)message
                                            style:(LGAlertViewStyle)style
                                     buttonTitles:(NSArray *)buttonTitles
                                cancelButtonTitle:(NSString *)cancelButtonTitle
                           destructiveButtonTitle:(NSString *)destructiveButtonTitle;

- (instancetype)initWithProgressViewAndTitle:(NSString *)title
                                     message:(NSString *)message
                                       style:(LGAlertViewStyle)style
                           progressLabelText:(NSString *)progressLabelText
                                buttonTitles:(NSArray *)buttonTitles
                           cancelButtonTitle:(NSString *)cancelButtonTitle
                      destructiveButtonTitle:(NSString *)destructiveButtonTitle;

- (instancetype)initWithTextFieldsAndTitle:(NSString *)title
                                   message:(NSString *)message
                        numberOfTextFields:(NSUInteger)numberOfTextFields
                    textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                              buttonTitles:(NSArray *)buttonTitles
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                    destructiveButtonTitle:(NSString *)destructiveButtonTitle;

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                             style:(LGAlertViewStyle)style
                      buttonTitles:(NSArray *)buttonTitles
                 cancelButtonTitle:(NSString *)cancelButtonTitle
            destructiveButtonTitle:(NSString *)destructiveButtonTitle;

+ (instancetype)alertViewWithViewAndTitle:(NSString *)title
                                  message:(NSString *)message
                                    style:(LGAlertViewStyle)style
                                     view:(UIView *)view
                             buttonTitles:(NSArray *)buttonTitles
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle;

+ (instancetype)alertViewWithActivityIndicatorAndTitle:(NSString *)title
                                               message:(NSString *)message
                                                 style:(LGAlertViewStyle)style
                                          buttonTitles:(NSArray *)buttonTitles
                                     cancelButtonTitle:(NSString *)cancelButtonTitle
                                destructiveButtonTitle:(NSString *)destructiveButtonTitle;

+ (instancetype)alertViewWithProgressViewAndTitle:(NSString *)title
                                          message:(NSString *)message
                                            style:(LGAlertViewStyle)style
                                progressLabelText:(NSString *)progressLabelText
                                     buttonTitles:(NSArray *)buttonTitles
                                cancelButtonTitle:(NSString *)cancelButtonTitle
                           destructiveButtonTitle:(NSString *)destructiveButtonTitle;

+ (instancetype)alertViewWithTextFieldsAndTitle:(NSString *)title
                                        message:(NSString *)message
                             numberOfTextFields:(NSUInteger)numberOfTextFields
                         textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                                   buttonTitles:(NSArray *)buttonTitles
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle;

#pragma mark -

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                        style:(LGAlertViewStyle)style
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
                actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
           destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
- (instancetype)initWithViewAndTitle:(NSString *)title
                             message:(NSString *)message
                               style:(LGAlertViewStyle)style
                                view:(UIView *)view
                        buttonTitles:(NSArray *)buttonTitles
                   cancelButtonTitle:(NSString *)cancelButtonTitle
              destructiveButtonTitle:(NSString *)destructiveButtonTitle
                       actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                       cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                  destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
- (instancetype)initWithActivityIndicatorAndTitle:(NSString *)title
                                          message:(NSString *)message
                                            style:(LGAlertViewStyle)style
                                     buttonTitles:(NSArray *)buttonTitles
                                cancelButtonTitle:(NSString *)cancelButtonTitle
                           destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                    actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                    cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                               destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
- (instancetype)initWithProgressViewAndTitle:(NSString *)title
                                     message:(NSString *)message
                                       style:(LGAlertViewStyle)style
                           progressLabelText:(NSString *)progressLabelText
                                buttonTitles:(NSArray *)buttonTitles
                           cancelButtonTitle:(NSString *)cancelButtonTitle
                      destructiveButtonTitle:(NSString *)destructiveButtonTitle
                               actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                               cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                          destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
- (instancetype)initWithTextFieldsAndTitle:(NSString *)title
                                   message:(NSString *)message
                        numberOfTextFields:(NSUInteger)numberOfTextFields
                    textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                              buttonTitles:(NSArray *)buttonTitles
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                    destructiveButtonTitle:(NSString *)destructiveButtonTitle
                             actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                             cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                        destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                             style:(LGAlertViewStyle)style
                      buttonTitles:(NSArray *)buttonTitles
                 cancelButtonTitle:(NSString *)cancelButtonTitle
            destructiveButtonTitle:(NSString *)destructiveButtonTitle
                     actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                     cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (instancetype)alertViewWithViewAndTitle:(NSString *)title
                                  message:(NSString *)message
                                    style:(LGAlertViewStyle)style
                                     view:(UIView *)view
                             buttonTitles:(NSArray *)buttonTitles
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
                            actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                            cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                       destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (instancetype)alertViewWithActivityIndicatorAndTitle:(NSString *)title
                                               message:(NSString *)message
                                                 style:(LGAlertViewStyle)style
                                          buttonTitles:(NSArray *)buttonTitles
                                     cancelButtonTitle:(NSString *)cancelButtonTitle
                                destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                         actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                         cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                                    destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (instancetype)alertViewWithProgressViewAndTitle:(NSString *)title
                                          message:(NSString *)message
                                            style:(LGAlertViewStyle)style
                                progressLabelText:(NSString *)progressLabelText
                                     buttonTitles:(NSArray *)buttonTitles
                                cancelButtonTitle:(NSString *)cancelButtonTitle
                           destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                    actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                    cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                               destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (instancetype)alertViewWithTextFieldsAndTitle:(NSString *)title
                                        message:(NSString *)message
                             numberOfTextFields:(NSUInteger)numberOfTextFields
                         textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                                   buttonTitles:(NSArray *)buttonTitles
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                  actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                  cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                             destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

#pragma mark -

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                        style:(LGAlertViewStyle)style
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
                     delegate:(id<LGAlertViewDelegate>)delegate;

/** View can not be subclass of UIScrollView */
- (instancetype)initWithViewAndTitle:(NSString *)title
                             message:(NSString *)message
                               style:(LGAlertViewStyle)style
                                view:(UIView *)view
                        buttonTitles:(NSArray *)buttonTitles
                   cancelButtonTitle:(NSString *)cancelButtonTitle
              destructiveButtonTitle:(NSString *)destructiveButtonTitle
                            delegate:(id<LGAlertViewDelegate>)delegate;

- (instancetype)initWithActivityIndicatorAndTitle:(NSString *)title
                                          message:(NSString *)message
                                            style:(LGAlertViewStyle)style
                                     buttonTitles:(NSArray *)buttonTitles
                                cancelButtonTitle:(NSString *)cancelButtonTitle
                           destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                         delegate:(id<LGAlertViewDelegate>)delegate;

- (instancetype)initWithProgressViewAndTitle:(NSString *)title
                                     message:(NSString *)message
                                       style:(LGAlertViewStyle)style
                           progressLabelText:(NSString *)progressLabelText
                                buttonTitles:(NSArray *)buttonTitles
                           cancelButtonTitle:(NSString *)cancelButtonTitle
                      destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                    delegate:(id<LGAlertViewDelegate>)delegate;

- (instancetype)initWithTextFieldsAndTitle:(NSString *)title
                                   message:(NSString *)message
                        numberOfTextFields:(NSUInteger)numberOfTextFields
                    textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                              buttonTitles:(NSArray *)buttonTitles
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                    destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                  delegate:(id<LGAlertViewDelegate>)delegate;

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                             style:(LGAlertViewStyle)style
                      buttonTitles:(NSArray *)buttonTitles
                 cancelButtonTitle:(NSString *)cancelButtonTitle
            destructiveButtonTitle:(NSString *)destructiveButtonTitle
                          delegate:(id<LGAlertViewDelegate>)delegate;

/** View can not be subclass of UIScrollView */
+ (instancetype)alertViewWithViewAndTitle:(NSString *)title
                                  message:(NSString *)message
                                    style:(LGAlertViewStyle)style
                                     view:(UIView *)view
                             buttonTitles:(NSArray *)buttonTitles
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                 delegate:(id<LGAlertViewDelegate>)delegate;

+ (instancetype)alertViewWithActivityIndicatorAndTitle:(NSString *)title
                                               message:(NSString *)message
                                                 style:(LGAlertViewStyle)style
                                          buttonTitles:(NSArray *)buttonTitles
                                     cancelButtonTitle:(NSString *)cancelButtonTitle
                                destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                              delegate:(id<LGAlertViewDelegate>)delegate;

+ (instancetype)alertViewWithProgressViewAndTitle:(NSString *)title
                                          message:(NSString *)message
                                            style:(LGAlertViewStyle)style
                                progressLabelText:(NSString *)progressLabelText
                                     buttonTitles:(NSArray *)buttonTitles
                                cancelButtonTitle:(NSString *)cancelButtonTitle
                           destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                         delegate:(id<LGAlertViewDelegate>)delegate;

+ (instancetype)alertViewWithTextFieldsAndTitle:(NSString *)title
                                        message:(NSString *)message
                             numberOfTextFields:(NSUInteger)numberOfTextFields
                         textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                                   buttonTitles:(NSArray *)buttonTitles
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                       delegate:(id<LGAlertViewDelegate>)delegate;

#pragma mark -

- (void)showAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler;
- (void)dismissAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler;

- (void)transitionToAlertView:(LGAlertView *)alertView completionHandler:(void(^)())completionHandler;

- (void)setProgress:(float)progress progressLabelText:(NSString *)progressLabelText;

- (void)setButtonPropertiesAtIndex:(NSUInteger)index handler:(void(^)(LGAlertViewButtonProperties *properties))handler;

- (void)setButtonAtIndex:(NSUInteger)index enabled:(BOOL)enabled;
- (BOOL)isButtonEnabledAtIndex:(NSUInteger)index;

- (void)layoutInvalidateWithSize:(CGSize)size;

- (void)forceCancel;
- (void)forceDestructive;
- (void)forceActionAtIndex:(NSUInteger)index;

#pragma mark - Class methods

/** Setup LGAlertView globally for all instances of LGAlertViews */
+ (void)setWindowLevel:(LGAlertViewWindowLevel)windowLevel;
+ (LGAlertViewWindowLevel)windowLevel;
+ (void)setColorful:(BOOL)colorful;
+ (BOOL)colorful;
+ (void)setTintColor:(UIColor *)tintColor;
+ (UIColor *)tintColor;
+ (void)setCoverColor:(UIColor *)coverColor;
+ (UIColor *)coverColor;
+ (void)setBackgroundColor:(UIColor *)backgroundColor;
+ (UIColor *)backgroundColor;
+ (void)setButtonsHeight:(CGFloat)buttonsHeight;
+ (CGFloat)buttonsHeight;
+ (void)setTextFieldsHeight:(CGFloat)textFieldsHeight;
+ (CGFloat)textFieldsHeight;
+ (void)setOffsetVertical:(CGFloat)offsetVertical;
+ (CGFloat)offsetVertical;
+ (void)setCancelButtonOffsetY:(CGFloat)cancelButtonOffsetY;
+ (CGFloat)cancelButtonOffsetY;
+ (void)setHeightMax:(CGFloat)heightMax;
+ (CGFloat)heightMax;
+ (void)setWidth:(CGFloat)width;
+ (CGFloat)width;

+ (void)setLayerCornerRadius:(CGFloat)layerCornerRadius;
+ (CGFloat)layerCornerRadius;
+ (void)setLayerBorderColor:(UIColor *)layerBorderColor;
+ (UIColor *)layerBorderColor;
+ (void)setLayerBorderWidth:(CGFloat)layerBorderWidth;
+ (CGFloat)layerBorderWidth;
+ (void)setLayerShadowColor:(UIColor *)layerShadowColor;
+ (UIColor *)layerShadowColor;
+ (void)setLayerShadowRadius:(CGFloat)layerShadowRadius;
+ (CGFloat)layerShadowRadius;
+ (void)setLayerShadowOpacity:(CGFloat)layerShadowOpacity;
+ (CGFloat)layerShadowOpacity;
+ (void)setLayerShadowOffset:(CGSize)layerShadowOffset;
+ (CGSize)layerShadowOffset;

+ (void)setTitleTextColor:(UIColor *)titleTextColor;
+ (UIColor *)titleTextColor;
+ (void)setTitleTextAlignment:(NSTextAlignment)titleTextAlignment;
+ (NSTextAlignment)titleTextAlignment;
+ (void)setTitleFont:(UIFont *)titleFont;
+ (UIFont *)titleFont;

+ (void)setMessageTextColor:(UIColor *)messageTextColor;
+ (UIColor *)messageTextColor;
+ (void)setMessageTextAlignment:(NSTextAlignment)messageTextAlignment;
+ (NSTextAlignment)messageTextAlignment;
+ (void)setMessageFont:(UIFont *)messageFont;
+ (UIFont *)messageFont;

+ (void)setButtonsTitleColor:(UIColor *)buttonsTitleColor;
+ (UIColor *)buttonsTitleColor;
+ (void)setButtonsTitleColorHighlighted:(UIColor *)buttonsTitleColorHighlighted;
+ (UIColor *)buttonsTitleColorHighlighted;
+ (void)setButtonsTitleColorDisabled:(UIColor *)buttonsTitleColorDisabled;
+ (UIColor *)buttonsTitleColorDisabled;
+ (void)setButtonsTextAlignment:(NSTextAlignment)buttonsTextAlignment;
+ (NSTextAlignment)buttonsTextAlignment;
+ (void)setButtonsFont:(UIFont *)buttonsFont;
+ (UIFont *)buttonsFont;
+ (void)setButtonsBackgroundColor:(UIColor *)buttonsBackgroundColor;
+ (UIColor *)buttonsBackgroundColor;
+ (void)setButtonsBackgroundColorHighlighted:(UIColor *)buttonsBackgroundColorHighlighted;
+ (UIColor *)buttonsBackgroundColorHighlighted;
+ (void)setButtonsBackgroundColorDisabled:(UIColor *)buttonsBackgroundColorDisabled;
+ (UIColor *)buttonsBackgroundColorDisabled;
+ (void)setButtonsNumberOfLines:(NSUInteger)buttonsNumberOfLines;
+ (NSUInteger)buttonsNumberOfLines;
+ (void)setButtonsLineBreakMode:(NSLineBreakMode)buttonsLineBreakMode;
+ (NSLineBreakMode)buttonsLineBreakMode;
+ (void)setButtonsMinimumScaleFactor:(CGFloat)buttonsMinimumScaleFactor;
+ (CGFloat)buttonsMinimumScaleFactor;
+ (void)setButtonsAdjustsFontSizeToFitWidth:(BOOL)buttonsAdjustsFontSizeToFitWidth;
+ (BOOL)buttonsAdjustsFontSizeToFitWidth;

+ (void)setCancelButtonTitleColor:(UIColor *)cancelButtonTitleColor;
+ (UIColor *)cancelButtonTitleColor;
+ (void)setCancelButtonTitleColorHighlighted:(UIColor *)cancelButtonTitleColorHighlighted;
+ (UIColor *)cancelButtonTitleColorHighlighted;
+ (void)setCancelButtonTitleColorDisabled:(UIColor *)cancelButtonTitleColorDisabled;
+ (UIColor *)cancelButtonTitleColorDisabled;
+ (void)setCancelButtonTextAlignment:(NSTextAlignment)cancelButtonTextAlignment;
+ (NSTextAlignment)cancelButtonTextAlignment;
+ (void)setCancelButtonFont:(UIFont *)cancelButtonFont;
+ (UIFont *)cancelButtonFont;
+ (void)setCancelButtonBackgroundColor:(UIColor *)cancelButtonBackgroundColor;
+ (UIColor *)cancelButtonBackgroundColor;
+ (void)setCancelButtonBackgroundColorHighlighted:(UIColor *)cancelButtonBackgroundColorHighlighted;
+ (UIColor *)cancelButtonBackgroundColorHighlighted;
+ (void)setCancelButtonBackgroundColorDisabled:(UIColor *)cancelButtonBackgroundColorDisabled;
+ (UIColor *)cancelButtonBackgroundColorDisabled;
+ (void)setCancelButtonNumberOfLines:(NSUInteger)cancelButtonNumberOfLines;
+ (NSUInteger)cancelButtonNumberOfLines;
+ (void)setCancelButtonLineBreakMode:(NSLineBreakMode)cancelButtonLineBreakMode;
+ (NSLineBreakMode)cancelButtonLineBreakMode;
+ (void)setCancelButtonMinimumScaleFactor:(CGFloat)cancelButtonMinimumScaleFactor;
+ (CGFloat)cancelButtonMinimumScaleFactor;
+ (void)setCancelButtonAdjustsFontSizeToFitWidth:(BOOL)cancelButtonAdjustsFontSizeToFitWidth;
+ (BOOL)cancelButtonAdjustsFontSizeToFitWidth;

+ (void)setDestructiveButtonTitleColor:(UIColor *)destructiveButtonTitleColor;
+ (UIColor *)destructiveButtonTitleColor;
+ (void)setDestructiveButtonTitleColorHighlighted:(UIColor *)destructiveButtonTitleColorHighlighted;
+ (UIColor *)destructiveButtonTitleColorHighlighted;
+ (void)setDestructiveButtonTitleColorDisabled:(UIColor *)destructiveButtonTitleColorDisabled;
+ (UIColor *)destructiveButtonTitleColorDisabled;
+ (void)setDestructiveButtonTextAlignment:(NSTextAlignment)destructiveButtonTextAlignment;
+ (NSTextAlignment)destructiveButtonTextAlignment;
+ (void)setDestructiveButtonFont:(UIFont *)destructiveButtonFont;
+ (UIFont *)destructiveButtonFont;
+ (void)setDestructiveButtonBackgroundColor:(UIColor *)destructiveButtonBackgroundColor;
+ (UIColor *)destructiveButtonBackgroundColor;
+ (void)setDestructiveButtonBackgroundColorHighlighted:(UIColor *)destructiveButtonBackgroundColorHighlighted;
+ (UIColor *)destructiveButtonBackgroundColorHighlighted;
+ (void)setDestructiveButtonBackgroundColorDisabled:(UIColor *)destructiveButtonBackgroundColorDisabled;
+ (UIColor *)destructiveButtonBackgroundColorDisabled;
+ (void)setDestructiveButtonNumberOfLines:(NSUInteger)destructiveButtonNumberOfLines;
+ (NSUInteger)destructiveButtonNumberOfLines;
+ (void)setDestructiveButtonLineBreakMode:(NSLineBreakMode)destructiveButtonLineBreakMode;
+ (NSLineBreakMode)destructiveButtonLineBreakMode;
+ (void)setDestructiveButtonMinimumScaleFactor:(CGFloat)destructiveButtonMinimumScaleFactor;
+ (CGFloat)destructiveButtonMinimumScaleFactor;
+ (void)setDestructiveButtonAdjustsFontSizeToFitWidth:(BOOL)destructiveButtonAdjustsFontSizeToFitWidth;
+ (BOOL)destructiveButtonAdjustsFontSizeToFitWidth;

+ (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle;
+ (UIActivityIndicatorViewStyle)activityIndicatorViewStyle;
+ (void)setActivityIndicatorViewColor:(UIColor *)activityIndicatorViewColor;
+ (UIColor *)activityIndicatorViewColor;

+ (void)setProgressViewProgressTintColor:(UIColor *)progressViewProgressTintColor;
+ (UIColor *)progressViewProgressTintColor;
+ (void)setProgressViewTrackTintColor:(UIColor *)progressViewTrackTintColor;
+ (UIColor *)progressViewTrackTintColor;
+ (void)setProgressViewProgressImage:(UIImage *)progressViewProgressImage;
+ (UIImage *)progressViewProgressImage;
+ (void)setProgressViewTrackImage:(UIImage *)progressViewTrackImage;
+ (UIImage *)progressViewTrackImage;
+ (void)setProgressLabelTextColor:(UIColor *)progressLabelTextColor;
+ (UIColor *)progressLabelTextColor;
+ (void)setProgressLabelTextAlignment:(NSTextAlignment)progressLabelTextAlignment;
+ (NSTextAlignment)progressLabelTextAlignment;
+ (void)setProgressLabelFont:(UIFont *)progressLabelFont;
+ (UIFont *)progressLabelFont;

+ (void)setSeparatorsColor:(UIColor *)separatorsColor;
+ (UIColor *)separatorsColor;
+ (void)setIndicatorStyle:(UIScrollViewIndicatorStyle)indicatorStyle;
+ (UIScrollViewIndicatorStyle)indicatorStyle;
+ (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator;
+ (BOOL)showsVerticalScrollIndicator;
+ (void)setPadShowsActionSheetFromBottom:(BOOL)padShowActionSheetFromBottom;
+ (BOOL)padShowsActionSheetFromBottom;
+ (void)setOneRowOneButton:(BOOL)oneRowOneButton;
+ (BOOL)oneRowOneButton;

+ (NSArray *)alertViewsArray;

#pragma mark -

/** Unavailable, use +alertViewWithTitle... instead */
+ (instancetype)new __attribute__((unavailable("use +alertViewWithTitle... instead")));
/** Unavailable, use -initWithTitle... instead */
- (instancetype)init __attribute__((unavailable("use -initWithTitle... instead")));
/** Unavailable, use -initWithTitle... instead */
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("use -initWithTitle... instead")));

@end
