//
//  LGAlertView.m
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

#import "LGAlertView.h"
#import "LGAlertViewWindow.h"
#import "LGAlertViewController.h"
#import "LGAlertViewCell.h"
#import "LGAlertViewTextField.h"
#import "LGAlertViewShared.h"

#define kLGAlertViewStatusBarHeight                   ([UIApplication sharedApplication].isStatusBarHidden ? 0.0 : 20.0)
#define kLGAlertViewSeparatorHeight                   ([UIScreen mainScreen].scale == 1.0 ? 1.0 : 0.5)
#define kLGAlertViewButtonTitleMarginH                8.0
#define kLGAlertViewInnerMarginH                      (self.style == LGAlertViewStyleAlert ? 16.0 : 12.0)
#define kLGAlertViewIsCancelButtonSeparate(alertView) (alertView.style == LGAlertViewStyleActionSheet && alertView.cancelButtonOffsetY != NSNotFound && alertView.cancelButtonOffsetY > 0.0 && !kLGAlertViewPadAndNotForce(alertView))
#define kLGAlertViewButtonWidthMin                    64.0
#define kLGAlertViewWindowPrevious(index)             (index > 0 && index < kLGAlertViewWindowsArray.count ? [kLGAlertViewWindowsArray objectAtIndex:(index-1)] : nil)
#define kLGAlertViewWindowNext(index)                 (kLGAlertViewWindowsArray.count > index+1 ? [kLGAlertViewWindowsArray objectAtIndex:(index+1)] : nil)
#define kLGAlertViewPadAndNotForce(alertView)         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && !alertView.isPadShowsActionSheetFromBottom)

#define kLGAlertViewPointIsNil(point) CGPointEqualToPoint(point, CGPointMake(NSNotFound, NSNotFound))

#pragma mark - Types

typedef enum {
    LGAlertViewTypeDefault           = 0,
    LGAlertViewTypeActivityIndicator = 1,
    LGAlertViewTypeProgressView      = 2,
    LGAlertViewTypeTextFields        = 3
}
LGAlertViewType;

#pragma mark - Static

static NSMutableArray *kLGAlertViewWindowsArray;
static NSMutableArray *kLGAlertViewArray;

#pragma mark - Interface

@interface LGAlertView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (assign, nonatomic, getter=isExists) BOOL exists;

@property (strong, nonatomic) LGAlertViewWindow *window;

@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) LGAlertViewController *viewController;

@property (strong, nonatomic) UIVisualEffectView *backgroundView;

@property (strong, nonatomic) UIView *styleView;
@property (strong, nonatomic) UIView *styleCancelView;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITableView  *tableView;

@property (assign, nonatomic, getter=isShowing) BOOL showing;

@property (assign, nonatomic) LGAlertViewStyle style;
@property (copy, nonatomic) NSString           *title;
@property (copy, nonatomic) NSString           *message;
@property (strong, nonatomic) UIView           *innerView;
@property (strong, nonatomic) NSMutableArray   *buttonTitles;
@property (copy, nonatomic) NSString           *cancelButtonTitle;
@property (copy, nonatomic) NSString           *destructiveButtonTitle;

@property (strong, nonatomic) UILabel  *titleLabel;
@property (strong, nonatomic) UILabel  *messageLabel;
@property (strong, nonatomic) UIButton *destructiveButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *firstButton;
@property (strong, nonatomic) UIButton *secondButton;
@property (strong, nonatomic) UIButton *thirdButton;

@property (strong, nonatomic) NSMutableArray *textFieldsArray;
@property (strong, nonatomic) NSMutableArray *textFieldSeparatorsArray;

@property (strong, nonatomic) UIView *separatorHorizontalView;
@property (strong, nonatomic) UIView *separatorVerticalView1;
@property (strong, nonatomic) UIView *separatorVerticalView2;

@property (assign, nonatomic) CGPoint scrollViewCenterShowed;
@property (assign, nonatomic) CGPoint scrollViewCenterHidden;

@property (assign, nonatomic) CGPoint cancelButtonCenterShowed;
@property (assign, nonatomic) CGPoint cancelButtonCenterHidden;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UILabel        *progressLabel;

@property (strong, nonatomic) NSString *progressLabelText;

@property (assign, nonatomic) LGAlertViewType type;

@property (assign, nonatomic) CGFloat keyboardHeight;

@property (assign, nonatomic, getter=isUserButtonsTitleColor)                           BOOL userButtonsTitleColor;
@property (assign, nonatomic, getter=isUserButtonsTitleColorHighlighted)                BOOL userButtonsTitleColorHighlighted;
@property (assign, nonatomic, getter=isUserButtonsBackgroundColorHighlighted)           BOOL userButtonsBackgroundColorHighlighted;
@property (assign, nonatomic, getter=isUserCancelButtonTitleColor)                      BOOL userCancelButtonTitleColor;
@property (assign, nonatomic, getter=isUserCancelButtonTitleColorHighlighted)           BOOL userCancelButtonTitleColorHighlighted;
@property (assign, nonatomic, getter=isUserCancelButtonBackgroundColorHighlighted)      BOOL userCancelButtonBackgroundColorHighlighted;
@property (assign, nonatomic, getter=isUserDestructiveButtonTitleColorHighlighted)      BOOL userDestructiveButtonTitleColorHighlighted;
@property (assign, nonatomic, getter=isUserDestructiveButtonBackgroundColorHighlighted) BOOL userDestructiveButtonBackgroundColorHighlighted;
@property (assign, nonatomic, getter=isUserActivityIndicatorViewColor)                  BOOL userActivityIndicatorViewColor;
@property (assign, nonatomic, getter=isUserProgressViewProgressTintColor)               BOOL userProgressViewProgressTintColor;

@property (strong, nonatomic) NSMutableDictionary *buttonsPropertiesDictionary;
@property (strong, nonatomic) NSMutableArray *buttonsEnabledArray;

@end

#pragma mark - Implementation

@implementation LGAlertView

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                                style:(LGAlertViewStyle)style
                         buttonTitles:(nullable NSArray *)buttonTitles
                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
               destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle {
    self = [super init];
    if (self) {
        self.style = style;
        self.title = title;
        self.message = message;
        self.buttonTitles = buttonTitles.mutableCopy;
        self.cancelButtonTitle = cancelButtonTitle;
        self.destructiveButtonTitle = destructiveButtonTitle;

        [self setupDefaults];
    }
    return self;
}

- (nonnull instancetype)initWithViewAndTitle:(nullable NSString *)title
                                     message:(nullable NSString *)message
                                       style:(LGAlertViewStyle)style
                                        view:(nullable UIView *)view
                                buttonTitles:(nullable NSArray *)buttonTitles
                           cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                      destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle {
    self = [super init];
    if (self) {
        self.style = style;
        self.title = title;
        self.message = message;
        self.innerView = view;
        self.buttonTitles = buttonTitles.mutableCopy;
        self.cancelButtonTitle = cancelButtonTitle;
        self.destructiveButtonTitle = destructiveButtonTitle;

        [self setupDefaults];
    }
    return self;
}

