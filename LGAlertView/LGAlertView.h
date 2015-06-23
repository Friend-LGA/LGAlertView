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

@class LGAlertView;

static NSString *const kLGAlertViewWillShowNotification    = @"LGAlertViewWillShowNotification";
static NSString *const kLGAlertViewWillDismissNotification = @"LGAlertViewWillDismissNotification";
static NSString *const kLGAlertViewDidShowNotification     = @"LGAlertViewDidShowNotification";
static NSString *const kLGAlertViewDidDismissNotification  = @"LGAlertViewDidDismissNotification";

static CGFloat const kLGAlertViewMargin = 16.f;
static CGFloat const kLGAlertViewWidth  = 320.f-kLGAlertViewMargin*2;

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

@property (assign, nonatomic, getter=isShowing) BOOL showing;

/** Default is YES */
@property (assign, nonatomic, getter=isCancelOnTouch) BOOL cancelOnTouch;
/** Set highlighted buttons background color to blue, and set highlighted destructive button background color to red. Default is YES */
@property (assign, nonatomic, getter=isColorful) BOOL colorful;

@property (strong, nonatomic) UIColor *tintColor;
@property (strong, nonatomic) UIColor *coverColor;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (assign, nonatomic) CGFloat layerCornerRadius;
@property (strong, nonatomic) UIColor *layerBorderColor;
@property (assign, nonatomic) CGFloat layerBorderWidth;
@property (strong, nonatomic) UIColor *layerShadowColor;
@property (assign, nonatomic) CGFloat layerShadowRadius;

@property (assign, nonatomic) CGFloat heightMax;
@property (assign, nonatomic) CGFloat widthMax;

@property (strong, nonatomic) UIColor         *titleTextColor;
@property (assign, nonatomic) NSTextAlignment titleTextAlignment;
@property (strong, nonatomic) UIFont          *titleFont;

@property (strong, nonatomic) UIColor         *messageTextColor;
@property (assign, nonatomic) NSTextAlignment messageTextAlignment;
@property (strong, nonatomic) UIFont          *messageFont;

@property (strong, nonatomic) UIColor         *buttonsTitleColor;
@property (strong, nonatomic) UIColor         *buttonsTitleColorHighlighted;
@property (assign, nonatomic) NSTextAlignment buttonsTextAlignment;
@property (strong, nonatomic) UIFont          *buttonsFont;
@property (strong, nonatomic) UIColor         *buttonsBackgroundColorHighlighted;
@property (assign, nonatomic) NSUInteger      buttonsNumberOfLines;
@property (assign, nonatomic) NSLineBreakMode buttonsLineBreakMode;
@property (assign, nonatomic) BOOL            buttonsAdjustsFontSizeToFitWidth;
@property (assign, nonatomic) CGFloat         buttonsMinimumScaleFactor;

@property (strong, nonatomic) UIColor         *cancelButtonTitleColor;
@property (strong, nonatomic) UIColor         *cancelButtonTitleColorHighlighted;
@property (assign, nonatomic) NSTextAlignment cancelButtonTextAlignment;
@property (strong, nonatomic) UIFont          *cancelButtonFont;
@property (strong, nonatomic) UIColor         *cancelButtonBackgroundColorHighlighted;
@property (assign, nonatomic) NSUInteger      cancelButtonNumberOfLines;
@property (assign, nonatomic) NSLineBreakMode cancelButtonLineBreakMode;
@property (assign, nonatomic) BOOL            cancelButtonAdjustsFontSizeToFitWidth;
@property (assign, nonatomic) CGFloat         cancelButtonMinimumScaleFactor;

@property (strong, nonatomic) UIColor         *destructiveButtonTitleColor;
@property (strong, nonatomic) UIColor         *destructiveButtonTitleColorHighlighted;
@property (assign, nonatomic) NSTextAlignment destructiveButtonTextAlignment;
@property (strong, nonatomic) UIFont          *destructiveButtonFont;
@property (strong, nonatomic) UIColor         *destructiveButtonBackgroundColorHighlighted;
@property (assign, nonatomic) NSUInteger      destructiveButtonNumberOfLines;
@property (assign, nonatomic) NSLineBreakMode destructiveButtonLineBreakMode;
@property (assign, nonatomic) BOOL            destructiveButtonAdjustsFontSizeToFitWidth;
@property (assign, nonatomic) CGFloat         destructiveButtonMinimumScaleFactor;

@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (strong, nonatomic) UIColor                      *activityIndicatorViewColor;

@property (strong, nonatomic) UIColor *progressViewProgressTintColor;
@property (strong, nonatomic) UIColor *progressViewTrackTintColor;
@property (strong, nonatomic) UIImage *progressViewProgressImage;
@property (strong, nonatomic) UIImage *progressViewTrackImage;

@property (assign, nonatomic, readonly) float progress;