- (nonnull instancetype)initWithActivityIndicatorAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                             buttonTitles:(nullable NSArray *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle {
    self = [super init];
    if (self) {
        self.style = style;
        self.title = title;
        self.message = message;
        self.buttonTitles = buttonTitles.mutableCopy;
        self.cancelButtonTitle = cancelButtonTitle;
        self.destructiveButtonTitle = destructiveButtonTitle;

        self.type = LGAlertViewTypeActivityIndicator;

        [self setupDefaults];
    }
    return self;
}

- (nonnull instancetype)initWithProgressViewAndTitle:(nullable NSString *)title
                                             message:(nullable NSString *)message
                                               style:(LGAlertViewStyle)style
                                   progressLabelText:(NSString *)progressLabelText
                                        buttonTitles:(nullable NSArray *)buttonTitles
                                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                              destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle {
    self = [super init];
    if (self) {
        self.style = style;
        self.title = title;
        self.message = message;
        self.buttonTitles = buttonTitles.mutableCopy;
        self.cancelButtonTitle = cancelButtonTitle;
        self.destructiveButtonTitle = destructiveButtonTitle;
        self.progressLabelText = progressLabelText;

        self.type = LGAlertViewTypeProgressView;

        [self setupDefaults];
    }
    return self;
}

- (nonnull instancetype)initWithTextFieldsAndTitle:(nullable NSString *)title
                                           message:(nullable NSString *)message
                                numberOfTextFields:(NSUInteger)numberOfTextFields
                            textFieldsSetupHandler:(LGAlertViewTextFieldsSetupHandler)textFieldsSetupHandler
                                      buttonTitles:(nullable NSArray *)buttonTitles
                                 cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                            destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle {
    self = [super init];
    if (self) {
        self.title = title;
        self.message = message;
        self.buttonTitles = buttonTitles.mutableCopy;
        self.cancelButtonTitle = cancelButtonTitle;
        self.destructiveButtonTitle = destructiveButtonTitle;

        self.type = LGAlertViewTypeTextFields;

        self.textFieldsArray = [NSMutableArray new];
        self.textFieldSeparatorsArray = [NSMutableArray new];

        for (NSUInteger i=0; i<numberOfTextFields; i++) {
            LGAlertViewTextField *textField = [LGAlertViewTextField new];
            textField.delegate = self;
            textField.tag = i;

            if (i == numberOfTextFields-1) {
                textField.returnKeyType = UIReturnKeyDone;
            }
            else {
                textField.returnKeyType = UIReturnKeyNext;
            }

            if (textFieldsSetupHandler) {
                textFieldsSetupHandler(textField, i);
            }

            [self.textFieldsArray addObject:textField];

            // -----

            UIView *separatorView = [UIView new];
            [self.textFieldSeparatorsArray addObject:separatorView];
        }

        [self setupDefaults];
    }
    return self;
}

+ (nonnull instancetype)alertViewWithTitle:(nullable NSString *)title
                                   message:(nullable NSString *)message
                                     style:(LGAlertViewStyle)style
                              buttonTitles:(nullable NSArray *)buttonTitles
                         cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                    destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle {
    return [[self alloc] initWithTitle:title
                               message:message
                                 style:style
                          buttonTitles:buttonTitles
                     cancelButtonTitle:cancelButtonTitle
                destructiveButtonTitle:destructiveButtonTitle];
}

+ (nonnull instancetype)alertViewWithViewAndTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                            style:(LGAlertViewStyle)style
                                             view:(nullable UIView *)view
                                     buttonTitles:(nullable NSArray *)buttonTitles
                                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                           destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle {
    return [[self alloc] initWithViewAndTitle:title
                                      message:message
                                        style:style
                                         view:view
                                 buttonTitles:buttonTitles
                            cancelButtonTitle:cancelButtonTitle
                       destructiveButtonTitle:destructiveButtonTitle];
}

+ (nonnull instancetype)alertViewWithActivityIndicatorAndTitle:(nullable NSString *)title
                                                       message:(nullable NSString *)message
                                                         style:(LGAlertViewStyle)style
                                                  buttonTitles:(nullable NSArray *)buttonTitles
                                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                        destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle {
    return [[self alloc] initWithActivityIndicatorAndTitle:title
                                                   message:message
                                                     style:style
                                              buttonTitles:buttonTitles
                                         cancelButtonTitle:cancelButtonTitle
                                    destructiveButtonTitle:destructiveButtonTitle];
}

+ (nonnull instancetype)alertViewWithProgressViewAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                        progressLabelText:(NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle {
    return [[self alloc] initWithProgressViewAndTitle:title
                                              message:message
                                                style:style
                                    progressLabelText:progressLabelText
                                         buttonTitles:buttonTitles
                                    cancelButtonTitle:cancelButtonTitle
                               destructiveButtonTitle:destructiveButtonTitle];
}

+ (nonnull instancetype)alertViewWithTextFieldsAndTitle:(nullable NSString *)title
                                                message:(nullable NSString *)message
                                     numberOfTextFields:(NSUInteger)numberOfTextFields
                                 textFieldsSetupHandler:(LGAlertViewTextFieldsSetupHandler)textFieldsSetupHandler
                                           buttonTitles:(nullable NSArray *)buttonTitles
                                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle {
    return [[self alloc] initWithTextFieldsAndTitle:title
                                            message:message
                                 numberOfTextFields:numberOfTextFields
                             textFieldsSetupHandler:textFieldsSetupHandler
                                       buttonTitles:buttonTitles
                                  cancelButtonTitle:cancelButtonTitle
                             destructiveButtonTitle:destructiveButtonTitle];
}

#pragma mark -

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                                style:(LGAlertViewStyle)style
                         buttonTitles:(nullable NSArray *)buttonTitles
                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
               destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                        actionHandler:(LGAlertViewActionHandler)actionHandler
                        cancelHandler:(LGAlertViewHandler)cancelHandler
                   destructiveHandler:(LGAlertViewHandler)destructiveHandler {
    self = [self initWithTitle:title
                       message:message
                         style:style
                  buttonTitles:buttonTitles
             cancelButtonTitle:cancelButtonTitle
        destructiveButtonTitle:destructiveButtonTitle];
    if (self) {
        self.actionHandler = actionHandler;
        self.cancelHandler = cancelHandler;
        self.destructiveHandler = destructiveHandler;
    }
    return self;
}

- (nonnull instancetype)initWithViewAndTitle:(nullable NSString *)title
                                     message:(nullable NSString *)message
                                       style:(LGAlertViewStyle)style
                                        view:(nullable UIView *)view
                                buttonTitles:(nullable NSArray *)buttonTitles
                           cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                      destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                               actionHandler:(LGAlertViewActionHandler)actionHandler
                               cancelHandler:(LGAlertViewHandler)cancelHandler
                          destructiveHandler:(LGAlertViewHandler)destructiveHandler {
    self = [self initWithViewAndTitle:title
                              message:message
                                style:style
                                 view:view
                         buttonTitles:buttonTitles
                    cancelButtonTitle:cancelButtonTitle
               destructiveButtonTitle:destructiveButtonTitle];
    if (self) {
        self.actionHandler = actionHandler;
        self.cancelHandler = cancelHandler;
        self.destructiveHandler = destructiveHandler;
    }
    return self;
}

- (nonnull instancetype)initWithActivityIndicatorAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                             buttonTitles:(nullable NSArray *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                            actionHandler:(LGAlertViewActionHandler)actionHandler
                                            cancelHandler:(LGAlertViewHandler)cancelHandler
                                       destructiveHandler:(LGAlertViewHandler)destructiveHandler {
    self = [self initWithActivityIndicatorAndTitle:title
                                           message:message
                                             style:style
                                      buttonTitles:buttonTitles
                                 cancelButtonTitle:cancelButtonTitle
                            destructiveButtonTitle:destructiveButtonTitle];
    if (self) {
        self.actionHandler = actionHandler;
        self.cancelHandler = cancelHandler;
        self.destructiveHandler = destructiveHandler;
    }
    return self;
}

- (nonnull instancetype)initWithProgressViewAndTitle:(nullable NSString *)title
                                             message:(nullable NSString *)message
                                               style:(LGAlertViewStyle)style
                                   progressLabelText:(NSString *)progressLabelText
                                        buttonTitles:(nullable NSArray *)buttonTitles
                                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                              destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                       actionHandler:(LGAlertViewActionHandler)actionHandler
                                       cancelHandler:(LGAlertViewHandler)cancelHandler
                                  destructiveHandler:(LGAlertViewHandler)destructiveHandler {
    self = [self initWithProgressViewAndTitle:title
                                      message:message
                                        style:style
                            progressLabelText:progressLabelText
                                 buttonTitles:buttonTitles
                            cancelButtonTitle:cancelButtonTitle
                       destructiveButtonTitle:destructiveButtonTitle];
    if (self) {
        self.actionHandler = actionHandler;
        self.cancelHandler = cancelHandler;
        self.destructiveHandler = destructiveHandler;
    }
    return self;
}

- (nonnull instancetype)initWithTextFieldsAndTitle:(nullable NSString *)title
                                           message:(nullable NSString *)message
                                numberOfTextFields:(NSUInteger)numberOfTextFields
                            textFieldsSetupHandler:(LGAlertViewTextFieldsSetupHandler)textFieldsSetupHandler
                                      buttonTitles:(nullable NSArray *)buttonTitles
                                 cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                            destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                     actionHandler:(LGAlertViewActionHandler)actionHandler
                                     cancelHandler:(LGAlertViewHandler)cancelHandler
                                destructiveHandler:(LGAlertViewHandler)destructiveHandler {
    self = [self initWithTextFieldsAndTitle:title
                                    message:message
                         numberOfTextFields:numberOfTextFields
                     textFieldsSetupHandler:textFieldsSetupHandler
                               buttonTitles:buttonTitles
                          cancelButtonTitle:cancelButtonTitle
                     destructiveButtonTitle:destructiveButtonTitle];
    if (self) {
        self.actionHandler = actionHandler;
        self.cancelHandler = cancelHandler;
        self.destructiveHandler = destructiveHandler;
    }
    return self;
}

+ (nonnull instancetype)alertViewWithTitle:(nullable NSString *)title
                                   message:(nullable NSString *)message
                                     style:(LGAlertViewStyle)style
                              buttonTitles:(nullable NSArray *)buttonTitles
                         cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                    destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                             actionHandler:(LGAlertViewActionHandler)actionHandler
                             cancelHandler:(LGAlertViewHandler)cancelHandler
                        destructiveHandler:(LGAlertViewHandler)destructiveHandler {
    return [[self alloc] initWithTitle:title
                               message:message
                                 style:style
                          buttonTitles:buttonTitles
                     cancelButtonTitle:cancelButtonTitle
                destructiveButtonTitle:destructiveButtonTitle
                         actionHandler:actionHandler
                         cancelHandler:cancelHandler
                    destructiveHandler:destructiveHandler];
}

+ (nonnull instancetype)alertViewWithViewAndTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                            style:(LGAlertViewStyle)style
                                             view:(nullable UIView *)view
                                     buttonTitles:(nullable NSArray *)buttonTitles
                                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                           destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                    actionHandler:(LGAlertViewActionHandler)actionHandler
                                    cancelHandler:(LGAlertViewHandler)cancelHandler
                               destructiveHandler:(LGAlertViewHandler)destructiveHandler {
    return [[self alloc] initWithViewAndTitle:title
                                      message:message
                                        style:style
                                         view:view
                                 buttonTitles:buttonTitles
                            cancelButtonTitle:cancelButtonTitle
                       destructiveButtonTitle:destructiveButtonTitle
                                actionHandler:actionHandler
                                cancelHandler:cancelHandler
                           destructiveHandler:destructiveHandler];
}

+ (nonnull instancetype)alertViewWithActivityIndicatorAndTitle:(nullable NSString *)title
                                                       message:(nullable NSString *)message
                                                         style:(LGAlertViewStyle)style
                                                  buttonTitles:(nullable NSArray *)buttonTitles
                                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                        destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                                 actionHandler:(LGAlertViewActionHandler)actionHandler
                                                 cancelHandler:(LGAlertViewHandler)cancelHandler
                                            destructiveHandler:(LGAlertViewHandler)destructiveHandler {
    return [[self alloc] initWithActivityIndicatorAndTitle:title
                                                   message:message
                                                     style:style
                                              buttonTitles:buttonTitles
                                         cancelButtonTitle:cancelButtonTitle
                                    destructiveButtonTitle:destructiveButtonTitle
                                             actionHandler:actionHandler
                                             cancelHandler:cancelHandler
                                        destructiveHandler:destructiveHandler];
}

+ (nonnull instancetype)alertViewWithProgressViewAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                        progressLabelText:(NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                            actionHandler:(LGAlertViewActionHandler)actionHandler
                                            cancelHandler:(LGAlertViewHandler)cancelHandler
                                       destructiveHandler:(LGAlertViewHandler)destructiveHandler {
    return [[self alloc] initWithProgressViewAndTitle:title
                                              message:message
                                                style:style
                                    progressLabelText:progressLabelText
                                         buttonTitles:buttonTitles
                                    cancelButtonTitle:cancelButtonTitle
                               destructiveButtonTitle:destructiveButtonTitle
                                        actionHandler:actionHandler
                                        cancelHandler:cancelHandler
                                   destructiveHandler:destructiveHandler];
}

+ (nonnull instancetype)alertViewWithTextFieldsAndTitle:(nullable NSString *)title
                                                message:(nullable NSString *)message
                                     numberOfTextFields:(NSUInteger)numberOfTextFields
                                 textFieldsSetupHandler:(LGAlertViewTextFieldsSetupHandler)textFieldsSetupHandler
                                           buttonTitles:(nullable NSArray *)buttonTitles
                                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                          actionHandler:(LGAlertViewActionHandler)actionHandler
                                          cancelHandler:(LGAlertViewHandler)cancelHandler
                                     destructiveHandler:(LGAlertViewHandler)destructiveHandler {
    return [[self alloc] initWithTextFieldsAndTitle:title
                                            message:message
                                 numberOfTextFields:numberOfTextFields
                             textFieldsSetupHandler:textFieldsSetupHandler
                                       buttonTitles:buttonTitles
                                  cancelButtonTitle:cancelButtonTitle
                             destructiveButtonTitle:destructiveButtonTitle
                                      actionHandler:actionHandler
                                      cancelHandler:cancelHandler
                                 destructiveHandler:destructiveHandler];
}

#pragma mark -

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                                style:(LGAlertViewStyle)style
                         buttonTitles:(nullable NSArray *)buttonTitles
                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
               destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                             delegate:(nullable id<LGAlertViewDelegate>)delegate {
    self = [self initWithTitle:title
                       message:message
                         style:style
                  buttonTitles:buttonTitles
             cancelButtonTitle:cancelButtonTitle
        destructiveButtonTitle:destructiveButtonTitle];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (nonnull instancetype)initWithViewAndTitle:(nullable NSString *)title
                                     message:(nullable NSString *)message
                                       style:(LGAlertViewStyle)style
                                        view:(nullable UIView *)view
                                buttonTitles:(nullable NSArray *)buttonTitles
                           cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                      destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                    delegate:(nullable id<LGAlertViewDelegate>)delegate {
    self = [self initWithViewAndTitle:title
                              message:message
                                style:style
                                 view:view
                         buttonTitles:buttonTitles
                    cancelButtonTitle:cancelButtonTitle
               destructiveButtonTitle:destructiveButtonTitle];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (nonnull instancetype)initWithActivityIndicatorAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                             buttonTitles:(nullable NSArray *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                                 delegate:(nullable id<LGAlertViewDelegate>)delegate {
    self = [self initWithActivityIndicatorAndTitle:title
                                           message:message
                                             style:style
                                      buttonTitles:buttonTitles
                                 cancelButtonTitle:cancelButtonTitle
                            destructiveButtonTitle:destructiveButtonTitle];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (nonnull instancetype)initWithProgressViewAndTitle:(nullable NSString *)title
                                             message:(nullable NSString *)message
                                               style:(LGAlertViewStyle)style
                                   progressLabelText:(NSString *)progressLabelText
                                        buttonTitles:(nullable NSArray *)buttonTitles
                                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                              destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                            delegate:(nullable id<LGAlertViewDelegate>)delegate {
    self = [self initWithProgressViewAndTitle:title
                                      message:message
                                        style:style
                            progressLabelText:progressLabelText
                                 buttonTitles:buttonTitles
                            cancelButtonTitle:cancelButtonTitle
                       destructiveButtonTitle:destructiveButtonTitle];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (nonnull instancetype)initWithTextFieldsAndTitle:(nullable NSString *)title
                                           message:(nullable NSString *)message
                                numberOfTextFields:(NSUInteger)numberOfTextFields
                            textFieldsSetupHandler:(LGAlertViewTextFieldsSetupHandler)textFieldsSetupHandler
                                      buttonTitles:(nullable NSArray *)buttonTitles
                                 cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                            destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                          delegate:(nullable id<LGAlertViewDelegate>)delegate {
    self = [self initWithTextFieldsAndTitle:title
                                    message:message
                         numberOfTextFields:numberOfTextFields
                     textFieldsSetupHandler:textFieldsSetupHandler
                               buttonTitles:buttonTitles
                          cancelButtonTitle:cancelButtonTitle
                     destructiveButtonTitle:destructiveButtonTitle];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

+ (nonnull instancetype)alertViewWithTitle:(nullable NSString *)title
                                   message:(nullable NSString *)message
                                     style:(LGAlertViewStyle)style
                              buttonTitles:(nullable NSArray *)buttonTitles
                         cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                    destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                  delegate:(nullable id<LGAlertViewDelegate>)delegate {
    return [[self alloc] initWithTitle:title
                               message:message
                                 style:style
                          buttonTitles:buttonTitles
                     cancelButtonTitle:cancelButtonTitle
                destructiveButtonTitle:destructiveButtonTitle
                              delegate:delegate];
}

+ (nonnull instancetype)alertViewWithViewAndTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                            style:(LGAlertViewStyle)style
                                             view:(nullable UIView *)view
                                     buttonTitles:(nullable NSArray *)buttonTitles
                                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                           destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                         delegate:(nullable id<LGAlertViewDelegate>)delegate {
    return [[self alloc] initWithViewAndTitle:title
                                      message:message
                                        style:style
                                         view:view
                                 buttonTitles:buttonTitles
                            cancelButtonTitle:cancelButtonTitle
                       destructiveButtonTitle:destructiveButtonTitle
                                     delegate:delegate];
}

+ (nonnull instancetype)alertViewWithActivityIndicatorAndTitle:(nullable NSString *)title
                                                       message:(nullable NSString *)message
                                                         style:(LGAlertViewStyle)style
                                                  buttonTitles:(nullable NSArray *)buttonTitles
                                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                        destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                                      delegate:(nullable id<LGAlertViewDelegate>)delegate {
    return [[self alloc] initWithActivityIndicatorAndTitle:title
                                                   message:message
                                                     style:style
                                              buttonTitles:buttonTitles
                                         cancelButtonTitle:cancelButtonTitle
                                    destructiveButtonTitle:destructiveButtonTitle
                                                  delegate:delegate];
}

+ (nonnull instancetype)alertViewWithProgressViewAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                        progressLabelText:(NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                                 delegate:(nullable id<LGAlertViewDelegate>)delegate {
    return [[self alloc] initWithProgressViewAndTitle:title
                                              message:message
                                                style:style
                                    progressLabelText:progressLabelText
                                         buttonTitles:buttonTitles
                                    cancelButtonTitle:cancelButtonTitle
                               destructiveButtonTitle:destructiveButtonTitle
                                             delegate:delegate];
}

+ (nonnull instancetype)alertViewWithTextFieldsAndTitle:(nullable NSString *)title
                                                message:(nullable NSString *)message
                                     numberOfTextFields:(NSUInteger)numberOfTextFields
                                 textFieldsSetupHandler:(LGAlertViewTextFieldsSetupHandler)textFieldsSetupHandler
                                           buttonTitles:(nullable NSArray *)buttonTitles
                                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                               delegate:(nullable id<LGAlertViewDelegate>)delegate {
    return [[self alloc] alertViewWithTextFieldsAndTitle:title
                                                 message:message
                                      numberOfTextFields:numberOfTextFields
                                  textFieldsSetupHandler:textFieldsSetupHandler
                                            buttonTitles:buttonTitles
                                       cancelButtonTitle:cancelButtonTitle
                                  destructiveButtonTitle:destructiveButtonTitle
                                                delegate:delegate];
}

#pragma mark - Defaults

+ (void)load {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        kLGAlertViewWindowsArray = [NSMutableArray new];
        kLGAlertViewArray = [NSMutableArray new];

        self.windowLevel = LGAlertViewWindowLevelAboveStatusBar;
        self.cancelOnTouch = nil;
        self.dismissOnAction = YES;
        
        self.tintColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        self.coverColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        self.coverBlurEffect = nil;
        self.coverAlpha = 1.0;
        self.backgroundColor = UIColor.whiteColor;
        self.buttonsHeight = NSNotFound;
        self.textFieldsHeight = 44.0;
        self.offsetVertical = 8.0;
        self.cancelButtonOffsetY = 8.0;
        self.heightMax = NSNotFound;
        self.width = NSNotFound;
        self.separatorsColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        self.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        self.showsVerticalScrollIndicator = NO;
        self.padShowsActionSheetFromBottom = NO;
        self.oneRowOneButton = NO;

        self.layerCornerRadius = [UIDevice currentDevice].systemVersion.floatValue < 9.0 ? 6.0 : 12.0;
        self.layerBorderColor = nil;
        self.layerBorderWidth = 0.0;
        self.layerShadowColor = nil;
        self.layerShadowRadius = 0.0;
        self.layerShadowOpacity = 0.0;
        self.layerShadowOffset = CGSizeZero;

        self.titleTextColor = nil;
        self.titleTextAlignment = NSTextAlignmentCenter;
        self.titleFont = nil;

        self.messageTextColor = nil;
        self.messageTextAlignment = NSTextAlignmentCenter;
        self.messageFont = [UIFont systemFontOfSize:14.0];

        self.buttonsTitleColor = self.tintColor;
        self.buttonsTitleColorHighlighted = UIColor.whiteColor;
        self.buttonsTitleColorDisabled = UIColor.grayColor;
        self.buttonsTextAlignment = NSTextAlignmentCenter;
        self.buttonsFont = [UIFont systemFontOfSize:18.0];
        self.buttonsBackgroundColor = nil;
        self.buttonsBackgroundColorHighlighted = self.tintColor;
        self.buttonsBackgroundColorDisabled = nil;
        self.buttonsNumberOfLines = 1;
        self.buttonsLineBreakMode = NSLineBreakByTruncatingMiddle;
        self.buttonsMinimumScaleFactor = 14.0/18.0;
        self.buttonsAdjustsFontSizeToFitWidth = YES;

        self.cancelButtonTitleColor = self.tintColor;
        self.cancelButtonTitleColorHighlighted = UIColor.whiteColor;
        self.cancelButtonTitleColorDisabled = UIColor.grayColor;
        self.cancelButtonTextAlignment = NSTextAlignmentCenter;
        self.cancelButtonFont = [UIFont boldSystemFontOfSize:18.0];
        self.cancelButtonBackgroundColor = nil;
        self.cancelButtonBackgroundColorHighlighted = self.tintColor;
        self.cancelButtonBackgroundColorDisabled = nil;
        self.cancelButtonNumberOfLines = 1;
        self.cancelButtonLineBreakMode = NSLineBreakByTruncatingMiddle;
        self.cancelButtonMinimumScaleFactor = 14.0/18.0;
        self.cancelButtonAdjustsFontSizeToFitWidth = YES;

        self.destructiveButtonTitleColor = UIColor.redColor;
        self.destructiveButtonTitleColorHighlighted = UIColor.whiteColor;
        self.destructiveButtonTitleColorDisabled = UIColor.grayColor;
        self.destructiveButtonTextAlignment = NSTextAlignmentCenter;
        self.destructiveButtonFont = [UIFont systemFontOfSize:18.0];
        self.destructiveButtonBackgroundColor = nil;
        self.destructiveButtonBackgroundColorHighlighted = UIColor.redColor;
        self.destructiveButtonBackgroundColorDisabled = nil;
        self.destructiveButtonNumberOfLines = 1;
        self.destructiveButtonLineBreakMode = NSLineBreakByTruncatingMiddle;
        self.destructiveButtonMinimumScaleFactor = 14.0/18.0;
        self.destructiveButtonAdjustsFontSizeToFitWidth = YES;

        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        self.activityIndicatorViewColor = self.tintColor;

        self.progressViewProgressTintColor = self.tintColor;
        self.progressViewTrackTintColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        self.progressViewProgressImage = nil;
        self.progressViewTrackImage = nil;
        self.progressLabelTextColor = UIColor.blackColor;
        self.progressLabelTextAlignment = NSTextAlignmentCenter;
        self.progressLabelFont = [UIFont systemFontOfSize:14.0];
    });
}

- (void)setupDefaults {
    self.buttonsEnabledArray = [NSMutableArray new];

    for (NSUInteger i=0; i<self.buttonTitles.count; i++) {
        [self.buttonsEnabledArray addObject:@YES];
    }

    // -----

    self.windowLevel = LGAlertView.windowLevel;
    if (LGAlertView.cancelOnTouch) {
        self.cancelOnTouch = LGAlertView.cancelOnTouch.boolValue;
    }
    else {
        self.cancelOnTouch = self.type != LGAlertViewTypeActivityIndicator && self.type != LGAlertViewTypeProgressView && self.type != LGAlertViewTypeTextFields;
    }
    self.dismissOnAction = LGAlertView.isDismissOnAction;
    self.tag = 0;

    self.tintColor = LGAlertView.tintColor;
    self.coverColor = LGAlertView.coverColor;
    self.coverBlurEffect = LGAlertView.coverBlurEffect;
    self.coverAlpha = LGAlertView.coverAlpha;
    self.backgroundColor = LGAlertView.backgroundColor;
    if (LGAlertView.buttonsHeight != NSNotFound) {
        self.buttonsHeight = LGAlertView.buttonsHeight;
    }
    else {
        self.buttonsHeight = (self.style == LGAlertViewStyleAlert || [UIDevice currentDevice].systemVersion.floatValue < 9.0) ? 44.0 : 56.0;
    }
    self.textFieldsHeight = LGAlertView.textFieldsHeight;
    self.offsetVertical = LGAlertView.offsetVertical;
    self.cancelButtonOffsetY = LGAlertView.cancelButtonOffsetY;
    self.heightMax = LGAlertView.heightMax;
    self.width = LGAlertView.width;
    self.separatorsColor = LGAlertView.separatorsColor;
    self.indicatorStyle = LGAlertView.indicatorStyle;
    self.showsVerticalScrollIndicator = LGAlertView.isShowsVerticalScrollIndicator;
    self.padShowsActionSheetFromBottom = LGAlertView.isPadShowsActionSheetFromBottom;
    self.oneRowOneButton = LGAlertView.isOneRowOneButton;

    self.layerCornerRadius = LGAlertView.layerCornerRadius;
    self.layerBorderColor = LGAlertView.layerBorderColor;
    self.layerBorderWidth = LGAlertView.layerBorderWidth;
    self.layerShadowColor = LGAlertView.layerShadowColor;
    self.layerShadowRadius = LGAlertView.layerShadowRadius;
    self.layerShadowOpacity = LGAlertView.layerShadowOpacity;
    self.layerShadowOffset = LGAlertView.layerShadowOffset;

    if (LGAlertView.titleTextColor) {
        self.titleTextColor = LGAlertView.titleTextColor;
    }
    else {
        self.titleTextColor = self.style == LGAlertViewStyleAlert ? [UIColor blackColor] : [UIColor grayColor];
    }
    self.titleTextAlignment = LGAlertView.titleTextAlignment;
    if (LGAlertView.titleFont) {
        self.titleFont = LGAlertView.titleFont;
    }
    else {
        self.titleFont = self.style == LGAlertViewStyleAlert ? [UIFont boldSystemFontOfSize:18.0] : [UIFont boldSystemFontOfSize:14.0];
    }

    if (LGAlertView.messageTextColor) {
        self.messageTextColor = LGAlertView.messageTextColor;
    }
    else {
        self.messageTextColor = self.style == LGAlertViewStyleAlert ? [UIColor blackColor] : [UIColor grayColor];
    }
    self.messageTextAlignment = LGAlertView.messageTextAlignment;
    self.messageFont = LGAlertView.messageFont;

    self.buttonsTitleColor = LGAlertView.buttonsTitleColor;
    self.buttonsTitleColorHighlighted = LGAlertView.buttonsTitleColorHighlighted;
    self.buttonsTitleColorDisabled = LGAlertView.buttonsTitleColorDisabled;
    self.buttonsTextAlignment = LGAlertView.buttonsTextAlignment;
    self.buttonsFont = LGAlertView.buttonsFont;
    self.buttonsNumberOfLines = LGAlertView.buttonsNumberOfLines;
    self.buttonsLineBreakMode = LGAlertView.buttonsLineBreakMode;
    self.buttonsAdjustsFontSizeToFitWidth = LGAlertView.isButtonsAdjustsFontSizeToFitWidth;
    self.buttonsMinimumScaleFactor = LGAlertView.buttonsMinimumScaleFactor;
    self.buttonsBackgroundColor = LGAlertView.buttonsBackgroundColor;
    self.buttonsBackgroundColorHighlighted = LGAlertView.buttonsBackgroundColorHighlighted;
    self.buttonsBackgroundColorDisabled = LGAlertView.buttonsBackgroundColorDisabled;
    self.buttonsEnabled = YES;

    self.cancelButtonTitleColor = LGAlertView.cancelButtonTitleColor;
    self.cancelButtonTitleColorHighlighted = LGAlertView.cancelButtonTitleColorHighlighted;
    self.cancelButtonTitleColorDisabled = LGAlertView.cancelButtonTitleColorDisabled;
    self.cancelButtonTextAlignment = LGAlertView.cancelButtonTextAlignment;
    self.cancelButtonFont = LGAlertView.cancelButtonFont;
    self.cancelButtonNumberOfLines = LGAlertView.cancelButtonNumberOfLines;
    self.cancelButtonLineBreakMode = LGAlertView.cancelButtonLineBreakMode;
    self.cancelButtonAdjustsFontSizeToFitWidth = LGAlertView.isCancelButtonAdjustsFontSizeToFitWidth;
    self.cancelButtonMinimumScaleFactor = LGAlertView.cancelButtonMinimumScaleFactor;
    self.cancelButtonBackgroundColor = LGAlertView.cancelButtonBackgroundColor;
    self.cancelButtonBackgroundColorHighlighted = LGAlertView.cancelButtonBackgroundColorHighlighted;
    self.cancelButtonBackgroundColorDisabled = LGAlertView.cancelButtonBackgroundColorDisabled;
    self.cancelButtonEnabled = YES;

    self.destructiveButtonTitleColor = LGAlertView.destructiveButtonTitleColor;
    self.destructiveButtonTitleColorHighlighted = LGAlertView.destructiveButtonTitleColorHighlighted;
    self.destructiveButtonTitleColorDisabled = LGAlertView.destructiveButtonTitleColorDisabled;
    self.destructiveButtonTextAlignment = LGAlertView.destructiveButtonTextAlignment;
    self.destructiveButtonFont = LGAlertView.destructiveButtonFont;
    self.destructiveButtonNumberOfLines = LGAlertView.destructiveButtonNumberOfLines;
    self.destructiveButtonLineBreakMode = LGAlertView.destructiveButtonLineBreakMode;
    self.destructiveButtonAdjustsFontSizeToFitWidth = LGAlertView.isDestructiveButtonAdjustsFontSizeToFitWidth;
    self.destructiveButtonMinimumScaleFactor = LGAlertView.destructiveButtonMinimumScaleFactor;
    self.destructiveButtonBackgroundColor = LGAlertView.destructiveButtonBackgroundColor;
    self.destructiveButtonBackgroundColorHighlighted = LGAlertView.destructiveButtonBackgroundColorHighlighted;
    self.destructiveButtonBackgroundColorDisabled = LGAlertView.destructiveButtonBackgroundColorDisabled;
    self.destructiveButtonEnabled = YES;

    self.activityIndicatorViewStyle = LGAlertView.activityIndicatorViewStyle;
    self.activityIndicatorViewColor = LGAlertView.activityIndicatorViewColor;

    self.progressViewProgressTintColor = LGAlertView.progressViewProgressTintColor;
    self.progressViewTrackTintColor = LGAlertView.progressViewTrackTintColor;
    self.progressViewProgressImage = LGAlertView.progressViewProgressImage;
    self.progressViewTrackImage = LGAlertView.progressViewTrackImage;
    self.progressLabelTextColor = LGAlertView.progressLabelTextColor;
    self.progressLabelTextAlignment = LGAlertView.progressLabelTextAlignment;
    self.progressLabelFont = LGAlertView.progressLabelFont;

    // -----

    self.view = [UIView new];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.userInteractionEnabled = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.backgroundView = [[UIVisualEffectView alloc] initWithEffect:self.coverBlurEffect];
    self.backgroundView.alpha = 0.0;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.backgroundView];

    // -----

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction:)];
    tapGesture.delegate = self;
    [self.backgroundView addGestureRecognizer:tapGesture];

    // -----

    self.viewController = [[LGAlertViewController alloc] initWithAlertView:self view:self.view];

    self.window = [[LGAlertViewWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.hidden = YES;
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.window.opaque = NO;
    self.window.backgroundColor = [UIColor clearColor];
    self.window.rootViewController = self.viewController;
}

#pragma mark - Dealloc

#if DEBUG
- (void)dealloc {
    NSLog(@"%s [Line %d]", __PRETTY_FUNCTION__, __LINE__);
}
#endif

#pragma mark - Observers

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowVisibleChanged:) name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowVisibleChanged:) name:UIWindowDidBecomeHiddenNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardVisibleChanged:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardVisibleChanged:) name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - Window notifications

- (void)windowVisibleChanged:(NSNotification *)notification {
    NSUInteger windowIndex = [kLGAlertViewWindowsArray indexOfObject:self.window];

    //NSLog(@"windowVisibleChanged: %@", notification);

    UIWindow *notificationWindow = notification.object;

    //NSLog(@"%@", NSStringFromClass([window class]));

    if ([NSStringFromClass([notificationWindow class]) isEqualToString:@"UITextEffectsWindow"] ||
        [NSStringFromClass([notificationWindow class]) isEqualToString:@"UIRemoteKeyboardWindow"] ||
        [NSStringFromClass([notificationWindow class]) isEqualToString:@"LGAlertViewWindow"] ||
        [notificationWindow isEqual:self.window]) {
        return;
    }

    if (notification.name == UIWindowDidBecomeVisibleNotification) {
        if ([notificationWindow isEqual:kLGAlertViewWindowPrevious(windowIndex)]) {
            notificationWindow.hidden = YES;

            [self.window makeKeyAndVisible];
        }
        else if (!kLGAlertViewWindowNext(windowIndex)) {
            self.window.hidden = YES;

            [kLGAlertViewWindowsArray addObject:notificationWindow];
        }
    }
    else if (notification.name == UIWindowDidBecomeHiddenNotification) {
        if ([notificationWindow isEqual:kLGAlertViewWindowNext(windowIndex)] &&
            [notificationWindow isEqual:kLGAlertViewWindowsArray.lastObject]) {
            [self.window makeKeyAndVisible];

            [kLGAlertViewWindowsArray removeLastObject];
        }
    }
}

#pragma mark - Keyboard notifications

- (void)keyboardVisibleChanged:(NSNotification *)notification{
    [LGAlertView
     keyboardAnimateWithNotificationUserInfo:notification.userInfo
     animations:^(CGFloat keyboardHeight) {
         if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
             self.keyboardHeight = keyboardHeight;
         }
         else {
             self.keyboardHeight = 0.0;
         }

         [self layoutValidateWithSize:self.view.frame.size];
     }];
}

- (void)keyboardFrameChanged:(NSNotification *)notification {
    if ([notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] == 0.0) {
        self.keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(LGAlertViewTextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        if (self.textFieldsArray.count > textField.tag+1) {
            LGAlertViewTextField *nextTextField = self.textFieldsArray[textField.tag+1];
            [nextTextField becomeFirstResponder];
        }
    }
    else if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    }

    return YES;
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.isCancelOnTouch;
}

#pragma mark - Setters and Getters

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;

    if (!self.isUserButtonsTitleColor) {
        self.buttonsTitleColor = tintColor;
    }

    if (!self.isUserCancelButtonTitleColor) {
        self.cancelButtonTitleColor = tintColor;
    }

    if (!self.isUserButtonsBackgroundColorHighlighted) {
        self.buttonsBackgroundColorHighlighted = tintColor;
    }

    if (!self.isUserCancelButtonBackgroundColorHighlighted) {
        self.cancelButtonBackgroundColorHighlighted = tintColor;
    }

    if (!self.isUserActivityIndicatorViewColor) {
        self.activityIndicatorViewColor = tintColor;
    }

    if (!self.isUserProgressViewProgressTintColor) {
        self.progressViewProgressTintColor = tintColor;
    }
}

- (void)setButtonsTitleColor:(UIColor *)buttonsTitleColor {
    _buttonsTitleColor = buttonsTitleColor;
    self.userButtonsTitleColor = YES;
}

- (void)setButtonsTitleColorHighlighted:(UIColor *)buttonsTitleColorHighlighted {
    _buttonsTitleColorHighlighted = buttonsTitleColorHighlighted;
    self.userButtonsTitleColorHighlighted = YES;
}

- (void)setButtonsBackgroundColorHighlighted:(UIColor *)buttonsBackgroundColorHighlighted {
    _buttonsBackgroundColorHighlighted = buttonsBackgroundColorHighlighted;
    self.userButtonsBackgroundColorHighlighted = YES;
}

- (void)setCancelButtonTitleColor:(UIColor *)cancelButtonTitleColor {
    _cancelButtonTitleColor = cancelButtonTitleColor;
    self.userCancelButtonTitleColor = YES;
}

- (void)setCancelButtonTitleColorHighlighted:(UIColor *)cancelButtonTitleColorHighlighted {
    _cancelButtonTitleColorHighlighted = cancelButtonTitleColorHighlighted;
    self.userCancelButtonTitleColorHighlighted = YES;
}

- (void)setCancelButtonBackgroundColorHighlighted:(UIColor *)cancelButtonBackgroundColorHighlighted {
    _cancelButtonBackgroundColorHighlighted = cancelButtonBackgroundColorHighlighted;
    self.userCancelButtonBackgroundColorHighlighted = YES;
}

- (void)setDestructiveButtonTitleColorHighlighted:(UIColor *)destructiveButtonTitleColorHighlighted {
    _destructiveButtonTitleColorHighlighted = destructiveButtonTitleColorHighlighted;
    self.userDestructiveButtonTitleColorHighlighted = YES;
}

- (void)setDestructiveButtonBackgroundColorHighlighted:(UIColor *)destructiveButtonBackgroundColorHighlighted {
    _destructiveButtonBackgroundColorHighlighted = destructiveButtonBackgroundColorHighlighted;
    self.userDestructiveButtonBackgroundColorHighlighted = YES;
}

- (void)setActivityIndicatorViewColor:(UIColor *)activityIndicatorViewColor {
    _activityIndicatorViewColor = activityIndicatorViewColor;
    self.userActivityIndicatorViewColor = YES;
}

- (void)setProgressViewProgressTintColor:(UIColor *)progressViewProgressTintColor {
    _progressViewProgressTintColor = progressViewProgressTintColor;
    self.userProgressViewProgressTintColor = YES;
}

- (BOOL)isVisible {
    return (self.isShowing && self.window.isKeyWindow && !self.window.isHidden);
}

#pragma mark -

- (void)setProgress:(float)progress progressLabelText:(nullable NSString *)progressLabelText {
    if (self.type != LGAlertViewTypeProgressView) return;

    [self.progressView setProgress:progress animated:YES];

    self.progressLabel.text = progressLabelText;
}

- (float)progress {
    if (self.type != LGAlertViewTypeProgressView) return 0.0;

    return self.progressView.progress;
}

- (void)setButtonAtIndex:(NSUInteger)index enabled:(BOOL)enabled {
    if (self.buttonTitles.count <= index) return;

    self.buttonsEnabledArray[index] = [NSNumber numberWithBool:enabled];

    if (self.tableView) {
        if (self.destructiveButtonTitle.length) {
            index++;
        }

        LGAlertViewCell *cell = (LGAlertViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.enabled = enabled;
    }
    else if (self.scrollView) {
        switch (index) {
            case 0:
                self.firstButton.enabled = enabled;
                break;
            case 1:
                self.secondButton.enabled = enabled;
                break;
            case 2:
                self.thirdButton.enabled = enabled;
                break;
            default:
                break;
        }
    }
}

- (void)setCancelButtonEnabled:(BOOL)cancelButtonEnabled {
    _cancelButtonEnabled = cancelButtonEnabled;

    if (self.cancelButtonTitle.length) {
        if (self.tableView) {
            LGAlertViewCell *cell = (LGAlertViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(self.buttonTitles.count-1) inSection:0]];
            cell.enabled = cancelButtonEnabled;
        }
        else if (self.scrollView) {
            self.cancelButton.enabled = cancelButtonEnabled;
        }
    }
}

- (void)setDestructiveButtonEnabled:(BOOL)destructiveButtonEnabled {
    _destructiveButtonEnabled = destructiveButtonEnabled;

    if (self.destructiveButtonTitle.length) {
        if (self.tableView) {
            LGAlertViewCell *cell = (LGAlertViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.enabled = destructiveButtonEnabled;
        }
        else if (self.scrollView) {
            self.destructiveButton.enabled = destructiveButtonEnabled;
        }
    }
}

- (BOOL)isButtonEnabledAtIndex:(NSUInteger)index {
    return [self.buttonsEnabledArray[index] boolValue];
}

- (void)setButtonPropertiesAtIndex:(NSUInteger)index
                           handler:(void(^ _Nonnull)(LGAlertViewButtonProperties * _Nonnull properties))handler {
    if (!handler || self.buttonTitles.count <= index) return;

    if (!self.buttonsPropertiesDictionary) {
        self.buttonsPropertiesDictionary = [NSMutableDictionary new];
    }

    LGAlertViewButtonProperties *properties = self.buttonsPropertiesDictionary[[NSNumber numberWithInteger:index]];

    if (!properties) {
        properties = [LGAlertViewButtonProperties new];
    }

    handler(properties);

    if (properties.isUserEnabled) {
        self.buttonsEnabledArray[index] = [NSNumber numberWithBool:properties.enabled];
    }

    [self.buttonsPropertiesDictionary setObject:properties forKey:[NSNumber numberWithInteger:index]];
}

- (void)forceCancel {
    NSAssert(self.cancelButtonTitle.length > 0, @"Cancel button is not exists");

    [self cancelAction:nil];
}

- (void)forceDestructive {
    NSAssert(self.destructiveButtonTitle.length > 0, @"Destructive button is not exists");

    [self destructiveAction:nil];
}

- (void)forceActionAtIndex:(NSUInteger)index {
    NSAssert(self.buttonTitles.count > index, @"Button at index %lu is not exists", (long unsigned)index);

    [self actionActionAtIndex:index title:self.buttonTitles[index + (self.tableView && self.destructiveButtonTitle.length ? 1 : 0)]];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buttonTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGAlertViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.title = self.buttonTitles[indexPath.row];

    if (self.destructiveButtonTitle.length && indexPath.row == 0) {
        cell.titleColor                 = self.destructiveButtonTitleColor;
        cell.titleColorHighlighted      = self.destructiveButtonTitleColorHighlighted;
        cell.titleColorDisabled         = self.destructiveButtonTitleColorDisabled;
        cell.backgroundColorNormal      = self.destructiveButtonBackgroundColor;
        cell.backgroundColorHighlighted = self.destructiveButtonBackgroundColorHighlighted;
        cell.backgroundColorDisabled    = self.destructiveButtonBackgroundColorDisabled;
        cell.separatorVisible           = (indexPath.row != self.buttonTitles.count-1);
        cell.separatorColor_            = self.separatorsColor;
        cell.textAlignment              = self.destructiveButtonTextAlignment;
        cell.font                       = self.destructiveButtonFont;
        cell.numberOfLines              = self.destructiveButtonNumberOfLines;
        cell.lineBreakMode              = self.destructiveButtonLineBreakMode;
        cell.adjustsFontSizeToFitWidth  = self.destructiveButtonAdjustsFontSizeToFitWidth;
        cell.minimumScaleFactor         = self.destructiveButtonMinimumScaleFactor;
        cell.enabled                    = self.destructiveButtonEnabled;
    }
    else if (self.cancelButtonTitle.length && !kLGAlertViewIsCancelButtonSeparate(self) && indexPath.row == self.buttonTitles.count-1) {
        cell.titleColor                 = self.cancelButtonTitleColor;
        cell.titleColorHighlighted      = self.cancelButtonTitleColorHighlighted;
        cell.titleColorDisabled         = self.cancelButtonTitleColorDisabled;
        cell.backgroundColorNormal      = self.cancelButtonBackgroundColor;
        cell.backgroundColorHighlighted = self.cancelButtonBackgroundColorHighlighted;
        cell.backgroundColorDisabled    = self.cancelButtonBackgroundColorDisabled;
        cell.separatorVisible           = NO;
        cell.separatorColor_            = self.separatorsColor;
        cell.textAlignment              = self.cancelButtonTextAlignment;
        cell.font                       = self.cancelButtonFont;
        cell.numberOfLines              = self.cancelButtonNumberOfLines;
        cell.lineBreakMode              = self.cancelButtonLineBreakMode;
        cell.adjustsFontSizeToFitWidth  = self.cancelButtonAdjustsFontSizeToFitWidth;
        cell.minimumScaleFactor         = self.cancelButtonMinimumScaleFactor;
        cell.enabled                    = self.cancelButtonEnabled;
    }
    else {
        LGAlertViewButtonProperties *properties = nil;

        if (self.buttonsPropertiesDictionary) {
            properties = self.buttonsPropertiesDictionary[[NSNumber numberWithInteger:(indexPath.row - (self.destructiveButtonTitle.length ? 1 : 0))]];
        }

        cell.titleColor                 = (properties.isUserTitleColor ? properties.titleColor : self.buttonsTitleColor);
        cell.titleColorHighlighted      = (properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : self.buttonsTitleColorHighlighted);
        cell.titleColorDisabled         = (properties.isUserTitleColorDisabled ? properties.titleColorDisabled : self.buttonsTitleColorDisabled);
        cell.backgroundColorNormal      = (properties.isUserBackgroundColor ? properties.backgroundColor : self.buttonsBackgroundColor);
        cell.backgroundColorHighlighted = (properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : self.buttonsBackgroundColorHighlighted);
        cell.backgroundColorDisabled    = (properties.isUserBackgroundColorDisabled ? properties.backgroundColorDisabled : self.buttonsBackgroundColorDisabled);
        cell.separatorVisible           = (indexPath.row != self.buttonTitles.count-1);
        cell.separatorColor_            = self.separatorsColor;
        cell.textAlignment              = (properties.isUserTextAlignment ? properties.textAlignment : self.buttonsTextAlignment);
        cell.font                       = (properties.isUserFont ? properties.font : self.buttonsFont);
        cell.numberOfLines              = (properties.isUserNumberOfLines ? properties.numberOfLines : self.buttonsNumberOfLines);
        cell.lineBreakMode              = (properties.isUserLineBreakMode ? properties.lineBreakMode : self.buttonsLineBreakMode);
        cell.adjustsFontSizeToFitWidth  = (properties.isUserAdjustsFontSizeTofitWidth ? properties.adjustsFontSizeToFitWidth : self.buttonsAdjustsFontSizeToFitWidth);
        cell.minimumScaleFactor         = (properties.isUserMinimimScaleFactor ? properties.minimumScaleFactor : self.buttonsMinimumScaleFactor);
        cell.enabled                    = [self.buttonsEnabledArray[indexPath.row - (self.destructiveButtonTitle.length ? 1 : 0)] boolValue];
    }

    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.destructiveButtonTitle.length && indexPath.row == 0 && self.destructiveButtonNumberOfLines != 1) {
        NSString *title = self.buttonTitles[indexPath.row];

        UILabel *label = [UILabel new];
        label.text = title;
        label.textAlignment             = self.destructiveButtonTextAlignment;
        label.font                      = self.destructiveButtonFont;
        label.numberOfLines             = self.destructiveButtonNumberOfLines;
        label.lineBreakMode             = self.destructiveButtonLineBreakMode;
        label.adjustsFontSizeToFitWidth = self.destructiveButtonAdjustsFontSizeToFitWidth;
        label.minimumScaleFactor        = self.destructiveButtonMinimumScaleFactor;

        CGSize size = [label sizeThatFits:CGSizeMake(tableView.frame.size.width-kLGAlertViewPaddingW*2, CGFLOAT_MAX)];
        size.height += kLGAlertViewButtonTitleMarginH*2;

        if (size.height < self.buttonsHeight) {
            size.height = self.buttonsHeight;
        }

        return size.height;
    }
    else if (self.cancelButtonTitle.length && !kLGAlertViewIsCancelButtonSeparate(self) && indexPath.row == self.buttonTitles.count-1 && self.cancelButtonNumberOfLines != 1) {
        NSString *title = self.buttonTitles[indexPath.row];

        UILabel *label = [UILabel new];
        label.text = title;
        label.textAlignment             = self.cancelButtonTextAlignment;
        label.font                      = self.cancelButtonFont;
        label.numberOfLines             = self.cancelButtonNumberOfLines;
        label.lineBreakMode             = self.cancelButtonLineBreakMode;
        label.adjustsFontSizeToFitWidth = self.cancelButtonAdjustsFontSizeToFitWidth;
        label.minimumScaleFactor        = self.cancelButtonMinimumScaleFactor;

        CGSize size = [label sizeThatFits:CGSizeMake(tableView.frame.size.width-kLGAlertViewPaddingW*2, CGFLOAT_MAX)];
        size.height += kLGAlertViewButtonTitleMarginH*2;

        if (size.height < self.buttonsHeight) {
            size.height = self.buttonsHeight;
        }

        return size.height;
    }
    else if (self.buttonsNumberOfLines != 1) {
        NSString *title = self.buttonTitles[indexPath.row];

        UILabel *label = [UILabel new];
        label.text = title;
        label.textAlignment             = self.buttonsTextAlignment;
        label.font                      = self.buttonsFont;
        label.numberOfLines             = self.buttonsNumberOfLines;
        label.lineBreakMode             = self.buttonsLineBreakMode;
        label.adjustsFontSizeToFitWidth = self.buttonsAdjustsFontSizeToFitWidth;
        label.minimumScaleFactor        = self.buttonsMinimumScaleFactor;

        CGSize size = [label sizeThatFits:CGSizeMake(tableView.frame.size.width-kLGAlertViewPaddingW*2, CGFLOAT_MAX)];
        size.height += kLGAlertViewButtonTitleMarginH*2;

        if (size.height < self.buttonsHeight) {
            size.height = self.buttonsHeight;
        }

        return size.height;
    }
    else return self.buttonsHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.destructiveButtonTitle.length && indexPath.row == 0) {
        [self destructiveAction:nil];
    }
    else if (self.cancelButtonTitle.length && indexPath.row == self.buttonTitles.count-1 && !kLGAlertViewIsCancelButtonSeparate(self)) {
        [self cancelAction:nil];
    }
    else {
        NSUInteger index = indexPath.row;

        if (self.destructiveButtonTitle.length) {
            index--;
        }

        NSString *title = self.buttonTitles[indexPath.row];

        // -----

        [self actionActionAtIndex:index title:title];
    }
}

#pragma mark - Show

- (void)showAnimated:(BOOL)animated completionHandler:(LGAlertViewCompletionHandler)completionHandler {
    [self showAnimated:animated hidden:NO completionHandler:completionHandler];
}

- (void)showAnimated {
    [self showAnimated:YES completionHandler:nil];
}

- (void)show {
    [self showAnimated:NO completionHandler:nil];
}

- (void)showAnimated:(BOOL)animated hidden:(BOOL)hidden completionHandler:(LGAlertViewCompletionHandler)completionHandler {
    if (self.isShowing) return;

    self.window.windowLevel = UIWindowLevelStatusBar + (self.windowLevel == LGAlertViewWindowLevelAboveStatusBar ? 1 : -1);
    self.view.userInteractionEnabled = NO;

    CGSize size = self.viewController.view.bounds.size;

    [self subviewsValidateWithSize:size];
    [self layoutValidateWithSize:size];

    self.showing = YES;

    if (![kLGAlertViewArray containsObject:self]) {
        [kLGAlertViewArray addObject:self];
    }

    // -----

    [self addObservers];

    // -----

    UIWindow *windowApp = [UIApplication sharedApplication].delegate.window;
    NSAssert(windowApp != nil, @"Application needs to have at least one window");

    UIWindow *windowKey = [UIApplication sharedApplication].keyWindow;
    NSAssert(windowKey != nil, @"Application needs to have at least one keyAndVisible window");

    if (!kLGAlertViewWindowsArray.count) {
        [kLGAlertViewWindowsArray addObject:windowApp];
    }

    if (![windowKey isEqual:windowApp] && ![kLGAlertViewWindowsArray containsObject:windowKey]) {
        [kLGAlertViewWindowsArray addObject:windowKey];
    }

    if (![kLGAlertViewWindowsArray containsObject:self.window]) {
        [kLGAlertViewWindowsArray addObject:self.window];
    }

    if (!hidden && ![windowKey isEqual:windowApp]) {
        windowKey.hidden = YES;
    }

    [self.window makeKeyAndVisible];

    // -----

    if (self.willShowHandler) {
        self.willShowHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewWillShow:)]) {
        [self.delegate alertViewWillShow:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewWillShowNotification object:self userInfo:nil];

    // -----

    if (hidden) {
        self.backgroundView.hidden = YES;
        self.scrollView.hidden = YES;
        self.styleView.hidden = YES;

        if (kLGAlertViewIsCancelButtonSeparate(self)) {
            self.cancelButton.hidden = YES;
            self.styleCancelView.hidden = YES;
        }
    }

    // -----

    if (animated) {
        [LGAlertView
         animateStandardWithAnimations:^(void) {
             [self showAnimations];
         }
         completion:^(BOOL finished) {
             if (!hidden) {
                 [self showComplete];
             }

             if (completionHandler) {
                 completionHandler();
             }
         }];
    }
    else {
        [self showAnimations];

        if (!hidden) {
            [self showComplete];
        }

        if (completionHandler) {
            completionHandler();
        }
    }
}

- (void)showAnimations {
    self.backgroundView.alpha = self.coverAlpha;

    if (self.style == LGAlertViewStyleAlert || kLGAlertViewPadAndNotForce(self)) {
        self.scrollView.transform = CGAffineTransformIdentity;
        self.scrollView.alpha = 1.0;

        self.styleView.transform = CGAffineTransformIdentity;
        self.styleView.alpha = 1.0;
    }
    else {
        self.scrollView.center = self.scrollViewCenterShowed;

        self.styleView.center = self.scrollViewCenterShowed;
    }

    if (kLGAlertViewIsCancelButtonSeparate(self) && self.cancelButton) {
        self.cancelButton.center = self.cancelButtonCenterShowed;

        self.styleCancelView.center = self.cancelButtonCenterShowed;
    }
}

- (void)showComplete {
    if (self.type == LGAlertViewTypeTextFields && self.textFieldsArray.count) {
        [self.textFieldsArray[0] becomeFirstResponder];
    }

    // -----

    if (self.didShowHandler) {
        self.didShowHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidShow:)]) {
        [self.delegate alertViewDidShow:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewDidShowNotification object:self userInfo:nil];

    // -----

    self.view.userInteractionEnabled = YES;
}

#pragma mark - Dismiss

- (void)dismissAnimated:(BOOL)animated completionHandler:(LGAlertViewCompletionHandler)completionHandler {
    if (!self.isShowing) return;

    self.view.userInteractionEnabled = NO;

    self.showing = NO;

    [self removeObservers];

    [self.view endEditing:YES];

    // -----

    if (self.willDismissHandler) {
        self.willDismissHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewWillDismiss:)]) {
        [self.delegate alertViewWillDismiss:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewWillDismissNotification object:self userInfo:nil];

    // -----

    if (animated) {
        [LGAlertView
         animateStandardWithAnimations:^(void) {
             [self dismissAnimations];
         }
         completion:^(BOOL finished) {
             [self dismissComplete];

             if (completionHandler) {
                 completionHandler();
             }
         }];
    }
    else {
        [self dismissAnimations];

        [self dismissComplete];

        if (completionHandler) {
            completionHandler();
        }
    }
}

- (void)dismissAnimated {
    [self dismissAnimated:YES completionHandler:nil];
}

- (void)dismiss {
    [self dismissAnimated:NO completionHandler:nil];
}

- (void)dismissAnimations {
    self.backgroundView.alpha = 0.0;

    if (self.style == LGAlertViewStyleAlert || kLGAlertViewPadAndNotForce(self)) {
        self.scrollView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        self.scrollView.alpha = 0.0;

        self.styleView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        self.styleView.alpha = 0.0;
    }
    else {
        self.scrollView.center = self.scrollViewCenterHidden;

        self.styleView.center = self.scrollViewCenterHidden;
    }

    if (kLGAlertViewIsCancelButtonSeparate(self) && self.cancelButton) {
        self.cancelButton.center = self.cancelButtonCenterHidden;

        self.styleCancelView.center = self.cancelButtonCenterHidden;
    }
}