@property (strong, nonatomic) UIColor         *progressLabelTextColor;
@property (assign, nonatomic) NSTextAlignment progressLabelTextAlignment;
@property (strong, nonatomic) UIFont          *progressLabelFont;

@property (strong, nonatomic) UIColor *separatorsColor;

@property (assign, nonatomic) UIScrollViewIndicatorStyle indicatorStyle;

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
@property (strong, nonatomic) void (^cancelHandler)(LGAlertView *alertView, BOOL onButton);
/** Do not forget about weak referens to self */
@property (strong, nonatomic) void (^destructiveHandler)(LGAlertView *alertView);

@property (assign, nonatomic) id<LGAlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle;

/** View can not be subclass of UIScrollView */
- (instancetype)initWithViewStyleWithTitle:(NSString *)title
                                   message:(NSString *)message
                                      view:(UIView *)view
                              buttonTitles:(NSArray *)buttonTitles
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                    destructiveButtonTitle:(NSString *)destructiveButtonTitle;

- (instancetype)initWithActivityIndicatorStyleWithTitle:(NSString *)title
                                                message:(NSString *)message
                                           buttonTitles:(NSArray *)buttonTitles
                                      cancelButtonTitle:(NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(NSString *)destructiveButtonTitle;

- (instancetype)initWithProgressViewStyleWithTitle:(NSString *)title
                                           message:(NSString *)message
                                 progressLabelText:(NSString *)progressLabelText
                                      buttonTitles:(NSArray *)buttonTitles
                                 cancelButtonTitle:(NSString *)cancelButtonTitle
                            destructiveButtonTitle:(NSString *)destructiveButtonTitle;

- (instancetype)initWithTextFieldsStyleWithTitle:(NSString *)title
                                         message:(NSString *)message
                              numberOfTextFields:(NSUInteger)numberOfTextFields
                          textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                                    buttonTitles:(NSArray *)buttonTitles
                               cancelButtonTitle:(NSString *)cancelButtonTitle
                          destructiveButtonTitle:(NSString *)destructiveButtonTitle;

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                      buttonTitles:(NSArray *)buttonTitles
                 cancelButtonTitle:(NSString *)cancelButtonTitle
            destructiveButtonTitle:(NSString *)destructiveButtonTitle;

/** View can not be subclass of UIScrollView */
+ (instancetype)alertViewWithViewStyleWithTitle:(NSString *)title
                                        message:(NSString *)message
                                           view:(UIView *)view
                                   buttonTitles:(NSArray *)buttonTitles
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle;

+ (instancetype)alertViewWithActivityIndicatorStyleWithTitle:(NSString *)title
                                                     message:(NSString *)message
                                                buttonTitles:(NSArray *)buttonTitles
                                           cancelButtonTitle:(NSString *)cancelButtonTitle
                                      destructiveButtonTitle:(NSString *)destructiveButtonTitle;

+ (instancetype)alertViewWithProgressViewStyleWithTitle:(NSString *)title
                                                message:(NSString *)message
                                      progressLabelText:(NSString *)progressLabelText
                                           buttonTitles:(NSArray *)buttonTitles
                                      cancelButtonTitle:(NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(NSString *)destructiveButtonTitle;

+ (instancetype)alertViewWithTextFieldsStyleWithTitle:(NSString *)title
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
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
                actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
           destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/**
 View can not be subclass of UIScrollView.
 Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks.
 */
- (instancetype)initWithViewStyleWithTitle:(NSString *)title
                                   message:(NSString *)message
                                      view:(UIView *)view
                              buttonTitles:(NSArray *)buttonTitles
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                    destructiveButtonTitle:(NSString *)destructiveButtonTitle
                             actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                             cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                        destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
- (instancetype)initWithActivityIndicatorStyleWithTitle:(NSString *)title
                                                message:(NSString *)message
                                           buttonTitles:(NSArray *)buttonTitles
                                      cancelButtonTitle:(NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                          actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                          cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                                     destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
- (instancetype)initWithProgressViewStyleWithTitle:(NSString *)title
                                           message:(NSString *)message
                                 progressLabelText:(NSString *)progressLabelText
                                      buttonTitles:(NSArray *)buttonTitles
                                 cancelButtonTitle:(NSString *)cancelButtonTitle
                            destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                     actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                     cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                                destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
- (instancetype)initWithTextFieldsStyleWithTitle:(NSString *)title
                                         message:(NSString *)message
                              numberOfTextFields:(NSUInteger)numberOfTextFields
                          textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                                    buttonTitles:(NSArray *)buttonTitles
                               cancelButtonTitle:(NSString *)cancelButtonTitle
                          destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                   actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                   cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                              destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                      buttonTitles:(NSArray *)buttonTitles
                 cancelButtonTitle:(NSString *)cancelButtonTitle
            destructiveButtonTitle:(NSString *)destructiveButtonTitle
                     actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                     cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/**
 View can not be subclass of UIScrollView.
 Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks.
 */
+ (instancetype)alertViewWithViewStyleWithTitle:(NSString *)title
                                        message:(NSString *)message
                                           view:(UIView *)view
                                   buttonTitles:(NSArray *)buttonTitles
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                  actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                  cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                             destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (instancetype)alertViewWithActivityIndicatorStyleWithTitle:(NSString *)title
                                                     message:(NSString *)message
                                                buttonTitles:(NSArray *)buttonTitles
                                           cancelButtonTitle:(NSString *)cancelButtonTitle
                                      destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                               actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                               cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                                          destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (instancetype)alertViewWithProgressViewStyleWithTitle:(NSString *)title
                                                message:(NSString *)message
                                      progressLabelText:(NSString *)progressLabelText
                                           buttonTitles:(NSArray *)buttonTitles
                                      cancelButtonTitle:(NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                          actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                          cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                                     destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/** Do not forget about weak referens to self for actionHandler, cancelHandler and destructiveHandler blocks */
+ (instancetype)alertViewWithTextFieldsStyleWithTitle:(NSString *)title
                                              message:(NSString *)message
                                   numberOfTextFields:(NSUInteger)numberOfTextFields
                               textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                                         buttonTitles:(NSArray *)buttonTitles
                                    cancelButtonTitle:(NSString *)cancelButtonTitle
                               destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                        actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                        cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                                   destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

#pragma mark -

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
                     delegate:(id<LGAlertViewDelegate>)delegate;

/** View can not be subclass of UIScrollView */
- (instancetype)initWithViewStyleWithTitle:(NSString *)title
                                   message:(NSString *)message
                                      view:(UIView *)view
                              buttonTitles:(NSArray *)buttonTitles
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                    destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                  delegate:(id<LGAlertViewDelegate>)delegate;

- (instancetype)initWithActivityIndicatorStyleWithTitle:(NSString *)title
                                                message:(NSString *)message
                                           buttonTitles:(NSArray *)buttonTitles
                                      cancelButtonTitle:(NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                               delegate:(id<LGAlertViewDelegate>)delegate;

- (instancetype)initWithProgressViewStyleWithTitle:(NSString *)title
                                           message:(NSString *)message
                                 progressLabelText:(NSString *)progressLabelText
                                      buttonTitles:(NSArray *)buttonTitles
                                 cancelButtonTitle:(NSString *)cancelButtonTitle
                            destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                          delegate:(id<LGAlertViewDelegate>)delegate;

- (instancetype)initWithTextFieldsStyleWithTitle:(NSString *)title
                                         message:(NSString *)message
                              numberOfTextFields:(NSUInteger)numberOfTextFields
                          textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                                    buttonTitles:(NSArray *)buttonTitles
                               cancelButtonTitle:(NSString *)cancelButtonTitle
                          destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                        delegate:(id<LGAlertViewDelegate>)delegate;

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                      buttonTitles:(NSArray *)buttonTitles
                 cancelButtonTitle:(NSString *)cancelButtonTitle
            destructiveButtonTitle:(NSString *)destructiveButtonTitle
                          delegate:(id<LGAlertViewDelegate>)delegate;

/** View can not be subclass of UIScrollView */
+ (instancetype)alertViewWithViewStyleWithTitle:(NSString *)title
                                        message:(NSString *)message
                                           view:(UIView *)view
                                   buttonTitles:(NSArray *)buttonTitles
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                       delegate:(id<LGAlertViewDelegate>)delegate;

+ (instancetype)alertViewWithActivityIndicatorStyleWithTitle:(NSString *)title
                                                     message:(NSString *)message
                                                buttonTitles:(NSArray *)buttonTitles
                                           cancelButtonTitle:(NSString *)cancelButtonTitle
                                      destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                                    delegate:(id<LGAlertViewDelegate>)delegate;

+ (instancetype)alertViewWithProgressViewStyleWithTitle:(NSString *)title
                                                message:(NSString *)message
                                      progressLabelText:(NSString *)progressLabelText
                                           buttonTitles:(NSArray *)buttonTitles
                                      cancelButtonTitle:(NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                               delegate:(id<LGAlertViewDelegate>)delegate;

+ (instancetype)alertViewWithTextFieldsStyleWithTitle:(NSString *)title
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

- (void)setProgress:(float)progress progressLabelText:(NSString *)progressLabelText;

#pragma mark -

/** Unavailable, use +alertViewWithTitle... instead */
+ (instancetype)new __attribute__((unavailable("use +alertViewWithTitle... instead")));
/** Unavailable, use -initWithTitle... instead */
- (instancetype)init __attribute__((unavailable("use -initWithTitle... instead")));
/** Unavailable, use -initWithTitle... instead */
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("use -initWithTitle... instead")));

@end