- (void)dismissComplete {
    self.window.hidden = YES;

    if ([kLGAlertViewWindowsArray.lastObject isEqual:self.window]) {
        NSUInteger windowIndex = [kLGAlertViewWindowsArray indexOfObject:self.window];

        [kLGAlertViewWindowPrevious(windowIndex) makeKeyAndVisible];
    }

    // -----

    if (self.didDismissHandler) {
        self.didDismissHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidDismiss:)]) {
        [self.delegate alertViewDidDismiss:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewDidDismissNotification object:self userInfo:nil];

    // -----

    if ([kLGAlertViewWindowsArray containsObject:self.window]) {
        [kLGAlertViewWindowsArray removeObject:self.window];
    }

    if ([kLGAlertViewArray containsObject:self]) {
        [kLGAlertViewArray removeObject:self];
    }

    self.view = nil;
    self.viewController = nil;
    self.window = nil;
    self.delegate = nil;
}

#pragma mark - Transition

- (void)transitionToAlertView:(nonnull LGAlertView *)alertView completionHandler:(LGAlertViewCompletionHandler)completionHandler {
    self.view.userInteractionEnabled = NO;

    [alertView showAnimated:NO
                     hidden:YES
          completionHandler:^(void) {
              NSTimeInterval duration = 0.3;

              BOOL cancelButtonSelf = kLGAlertViewIsCancelButtonSeparate(self) && self.cancelButtonTitle.length;
              BOOL cancelButtonNext = kLGAlertViewIsCancelButtonSeparate(alertView) && alertView.cancelButtonTitle.length;

              // -----

              [UIView animateWithDuration:duration
                               animations:^(void) {
                                   self.scrollView.alpha = 0.0;

                                   if (cancelButtonSelf) {
                                       self.cancelButton.alpha = 0.0;

                                       if (!cancelButtonNext) {
                                           self.styleCancelView.alpha = 0.0;
                                       }
                                   }
                               }
                               completion:^(BOOL finished) {
                                   alertView.backgroundView.alpha = 0.0;
                                   alertView.backgroundView.hidden = NO;

                                   [UIView animateWithDuration:duration*2.0
                                                    animations:^(void) {
                                                        self.backgroundView.alpha = 0.0;
                                                        alertView.backgroundView.alpha = alertView.coverAlpha;
                                                    }];

                                   // -----

                                   CGRect styleViewFrame = alertView.styleView.frame;

                                   alertView.styleView.frame = self.styleView.frame;

                                   alertView.styleView.hidden = NO;
                                   self.styleView.hidden = YES;

                                   // -----

                                   if (cancelButtonNext) {
                                       alertView.styleCancelView.hidden = NO;

                                       if (!cancelButtonSelf) {
                                           alertView.styleCancelView.alpha = 0.0;
                                       }
                                   }

                                   // -----

                                   if (cancelButtonSelf && cancelButtonNext) {
                                       self.styleCancelView.hidden = YES;
                                   }

                                   // -----

                                   [UIView animateWithDuration:duration
                                                    animations:^(void) {
                                                        alertView.styleView.frame = styleViewFrame;
                                                    }
                                                    completion:^(BOOL finished) {
                                                        alertView.scrollView.alpha = 0.0;
                                                        alertView.scrollView.hidden = NO;

                                                        if (cancelButtonNext) {
                                                            alertView.cancelButton.alpha = 0.0;
                                                            alertView.cancelButton.hidden = NO;
                                                        }

                                                        [UIView animateWithDuration:duration
                                                                         animations:^(void) {
                                                                             self.scrollView.alpha = 0.0;
                                                                             alertView.scrollView.alpha = 1.0;

                                                                             if (cancelButtonNext) {
                                                                                 alertView.cancelButton.alpha = 1.0;

                                                                                 if (!cancelButtonSelf) {
                                                                                     alertView.styleCancelView.alpha = 1.0;
                                                                                 }
                                                                             }
                                                                         }
                                                                         completion:^(BOOL finished) {
                                                                             [self dismissAnimated:NO
                                                                                 completionHandler:^(void) {
                                                                                     [alertView showComplete];

                                                                                     if (completionHandler) {
                                                                                         completionHandler();
                                                                                     }
                                                                                 }];
                                                                         }];
                                                    }];
                               }];
          }];
}

- (void)transitionToAlertView:(LGAlertView *)alertView {
    [self transitionToAlertView:alertView completionHandler:nil];
}

#pragma mark -

- (CGFloat)widthForSize:(CGSize)size {
    if (self.width != NSNotFound) {
        CGFloat result = MIN(size.width, size.height);

        if (self.width < result) {
            result = self.width;
        }

        return result;
    }

    if (self.style == LGAlertViewStyleAlert || kLGAlertViewPadAndNotForce(self)) {
        return 320.0 - 20*2;
    }

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 320.0 - 16*2;
    }

    return MIN(size.width, size.height) - 8.0*2;
}

- (void)subviewsValidateWithSize:(CGSize)size {
    CGFloat width = [self widthForSize:size];

    // -----

    if (!self.isExists) {
        self.exists = YES;

        self.backgroundView.backgroundColor = self.coverColor;
        self.backgroundView.effect = self.coverBlurEffect;

        self.styleView = [UIView new];
        self.styleView.backgroundColor = self.backgroundColor;
        self.styleView.layer.masksToBounds = NO;
        self.styleView.layer.cornerRadius = self.layerCornerRadius+(self.layerCornerRadius == 0.0 ? 0.0 : self.layerBorderWidth+1.0);
        self.styleView.layer.borderColor = self.layerBorderColor.CGColor;
        self.styleView.layer.borderWidth = self.layerBorderWidth;
        self.styleView.layer.shadowColor = self.layerShadowColor.CGColor;
        self.styleView.layer.shadowRadius = self.layerShadowRadius;
        self.styleView.layer.shadowOpacity = self.layerShadowOpacity;
        self.styleView.layer.shadowOffset = self.layerShadowOffset;
        [self.view addSubview:self.styleView];

        self.scrollView = [UIScrollView new];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.indicatorStyle = self.indicatorStyle;
        self.scrollView.showsVerticalScrollIndicator = self.showsVerticalScrollIndicator;
        self.scrollView.alwaysBounceVertical = NO;
        self.scrollView.layer.masksToBounds = YES;
        self.scrollView.layer.cornerRadius = self.layerCornerRadius;
        [self.view addSubview:self.scrollView];

        CGFloat offsetY = 0.0;

        if (self.title.length) {
            self.titleLabel = [UILabel new];
            self.titleLabel.text = self.title;
            self.titleLabel.textColor = self.titleTextColor;
            self.titleLabel.textAlignment = self.titleTextAlignment;
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.titleLabel.backgroundColor = [UIColor clearColor];
            self.titleLabel.font = self.titleFont;

            CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(width-kLGAlertViewPaddingW*2, CGFLOAT_MAX)];
            CGRect titleLabelFrame = CGRectMake(kLGAlertViewPaddingW, kLGAlertViewInnerMarginH, width-kLGAlertViewPaddingW*2, titleLabelSize.height);

            if ([UIScreen mainScreen].scale == 1.0) {
                titleLabelFrame = CGRectIntegral(titleLabelFrame);
            }

            self.titleLabel.frame = titleLabelFrame;
            [self.scrollView addSubview:self.titleLabel];

            offsetY = self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height;
        }

        if (self.message.length) {
            self.messageLabel = [UILabel new];
            self.messageLabel.text = self.message;
            self.messageLabel.textColor = self.messageTextColor;
            self.messageLabel.textAlignment = self.messageTextAlignment;
            self.messageLabel.numberOfLines = 0;
            self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.messageLabel.backgroundColor = [UIColor clearColor];
            self.messageLabel.font = self.messageFont;

            if (!offsetY) {
                offsetY = kLGAlertViewInnerMarginH/2;
            }
            else if (self.style == LGAlertViewStyleActionSheet) {
                offsetY -= kLGAlertViewInnerMarginH/3;
            }

            CGSize messageLabelSize = [self.messageLabel sizeThatFits:CGSizeMake(width-kLGAlertViewPaddingW*2, CGFLOAT_MAX)];
            CGRect messageLabelFrame = CGRectMake(kLGAlertViewPaddingW, offsetY+kLGAlertViewInnerMarginH/2, width-kLGAlertViewPaddingW*2, messageLabelSize.height);

            if ([UIScreen mainScreen].scale == 1.0) {
                messageLabelFrame = CGRectIntegral(messageLabelFrame);
            }

            self.messageLabel.frame = messageLabelFrame;
            [self.scrollView addSubview:self.messageLabel];

            offsetY = self.messageLabel.frame.origin.y+self.messageLabel.frame.size.height;
        }

        if (self.innerView) {
            CGRect innerViewFrame = CGRectMake(width/2-self.innerView.frame.size.width/2, offsetY+kLGAlertViewInnerMarginH, self.innerView.frame.size.width, self.innerView.frame.size.height);

            if ([UIScreen mainScreen].scale == 1.0) {
                innerViewFrame = CGRectIntegral(innerViewFrame);
            }

            self.innerView.frame = innerViewFrame;
            [self.scrollView addSubview:self.innerView];

            offsetY = self.innerView.frame.origin.y+self.innerView.frame.size.height;
        }
        else if (self.type == LGAlertViewTypeActivityIndicator) {
            self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
            self.activityIndicator.color = self.activityIndicatorViewColor;
            self.activityIndicator.backgroundColor = [UIColor clearColor];
            [self.activityIndicator startAnimating];

            CGRect activityIndicatorFrame = CGRectMake(width/2-self.activityIndicator.frame.size.width/2,
                                                       offsetY+kLGAlertViewInnerMarginH,
                                                       self.activityIndicator.frame.size.width,
                                                       self.activityIndicator.frame.size.height);

            if ([UIScreen mainScreen].scale == 1.0) {
                activityIndicatorFrame = CGRectIntegral(activityIndicatorFrame);
            }

            self.activityIndicator.frame = activityIndicatorFrame;
            [self.scrollView addSubview:self.activityIndicator];

            offsetY = self.activityIndicator.frame.origin.y+self.activityIndicator.frame.size.height;
        }
        else if (self.type == LGAlertViewTypeProgressView) {
            self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
            self.progressView.backgroundColor = [UIColor clearColor];
            self.progressView.progressTintColor = self.progressViewProgressTintColor;
            self.progressView.trackTintColor = self.progressViewTrackTintColor;

            if (self.progressViewProgressImage) {
                self.progressView.progressImage = self.progressViewProgressImage;
            }

            if (self.progressViewTrackImage) {
                self.progressView.trackImage = self.progressViewTrackImage;
            }

            CGRect progressViewFrame = CGRectMake(kLGAlertViewPaddingW,
                                                  offsetY+kLGAlertViewInnerMarginH,
                                                  width-kLGAlertViewPaddingW*2,
                                                  self.progressView.frame.size.height);

            if ([UIScreen mainScreen].scale == 1.0) {
                progressViewFrame = CGRectIntegral(progressViewFrame);
            }

            self.progressView.frame = progressViewFrame;
            [self.scrollView addSubview:self.progressView];

            offsetY = self.progressView.frame.origin.y+self.progressView.frame.size.height;

            self.progressLabel = [UILabel new];
            self.progressLabel.text = self.progressLabelText;
            self.progressLabel.textColor = self.progressLabelTextColor;
            self.progressLabel.textAlignment = self.progressLabelTextAlignment;
            self.progressLabel.numberOfLines = 1;
            self.progressLabel.backgroundColor = [UIColor clearColor];
            self.progressLabel.font = self.progressLabelFont;

            CGSize progressLabelSize = [self.progressLabel sizeThatFits:CGSizeMake(width-kLGAlertViewPaddingW*2, CGFLOAT_MAX)];
            CGRect progressLabelFrame = CGRectMake(kLGAlertViewPaddingW,
                                                   offsetY+kLGAlertViewInnerMarginH/2,
                                                   width-kLGAlertViewPaddingW*2,
                                                   progressLabelSize.height);

            if ([UIScreen mainScreen].scale == 1.0) {
                progressLabelFrame = CGRectIntegral(progressLabelFrame);
            }

            self.progressLabel.frame = progressLabelFrame;
            [self.scrollView addSubview:self.progressLabel];

            offsetY = self.progressLabel.frame.origin.y+self.progressLabel.frame.size.height;
        }
        else if (self.type == LGAlertViewTypeTextFields) {
            for (NSUInteger i=0; i<self.textFieldsArray.count; i++) {
                UIView *separatorView = self.textFieldSeparatorsArray[i];
                separatorView.backgroundColor = self.separatorsColor;

                CGRect separatorViewFrame = CGRectMake(0.0,
                                                       offsetY+(i == 0 ? kLGAlertViewInnerMarginH : 0.0),
                                                       width,
                                                       kLGAlertViewSeparatorHeight);

                if ([UIScreen mainScreen].scale == 1.0) {
                    separatorViewFrame = CGRectIntegral(separatorViewFrame);
                }

                separatorView.frame = separatorViewFrame;
                [self.scrollView addSubview:separatorView];

                offsetY = separatorView.frame.origin.y+separatorView.frame.size.height;

                // -----

                LGAlertViewTextField *textField = self.textFieldsArray[i];

                CGRect textFieldFrame = CGRectMake(0.0, offsetY, width, self.textFieldsHeight);

                if ([UIScreen mainScreen].scale == 1.0) {
                    textFieldFrame = CGRectIntegral(textFieldFrame);
                }

                textField.frame = textFieldFrame;
                [self.scrollView addSubview:textField];

                offsetY = textField.frame.origin.y+textField.frame.size.height;
            }

            offsetY -= kLGAlertViewInnerMarginH;
        }

        // -----

        if (kLGAlertViewIsCancelButtonSeparate(self) && self.cancelButtonTitle) {
            CGFloat cornerRadius = self.layerCornerRadius+(self.layerCornerRadius == 0.0 ? 0.0 : self.layerBorderWidth+1.0);

            self.styleCancelView = [UIView new];
            self.styleCancelView.backgroundColor = self.backgroundColor;
            self.styleCancelView.layer.masksToBounds = NO;
            self.styleCancelView.layer.cornerRadius = cornerRadius;
            self.styleCancelView.layer.borderColor = self.layerBorderColor.CGColor;
            self.styleCancelView.layer.borderWidth = self.layerBorderWidth;
            self.styleCancelView.layer.shadowColor = self.layerShadowColor.CGColor;
            self.styleCancelView.layer.shadowRadius = self.layerShadowRadius;
            self.styleCancelView.layer.shadowOpacity = self.layerShadowOpacity;
            self.styleCancelView.layer.shadowOffset = self.layerShadowOffset;
            [self.view insertSubview:self.styleCancelView belowSubview:self.scrollView];

            [self cancelButtonInit];
            self.cancelButton.layer.masksToBounds = YES;
            self.cancelButton.layer.cornerRadius = self.layerCornerRadius;
            [self.view insertSubview:self.cancelButton aboveSubview:self.styleCancelView];
        }

        // -----

        NSUInteger numberOfButtons = self.buttonTitles.count;

        if (self.destructiveButtonTitle.length) {
            numberOfButtons++;
        }

        if (self.cancelButtonTitle.length && !kLGAlertViewIsCancelButtonSeparate(self)) {
            numberOfButtons++;
        }

        BOOL showTable = NO;

        if (numberOfButtons) {
            if (!self.isOneRowOneButton &&
                ((self.style == LGAlertViewStyleAlert && numberOfButtons < 4) ||
                 (self.style == LGAlertViewStyleActionSheet && numberOfButtons == 1))) {
                    CGFloat buttonWidth = width/numberOfButtons;

                    if (buttonWidth < kLGAlertViewButtonWidthMin) {
                        showTable = YES;
                    }

                    if (self.destructiveButtonTitle.length && !showTable) {
                        self.destructiveButton = [UIButton new];
                        self.destructiveButton.backgroundColor = [UIColor clearColor];
                        self.destructiveButton.titleLabel.numberOfLines = self.destructiveButtonNumberOfLines;
                        self.destructiveButton.titleLabel.lineBreakMode = self.destructiveButtonLineBreakMode;
                        self.destructiveButton.titleLabel.adjustsFontSizeToFitWidth = self.destructiveButtonAdjustsFontSizeToFitWidth;
                        self.destructiveButton.titleLabel.minimumScaleFactor = self.destructiveButtonMinimumScaleFactor;
                        self.destructiveButton.titleLabel.font = self.destructiveButtonFont;
                        [self.destructiveButton setTitle:self.destructiveButtonTitle forState:UIControlStateNormal];
                        [self.destructiveButton setTitleColor:self.destructiveButtonTitleColor forState:UIControlStateNormal];
                        [self.destructiveButton setTitleColor:self.destructiveButtonTitleColorHighlighted forState:UIControlStateHighlighted];
                        [self.destructiveButton setTitleColor:self.destructiveButtonTitleColorHighlighted forState:UIControlStateSelected];
                        [self.destructiveButton setTitleColor:self.destructiveButtonTitleColorDisabled forState:UIControlStateDisabled];
                        [self.destructiveButton setBackgroundImage:[LGAlertView image1x1WithColor:self.destructiveButtonBackgroundColor] forState:UIControlStateNormal];
                        [self.destructiveButton setBackgroundImage:[LGAlertView image1x1WithColor:self.destructiveButtonBackgroundColorHighlighted] forState:UIControlStateHighlighted];
                        [self.destructiveButton setBackgroundImage:[LGAlertView image1x1WithColor:self.destructiveButtonBackgroundColorHighlighted] forState:UIControlStateSelected];
                        [self.destructiveButton setBackgroundImage:[LGAlertView image1x1WithColor:self.destructiveButtonBackgroundColorDisabled] forState:UIControlStateDisabled];
                        self.destructiveButton.contentEdgeInsets = UIEdgeInsetsMake(kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW, kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW);
                        self.destructiveButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

                        if (self.destructiveButtonTextAlignment == NSTextAlignmentCenter) {
                            self.destructiveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                        }
                        else if (self.destructiveButtonTextAlignment == NSTextAlignmentLeft) {
                            self.destructiveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        }
                        else if (self.destructiveButtonTextAlignment == NSTextAlignmentRight) {
                            self.destructiveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                        }

                        self.destructiveButton.enabled = self.destructiveButtonEnabled;
                        [self.destructiveButton addTarget:self action:@selector(destructiveAction:) forControlEvents:UIControlEventTouchUpInside];

                        CGSize size = [self.destructiveButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];

                        if (size.width > buttonWidth) {
                            showTable = YES;
                        }
                    }

                    if (self.cancelButtonTitle.length && !kLGAlertViewIsCancelButtonSeparate(self) && !showTable) {
                        [self cancelButtonInit];

                        CGSize size = [self.cancelButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];

                        if (size.width > buttonWidth) {
                            showTable = YES;
                        }
                    }

                    if (self.buttonTitles.count > 0 && !showTable) {
                        LGAlertViewButtonProperties *properties = nil;

                        if (self.buttonsPropertiesDictionary) {
                            properties = self.buttonsPropertiesDictionary[[NSNumber numberWithInteger:0]];
                        }

                        self.firstButton = [UIButton new];
                        self.firstButton.backgroundColor = [UIColor clearColor];
                        self.firstButton.titleLabel.numberOfLines = (properties.isUserNumberOfLines ? properties.numberOfLines : self.buttonsNumberOfLines);
                        self.firstButton.titleLabel.lineBreakMode = (properties.isUserLineBreakMode ? properties.lineBreakMode : self.buttonsLineBreakMode);
                        self.firstButton.titleLabel.adjustsFontSizeToFitWidth = (properties.isAdjustsFontSizeToFitWidth ? properties.adjustsFontSizeToFitWidth : self.buttonsAdjustsFontSizeToFitWidth);
                        self.firstButton.titleLabel.minimumScaleFactor = (properties.isUserMinimimScaleFactor ? properties.minimumScaleFactor : self.buttonsMinimumScaleFactor);
                        self.firstButton.titleLabel.font = (properties.isUserFont ? properties.font : self.buttonsFont);
                        [self.firstButton setTitle:self.buttonTitles[0] forState:UIControlStateNormal];
                        [self.firstButton setTitleColor:(properties.isUserTitleColor ? properties.titleColor : self.buttonsTitleColor) forState:UIControlStateNormal];
                        [self.firstButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : self.buttonsTitleColorHighlighted) forState:UIControlStateHighlighted];
                        [self.firstButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : self.buttonsTitleColorHighlighted) forState:UIControlStateSelected];
                        [self.firstButton setTitleColor:(properties.isUserTitleColorDisabled ? properties.titleColorDisabled : self.buttonsTitleColorDisabled) forState:UIControlStateDisabled];
                        [self.firstButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColor ? properties.backgroundColor : self.buttonsBackgroundColor)] forState:UIControlStateNormal];
                        [self.firstButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : self.buttonsBackgroundColorHighlighted)] forState:UIControlStateHighlighted];
                        [self.firstButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : self.buttonsBackgroundColorHighlighted)] forState:UIControlStateSelected];
                        [self.firstButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorDisabled ? properties.backgroundColorDisabled : self.buttonsBackgroundColorDisabled)] forState:UIControlStateDisabled];
                        self.firstButton.contentEdgeInsets = UIEdgeInsetsMake(kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW, kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW);
                        self.firstButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

                        NSTextAlignment textAlignment = (properties.isUserTextAlignment ? properties.textAlignment : self.buttonsTextAlignment);

                        if (textAlignment == NSTextAlignmentCenter) {
                            self.firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                        }
                        else if (textAlignment == NSTextAlignmentLeft) {
                            self.firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        }
                        else if (textAlignment == NSTextAlignmentRight) {
                            self.firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                        }

                        self.firstButton.enabled = [self.buttonsEnabledArray[0] boolValue];
                        [self.firstButton addTarget:self action:@selector(firstButtonAction:) forControlEvents:UIControlEventTouchUpInside];

                        CGSize size = [self.firstButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];

                        if (size.width > buttonWidth) {
                            showTable = YES;
                        }

                        if (self.buttonTitles.count > 1 && !showTable) {
                            LGAlertViewButtonProperties *properties = nil;

                            if (self.buttonsPropertiesDictionary) {
                                properties = self.buttonsPropertiesDictionary[[NSNumber numberWithInteger:1]];
                            }

                            self.secondButton = [UIButton new];
                            self.secondButton.backgroundColor = [UIColor clearColor];
                            self.secondButton.titleLabel.numberOfLines = (properties.isUserNumberOfLines ? properties.numberOfLines : self.buttonsNumberOfLines);
                            self.secondButton.titleLabel.lineBreakMode = (properties.isUserLineBreakMode ? properties.lineBreakMode : self.buttonsLineBreakMode);
                            self.secondButton.titleLabel.adjustsFontSizeToFitWidth = (properties.isAdjustsFontSizeToFitWidth ? properties.adjustsFontSizeToFitWidth : self.buttonsAdjustsFontSizeToFitWidth);
                            self.secondButton.titleLabel.minimumScaleFactor = (properties.isUserMinimimScaleFactor ? properties.minimumScaleFactor : self.buttonsMinimumScaleFactor);
                            self.secondButton.titleLabel.font = (properties.isUserFont ? properties.font : self.buttonsFont);
                            [self.secondButton setTitle:self.buttonTitles[1] forState:UIControlStateNormal];
                            [self.secondButton setTitleColor:(properties.isUserTitleColor ? properties.titleColor : self.buttonsTitleColor) forState:UIControlStateNormal];
                            [self.secondButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : self.buttonsTitleColorHighlighted) forState:UIControlStateHighlighted];
                            [self.secondButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : self.buttonsTitleColorHighlighted) forState:UIControlStateSelected];
                            [self.secondButton setTitleColor:(properties.isUserTitleColorDisabled ? properties.titleColorDisabled : self.buttonsTitleColorDisabled) forState:UIControlStateDisabled];
                            [self.secondButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColor ? properties.backgroundColor : self.buttonsBackgroundColor)] forState:UIControlStateNormal];
                            [self.secondButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : self.buttonsBackgroundColorHighlighted)] forState:UIControlStateHighlighted];
                            [self.secondButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : self.buttonsBackgroundColorHighlighted)] forState:UIControlStateSelected];
                            [self.secondButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorDisabled ? properties.backgroundColorDisabled : self.buttonsBackgroundColorDisabled)] forState:UIControlStateDisabled];
                            self.secondButton.contentEdgeInsets = UIEdgeInsetsMake(kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW, kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW);
                            self.secondButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

                            NSTextAlignment textAlignment = (properties.isUserTextAlignment ? properties.textAlignment : self.buttonsTextAlignment);

                            if (textAlignment == NSTextAlignmentCenter) {
                                self.secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                            }
                            else if (textAlignment == NSTextAlignmentLeft) {
                                self.secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                            }
                            else if (textAlignment == NSTextAlignmentRight) {
                                self.secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                            }

                            self.secondButton.enabled = [self.buttonsEnabledArray[1] boolValue];
                            [self.secondButton addTarget:self action:@selector(secondButtonAction:) forControlEvents:UIControlEventTouchUpInside];

                            CGSize size = [self.secondButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];

                            if (size.width > buttonWidth) {
                                showTable = YES;
                            }

                            if (self.buttonTitles.count > 2 && !showTable) {
                                LGAlertViewButtonProperties *properties = nil;

                                if (self.buttonsPropertiesDictionary) {
                                    properties = self.buttonsPropertiesDictionary[[NSNumber numberWithInteger:2]];
                                }

                                self.thirdButton = [UIButton new];
                                self.thirdButton.backgroundColor = [UIColor clearColor];
                                self.thirdButton.titleLabel.numberOfLines = (properties.isUserNumberOfLines ? properties.numberOfLines : self.buttonsNumberOfLines);
                                self.thirdButton.titleLabel.lineBreakMode = (properties.isUserLineBreakMode ? properties.lineBreakMode : self.buttonsLineBreakMode);
                                self.thirdButton.titleLabel.adjustsFontSizeToFitWidth = (properties.isAdjustsFontSizeToFitWidth ? properties.adjustsFontSizeToFitWidth : self.buttonsAdjustsFontSizeToFitWidth);
                                self.thirdButton.titleLabel.minimumScaleFactor = (properties.isUserMinimimScaleFactor ? properties.minimumScaleFactor : self.buttonsMinimumScaleFactor);
                                self.thirdButton.titleLabel.font = (properties.isUserFont ? properties.font : self.buttonsFont);
                                [self.thirdButton setTitle:self.buttonTitles[2] forState:UIControlStateNormal];
                                [self.thirdButton setTitleColor:(properties.isUserTitleColor ? properties.titleColor : self.buttonsTitleColor) forState:UIControlStateNormal];
                                [self.thirdButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : self.buttonsTitleColorHighlighted) forState:UIControlStateHighlighted];
                                [self.thirdButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : self.buttonsTitleColorHighlighted) forState:UIControlStateSelected];
                                [self.thirdButton setTitleColor:(properties.isUserTitleColorDisabled ? properties.titleColorDisabled : self.buttonsTitleColorDisabled) forState:UIControlStateDisabled];
                                [self.thirdButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColor ? properties.backgroundColor : self.buttonsBackgroundColor)] forState:UIControlStateNormal];
                                [self.thirdButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : self.buttonsBackgroundColorHighlighted)] forState:UIControlStateHighlighted];
                                [self.thirdButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : self.buttonsBackgroundColorHighlighted)] forState:UIControlStateSelected];
                                [self.thirdButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorDisabled ? properties.backgroundColorDisabled : self.buttonsBackgroundColorDisabled)] forState:UIControlStateDisabled];
                                self.thirdButton.contentEdgeInsets = UIEdgeInsetsMake(kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW, kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW);
                                self.thirdButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

                                NSTextAlignment textAlignment = (properties.isUserTextAlignment ? properties.textAlignment : self.buttonsTextAlignment);

                                if (textAlignment == NSTextAlignmentCenter) {
                                    self.thirdButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                                }
                                else if (textAlignment == NSTextAlignmentLeft) {
                                    self.thirdButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                                }
                                else if (textAlignment == NSTextAlignmentRight) {
                                    self.thirdButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                                }

                                self.thirdButton.enabled = [self.buttonsEnabledArray[2] boolValue];
                                [self.thirdButton addTarget:self action:@selector(thirdButtonAction:) forControlEvents:UIControlEventTouchUpInside];

                                CGSize size = [self.thirdButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];

                                if (size.width > buttonWidth) {
                                    showTable = YES;
                                }
                            }
                        }
                    }

                    if (!showTable) {
                        UIButton *firstButton = nil;
                        UIButton *secondButton = nil;
                        UIButton *thirdButton = nil;

                        if (self.cancelButton && !kLGAlertViewIsCancelButtonSeparate(self)) {
                            [self.scrollView addSubview:self.cancelButton];

                            firstButton = self.cancelButton;
                        }

                        if (self.destructiveButton) {
                            [self.scrollView addSubview:self.destructiveButton];

                            if (!firstButton) {
                                firstButton = self.destructiveButton;
                            }
                            else {
                                secondButton = self.destructiveButton;
                            }
                        }

                        if (self.firstButton) {
                            [self.scrollView addSubview:self.firstButton];

                            if (!firstButton) {
                                firstButton = self.firstButton;
                            }
                            else if (!secondButton) {
                                secondButton = self.firstButton;
                            }
                            else {
                                thirdButton = self.firstButton;
                            }

                            if (self.secondButton) {
                                [self.scrollView addSubview:self.secondButton];

                                if (!secondButton) {
                                    secondButton = self.secondButton;
                                }
                                else {
                                    thirdButton = self.secondButton;
                                }

                                if (self.thirdButton) {
                                    [self.scrollView addSubview:self.thirdButton];

                                    thirdButton = self.thirdButton;
                                }
                            }
                        }

                        // -----

                        if (offsetY) {
                            self.separatorHorizontalView = [UIView new];
                            self.separatorHorizontalView.backgroundColor = self.separatorsColor;

                            CGRect separatorHorizontalViewFrame = CGRectMake(0.0, offsetY+kLGAlertViewInnerMarginH, width, kLGAlertViewSeparatorHeight);

                            if ([UIScreen mainScreen].scale == 1.0) {
                                separatorHorizontalViewFrame = CGRectIntegral(separatorHorizontalViewFrame);
                            }

                            self.separatorHorizontalView.frame = separatorHorizontalViewFrame;
                            [self.scrollView addSubview:self.separatorHorizontalView];

                            offsetY = self.separatorHorizontalView.frame.origin.y+self.separatorHorizontalView.frame.size.height;
                        }

                        // -----

                        CGRect firstButtonFrame = CGRectMake(0.0, offsetY, width/numberOfButtons, self.buttonsHeight);

                        if ([UIScreen mainScreen].scale == 1.0) {
                            firstButtonFrame = CGRectIntegral(firstButtonFrame);
                        }

                        firstButton.frame = firstButtonFrame;

                        CGRect secondButtonFrame = CGRectZero;
                        CGRect thirdButtonFrame = CGRectZero;

                        if (secondButton) {
                            secondButtonFrame = CGRectMake(firstButtonFrame.origin.x+firstButtonFrame.size.width+kLGAlertViewSeparatorHeight,
                                                           offsetY,
                                                           width/numberOfButtons-kLGAlertViewSeparatorHeight,
                                                           self.buttonsHeight);

                            if ([UIScreen mainScreen].scale == 1.0) {
                                secondButtonFrame = CGRectIntegral(secondButtonFrame);
                            }

                            secondButton.frame = secondButtonFrame;

                            if (thirdButton) {
                                thirdButtonFrame = CGRectMake(secondButtonFrame.origin.x+secondButtonFrame.size.width+kLGAlertViewSeparatorHeight,
                                                              offsetY,
                                                              width/numberOfButtons-kLGAlertViewSeparatorHeight,
                                                              self.buttonsHeight);

                                if ([UIScreen mainScreen].scale == 1.0) {
                                    thirdButtonFrame = CGRectIntegral(thirdButtonFrame);
                                }

                                thirdButton.frame = thirdButtonFrame;
                            }
                        }

                        // -----

                        if (secondButton) {
                            self.separatorVerticalView1 = [UIView new];
                            self.separatorVerticalView1.backgroundColor = self.separatorsColor;

                            CGRect separatorVerticalView1Frame = CGRectMake(firstButtonFrame.origin.x+firstButtonFrame.size.width,
                                                                            offsetY,
                                                                            kLGAlertViewSeparatorHeight,
                                                                            MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height));

                            if ([UIScreen mainScreen].scale == 1.0) {
                                separatorVerticalView1Frame = CGRectIntegral(separatorVerticalView1Frame);
                            }

                            self.separatorVerticalView1.frame = separatorVerticalView1Frame;
                            [self.scrollView addSubview:self.separatorVerticalView1];

                            if (thirdButton) {
                                self.separatorVerticalView2 = [UIView new];
                                self.separatorVerticalView2.backgroundColor = self.separatorsColor;

                                CGRect separatorVerticalView2Frame = CGRectMake(secondButtonFrame.origin.x+secondButtonFrame.size.width,
                                                                                offsetY,
                                                                                kLGAlertViewSeparatorHeight,
                                                                                MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height));

                                if ([UIScreen mainScreen].scale == 1.0) {
                                    separatorVerticalView2Frame = CGRectIntegral(separatorVerticalView2Frame);
                                }

                                self.separatorVerticalView2.frame = separatorVerticalView2Frame;
                                [self.scrollView addSubview:self.separatorVerticalView2];
                            }
                        }

                        // -----

                        offsetY += self.buttonsHeight;
                    }
                }
            else {
                showTable = YES;
            }

            if (showTable) {
                if (!kLGAlertViewIsCancelButtonSeparate(self)) {
                    self.cancelButton = nil;
                }

                self.destructiveButton = nil;
                self.firstButton = nil;
                self.secondButton = nil;
                self.thirdButton = nil;

                if (!self.buttonTitles) {
                    self.buttonTitles = [NSMutableArray new];
                }

                if (self.destructiveButtonTitle.length) {
                    [self.buttonTitles insertObject:self.destructiveButtonTitle atIndex:0];
                }

                if (self.cancelButtonTitle.length && !kLGAlertViewIsCancelButtonSeparate(self)) {
                    [self.buttonTitles addObject:self.cancelButtonTitle];
                }

                self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
                self.tableView.clipsToBounds = NO;
                self.tableView.backgroundColor = [UIColor clearColor];
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                self.tableView.dataSource = self;
                self.tableView.delegate = self;
                self.tableView.scrollEnabled = NO;
                [self.tableView registerClass:[LGAlertViewCell class] forCellReuseIdentifier:@"cell"];
                self.tableView.frame = CGRectMake(0.0, 0.0, width, CGFLOAT_MAX);
                [self.tableView reloadData];

                if (!offsetY) {
                    offsetY = -kLGAlertViewInnerMarginH;
                }
                else {
                    self.separatorHorizontalView = [UIView new];
                    self.separatorHorizontalView.backgroundColor = self.separatorsColor;

                    CGRect separatorTitleViewFrame = CGRectMake(0.0, 0.0, width, kLGAlertViewSeparatorHeight);

                    if ([UIScreen mainScreen].scale == 1.0) {
                        separatorTitleViewFrame = CGRectIntegral(separatorTitleViewFrame);
                    }

                    self.separatorHorizontalView.frame = separatorTitleViewFrame;
                    self.tableView.tableHeaderView = self.separatorHorizontalView;
                }

                CGRect tableViewFrame = CGRectMake(0.0, offsetY+kLGAlertViewInnerMarginH, width, self.tableView.contentSize.height);

                if ([UIScreen mainScreen].scale == 1.0) {
                    tableViewFrame = CGRectIntegral(tableViewFrame);
                }

                self.tableView.frame = tableViewFrame;

                [self.scrollView addSubview:self.tableView];

                offsetY = self.tableView.frame.origin.y+self.tableView.frame.size.height;
            }
        }
        else {
            offsetY += kLGAlertViewInnerMarginH;
        }

        // -----

        self.scrollView.contentSize = CGSizeMake(width, offsetY);
    }
}

- (void)layoutValidateWithSize:(CGSize)size {
    CGFloat width = [self widthForSize:size];

    // -----

    self.view.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    self.backgroundView.frame = CGRectMake(0.0, 0.0, size.width, size.height);

    // -----

    CGFloat heightMax = size.height-self.keyboardHeight-self.offsetVertical*2;

    if (self.windowLevel == LGAlertViewWindowLevelBelowStatusBar) {
        heightMax -= kLGAlertViewStatusBarHeight;
    }

    if (self.heightMax != NSNotFound && self.heightMax < heightMax) {
        heightMax = self.heightMax;
    }

    if (kLGAlertViewIsCancelButtonSeparate(self) && self.cancelButton) {
        heightMax -= (self.buttonsHeight+self.cancelButtonOffsetY);
    }
    else if (self.cancelOnTouch && !self.cancelButtonTitle.length && size.width < width+self.buttonsHeight*2) {
        heightMax -= self.buttonsHeight*2;
    }

    if (self.scrollView.contentSize.height < heightMax) {
        heightMax = self.scrollView.contentSize.height;
    }

    // -----

    CGRect scrollViewFrame = CGRectZero;
    CGAffineTransform scrollViewTransform = CGAffineTransformIdentity;
    CGFloat scrollViewAlpha = 1.0;

    if (self.style == LGAlertViewStyleAlert || kLGAlertViewPadAndNotForce(self)) {
        scrollViewFrame = CGRectMake(size.width/2-width/2, size.height/2-self.keyboardHeight/2-heightMax/2, width, heightMax);

        if (self.windowLevel == LGAlertViewWindowLevelBelowStatusBar) {
            scrollViewFrame.origin.y += kLGAlertViewStatusBarHeight/2;
        }

        if (!self.isVisible) {
            scrollViewTransform = CGAffineTransformMakeScale(1.2, 1.2);

            scrollViewAlpha = 0.0;
        }
    }
    else
    {
        CGFloat bottomShift = self.offsetVertical;

        if (kLGAlertViewIsCancelButtonSeparate(self) && self.cancelButton) {
            bottomShift += self.buttonsHeight+self.cancelButtonOffsetY;
        }

        scrollViewFrame = CGRectMake(size.width/2-width/2, size.height-bottomShift-heightMax, width, heightMax);
    }

    // -----

    if (self.style == LGAlertViewStyleActionSheet && !kLGAlertViewPadAndNotForce(self)) {
        CGRect cancelButtonFrame = CGRectZero;

        if (kLGAlertViewIsCancelButtonSeparate(self) && self.cancelButton) {
            cancelButtonFrame = CGRectMake(size.width/2-width/2, size.height-self.cancelButtonOffsetY-self.buttonsHeight, width, self.buttonsHeight);
        }

        self.scrollViewCenterShowed = CGPointMake(scrollViewFrame.origin.x+scrollViewFrame.size.width/2,
                                                  scrollViewFrame.origin.y+scrollViewFrame.size.height/2);

        self.cancelButtonCenterShowed = CGPointMake(cancelButtonFrame.origin.x+cancelButtonFrame.size.width/2,
                                                    cancelButtonFrame.origin.y+cancelButtonFrame.size.height/2);

        // -----

        CGFloat commonHeight = scrollViewFrame.size.height+self.offsetVertical;

        if (kLGAlertViewIsCancelButtonSeparate(self) && self.cancelButton) {
            commonHeight += self.buttonsHeight+self.cancelButtonOffsetY;
        }

        self.scrollViewCenterHidden = CGPointMake(scrollViewFrame.origin.x+scrollViewFrame.size.width/2,
                                                  scrollViewFrame.origin.y+scrollViewFrame.size.height/2+commonHeight+self.layerBorderWidth+self.layerShadowRadius);

        self.cancelButtonCenterHidden = CGPointMake(cancelButtonFrame.origin.x+cancelButtonFrame.size.width/2,
                                                    cancelButtonFrame.origin.y+cancelButtonFrame.size.height/2+commonHeight);

        if (!self.isVisible) {
            scrollViewFrame.origin.y += commonHeight;

            if (kLGAlertViewIsCancelButtonSeparate(self) && self.cancelButton) {
                cancelButtonFrame.origin.y += commonHeight;
            }
        }

        // -----

        if (kLGAlertViewIsCancelButtonSeparate(self) && self.cancelButton) {
            if ([UIScreen mainScreen].scale == 1.0) {
                cancelButtonFrame = CGRectIntegral(cancelButtonFrame);
            }

            self.cancelButton.frame = cancelButtonFrame;

            CGFloat borderWidth = self.layerBorderWidth;
            self.styleCancelView.frame = CGRectMake(cancelButtonFrame.origin.x-borderWidth,
                                                    cancelButtonFrame.origin.y-borderWidth,
                                                    cancelButtonFrame.size.width+borderWidth*2,
                                                    cancelButtonFrame.size.height+borderWidth*2);
        }
    }

    // -----

    if ([UIScreen mainScreen].scale == 1.0) {
        scrollViewFrame = CGRectIntegral(scrollViewFrame);

        if (scrollViewFrame.size.height - self.scrollView.contentSize.height == 1.0) {
            scrollViewFrame.size.height -= 2.0;
        }
    }

    // -----

    self.scrollView.frame = scrollViewFrame;
    self.scrollView.transform = scrollViewTransform;
    self.scrollView.alpha = scrollViewAlpha;

    CGFloat borderWidth = self.layerBorderWidth;
    self.styleView.frame = CGRectMake(scrollViewFrame.origin.x-borderWidth,
                                      scrollViewFrame.origin.y-borderWidth,
                                      scrollViewFrame.size.width+borderWidth*2,
                                      scrollViewFrame.size.height+borderWidth*2);
    self.styleView.transform = scrollViewTransform;
    self.styleView.alpha = scrollViewAlpha;
}

- (void)cancelButtonInit {
    self.cancelButton = [UIButton new];
    self.cancelButton.backgroundColor = [UIColor clearColor];
    self.cancelButton.titleLabel.numberOfLines = self.cancelButtonNumberOfLines;
    self.cancelButton.titleLabel.lineBreakMode = self.cancelButtonLineBreakMode;
    self.cancelButton.titleLabel.adjustsFontSizeToFitWidth = self.cancelButtonAdjustsFontSizeToFitWidth;
    self.cancelButton.titleLabel.minimumScaleFactor = self.cancelButtonMinimumScaleFactor;
    self.cancelButton.titleLabel.font = self.cancelButtonFont;
    [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:self.cancelButtonTitleColor forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:self.cancelButtonTitleColorHighlighted forState:UIControlStateHighlighted];
    [self.cancelButton setTitleColor:self.cancelButtonTitleColorHighlighted forState:UIControlStateSelected];
    [self.cancelButton setTitleColor:self.cancelButtonTitleColorDisabled forState:UIControlStateDisabled];
    [self.cancelButton setBackgroundImage:[LGAlertView image1x1WithColor:self.cancelButtonBackgroundColor] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[LGAlertView image1x1WithColor:self.cancelButtonBackgroundColorHighlighted] forState:UIControlStateHighlighted];
    [self.cancelButton setBackgroundImage:[LGAlertView image1x1WithColor:self.cancelButtonBackgroundColorHighlighted] forState:UIControlStateSelected];
    [self.cancelButton setBackgroundImage:[LGAlertView image1x1WithColor:self.cancelButtonBackgroundColorDisabled] forState:UIControlStateDisabled];
    self.cancelButton.contentEdgeInsets = UIEdgeInsetsMake(kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW, kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW);
    self.cancelButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    if (self.cancelButtonTextAlignment == NSTextAlignmentCenter) {
        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    else if (self.cancelButtonTextAlignment == NSTextAlignmentLeft) {
        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    else if (self.cancelButtonTextAlignment == NSTextAlignmentRight) {
        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }

    self.cancelButton.enabled = self.cancelButtonEnabled;
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)cancelAction:(id)sender {
    if (sender && [sender isKindOfClass:[UIButton class]]) {
        [(UIButton *)sender setSelected:YES];
    }

    // -----

    if (self.cancelHandler) {
        self.cancelHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewCancelled:)]) {
        [self.delegate alertViewCancelled:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewCancelNotification object:self userInfo:nil];

    // -----

    if (self.dismissOnAction) {
        [self dismissAnimated:YES completionHandler:nil];
    }
}

- (void)destructiveAction:(id)sender {
    if (sender && [sender isKindOfClass:[UIButton class]]) {
        [(UIButton *)sender setSelected:YES];
    }

    // -----

    if (self.destructiveHandler) {
        self.destructiveHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDestructiveButtonPressed:)]) {
        [self.delegate alertViewDestructiveButtonPressed:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewDestructiveNotification object:self userInfo:nil];

    // -----

    if (self.dismissOnAction) {
        [self dismissAnimated:YES completionHandler:nil];
    }
}

- (void)actionActionAtIndex:(NSUInteger)index title:(NSString *)title {
    if (self.actionHandler) {
        self.actionHandler(self, title, index);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:buttonPressedWithTitle:index:)]) {
        [self.delegate alertView:self buttonPressedWithTitle:title index:index];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewActionNotification
                                                        object:self
                                                      userInfo:@{@"title": title,
                                                                 @"index": [NSNumber numberWithInteger:index]}];

    // -----

    if (self.dismissOnAction) {
        [self dismissAnimated:YES completionHandler:nil];
    }
}

- (void)firstButtonAction:(id)sender {
    if (sender && [sender isKindOfClass:[UIButton class]]) {
        [(UIButton *)sender setSelected:YES];
    }

    // -----

    NSUInteger index = 0;

    NSString *title = self.buttonTitles[0];

    // -----

    [self actionActionAtIndex:index title:title];
}

- (void)secondButtonAction:(id)sender {
    if (sender && [sender isKindOfClass:[UIButton class]]) {
        [(UIButton *)sender setSelected:YES];
    }

    // -----

    NSUInteger index = 1;

    NSString *title = self.buttonTitles[1];

    // -----

    [self actionActionAtIndex:index title:title];
}

- (void)thirdButtonAction:(id)sender {
    if (sender && [sender isKindOfClass:[UIButton class]]) {
        [(UIButton *)sender setSelected:YES];
    }

    // -----

    NSUInteger index = 2;

    NSString *title = self.buttonTitles[2];

    // -----

    [self actionActionAtIndex:index title:title];
}

#pragma mark - Class methods

static LGAlertViewWindowLevel _classWindowLevel;

+ (void)setWindowLevel:(LGAlertViewWindowLevel)windowLevel {
    _classWindowLevel = windowLevel;
}

+ (LGAlertViewWindowLevel)windowLevel {
    return _classWindowLevel;
}

static NSNumber *_classCancelOnTouch;

+ (void)setCancelOnTouch:(NSNumber *)cancelOnTouch {
    _classCancelOnTouch = cancelOnTouch;
}

+ (NSNumber *)cancelOnTouch {
    return _classCancelOnTouch;
}

static BOOL _classDismissOnAction;

+ (void)setDismissOnAction:(BOOL)dismissOnAction {
    _classDismissOnAction = dismissOnAction;
}

+ (BOOL)isDismissOnAction {
    return _classDismissOnAction;
}

#pragma mark - Style properties

static UIColor *_classTintColor;

+ (void)setTintColor:(UIColor *)tintColor {
    _classTintColor = tintColor;
}

+ (UIColor *)tintColor {
    return _classTintColor;
}

static UIColor *_classCoverColor;

+ (void)setCoverColor:(UIColor *)coverColor {
    _classCoverColor = coverColor;
}

+ (UIColor *)coverColor {
    return _classCoverColor;
}

static UIBlurEffect *_classCoverBlurEffect;

+ (void)setCoverBlurEffect:(UIBlurEffect *)coverBlurEffect {
    _classCoverBlurEffect = coverBlurEffect;
}

+ (UIBlurEffect *)coverBlurEffect {
    return _classCoverBlurEffect;
}

static CGFloat _classCoverAlpha;

+ (void)setCoverAlpha:(CGFloat)coverAlpha {
    _classCoverAlpha = coverAlpha;
}

+ (CGFloat)coverAlpha {
    return _classCoverAlpha;
}

static UIColor *_classBackgroundColor;

+ (void)setBackgroundColor:(UIColor *)backgroundColor {
    _classBackgroundColor = backgroundColor;
}

+ (UIColor *)backgroundColor {
    return _classBackgroundColor;
}

static CGFloat _classButtonsHeight;

+ (void)setButtonsHeight:(CGFloat)buttonsHeight {
    _classButtonsHeight = buttonsHeight;
}

+ (CGFloat)buttonsHeight {
    return _classButtonsHeight;
}

static CGFloat _classTextFieldsHeight;

+ (void)setTextFieldsHeight:(CGFloat)textFieldsHeight {
    _classTextFieldsHeight = textFieldsHeight;
}

+ (CGFloat)textFieldsHeight {
    return _classTextFieldsHeight;
}

static CGFloat _classOffsetVertical;

+ (void)setOffsetVertical:(CGFloat)offsetVertical {
    _classOffsetVertical = offsetVertical;
}

+ (CGFloat)offsetVertical {
    return _classOffsetVertical;
}

static CGFloat _classCancelButtonOffsetY;

+ (void)setCancelButtonOffsetY:(CGFloat)cancelButtonOffsetY {
    _classCancelButtonOffsetY = cancelButtonOffsetY;
}

+ (CGFloat)cancelButtonOffsetY {
    return _classCancelButtonOffsetY;
}

static CGFloat _classHeightMax;

+ (void)setHeightMax:(CGFloat)heightMax {
    _classHeightMax = heightMax;
}

+ (CGFloat)heightMax {
    return _classHeightMax;
}

static CGFloat _classWidth;

+ (void)setWidth:(CGFloat)width {
    _classWidth = width;
}

+ (CGFloat)width {
    return _classWidth;
}

static UIColor *_classSeparatorsColor;

+ (void)setSeparatorsColor:(UIColor *)separatorsColor {
    _classSeparatorsColor = separatorsColor;
}

+ (UIColor *)separatorsColor {
    return _classSeparatorsColor;
}

static UIScrollViewIndicatorStyle _classIndicatorStyle;

+ (void)setIndicatorStyle:(UIScrollViewIndicatorStyle)indicatorStyle {
    _classIndicatorStyle = indicatorStyle;
}

+ (UIScrollViewIndicatorStyle)indicatorStyle {
    return _classIndicatorStyle;
}

static BOOL _classShowsVerticalScrollIndicator;

+ (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator {
    _classShowsVerticalScrollIndicator = showsVerticalScrollIndicator;
}

+ (BOOL)isShowsVerticalScrollIndicator {
    return _classShowsVerticalScrollIndicator;
}

static BOOL _classPadShowsActionSheetFromBottom;

+ (void)setPadShowsActionSheetFromBottom:(BOOL)padShowsActionSheetFromBottom {
    _classPadShowsActionSheetFromBottom = padShowsActionSheetFromBottom;
}

+ (BOOL)isPadShowsActionSheetFromBottom {
    return _classPadShowsActionSheetFromBottom;
}

static BOOL _classOneRowOneButton;

+ (void)setOneRowOneButton:(BOOL)oneRowOneButton {
    _classOneRowOneButton = oneRowOneButton;
}

+ (BOOL)isOneRowOneButton {
    return _classOneRowOneButton;
}

#pragma mark - Layer properties

static CGFloat _classLayerCornerRadius;

+ (void)setLayerCornerRadius:(CGFloat)layerCornerRadius {
    _classLayerCornerRadius = layerCornerRadius;
}

+ (CGFloat)layerCornerRadius {
    return _classLayerCornerRadius;
}

static UIColor *_classLayerBorderColor;

+ (void)setLayerBorderColor:(UIColor *)layerBorderColor {
    _classLayerBorderColor = layerBorderColor;
}

+ (UIColor *)layerBorderColor {
    return _classLayerBorderColor;
}

static CGFloat _classLayerBorderWidth;

+ (void)setLayerBorderWidth:(CGFloat)layerBorderWidth {
    _classLayerBorderWidth = layerBorderWidth;
}

+ (CGFloat)layerBorderWidth {
    return _classLayerBorderWidth;
}

static UIColor *_classLayerShadowColor;

+ (void)setLayerShadowColor:(UIColor *)layerShadowColor {
    _classLayerShadowColor = layerShadowColor;
}

+ (UIColor *)layerShadowColor {
    return _classLayerShadowColor;
}

static CGFloat _classLayerShadowRadius;

+ (void)setLayerShadowRadius:(CGFloat)layerShadowRadius {
    _classLayerShadowRadius = layerShadowRadius;
}

+ (CGFloat)layerShadowRadius {
    return _classLayerShadowRadius;
}

static CGFloat _classLayerShadowOpacity;

+ (void)setLayerShadowOpacity:(CGFloat)layerShadowOpacity {
    _classLayerShadowOpacity = layerShadowOpacity;
}

+ (CGFloat)layerShadowOpacity {
    return _classLayerShadowOpacity;
}

static CGSize _classLayerShadowOffset;

+ (void)setLayerShadowOffset:(CGSize)layerShadowOffset {
    _classLayerShadowOffset = layerShadowOffset;
}

+ (CGSize)layerShadowOffset {
    return _classLayerShadowOffset;
}

#pragma mark - Title properties

static UIColor *_classTitleTextColor;

+ (void)setTitleTextColor:(UIColor *)titleTextColor {
    _classTitleTextColor = titleTextColor;
}

+ (UIColor *)titleTextColor {
    return _classTitleTextColor;
}

static NSTextAlignment _classTitleTextAlignment;

+ (void)setTitleTextAlignment:(NSTextAlignment)titleTextAlignment {
    _classTitleTextAlignment = titleTextAlignment;
}

+ (NSTextAlignment)titleTextAlignment {
    return _classTitleTextAlignment;
}

static UIFont *_classTitleFont;

+ (void)setTitleFont:(UIFont *)titleFont {
    _classTitleFont = titleFont;
}

+ (UIFont *)titleFont {
    return _classTitleFont;
}

#pragma mark - Message properties

static UIColor *_classMessageTextColor;

+ (void)setMessageTextColor:(UIColor *)messageTextColor {
    _classMessageTextColor = messageTextColor;
}

+ (UIColor *)messageTextColor {
    return _classMessageTextColor;
}

static NSTextAlignment _classMessageTextAlignment;

+ (void)setMessageTextAlignment:(NSTextAlignment)messageTextAlignment {
    _classMessageTextAlignment = messageTextAlignment;
}

+ (NSTextAlignment)messageTextAlignment {
    return _classMessageTextAlignment;
}

static UIFont *_classMessageFont;

+ (void)setMessageFont:(UIFont *)messageFont {
    _classMessageFont = messageFont;
}

+ (UIFont *)messageFont {
    return _classMessageFont;
}

#pragma mark - Buttons properties

static UIColor *_classButtonsTitleColor;

+ (void)setButtonsTitleColor:(UIColor *)buttonsTitleColor {
    _classButtonsTitleColor = buttonsTitleColor;
}

+ (UIColor *)buttonsTitleColor {
    return _classButtonsTitleColor;
}

static UIColor *_classButtonsTitleColorHighlighted;

+ (void)setButtonsTitleColorHighlighted:(UIColor *)buttonsTitleColorHighlighted {
    _classButtonsTitleColorHighlighted = buttonsTitleColorHighlighted;
}

+ (UIColor *)buttonsTitleColorHighlighted {
    return _classButtonsTitleColorHighlighted;
}

static UIColor *_classButtonsTitleColorDisabled;

+ (void)setButtonsTitleColorDisabled:(UIColor *)buttonsTitleColorDisabled {
    _classButtonsTitleColorDisabled = buttonsTitleColorDisabled;
}

+ (UIColor *)buttonsTitleColorDisabled {
    return _classButtonsTitleColorDisabled;
}

static NSTextAlignment _classButtonsTextAlignment;

+ (void)setButtonsTextAlignment:(NSTextAlignment)buttonsTextAlignment {
    _classButtonsTextAlignment = buttonsTextAlignment;
}

+ (NSTextAlignment)buttonsTextAlignment {
    return _classButtonsTextAlignment;
}

static UIFont *_classButtonsFont;

+ (void)setButtonsFont:(UIFont *)buttonsFont {
    _classButtonsFont = buttonsFont;
}

+ (UIFont *)buttonsFont {
    return _classButtonsFont;
}

static UIColor *_classButtonsBackgroundColor;

+ (void)setButtonsBackgroundColor:(UIColor *)buttonsBackgroundColor {
    _classButtonsBackgroundColor = buttonsBackgroundColor;
}

+ (UIColor *)buttonsBackgroundColor {
    return _classButtonsBackgroundColor;
}

static UIColor *_classButtonsBackgroundColorHighlighted;

+ (void)setButtonsBackgroundColorHighlighted:(UIColor *)buttonsBackgroundColorHighlighted {
    _classButtonsBackgroundColorHighlighted = buttonsBackgroundColorHighlighted;
}

+ (UIColor *)buttonsBackgroundColorHighlighted {
    return _classButtonsBackgroundColorHighlighted;
}

static UIColor *_classButtonsBackgroundColorDisabled;

+ (void)setButtonsBackgroundColorDisabled:(UIColor *)buttonsBackgroundColorDisabled {
    _classButtonsBackgroundColorDisabled = buttonsBackgroundColorDisabled;
}

+ (UIColor *)buttonsBackgroundColorDisabled {
    return _classButtonsBackgroundColorDisabled;
}

static NSUInteger _classButtonsNumberOfLines;

+ (void)setButtonsNumberOfLines:(NSUInteger)buttonsNumberOfLines {
    _classButtonsNumberOfLines = buttonsNumberOfLines;
}

+ (NSUInteger)buttonsNumberOfLines {
    return _classButtonsNumberOfLines;
}

static NSLineBreakMode _classButtonsLineBreakMode;

+ (void)setButtonsLineBreakMode:(NSLineBreakMode)buttonsLineBreakMode {
    _classButtonsLineBreakMode = buttonsLineBreakMode;
}

+ (NSLineBreakMode)buttonsLineBreakMode {
    return _classButtonsLineBreakMode;
}

static CGFloat _classButtonsMinimumScaleFactor;

+ (void)setButtonsMinimumScaleFactor:(CGFloat)buttonsMinimumScaleFactor {
    _classButtonsMinimumScaleFactor = buttonsMinimumScaleFactor;
}

+ (CGFloat)buttonsMinimumScaleFactor {
    return _classButtonsMinimumScaleFactor;
}

static BOOL _classButtonsAdjustsFontSizeToFitWidth;

+ (void)setButtonsAdjustsFontSizeToFitWidth:(BOOL)buttonsAdjustsFontSizeToFitWidth {
    _classButtonsAdjustsFontSizeToFitWidth = buttonsAdjustsFontSizeToFitWidth;
}

+ (BOOL)isButtonsAdjustsFontSizeToFitWidth {
    return _classButtonsAdjustsFontSizeToFitWidth;
}

#pragma mark - Cancel button properties

static UIColor *_classCancelButtonTitleColor;

+ (void)setCancelButtonTitleColor:(UIColor *)cancelButtonTitleColor {
    _classCancelButtonTitleColor = cancelButtonTitleColor;
}

+ (UIColor *)cancelButtonTitleColor {
    return _classCancelButtonTitleColor;
}

static UIColor *_classCancelButtonTitleColorHighlighted;

+ (void)setCancelButtonTitleColorHighlighted:(UIColor *)cancelButtonTitleColorHighlighted {
    _classCancelButtonTitleColorHighlighted = cancelButtonTitleColorHighlighted;
}

+ (UIColor *)cancelButtonTitleColorHighlighted {
    return _classCancelButtonTitleColorHighlighted;
}

static UIColor *_classCancelButtonTitleColorDisabled;

+ (void)setCancelButtonTitleColorDisabled:(UIColor *)cancelButtonTitleColorDisabled {
    _classCancelButtonTitleColorDisabled = cancelButtonTitleColorDisabled;
}

+ (UIColor *)cancelButtonTitleColorDisabled {
    return _classCancelButtonTitleColorDisabled;
}

static NSTextAlignment _classCancelButtonTextAlignment;

+ (void)setCancelButtonTextAlignment:(NSTextAlignment)cancelButtonTextAlignment {
    _classCancelButtonTextAlignment = cancelButtonTextAlignment;
}

+ (NSTextAlignment)cancelButtonTextAlignment {
    return _classCancelButtonTextAlignment;
}

static UIFont *_classCancelButtonFont;

+ (void)setCancelButtonFont:(UIFont *)cancelButtonFont {
    _classCancelButtonFont = cancelButtonFont;
}

+ (UIFont *)cancelButtonFont {
    return _classCancelButtonFont;
}

static UIColor *_classCancelButtonBackgroundColor;

+ (void)setCancelButtonBackgroundColor:(UIColor *)cancelButtonBackgroundColor {
    _classCancelButtonBackgroundColor = cancelButtonBackgroundColor;
}

+ (UIColor *)cancelButtonBackgroundColor {
    return _classCancelButtonBackgroundColor;
}

static UIColor *_classCancelButtonBackgroundColorHighlighted;

+ (void)setCancelButtonBackgroundColorHighlighted:(UIColor *)cancelButtonBackgroundColorHighlighted {
    _classCancelButtonBackgroundColorHighlighted = cancelButtonBackgroundColorHighlighted;
}

+ (UIColor *)cancelButtonBackgroundColorHighlighted {
    return _classCancelButtonBackgroundColorHighlighted;
}

static UIColor *_classCancelButtonBackgroundColorDisabled;

+ (void)setCancelButtonBackgroundColorDisabled:(UIColor *)cancelButtonBackgroundColorDisabled {
    _classCancelButtonBackgroundColorDisabled = cancelButtonBackgroundColorDisabled;
}

+ (UIColor *)cancelButtonBackgroundColorDisabled {
    return _classCancelButtonBackgroundColorDisabled;
}

static NSUInteger _classCancelButtonNumberOfLines;

+ (void)setCancelButtonNumberOfLines:(NSUInteger)cancelButtonNumberOfLines {
    _classCancelButtonNumberOfLines = cancelButtonNumberOfLines;
}

+ (NSUInteger)cancelButtonNumberOfLines {
    return _classCancelButtonNumberOfLines;
}

static NSLineBreakMode _classCancelButtonLineBreakMode;

+ (void)setCancelButtonLineBreakMode:(NSLineBreakMode)cancelButtonLineBreakMode {
    _classCancelButtonLineBreakMode = cancelButtonLineBreakMode;
}

+ (NSLineBreakMode)cancelButtonLineBreakMode {
    return _classCancelButtonLineBreakMode;
}

static CGFloat _classCancelButtonMinimumScaleFactor;

+ (void)setCancelButtonMinimumScaleFactor:(CGFloat)cancelButtonMinimumScaleFactor {
    _classCancelButtonMinimumScaleFactor = cancelButtonMinimumScaleFactor;
}

+ (CGFloat)cancelButtonMinimumScaleFactor {
    return _classCancelButtonMinimumScaleFactor;
}

static BOOL _classCancelButtonAdjustsFontSizeToFitWidth;

+ (void)setCancelButtonAdjustsFontSizeToFitWidth:(BOOL)cancelButtonAdjustsFontSizeToFitWidth {
    _classCancelButtonAdjustsFontSizeToFitWidth = cancelButtonAdjustsFontSizeToFitWidth;
}

+ (BOOL)isCancelButtonAdjustsFontSizeToFitWidth {
    return _classCancelButtonAdjustsFontSizeToFitWidth;
}

#pragma mark - Destructive button properties

static UIColor *_classDestructiveButtonTitleColor;

+ (void)setDestructiveButtonTitleColor:(UIColor *)destructiveButtonTitleColor {
    _classDestructiveButtonTitleColor = destructiveButtonTitleColor;
}

+ (UIColor *)destructiveButtonTitleColor {
    return _classDestructiveButtonTitleColor;
}

static UIColor *_classDestructiveButtonTitleColorHighlighted;

+ (void)setDestructiveButtonTitleColorHighlighted:(UIColor *)destructiveButtonTitleColorHighlighted {
    _classDestructiveButtonTitleColorHighlighted = destructiveButtonTitleColorHighlighted;
}

+ (UIColor *)destructiveButtonTitleColorHighlighted {
    return _classDestructiveButtonTitleColorHighlighted;
}

static UIColor *_classDestructiveButtonTitleColorDisabled;

+ (void)setDestructiveButtonTitleColorDisabled:(UIColor *)destructiveButtonTitleColorDisabled {
    _classDestructiveButtonTitleColorDisabled = destructiveButtonTitleColorDisabled;
}

+ (UIColor *)destructiveButtonTitleColorDisabled {
    return _classDestructiveButtonTitleColorDisabled;
}

static NSTextAlignment _classDestructiveButtonTextAlignment;

+ (void)setDestructiveButtonTextAlignment:(NSTextAlignment)destructiveButtonTextAlignment {
    _classDestructiveButtonTextAlignment = destructiveButtonTextAlignment;
}

+ (NSTextAlignment)destructiveButtonTextAlignment {
    return _classDestructiveButtonTextAlignment;
}

static UIFont *_classDestructiveButtonFont;

+ (void)setDestructiveButtonFont:(UIFont *)destructiveButtonFont {
    _classDestructiveButtonFont = destructiveButtonFont;
}

+ (UIFont *)destructiveButtonFont {
    return _classDestructiveButtonFont;
}

static UIColor *_classDestructiveButtonBackgroundColor;

+ (void)setDestructiveButtonBackgroundColor:(UIColor *)destructiveButtonBackgroundColor {
    _classDestructiveButtonBackgroundColor = destructiveButtonBackgroundColor;
}

+ (UIColor *)destructiveButtonBackgroundColor {
    return _classDestructiveButtonBackgroundColor;
}

static UIColor *_classDestructiveButtonBackgroundColorHighlighted;

+ (void)setDestructiveButtonBackgroundColorHighlighted:(UIColor *)destructiveButtonBackgroundColorHighlighted {
    _classDestructiveButtonBackgroundColorHighlighted = destructiveButtonBackgroundColorHighlighted;
}

+ (UIColor *)destructiveButtonBackgroundColorHighlighted {
    return _classDestructiveButtonBackgroundColorHighlighted;
}

static UIColor *_classDestructiveButtonBackgroundColorDisabled;

+ (void)setDestructiveButtonBackgroundColorDisabled:(UIColor *)destructiveButtonBackgroundColorDisabled {
    _classDestructiveButtonBackgroundColorDisabled = destructiveButtonBackgroundColorDisabled;
}

+ (UIColor *)destructiveButtonBackgroundColorDisabled {
    return _classDestructiveButtonBackgroundColorDisabled;
}

static NSUInteger _classDestructiveButtonNumberOfLines;

+ (void)setDestructiveButtonNumberOfLines:(NSUInteger)destructiveButtonNumberOfLines {
    _classDestructiveButtonNumberOfLines = destructiveButtonNumberOfLines;
}

+ (NSUInteger)destructiveButtonNumberOfLines {
    return _classDestructiveButtonNumberOfLines;
}

static NSLineBreakMode _classDestructiveButtonLineBreakMode;

+ (void)setDestructiveButtonLineBreakMode:(NSLineBreakMode)destructiveButtonLineBreakMode {
    _classDestructiveButtonLineBreakMode = destructiveButtonLineBreakMode;
}

+ (NSLineBreakMode)destructiveButtonLineBreakMode {
    return _classDestructiveButtonLineBreakMode;
}

static CGFloat _classDestructiveButtonMinimumScaleFactor;

+ (void)setDestructiveButtonMinimumScaleFactor:(CGFloat)destructiveButtonMinimumScaleFactor {
    _classDestructiveButtonMinimumScaleFactor = destructiveButtonMinimumScaleFactor;
}

+ (CGFloat)destructiveButtonMinimumScaleFactor {
    return _classDestructiveButtonMinimumScaleFactor;
}

static BOOL _classDestructiveButtonAdjustsFontSizeToFitWidth;

+ (void)setDestructiveButtonAdjustsFontSizeToFitWidth:(BOOL)destructiveButtonAdjustsFontSizeToFitWidth {
    _classDestructiveButtonAdjustsFontSizeToFitWidth = destructiveButtonAdjustsFontSizeToFitWidth;
}

+ (BOOL)isDestructiveButtonAdjustsFontSizeToFitWidth {
    return _classDestructiveButtonAdjustsFontSizeToFitWidth;
}

#pragma mark - Activity indicator properties

static UIActivityIndicatorViewStyle _classActivityIndicatorViewStyle;

+ (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    _classActivityIndicatorViewStyle = activityIndicatorViewStyle;
}

+ (UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    return _classActivityIndicatorViewStyle;
}

static UIColor *_classActivityIndicatorViewColor;

+ (void)setActivityIndicatorViewColor:(UIColor *)activityIndicatorViewColor {
    _classActivityIndicatorViewColor = activityIndicatorViewColor;
}

+ (UIColor *)activityIndicatorViewColor {
    return _classActivityIndicatorViewColor;
}

#pragma mark - Progress view properties

static UIColor *_classProgressViewProgressTintColor;

+ (void)setProgressViewProgressTintColor:(UIColor *)progressViewProgressTintColor {
    _classProgressViewProgressTintColor = progressViewProgressTintColor;
}

+ (UIColor *)progressViewProgressTintColor {
    return _classProgressViewProgressTintColor;
}

static UIColor *_classProgressViewTrackTintColor;

+ (void)setProgressViewTrackTintColor:(UIColor *)progressViewTrackTintColor {
    _classProgressViewTrackTintColor = progressViewTrackTintColor;
}

+ (UIColor *)progressViewTrackTintColor {
    return _classProgressViewTrackTintColor;
}

static UIImage *_classProgressViewProgressImage;

+ (void)setProgressViewProgressImage:(UIImage *)progressViewProgressImage {
    _classProgressViewProgressImage = progressViewProgressImage;
}

+ (UIImage *)progressViewProgressImage {
    return _classProgressViewProgressImage;
}

static UIImage *_classProgressViewTrackImage;

+ (void)setProgressViewTrackImage:(UIImage *)progressViewTrackImage {
    _classProgressViewTrackImage = progressViewTrackImage;
}

+ (UIImage *)progressViewTrackImage {
    return _classProgressViewTrackImage;
}

static UIColor *_classProgressLabelTextColor;

+ (void)setProgressLabelTextColor:(UIColor *)progressLabelTextColor {
    _classProgressLabelTextColor = progressLabelTextColor;
}

+ (UIColor *)progressLabelTextColor {
    return _classProgressLabelTextColor;
}

static NSTextAlignment _classProgressLabelTextAlignment;

+ (void)setProgressLabelTextAlignment:(NSTextAlignment)progressLabelTextAlignment {
    _classProgressLabelTextAlignment = progressLabelTextAlignment;
}

+ (NSTextAlignment)progressLabelTextAlignment {
    return _classProgressLabelTextAlignment;
}

static UIFont *_classProgressLabelFont;

+ (void)setProgressLabelFont:(UIFont *)progressLabelFont {
    _classProgressLabelFont = progressLabelFont;
}

+ (UIFont *)progressLabelFont {
    return _classProgressLabelFont;
}

#pragma mark -

+ (nonnull NSArray *)alertViewsArray {
    if (!kLGAlertViewArray) {
        kLGAlertViewArray = [NSMutableArray new];
    }
    
    return kLGAlertViewArray;
}

#pragma mark - Support

+ (void)animateStandardWithAnimations:(void(^)())animations completion:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.5
                        options:0
                     animations:animations
                     completion:completion];
}

+ (UIImage *)image1x1WithColor:(UIColor *)color {
    if (!color) return nil;
    
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void)keyboardAnimateWithNotificationUserInfo:(NSDictionary *)notificationUserInfo animations:(void(^)(CGFloat keyboardHeight))animations {
    CGFloat keyboardHeight = (notificationUserInfo[UIKeyboardFrameEndUserInfoKey] ? [notificationUserInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height : 0.0);
    
    if (!keyboardHeight) return;
    
    NSTimeInterval animationDuration = [notificationUserInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int animationCurve = [notificationUserInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (animations) {
        animations(keyboardHeight);
    }
    
    [UIView commitAnimations];
}

@end
