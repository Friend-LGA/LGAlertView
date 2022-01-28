//
//  LGAlertView.m
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

#import "LGAlertView.h"
#import "LGAlertViewWindow.h"
#import "LGAlertViewController.h"
#import "LGAlertViewCell.h"
#import "LGAlertViewTextField.h"
#import "LGAlertViewButton.h"
#import "LGAlertViewHelper.h"
#import "LGAlertViewWindowsObserver.h"
#import "LGAlertViewShadowView.h"

#pragma mark - Constants

NSString * _Nonnull const LGAlertViewWillShowNotification = @"LGAlertViewWillShowNotification";
NSString * _Nonnull const LGAlertViewDidShowNotification  = @"LGAlertViewDidShowNotification";

NSString * _Nonnull const LGAlertViewWillDismissNotification = @"LGAlertViewWillDismissNotification";
NSString * _Nonnull const LGAlertViewDidDismissNotification  = @"LGAlertViewDidDismissNotification";

NSString * _Nonnull const LGAlertViewActionNotification      = @"LGAlertViewActionNotification";
NSString * _Nonnull const LGAlertViewCancelNotification      = @"LGAlertViewCancelNotification";
NSString * _Nonnull const LGAlertViewDestructiveNotification = @"LGAlertViewDestructiveNotification";

NSString * _Nonnull const LGAlertViewDidDismissAfterActionNotification      = @"LGAlertViewDidDismissAfterActionNotification";
NSString * _Nonnull const LGAlertViewDidDismissAfterCancelNotification      = @"LGAlertViewDidDismissAfterCancelNotification";
NSString * _Nonnull const LGAlertViewDidDismissAfterDestructiveNotification = @"LGAlertViewDidDismissAfterDestructiveNotification";

NSString * _Nonnull const LGAlertViewShowAnimationsNotification    = @"LGAlertViewShowAnimationsNotification";
NSString * _Nonnull const LGAlertViewDismissAnimationsNotification = @"LGAlertViewDismissAnimationsNotification";

NSString * _Nonnull const kLGAlertViewAnimationDuration = @"duration";

#pragma mark - Types

typedef enum {
    LGAlertViewTypeDefault           = 0,
    LGAlertViewTypeActivityIndicator = 1,
    LGAlertViewTypeProgressView      = 2,
    LGAlertViewTypeTextFields        = 3
}
LGAlertViewType;

#pragma mark - Interface

@interface LGAlertView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (readwrite) BOOL             showing;
@property (readwrite) LGAlertViewStyle style;
@property (readwrite) NSString         *title;
@property (readwrite) NSString         *message;
@property (readwrite) UIView           *innerView;
@property (readwrite) NSArray          *buttonTitles;
@property (readwrite) NSString         *cancelButtonTitle;
@property (readwrite) NSString         *destructiveButtonTitle;
@property (readwrite) NSArray          *textFieldsArray;

@property (assign, nonatomic, getter=isExists) BOOL exists;

@property (strong, nonatomic) LGAlertViewWindow *window;

@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) LGAlertViewController *viewController;

@property (strong, nonatomic) UIVisualEffectView *backgroundView;

@property (strong, nonatomic) LGAlertViewShadowView *shadowView;
@property (strong, nonatomic) LGAlertViewShadowView *shadowCancelView;

@property (strong, nonatomic) UIVisualEffectView *blurView;
@property (strong, nonatomic) UIVisualEffectView *blurCancelView;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITableView  *tableView;

@property (strong, nonatomic) UILabel           *titleLabel;
@property (strong, nonatomic) UILabel           *messageLabel;
@property (strong, nonatomic) UIView            *innerContainerView;
@property (strong, nonatomic) LGAlertViewButton *destructiveButton;
@property (strong, nonatomic) LGAlertViewButton *cancelButton;
@property (strong, nonatomic) LGAlertViewButton *firstButton;
@property (strong, nonatomic) LGAlertViewButton *secondButton;
@property (strong, nonatomic) LGAlertViewButton *thirdButton;

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

@property (assign, nonatomic) LGAlertViewType type;

@property (assign, nonatomic) CGFloat keyboardHeight;

@property (strong, nonatomic) NSMutableDictionary *buttonsPropertiesDictionary;
@property (strong, nonatomic) NSMutableArray *buttonsEnabledArray;

@property (strong, nonatomic) LGAlertViewCell *heightCell;

@property (assign, nonatomic) NSUInteger numberOfTextFields;

@property (copy, nonatomic) LGAlertViewTextFieldsSetupHandler textFieldsSetupHandler;

@property (assign, nonatomic, getter=isUserCancelOnTouch)                          BOOL userCancelOnTouch;
@property (assign, nonatomic, getter=isUserButtonsHeight)                          BOOL userButtonsHeight;
@property (assign, nonatomic, getter=isUserTitleTextColor)                         BOOL userTitleTextColor;
@property (assign, nonatomic, getter=isUserTitleFont)                              BOOL userTitleFont;
@property (assign, nonatomic, getter=isUserMessageTextColor)                       BOOL userMessageTextColor;
@property (assign, nonatomic, getter=isUserButtonsTitleColor)                      BOOL userButtonsTitleColor;
@property (assign, nonatomic, getter=isUserButtonsBackgroundColorHighlighted)      BOOL userButtonsBackgroundColorHighlighted;
@property (assign, nonatomic, getter=isUserCancelButtonTitleColor)                 BOOL userCancelButtonTitleColor;
@property (assign, nonatomic, getter=isUserCancelButtonBackgroundColorHighlighted) BOOL userCancelButtonBackgroundColorHighlighted;
@property (assign, nonatomic, getter=isUserActivityIndicatorViewColor)             BOOL userActivityIndicatorViewColor;
@property (assign, nonatomic, getter=isUserProgressViewProgressTintColor)          BOOL userProgressViewProgressTintColor;

@property (assign, nonatomic, getter=isInitialized) BOOL initialized;

@end

#pragma mark - Implementation

@implementation LGAlertView

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                                style:(LGAlertViewStyle)style
                         buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
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
                                buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
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
                                        progressLabelText:(nullable NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle {
    self = [super init];
    if (self) {
        self.style = style;
        self.type = LGAlertViewTypeActivityIndicator;
        self.title = title;
        self.message = message;
        self.buttonTitles = buttonTitles.mutableCopy;
        self.cancelButtonTitle = cancelButtonTitle;
        self.destructiveButtonTitle = destructiveButtonTitle;
        self.progressLabelText = progressLabelText;

        [self setupDefaults];
    }
    return self;
}

- (nonnull instancetype)initWithProgressViewAndTitle:(nullable NSString *)title
                                             message:(nullable NSString *)message
                                               style:(LGAlertViewStyle)style
                                            progress:(float)progress
                                   progressLabelText:(NSString *)progressLabelText
                                        buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                              destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle {
    self = [super init];
    if (self) {
        self.style = style;
        self.type = LGAlertViewTypeProgressView;
        self.title = title;
        self.message = message;
        self.buttonTitles = buttonTitles.mutableCopy;
        self.cancelButtonTitle = cancelButtonTitle;
        self.destructiveButtonTitle = destructiveButtonTitle;
        self.progress = progress;
        self.progressLabelText = progressLabelText;

        [self setupDefaults];
    }
    return self;
}

- (nonnull instancetype)initWithTextFieldsAndTitle:(nullable NSString *)title
                                           message:(nullable NSString *)message
                                numberOfTextFields:(NSUInteger)numberOfTextFields
                            textFieldsSetupHandler:(LGAlertViewTextFieldsSetupHandler)textFieldsSetupHandler
                                      buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                 cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                            destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle {
    self = [super init];
    if (self) {
        self.style = LGAlertViewStyleAlert;
        self.type = LGAlertViewTypeTextFields;
        self.title = title;
        self.message = message;
        self.numberOfTextFields = numberOfTextFields;
        self.textFieldsSetupHandler = textFieldsSetupHandler;
        self.buttonTitles = buttonTitles.mutableCopy;
        self.cancelButtonTitle = cancelButtonTitle;
        self.destructiveButtonTitle = destructiveButtonTitle;

        [self setupDefaults];
    }
    return self;
}

+ (nonnull instancetype)alertViewWithTitle:(nullable NSString *)title
                                   message:(nullable NSString *)message
                                     style:(LGAlertViewStyle)style
                              buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
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
                                     buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
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
                                             progressLabelText:(nullable NSString *)progressLabelText
                                                  buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                        destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle {
    return [[self alloc] initWithActivityIndicatorAndTitle:title
                                                   message:message
                                                     style:style
                                         progressLabelText:progressLabelText
                                              buttonTitles:buttonTitles
                                         cancelButtonTitle:cancelButtonTitle
                                    destructiveButtonTitle:destructiveButtonTitle];
}

+ (nonnull instancetype)alertViewWithProgressViewAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                                 progress:(float)progress
                                        progressLabelText:(NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle {
    return [[self alloc] initWithProgressViewAndTitle:title
                                              message:message
                                                style:style
                                             progress:progress
                                    progressLabelText:progressLabelText
                                         buttonTitles:buttonTitles
                                    cancelButtonTitle:cancelButtonTitle
                               destructiveButtonTitle:destructiveButtonTitle];
}

+ (nonnull instancetype)alertViewWithTextFieldsAndTitle:(nullable NSString *)title
                                                message:(nullable NSString *)message
                                     numberOfTextFields:(NSUInteger)numberOfTextFields
                                 textFieldsSetupHandler:(LGAlertViewTextFieldsSetupHandler)textFieldsSetupHandler
                                           buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
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
                         buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
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
                                buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
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
                                        progressLabelText:(nullable NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                            actionHandler:(LGAlertViewActionHandler)actionHandler
                                            cancelHandler:(LGAlertViewHandler)cancelHandler
                                       destructiveHandler:(LGAlertViewHandler)destructiveHandler {
    self = [self initWithActivityIndicatorAndTitle:title
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

- (nonnull instancetype)initWithProgressViewAndTitle:(nullable NSString *)title
                                             message:(nullable NSString *)message
                                               style:(LGAlertViewStyle)style
                                            progress:(float)progress
                                   progressLabelText:(NSString *)progressLabelText
                                        buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                              destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                       actionHandler:(LGAlertViewActionHandler)actionHandler
                                       cancelHandler:(LGAlertViewHandler)cancelHandler
                                  destructiveHandler:(LGAlertViewHandler)destructiveHandler {
    self = [self initWithProgressViewAndTitle:title
                                      message:message
                                        style:style
                                     progress:progress
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
                                      buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
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
                              buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
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
                                     buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
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
                                             progressLabelText:(nullable NSString *)progressLabelText
                                                  buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                        destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                                 actionHandler:(LGAlertViewActionHandler)actionHandler
                                                 cancelHandler:(LGAlertViewHandler)cancelHandler
                                            destructiveHandler:(LGAlertViewHandler)destructiveHandler {
    return [[self alloc] initWithActivityIndicatorAndTitle:title
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

+ (nonnull instancetype)alertViewWithProgressViewAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                                 progress:(float)progress
                                        progressLabelText:(NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                            actionHandler:(LGAlertViewActionHandler)actionHandler
                                            cancelHandler:(LGAlertViewHandler)cancelHandler
                                       destructiveHandler:(LGAlertViewHandler)destructiveHandler {
    return [[self alloc] initWithProgressViewAndTitle:title
                                              message:message
                                                style:style
                                             progress:progress
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
                                           buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
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
                         buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
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
                                buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
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
                                        progressLabelText:(nullable NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                                 delegate:(nullable id<LGAlertViewDelegate>)delegate {
    self = [self initWithActivityIndicatorAndTitle:title
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

- (nonnull instancetype)initWithProgressViewAndTitle:(nullable NSString *)title
                                             message:(nullable NSString *)message
                                               style:(LGAlertViewStyle)style
                                            progress:(float)progress
                                   progressLabelText:(NSString *)progressLabelText
                                        buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                              destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                            delegate:(nullable id<LGAlertViewDelegate>)delegate {
    self = [self initWithProgressViewAndTitle:title
                                      message:message
                                        style:style
                                     progress:progress
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
                                      buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
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
                              buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
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
                                     buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
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
                                             progressLabelText:(nullable NSString *)progressLabelText
                                                  buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                        destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                                      delegate:(nullable id<LGAlertViewDelegate>)delegate {
    return [[self alloc] initWithActivityIndicatorAndTitle:title
                                                   message:message
                                                     style:style
                                         progressLabelText:progressLabelText
                                              buttonTitles:buttonTitles
                                         cancelButtonTitle:cancelButtonTitle
                                    destructiveButtonTitle:destructiveButtonTitle
                                                  delegate:delegate];
}

+ (nonnull instancetype)alertViewWithProgressViewAndTitle:(nullable NSString *)title
                                                  message:(nullable NSString *)message
                                                    style:(LGAlertViewStyle)style
                                                 progress:(float)progress
                                        progressLabelText:(NSString *)progressLabelText
                                             buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                                 delegate:(nullable id<LGAlertViewDelegate>)delegate {
    return [[self alloc] initWithProgressViewAndTitle:title
                                              message:message
                                                style:style
                                             progress:progress
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
                                           buttonTitles:(nullable NSArray<NSString *> *)buttonTitles
                                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                               delegate:(nullable id<LGAlertViewDelegate>)delegate {
    return [[self alloc] initWithTextFieldsAndTitle:title
                                            message:message
                                 numberOfTextFields:numberOfTextFields
                             textFieldsSetupHandler:textFieldsSetupHandler
                                       buttonTitles:buttonTitles
                                  cancelButtonTitle:cancelButtonTitle
                             destructiveButtonTitle:destructiveButtonTitle
                                           delegate:delegate];
}

#pragma mark -

- (nonnull instancetype)initAsAppearance {
    self = [super init];
    if (self) {
        _heightCell = [[LGAlertViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        // -----

        _windowLevel = LGAlertViewWindowLevelAboveStatusBar;
        _dismissOnAction = YES;

        _tintColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        _coverColor = [UIColor colorWithWhite:0.0 alpha:0.35];
        _coverBlurEffect = nil;
        _coverAlpha = 1.0;
        _backgroundColor = UIColor.whiteColor;
        _backgroundBlurEffect = nil;
        _textFieldsHeight = 44.0;
        _offsetVertical = 8.0;
        _cancelButtonOffsetY = 8.0;
        _heightMax = NSNotFound;
        _width = NSNotFound;
        _separatorsColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        _indicatorStyle = UIScrollViewIndicatorStyleBlack;
        _showsVerticalScrollIndicator = NO;
        _padShowsActionSheetFromBottom = NO;
        _oneRowOneButton = NO;
        _shouldDismissAnimated = YES;

        _layerCornerRadius = LGAlertViewHelper.systemVersion < 9.0 ? 6.0 : 12.0;
        _layerBorderColor = nil;
        _layerBorderWidth = 0.0;
        _layerShadowColor = nil;
        _layerShadowRadius = 0.0;
        _layerShadowOffset = CGPointZero;

        _animationDuration = 0.5;
        _initialScale = 1.2;
        _finalScale = 0.95;

        _titleTextColor = nil;
        _titleTextAlignment = NSTextAlignmentCenter;
        _titleFont = nil;

        _messageTextColor = nil;
        _messageTextAlignment = NSTextAlignmentCenter;
        _messageFont = [UIFont systemFontOfSize:14.0];

        _buttonsTitleColor = self.tintColor;
        _buttonsTitleColorHighlighted = UIColor.whiteColor;
        _buttonsTitleColorDisabled = UIColor.grayColor;
        _buttonsTextAlignment = NSTextAlignmentCenter;
        _buttonsFont = [UIFont systemFontOfSize:18.0];
        _buttonsBackgroundColor = UIColor.clearColor;
        _buttonsBackgroundColorHighlighted = self.tintColor;
        _buttonsBackgroundColorDisabled = nil;
        _buttonsNumberOfLines = 1;
        _buttonsLineBreakMode = NSLineBreakByTruncatingMiddle;
        _buttonsMinimumScaleFactor = 14.0 / 18.0;
        _buttonsAdjustsFontSizeToFitWidth = YES;
        _buttonsEnabled = YES;
        _buttonsIconPosition = LGAlertViewButtonIconPositionLeft;

        _cancelButtonTitleColor = self.tintColor;
        _cancelButtonTitleColorHighlighted = UIColor.whiteColor;
        _cancelButtonTitleColorDisabled = UIColor.grayColor;
        _cancelButtonTextAlignment = NSTextAlignmentCenter;
        _cancelButtonFont = [UIFont boldSystemFontOfSize:18.0];
        _cancelButtonBackgroundColor = UIColor.clearColor;
        _cancelButtonBackgroundColorHighlighted = self.tintColor;
        _cancelButtonBackgroundColorDisabled = nil;
        _cancelButtonNumberOfLines = 1;
        _cancelButtonLineBreakMode = NSLineBreakByTruncatingMiddle;
        _cancelButtonMinimumScaleFactor = 14.0 / 18.0;
        _cancelButtonAdjustsFontSizeToFitWidth = YES;
        _cancelButtonEnabled = YES;
        _cancelButtonIconPosition = LGAlertViewButtonIconPositionLeft;

        _destructiveButtonTitleColor = UIColor.redColor;
        _destructiveButtonTitleColorHighlighted = UIColor.whiteColor;
        _destructiveButtonTitleColorDisabled = UIColor.grayColor;
        _destructiveButtonTextAlignment = NSTextAlignmentCenter;
        _destructiveButtonFont = [UIFont systemFontOfSize:18.0];
        _destructiveButtonBackgroundColor = UIColor.clearColor;
        _destructiveButtonBackgroundColorHighlighted = UIColor.redColor;
        _destructiveButtonBackgroundColorDisabled = nil;
        _destructiveButtonNumberOfLines = 1;
        _destructiveButtonLineBreakMode = NSLineBreakByTruncatingMiddle;
        _destructiveButtonMinimumScaleFactor = 14.0 / 18.0;
        _destructiveButtonAdjustsFontSizeToFitWidth = YES;
        _destructiveButtonEnabled = YES;
        _destructiveButtonIconPosition = LGAlertViewButtonIconPositionLeft;

        _activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _activityIndicatorViewColor = self.tintColor;

        _progressViewProgressTintColor = self.tintColor;
        _progressViewTrackTintColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        _progressViewProgressImage = nil;
        _progressViewTrackImage = nil;

        _progressLabelTextColor = UIColor.blackColor;
        _progressLabelTextAlignment = NSTextAlignmentCenter;
        _progressLabelFont = [UIFont systemFontOfSize:14.0];
        _progressLabelNumberOfLines = 1;
        _progressLabelLineBreakMode = NSLineBreakByTruncatingTail;

        _textFieldsBackgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
        _textFieldsTextColor = UIColor.blackColor;
        _textFieldsFont = [UIFont systemFontOfSize:16.0];
        _textFieldsTextAlignment = NSTextAlignmentLeft;
        _textFieldsClearsOnBeginEditing = NO;
        _textFieldsAdjustsFontSizeToFitWidth = NO;
        _textFieldsMinimumFontSize = 12.0;
        _textFieldsClearButtonMode = UITextFieldViewModeAlways;
    }
    return self;
}

#pragma mark - Defaults

- (void)setupDefaults {
    self.buttonsEnabledArray = [NSMutableArray new];

    for (NSUInteger i = 0; i < self.buttonTitles.count; i++) {
        [self.buttonsEnabledArray addObject:@YES];
    }

    LGAlertView *appearance = [LGAlertView appearance];

    // -----

    _heightCell = appearance.heightCell;

    // -----

    _windowLevel = appearance.windowLevel;
    if (appearance.isUserCancelOnTouch) {
        _cancelOnTouch = appearance.cancelOnTouch;
    }
    else {
        _cancelOnTouch = self.type != LGAlertViewTypeActivityIndicator && self.type != LGAlertViewTypeProgressView && self.type != LGAlertViewTypeTextFields;
    }
    _dismissOnAction = appearance.dismissOnAction;
    _tag = NSNotFound;

    _tintColor = appearance.tintColor;
    _coverColor = appearance.coverColor;
    _coverBlurEffect = appearance.coverBlurEffect;
    _coverAlpha = appearance.coverAlpha;
    _backgroundColor = appearance.backgroundColor;
    _backgroundBlurEffect = appearance.backgroundBlurEffect;
    if (appearance.isUserButtonsHeight) {
        _buttonsHeight = appearance.buttonsHeight;
    }
    else {
        _buttonsHeight = (self.style == LGAlertViewStyleAlert || LGAlertViewHelper.systemVersion < 9.0) ? 44.0 : 56.0;
    }
    _textFieldsHeight = appearance.textFieldsHeight;
    _offsetVertical = appearance.offsetVertical;
    _cancelButtonOffsetY = appearance.cancelButtonOffsetY;
    _heightMax = appearance.heightMax;
    _width = appearance.width;
    _separatorsColor = appearance.separatorsColor;
    _indicatorStyle = appearance.indicatorStyle;
    _showsVerticalScrollIndicator = appearance.showsVerticalScrollIndicator;
    _padShowsActionSheetFromBottom = appearance.padShowsActionSheetFromBottom;
    _oneRowOneButton = appearance.oneRowOneButton;
    _shouldDismissAnimated = appearance.shouldDismissAnimated;

    _layerCornerRadius = appearance.layerCornerRadius;
    _layerBorderColor = appearance.layerBorderColor;
    _layerBorderWidth = appearance.layerBorderWidth;
    _layerShadowColor = appearance.layerShadowColor;
    _layerShadowRadius = appearance.layerShadowRadius;
    _layerShadowOffset = appearance.layerShadowOffset;

    _animationDuration = appearance.animationDuration;
    _initialScale = appearance.initialScale;
    _finalScale = appearance.finalScale;

    if (appearance.isUserTitleTextColor) {
        _titleTextColor = appearance.titleTextColor;
    }
    else {
        _titleTextColor = self.style == LGAlertViewStyleAlert ? UIColor.blackColor : UIColor.grayColor;
    }
    _titleTextAlignment = appearance.titleTextAlignment;
    if (appearance.isUserTitleFont) {
        _titleFont = appearance.titleFont;
    }
    else {
        _titleFont = [UIFont boldSystemFontOfSize:self.style == LGAlertViewStyleAlert ? 18.0 : 14.0];
    }

    if (appearance.isUserMessageTextColor) {
        _messageTextColor = appearance.messageTextColor;
    }
    else {
        _messageTextColor = self.style == LGAlertViewStyleAlert ? UIColor.blackColor : UIColor.grayColor;
    }
    _messageTextAlignment = appearance.messageTextAlignment;
    _messageFont = appearance.messageFont;

    _buttonsTitleColor = appearance.buttonsTitleColor;
    _buttonsTitleColorHighlighted = appearance.buttonsTitleColorHighlighted;
    _buttonsTitleColorDisabled = appearance.buttonsTitleColorDisabled;
    _buttonsTextAlignment = appearance.buttonsTextAlignment;
    _buttonsFont = appearance.buttonsFont;
    _buttonsBackgroundColor = appearance.buttonsBackgroundColor;
    _buttonsBackgroundColorHighlighted = appearance.buttonsBackgroundColorHighlighted;
    _buttonsBackgroundColorDisabled = appearance.buttonsBackgroundColorDisabled;
    _buttonsNumberOfLines = appearance.buttonsNumberOfLines;
    _buttonsLineBreakMode = appearance.buttonsLineBreakMode;
    _buttonsMinimumScaleFactor = appearance.buttonsMinimumScaleFactor;
    _buttonsAdjustsFontSizeToFitWidth = appearance.buttonsAdjustsFontSizeToFitWidth;
    _buttonsEnabled = appearance.buttonsEnabled;
    _buttonsIconPosition = appearance.buttonsIconPosition;

    _cancelButtonTitleColor = appearance.cancelButtonTitleColor;
    _cancelButtonTitleColorHighlighted = appearance.cancelButtonTitleColorHighlighted;
    _cancelButtonTitleColorDisabled = appearance.cancelButtonTitleColorDisabled;
    _cancelButtonTextAlignment = appearance.cancelButtonTextAlignment;
    _cancelButtonFont = appearance.cancelButtonFont;
    _cancelButtonBackgroundColor = appearance.cancelButtonBackgroundColor;
    _cancelButtonBackgroundColorHighlighted = appearance.cancelButtonBackgroundColorHighlighted;
    _cancelButtonBackgroundColorDisabled = appearance.cancelButtonBackgroundColorDisabled;
    _cancelButtonNumberOfLines = appearance.cancelButtonNumberOfLines;
    _cancelButtonLineBreakMode = appearance.cancelButtonLineBreakMode;
    _cancelButtonMinimumScaleFactor = appearance.cancelButtonMinimumScaleFactor;
    _cancelButtonAdjustsFontSizeToFitWidth = appearance.cancelButtonAdjustsFontSizeToFitWidth;
    _cancelButtonEnabled = appearance.cancelButtonEnabled;
    _cancelButtonIconPosition = appearance.cancelButtonIconPosition;

    _destructiveButtonTitleColor = appearance.destructiveButtonTitleColor;
    _destructiveButtonTitleColorHighlighted = appearance.destructiveButtonTitleColorHighlighted;
    _destructiveButtonTitleColorDisabled = appearance.destructiveButtonTitleColorDisabled;
    _destructiveButtonTextAlignment = appearance.destructiveButtonTextAlignment;
    _destructiveButtonFont = appearance.destructiveButtonFont;
    _destructiveButtonBackgroundColor = appearance.destructiveButtonBackgroundColor;
    _destructiveButtonBackgroundColorHighlighted = appearance.destructiveButtonBackgroundColorHighlighted;
    _destructiveButtonBackgroundColorDisabled = appearance.destructiveButtonBackgroundColorDisabled;
    _destructiveButtonNumberOfLines = appearance.destructiveButtonNumberOfLines;
    _destructiveButtonLineBreakMode = appearance.destructiveButtonLineBreakMode;
    _destructiveButtonMinimumScaleFactor = appearance.destructiveButtonMinimumScaleFactor;
    _destructiveButtonAdjustsFontSizeToFitWidth = appearance.destructiveButtonAdjustsFontSizeToFitWidth;
    _destructiveButtonEnabled = appearance.destructiveButtonEnabled;
    _destructiveButtonIconPosition = appearance.destructiveButtonIconPosition;

    _activityIndicatorViewStyle = appearance.activityIndicatorViewStyle;
    _activityIndicatorViewColor = appearance.activityIndicatorViewColor;

    _progressViewProgressTintColor = appearance.progressViewProgressTintColor;
    _progressViewTrackTintColor = appearance.progressViewTrackTintColor;
    _progressViewProgressImage = appearance.progressViewProgressImage;
    _progressViewTrackImage = appearance.progressViewTrackImage;

    _progressLabelTextColor = appearance.progressLabelTextColor;
    _progressLabelTextAlignment = appearance.progressLabelTextAlignment;
    _progressLabelFont = appearance.progressLabelFont;
    _progressLabelNumberOfLines = appearance.progressLabelNumberOfLines;
    _progressLabelLineBreakMode = appearance.progressLabelLineBreakMode;

    _textFieldsBackgroundColor = appearance.textFieldsBackgroundColor;
    _textFieldsTextColor = appearance.textFieldsTextColor;
    _textFieldsFont = appearance.textFieldsFont;
    _textFieldsTextAlignment = appearance.textFieldsTextAlignment;
    _textFieldsClearsOnBeginEditing = appearance.textFieldsClearsOnBeginEditing;
    _textFieldsAdjustsFontSizeToFitWidth = appearance.textFieldsAdjustsFontSizeToFitWidth;
    _textFieldsMinimumFontSize = appearance.textFieldsMinimumFontSize;
    _textFieldsClearButtonMode = appearance.textFieldsClearButtonMode;

    // -----

    self.view = [UIView new];
    self.view.backgroundColor = UIColor.clearColor;
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
    self.window.backgroundColor = UIColor.clearColor;
    self.window.rootViewController = self.viewController;

    // -----

    self.initialized = YES;
}

#pragma mark - Class load

+ (void)load {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        [[LGAlertViewWindowsObserver sharedInstance] startObserving];
    });
}

#pragma mark - Dealloc

- (void)dealloc {
    [self removeObservers];

#if DEBUG && LG_ALERT_VIEW_DEBUG
    NSLog(@"LGAlertView DEALLOCATED");
#endif
}

#pragma mark - UIAppearance

+ (instancetype)appearance {
    return [self sharedAlertViewForAppearance];
}

+ (instancetype)appearanceWhenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ... {
    return [self sharedAlertViewForAppearance];
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait {
    return [self sharedAlertViewForAppearance];
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait whenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ... {
    return [self sharedAlertViewForAppearance];
}

+ (instancetype)sharedAlertViewForAppearance {
    static LGAlertView *alertView;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        alertView = [[LGAlertView alloc] initAsAppearance];
    });

    return alertView;
}

#pragma mark - Observers

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardVisibleChanged:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardVisibleChanged:) name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowVisibleChanged:) name:UIWindowDidBecomeVisibleNotification object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
}

#pragma mark - Window notifications

- (void)windowVisibleChanged:(NSNotification *)notification {
    if (notification.object == self.window) {
        [self.viewController.view setNeedsLayout];
    }
}

#pragma mark - Keyboard notifications

- (void)keyboardVisibleChanged:(NSNotification *)notification {
    if (!self.isShowing || self.window.isHidden || !self.window.isKeyWindow) return;

    [LGAlertViewHelper
     keyboardAnimateWithNotificationUserInfo:notification.userInfo
     animations:^(CGFloat keyboardHeight) {
         if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
             self.keyboardHeight = keyboardHeight;
         }
         else {
             self.keyboardHeight = 0.0;
         }

         [self layoutValidateWithSize:self.view.bounds.size];
     }];
}

- (void)keyboardFrameChanged:(NSNotification *)notification {
    if (!self.isShowing ||
        self.window.isHidden ||
        !self.window.isKeyWindow ||
        [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] != 0.0) {
        return;
    }

    self.keyboardHeight = CGRectGetHeight([notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]);
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(LGAlertViewTextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        if (self.textFieldsArray.count > textField.tag + 1) {
            LGAlertViewTextField *nextTextField = self.textFieldsArray[textField.tag + 1];
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

- (void)setCancelOnTouch:(BOOL)cancelOnTouch {
    _cancelOnTouch = cancelOnTouch;
    self.userCancelOnTouch = YES;
}

- (void)setButtonsHeight:(CGFloat)buttonsHeight {
    _buttonsHeight = buttonsHeight;
    self.userButtonsHeight = YES;
}

- (void)setTitleTextColor:(UIColor *)titleTextColor {
    _titleTextColor = titleTextColor;
    self.userTitleTextColor = YES;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.userTitleFont = YES;
}

- (void)setMessageTextColor:(UIColor *)messageTextColor {
    _messageTextColor = messageTextColor;
    self.userMessageTextColor = YES;
}

- (void)setButtonsTitleColor:(UIColor *)buttonsTitleColor {
    _buttonsTitleColor = buttonsTitleColor;
    self.userButtonsTitleColor = YES;
}

- (void)setButtonsBackgroundColorHighlighted:(UIColor *)buttonsBackgroundColorHighlighted {
    _buttonsBackgroundColorHighlighted = buttonsBackgroundColorHighlighted;
    self.userButtonsBackgroundColorHighlighted = YES;
}

- (void)setCancelButtonTitleColor:(UIColor *)cancelButtonTitleColor {
    _cancelButtonTitleColor = cancelButtonTitleColor;
    self.userCancelButtonTitleColor = YES;
}

- (void)setCancelButtonBackgroundColorHighlighted:(UIColor *)cancelButtonBackgroundColorHighlighted {
    _cancelButtonBackgroundColorHighlighted = cancelButtonBackgroundColorHighlighted;
    self.userCancelButtonBackgroundColorHighlighted = YES;
}

- (void)setActivityIndicatorViewColor:(UIColor *)activityIndicatorViewColor {
    _activityIndicatorViewColor = activityIndicatorViewColor;
    self.userActivityIndicatorViewColor = YES;
}

- (void)setProgressViewProgressTintColor:(UIColor *)progressViewProgressTintColor {
    _progressViewProgressTintColor = progressViewProgressTintColor;
    self.userProgressViewProgressTintColor = YES;
}

#pragma mark -

- (void)setProgress:(float)progress {
    if (self.type != LGAlertViewTypeProgressView) return;

    _progress = progress;
    [self.progressView setProgress:_progress animated:YES];
}

- (void)setProgressLabelText:(nullable NSString *)progressLabelText {
    if (self.type != LGAlertViewTypeProgressView && self.type != LGAlertViewTypeActivityIndicator) return;

    _progressLabelText = progressLabelText;
    self.progressLabel.text = _progressLabelText;
}

- (void)setCancelButtonEnabled:(BOOL)cancelButtonEnabled {
    _cancelButtonEnabled = cancelButtonEnabled;

    if (self.cancelButtonTitle) {
        if (self.tableView) {
            LGAlertViewCell *cell = (LGAlertViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(self.buttonTitles.count - 1) inSection:0]];
            cell.enabled = cancelButtonEnabled;
        }
        else if (self.scrollView) {
            self.cancelButton.enabled = cancelButtonEnabled;
        }
    }
}

- (void)setDestructiveButtonEnabled:(BOOL)destructiveButtonEnabled {
    _destructiveButtonEnabled = destructiveButtonEnabled;

    if (self.destructiveButtonTitle) {
        if (self.tableView) {
            LGAlertViewCell *cell = (LGAlertViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.enabled = destructiveButtonEnabled;
        }
        else if (self.scrollView) {
            self.destructiveButton.enabled = destructiveButtonEnabled;
        }
    }
}

- (CGFloat)width {
    CGSize size = LGAlertViewHelper.appWindow.bounds.size;

    if (_width != NSNotFound) {
        CGFloat result = MIN(size.width, size.height);

        if (_width < result) {
            result = _width;
        }

        return result;
    }

    // If we try to get width of appearance object
    if (!self.isInitialized) return NSNotFound;

    if (self.style == LGAlertViewStyleAlert || [LGAlertViewHelper isPadAndNotForce:self]) {
        return 280.0; // 320.0 - (20.0 * 2.0)
    }

    if (LGAlertViewHelper.isPad) {
        return 388.0; // 320.0 - (16.0 * 2.0)
    }

    return MIN(size.width, size.height) - 16.0; // MIN(size.width, size.height) - (8.0 * 2.0)
}

- (void)setDelegate:(id<LGAlertViewDelegate>)delegate {
    _delegate = delegate;

    if (!delegate) return;

    if ([delegate respondsToSelector:@selector(alertView:buttonPressedWithTitle:index:)]) {
        NSLog(@"WARNING: delegate method \"alertView:buttonPressedWithTitle:index:\" is DEPRECATED, use \"alertView:clickedButtonAtIndex:title:\" instead");
    }

    if ([delegate respondsToSelector:@selector(alertViewDestructiveButtonPressed:)]) {
        NSLog(@"WARNING: delegate method \"alertViewDestructiveButtonPressed:\" is DEPRECATED, use \"alertViewDestructed:\" instead");
    }
}

#pragma mark -

- (void)setProgress:(float)progress progressLabelText:(nullable NSString *)progressLabelText {
    if (self.type != LGAlertViewTypeProgressView) return;

    self.progress = progress;
    self.progressLabelText = progressLabelText;
}

- (void)setButtonEnabled:(BOOL)enabled atIndex:(NSUInteger)index {
    if (self.buttonTitles.count <= index) return;

    self.buttonsEnabledArray[index] = @(enabled);

    if (self.tableView) {
        if (self.destructiveButtonTitle) {
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

- (BOOL)isButtonEnabledAtIndex:(NSUInteger)index {
    return [self.buttonsEnabledArray[index] boolValue];
}

- (void)setButtonPropertiesAtIndex:(NSUInteger)index
                           handler:(void(^ _Nonnull)(LGAlertViewButtonProperties * _Nonnull properties))handler {
    if (!handler || self.buttonTitles.count <= index) return;

    if (!self.buttonsPropertiesDictionary) {
        self.buttonsPropertiesDictionary = [NSMutableDictionary new];
    }

    LGAlertViewButtonProperties *properties = self.buttonsPropertiesDictionary[@(index)];

    if (!properties) {
        properties = [LGAlertViewButtonProperties new];
    }

    handler(properties);

    if (properties.isUserEnabled) {
        self.buttonsEnabledArray[index] = @(properties.enabled);
    }

    [self.buttonsPropertiesDictionary setObject:properties forKey:@(index)];
}

- (void)forceCancel {
    NSAssert(self.cancelButtonTitle, @"Cancel button is not exists");

    [self cancelAction:nil];
}

- (void)forceDestructive {
    NSAssert(self.destructiveButtonTitle, @"Destructive button is not exists");

    [self destructiveAction:nil];
}

- (void)forceActionAtIndex:(NSUInteger)index {
    NSAssert(self.buttonTitles.count > index, @"Button at index %lu is not exists", (long unsigned)index);

    [self actionActionAtIndex:index title:self.buttonTitles[index + (self.tableView && self.destructiveButtonTitle ? 1 : 0)]];
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

    [self configCell:cell forRowAtIndexPath:indexPath];

    return cell;
}

- (void)configCell:(LGAlertViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = self.buttonTitles[indexPath.row];

    if (self.destructiveButtonTitle && indexPath.row == 0) {
        cell.titleColor                 = self.destructiveButtonTitleColor;
        cell.titleColorHighlighted      = self.destructiveButtonTitleColorHighlighted;
        cell.titleColorDisabled         = self.destructiveButtonTitleColorDisabled;
        cell.backgroundColorNormal      = self.destructiveButtonBackgroundColor;
        cell.backgroundColorHighlighted = self.destructiveButtonBackgroundColorHighlighted;
        cell.backgroundColorDisabled    = self.destructiveButtonBackgroundColorDisabled;
        cell.image                      = self.destructiveButtonIconImage;
        cell.imageHighlighted           = self.destructiveButtonIconImageHighlighted;
        cell.imageDisabled              = self.destructiveButtonIconImageDisabled;
        cell.iconPosition               = self.destructiveButtonIconPosition;

        cell.separatorView.hidden                = (indexPath.row == self.buttonTitles.count - 1);
        cell.separatorView.backgroundColor       = self.separatorsColor;
        cell.textLabel.textAlignment             = self.destructiveButtonTextAlignment;
        cell.textLabel.font                      = self.destructiveButtonFont;
        cell.textLabel.numberOfLines             = self.destructiveButtonNumberOfLines;
        cell.textLabel.lineBreakMode             = self.destructiveButtonLineBreakMode;
        cell.textLabel.adjustsFontSizeToFitWidth = self.destructiveButtonAdjustsFontSizeToFitWidth;
        cell.textLabel.minimumScaleFactor        = self.destructiveButtonMinimumScaleFactor;

        cell.enabled = self.destructiveButtonEnabled;
    }
    else if (self.cancelButtonTitle && ![LGAlertViewHelper isCancelButtonSeparate:self] && indexPath.row == self.buttonTitles.count - 1) {
        cell.titleColor                 = self.cancelButtonTitleColor;
        cell.titleColorHighlighted      = self.cancelButtonTitleColorHighlighted;
        cell.titleColorDisabled         = self.cancelButtonTitleColorDisabled;
        cell.backgroundColorNormal      = self.cancelButtonBackgroundColor;
        cell.backgroundColorHighlighted = self.cancelButtonBackgroundColorHighlighted;
        cell.backgroundColorDisabled    = self.cancelButtonBackgroundColorDisabled;
        cell.image                      = self.cancelButtonIconImage;
        cell.imageHighlighted           = self.cancelButtonIconImageHighlighted;
        cell.imageDisabled              = self.cancelButtonIconImageDisabled;
        cell.iconPosition               = self.cancelButtonIconPosition;

        cell.separatorView.hidden                = YES;
        cell.separatorView.backgroundColor       = self.separatorsColor;
        cell.textLabel.textAlignment             = self.cancelButtonTextAlignment;
        cell.textLabel.font                      = self.cancelButtonFont;
        cell.textLabel.numberOfLines             = self.cancelButtonNumberOfLines;
        cell.textLabel.lineBreakMode             = self.cancelButtonLineBreakMode;
        cell.textLabel.adjustsFontSizeToFitWidth = self.cancelButtonAdjustsFontSizeToFitWidth;
        cell.textLabel.minimumScaleFactor        = self.cancelButtonMinimumScaleFactor;

        cell.enabled = self.cancelButtonEnabled;
    }
    else {
        NSInteger buttonIndex = indexPath.row - (self.destructiveButtonTitle ? 1 : 0);

        LGAlertViewButtonProperties *properties = nil;

        if (self.buttonsPropertiesDictionary) {
            properties = self.buttonsPropertiesDictionary[@(buttonIndex)];
        }

        cell.titleColor                 = (properties.isUserTitleColor ? properties.titleColor : self.buttonsTitleColor);
        cell.titleColorHighlighted      = (properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : self.buttonsTitleColorHighlighted);
        cell.titleColorDisabled         = (properties.isUserTitleColorDisabled ? properties.titleColorDisabled : self.buttonsTitleColorDisabled);
        cell.backgroundColorNormal      = (properties.isUserBackgroundColor ? properties.backgroundColor : self.buttonsBackgroundColor);
        cell.backgroundColorHighlighted = (properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : self.buttonsBackgroundColorHighlighted);
        cell.backgroundColorDisabled    = (properties.isUserBackgroundColorDisabled ? properties.backgroundColorDisabled : self.buttonsBackgroundColorDisabled);

        UIImage *image = nil;

        if (properties.isUserIconImage) {
            image = properties.iconImage;
        }
        else if (self.buttonsIconImages.count > buttonIndex) {
            image = self.buttonsIconImages[buttonIndex];
        }

        cell.image = image;

        UIImage *imageHighlighted = nil;

        if (properties.isUserIconImageHighlighted) {
            imageHighlighted = properties.iconImageHighlighted;
        }
        else if (self.buttonsIconImagesHighlighted.count > buttonIndex) {
            imageHighlighted = self.buttonsIconImagesHighlighted[buttonIndex];
        }

        cell.imageHighlighted = imageHighlighted;

        UIImage *imageDisabled = nil;

        if (properties.isUserIconImageDisabled) {
            imageDisabled = properties.iconImageDisabled;
        }
        else if (self.buttonsIconImagesDisabled.count > buttonIndex) {
            imageDisabled = self.buttonsIconImagesDisabled[buttonIndex];
        }

        cell.imageDisabled = imageDisabled;
        cell.iconPosition  = (properties.isUserIconPosition ? properties.iconPosition : self.buttonsIconPosition);

        cell.separatorView.hidden                = (indexPath.row == self.buttonTitles.count - 1);
        cell.separatorView.backgroundColor       = self.separatorsColor;
        cell.textLabel.textAlignment             = (properties.isUserTextAlignment ? properties.textAlignment : self.buttonsTextAlignment);
        cell.textLabel.font                      = (properties.isUserFont ? properties.font : self.buttonsFont);
        cell.textLabel.numberOfLines             = (properties.isUserNumberOfLines ? properties.numberOfLines : self.buttonsNumberOfLines);
        cell.textLabel.lineBreakMode             = (properties.isUserLineBreakMode ? properties.lineBreakMode : self.buttonsLineBreakMode);
        cell.textLabel.adjustsFontSizeToFitWidth = (properties.isUserAdjustsFontSizeTofitWidth ? properties.adjustsFontSizeToFitWidth : self.buttonsAdjustsFontSizeToFitWidth);
        cell.textLabel.minimumScaleFactor        = (properties.isUserMinimimScaleFactor ? properties.minimumScaleFactor : self.buttonsMinimumScaleFactor);

        cell.enabled = [self.buttonsEnabledArray[buttonIndex] boolValue];
    }
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configCell:self.heightCell forRowAtIndexPath:indexPath];

    CGSize size = [self.heightCell sizeThatFits:CGSizeMake(CGRectGetWidth(tableView.bounds), CGFLOAT_MAX)];

    if (size.height < self.buttonsHeight) {
        size.height = self.buttonsHeight;
    }

    return size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.destructiveButtonTitle && indexPath.row == 0) {
        [self destructiveAction:nil];
    }
    else if (self.cancelButtonTitle && indexPath.row == self.buttonTitles.count - 1 && ![LGAlertViewHelper isCancelButtonSeparate:self]) {
        [self cancelAction:nil];
    }
    else {
        NSUInteger index = indexPath.row;

        if (self.destructiveButtonTitle) {
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
    if (!self.isValid || self.isShowing) return;

    self.window.windowLevel = UIWindowLevelStatusBar + (self.windowLevel == LGAlertViewWindowLevelAboveStatusBar ? 1 : -1);
    self.view.userInteractionEnabled = NO;

    [self subviewsValidateWithSize:CGSizeZero];
    [self layoutValidateWithSize:CGSizeZero];

    self.showing = YES;

    // -----

    UIWindow *keyWindow = LGAlertViewHelper.keyWindow;

    [keyWindow endEditing:YES];

    if (!hidden && keyWindow != LGAlertViewHelper.appWindow) {
        keyWindow.hidden = YES;
    }

    [self.window makeKeyAndVisible];

    // -----

    [self addObservers];

    // -----

    [self willShowCallback];

    // -----

    if (hidden) {
        self.scrollView.hidden = YES;
        self.backgroundView.hidden = YES;
        self.shadowView.hidden = YES;
        self.blurView.hidden = YES;

        if ([LGAlertViewHelper isCancelButtonSeparate:self]) {
            self.cancelButton.hidden = YES;
            self.shadowCancelView.hidden = YES;
            self.blurCancelView.hidden = YES;
        }
    }

    // -----

    if (animated) {
        [LGAlertViewHelper
         animateWithDuration:self.animationDuration
         animations:^(void) {
             [self showAnimations];

             // -----

             [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewShowAnimationsNotification
                                                                 object:self
                                                               userInfo:@{kLGAlertViewAnimationDuration: @(self.animationDuration)}];

             if (self.showAnimationsBlock) {
                 self.showAnimationsBlock(self, self.animationDuration);
             }

             if (self.delegate && [self.delegate respondsToSelector:@selector(showAnimationsForAlertView:duration:)]) {
                 [self.delegate showAnimationsForAlertView:self duration:self.animationDuration];
             }
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

    if (self.style == LGAlertViewStyleAlert || [LGAlertViewHelper isPadAndNotForce:self]) {
        self.scrollView.transform = CGAffineTransformIdentity;
        self.scrollView.alpha = 1.0;

        self.shadowView.transform = CGAffineTransformIdentity;
        self.shadowView.alpha = 1.0;

        self.blurView.transform = CGAffineTransformIdentity;
        self.blurView.alpha = 1.0;
    }
    else {
        self.scrollView.center = self.scrollViewCenterShowed;

        self.shadowView.center = self.scrollViewCenterShowed;

        self.blurView.center = self.scrollViewCenterShowed;
    }

    if ([LGAlertViewHelper isCancelButtonSeparate:self] && self.cancelButton) {
        self.cancelButton.center = self.cancelButtonCenterShowed;

        self.shadowCancelView.center = self.cancelButtonCenterShowed;

        self.blurCancelView.center = self.cancelButtonCenterShowed;
    }
}

- (void)showComplete {
    if (self.type == LGAlertViewTypeTextFields && self.textFieldsArray.count) {
        [self.textFieldsArray[0] becomeFirstResponder];
    }

    // -----

    [self didShowCallback];

    // -----

    self.view.userInteractionEnabled = YES;
}

#pragma mark - Dismiss

- (void)dismissAnimated:(BOOL)animated completionHandler:(LGAlertViewCompletionHandler)completionHandler {
    if (!self.isShowing) return;

    if (self.window.isHidden) {
        [self dismissComplete];
        return;
    }

    self.view.userInteractionEnabled = NO;

    self.showing = NO;

    [self.view endEditing:YES];

    // -----

    [self willDismissCallback];

    // -----

    if (animated) {
        [LGAlertViewHelper
         animateWithDuration:self.animationDuration
         animations:^(void) {
             [self dismissAnimations];

             // -----

             [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewDismissAnimationsNotification
                                                                 object:self
                                                               userInfo:@{kLGAlertViewAnimationDuration: @(self.animationDuration)}];

             if (self.dismissAnimationsBlock) {
                 self.dismissAnimationsBlock(self, self.animationDuration);
             }

             if (self.delegate && [self.delegate respondsToSelector:@selector(dismissAnimationsForAlertView:duration:)]) {
                 [self.delegate dismissAnimationsForAlertView:self duration:self.animationDuration];
             }
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

    if (self.style == LGAlertViewStyleAlert || [LGAlertViewHelper isPadAndNotForce:self]) {
        CGAffineTransform transform = CGAffineTransformMakeScale(self.finalScale, self.finalScale);
        CGFloat alpha = 0.0;

        self.scrollView.transform = transform;
        self.scrollView.alpha = alpha;

        self.shadowView.transform = transform;
        self.shadowView.alpha = alpha;

        self.blurView.transform = transform;
        self.blurView.alpha = alpha;
    }
    else {
        self.scrollView.center = self.scrollViewCenterHidden;

        self.shadowView.center = self.scrollViewCenterHidden;

        self.blurView.center = self.scrollViewCenterHidden;
    }

    if ([LGAlertViewHelper isCancelButtonSeparate:self] && self.cancelButton) {
        self.cancelButton.center = self.cancelButtonCenterHidden;

        self.shadowCancelView.center = self.cancelButtonCenterHidden;

        self.blurCancelView.center = self.cancelButtonCenterHidden;
    }
}

- (void)dismissComplete {
    [self removeObservers];

    self.window.hidden = YES;

    // -----

    [self didDismissCallback];

    // -----

    self.view = nil;
    self.viewController = nil;
    self.window = nil;
    self.delegate = nil;
}

#pragma mark - Transition

- (void)transitionToAlertView:(nonnull LGAlertView *)alertView completionHandler:(LGAlertViewCompletionHandler)completionHandler {
    if (![self isAlertViewValid:alertView] || !self.isShowing) return;

    self.view.userInteractionEnabled = NO;

    [alertView showAnimated:NO
                     hidden:YES
          completionHandler:^(void) {
              NSTimeInterval duration = 0.3;

              BOOL cancelButtonSelf = [LGAlertViewHelper isCancelButtonSeparate:self] && self.cancelButtonTitle;
              BOOL cancelButtonNext = [LGAlertViewHelper isCancelButtonSeparate:alertView] && alertView.cancelButtonTitle;

              // -----

              [UIView animateWithDuration:duration
                               animations:^(void) {
                                   self.scrollView.alpha = 0.0;

                                   if (cancelButtonSelf) {
                                       self.cancelButton.alpha = 0.0;

                                       if (!cancelButtonNext) {
                                           self.shadowCancelView.alpha = 0.0;
                                           self.blurCancelView.alpha = 0.0;
                                       }
                                   }
                               }
                               completion:^(BOOL finished) {
                                   alertView.backgroundView.alpha = 0.0;
                                   alertView.backgroundView.hidden = NO;

                                   [UIView animateWithDuration:duration * 2.0
                                                    animations:^(void) {
                                                        self.backgroundView.alpha = 0.0;
                                                        alertView.backgroundView.alpha = alertView.coverAlpha;
                                                    }];

                                   // -----

                                   CGRect shadowViewFrame = alertView.shadowView.frame;

                                   alertView.shadowView.frame = self.shadowView.frame;

                                   alertView.shadowView.hidden = NO;
                                   self.shadowView.hidden = YES;

                                   // -----

                                   CGRect blurViewFrame = alertView.blurView.frame;

                                   alertView.blurView.frame = self.blurView.frame;

                                   alertView.blurView.hidden = NO;
                                   self.blurView.hidden = YES;

                                   // -----

                                   if (cancelButtonNext) {
                                       alertView.shadowCancelView.hidden = NO;
                                       alertView.blurCancelView.hidden = NO;

                                       if (!cancelButtonSelf) {
                                           alertView.shadowCancelView.alpha = 0.0;
                                           alertView.blurCancelView.alpha = 0.0;
                                       }
                                   }

                                   // -----

                                   if (cancelButtonSelf && cancelButtonNext) {
                                       self.shadowCancelView.hidden = YES;
                                       self.blurCancelView.hidden = YES;
                                   }

                                   // -----

                                   [UIView animateWithDuration:duration
                                                    animations:^(void) {
                                                        alertView.shadowView.frame = shadowViewFrame;
                                                        alertView.blurView.frame = blurViewFrame;
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
                                                                                     alertView.shadowCancelView.alpha = 1.0;
                                                                                     alertView.blurCancelView.alpha = 1.0;
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

- (void)subviewsValidateWithSize:(CGSize)size {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = self.viewController.view.bounds.size;
    }

    // -----

    CGFloat width = self.width;

    // -----

    if (!self.isExists) {
        self.exists = YES;

        self.backgroundView.backgroundColor = self.coverColor;
        self.backgroundView.effect = self.coverBlurEffect;

        self.shadowView = [LGAlertViewShadowView new];
        self.shadowView.clipsToBounds = YES;
        self.shadowView.userInteractionEnabled = NO;
        self.shadowView.cornerRadius = self.layerCornerRadius;
        self.shadowView.strokeColor = self.layerBorderColor;
        self.shadowView.strokeWidth = self.layerBorderWidth;
        self.shadowView.shadowColor = self.layerShadowColor;
        self.shadowView.shadowBlur = self.layerShadowRadius;
        self.shadowView.shadowOffset = self.layerShadowOffset;
        [self.view addSubview:self.shadowView];

        self.blurView = [[UIVisualEffectView alloc] initWithEffect:self.backgroundBlurEffect];
        self.blurView.contentView.backgroundColor = self.backgroundColor;
        self.blurView.clipsToBounds = YES;
        self.blurView.layer.cornerRadius = self.layerCornerRadius;
        self.blurView.layer.borderWidth = self.layerBorderWidth;
        self.blurView.layer.borderColor = self.layerBorderColor.CGColor;
        self.blurView.userInteractionEnabled = NO;
        [self.view addSubview:self.blurView];

        self.scrollView = [UIScrollView new];
        self.scrollView.backgroundColor = UIColor.clearColor;
        self.scrollView.indicatorStyle = self.indicatorStyle;
        self.scrollView.showsVerticalScrollIndicator = self.showsVerticalScrollIndicator;
        self.scrollView.alwaysBounceVertical = NO;
        self.scrollView.clipsToBounds = YES;
        self.scrollView.layer.cornerRadius = self.layerCornerRadius - self.layerBorderWidth - (self.layerBorderWidth ? 1.0 : 0.0);
        [self.view addSubview:self.scrollView];

        CGFloat offsetY = 0.0;

        if (self.title) {
            self.titleLabel = [UILabel new];
            self.titleLabel.text = self.title;
            self.titleLabel.textColor = self.titleTextColor;
            self.titleLabel.textAlignment = self.titleTextAlignment;
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.titleLabel.backgroundColor = UIColor.clearColor;
            self.titleLabel.font = self.titleFont;

            CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(width - LGAlertViewPaddingWidth * 2.0, CGFLOAT_MAX)];
            CGRect titleLabelFrame = CGRectMake(LGAlertViewPaddingWidth, self.innerMarginHeight, width - LGAlertViewPaddingWidth * 2.0, titleLabelSize.height);

            if (LGAlertViewHelper.isNotRetina) {
                titleLabelFrame = CGRectIntegral(titleLabelFrame);
            }

            self.titleLabel.frame = titleLabelFrame;
            [self.scrollView addSubview:self.titleLabel];

            offsetY = CGRectGetMinY(self.titleLabel.frame) + CGRectGetHeight(self.titleLabel.frame);
        }

        if (self.message) {
            self.messageLabel = [UILabel new];
            self.messageLabel.text = self.message;
            self.messageLabel.textColor = self.messageTextColor;
            self.messageLabel.textAlignment = self.messageTextAlignment;
            self.messageLabel.numberOfLines = 0;
            self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.messageLabel.backgroundColor = UIColor.clearColor;
            self.messageLabel.font = self.messageFont;

            if (!offsetY) {
                offsetY = self.innerMarginHeight / 2.0;
            }
            else if (self.style == LGAlertViewStyleActionSheet) {
                offsetY -= self.innerMarginHeight / 3.0;
            }

            CGSize messageLabelSize = [self.messageLabel sizeThatFits:CGSizeMake(width - LGAlertViewPaddingWidth * 2.0, CGFLOAT_MAX)];
            CGRect messageLabelFrame = CGRectMake(LGAlertViewPaddingWidth, offsetY + self.innerMarginHeight / 2.0, width-LGAlertViewPaddingWidth * 2.0, messageLabelSize.height);

            if (LGAlertViewHelper.isNotRetina) {
                messageLabelFrame = CGRectIntegral(messageLabelFrame);
            }

            self.messageLabel.frame = messageLabelFrame;
            [self.scrollView addSubview:self.messageLabel];

            offsetY = CGRectGetMinY(self.messageLabel.frame) + CGRectGetHeight(self.messageLabel.frame);
        }

        if (self.innerView) {
            self.innerContainerView = [UIView new];
            self.innerContainerView.backgroundColor = UIColor.clearColor;

            CGRect innerContainerViewFrame = CGRectMake(0.0, offsetY + self.innerMarginHeight, width, CGRectGetHeight(self.innerView.bounds));

            if (LGAlertViewHelper.isNotRetina) {
                innerContainerViewFrame = CGRectIntegral(innerContainerViewFrame);
            }

            self.innerContainerView.frame = innerContainerViewFrame;
            [self.scrollView addSubview:self.innerContainerView];

            CGRect innerViewFrame = CGRectMake((width / 2.0) - (CGRectGetWidth(self.innerView.bounds) / 2.0),
                                               0.0,
                                               CGRectGetWidth(self.innerView.bounds),
                                               CGRectGetHeight(self.innerView.bounds));

            if (LGAlertViewHelper.isNotRetina) {
                innerViewFrame = CGRectIntegral(innerViewFrame);
            }

            self.innerView.frame = innerViewFrame;
            [self.innerContainerView addSubview:self.innerView];

            offsetY = CGRectGetMinY(self.innerContainerView.frame) + CGRectGetHeight(self.innerContainerView.frame);
        }
        else if (self.type == LGAlertViewTypeActivityIndicator || self.type == LGAlertViewTypeProgressView) {
            if (self.type == LGAlertViewTypeActivityIndicator) {
                self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
                self.activityIndicator.color = self.activityIndicatorViewColor;
                self.activityIndicator.backgroundColor = UIColor.clearColor;
                [self.activityIndicator startAnimating];

                CGRect activityIndicatorFrame = CGRectMake(width / 2.0 - CGRectGetWidth(self.activityIndicator.bounds) / 2.0,
                                                           offsetY + self.innerMarginHeight,
                                                           CGRectGetWidth(self.activityIndicator.bounds),
                                                           CGRectGetHeight(self.activityIndicator.bounds));

                if (LGAlertViewHelper.isNotRetina) {
                    activityIndicatorFrame = CGRectIntegral(activityIndicatorFrame);
                }

                self.activityIndicator.frame = activityIndicatorFrame;
                [self.scrollView addSubview:self.activityIndicator];

                offsetY = CGRectGetMinY(self.activityIndicator.frame) + CGRectGetHeight(self.activityIndicator.frame);
            }
            else if (self.type == LGAlertViewTypeProgressView) {
                self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
                self.progressView.progress = self.progress;
                self.progressView.backgroundColor = UIColor.clearColor;
                self.progressView.progressTintColor = self.progressViewProgressTintColor;
                self.progressView.trackTintColor = self.progressViewTrackTintColor;

                if (self.progressViewProgressImage) {
                    self.progressView.progressImage = self.progressViewProgressImage;
                }

                if (self.progressViewTrackImage) {
                    self.progressView.trackImage = self.progressViewTrackImage;
                }

                CGRect progressViewFrame = CGRectMake(LGAlertViewPaddingWidth,
                                                      offsetY + self.innerMarginHeight,
                                                      width - (LGAlertViewPaddingWidth * 2.0),
                                                      CGRectGetHeight(self.progressView.bounds));

                if (LGAlertViewHelper.isNotRetina) {
                    progressViewFrame = CGRectIntegral(progressViewFrame);
                }

                self.progressView.frame = progressViewFrame;
                [self.scrollView addSubview:self.progressView];

                offsetY = CGRectGetMinY(self.progressView.frame) + CGRectGetHeight(self.progressView.frame);
            }

            if (self.progressLabelText) {
                self.progressLabel = [UILabel new];
                self.progressLabel.text = self.progressLabelText;
                self.progressLabel.textColor = self.progressLabelTextColor;
                self.progressLabel.textAlignment = self.progressLabelTextAlignment;
                self.progressLabel.numberOfLines = self.progressLabelNumberOfLines;
                self.progressLabel.backgroundColor = UIColor.clearColor;
                self.progressLabel.font = self.progressLabelFont;
                self.progressLabel.lineBreakMode = self.progressLabelLineBreakMode;

                CGRect progressLabelFrame = CGRectMake(LGAlertViewPaddingWidth,
                                                       offsetY + (self.innerMarginHeight / 2.0),
                                                       width - (LGAlertViewPaddingWidth * 2.0),
                                                       self.progressLabelNumberOfLines * self.progressLabelFont.lineHeight);

                if (LGAlertViewHelper.isNotRetina) {
                    progressLabelFrame = CGRectIntegral(progressLabelFrame);
                }

                self.progressLabel.frame = progressLabelFrame;
                [self.scrollView addSubview:self.progressLabel];

                offsetY = CGRectGetMinY(self.progressLabel.frame) + CGRectGetHeight(self.progressLabel.frame);
            }
        }
        else if (self.type == LGAlertViewTypeTextFields) {
            NSMutableArray *textFieldsArray = [NSMutableArray new];

            for (NSUInteger i = 0; i < self.numberOfTextFields; i++) {
                UIView *separatorView = [UIView new];
                separatorView.backgroundColor = self.separatorsColor;

                CGRect separatorViewFrame = CGRectMake(0.0,
                                                       offsetY + (i == 0 ? self.innerMarginHeight : 0.0),
                                                       width,
                                                       LGAlertViewHelper.separatorHeight);

                if (LGAlertViewHelper.isNotRetina) {
                    separatorViewFrame = CGRectIntegral(separatorViewFrame);
                }

                separatorView.frame = separatorViewFrame;
                [self.scrollView addSubview:separatorView];

                offsetY = CGRectGetMinY(separatorView.frame) + CGRectGetHeight(separatorView.frame);

                // -----

                LGAlertViewTextField *textField = [LGAlertViewTextField new];
                textField.delegate = self;
                textField.tag = i;
                textField.backgroundColor = self.textFieldsBackgroundColor;
                textField.textColor = self.textFieldsTextColor;
                textField.font = self.textFieldsFont;
                textField.textAlignment = self.textFieldsTextAlignment;
                textField.clearsOnBeginEditing = self.textFieldsClearsOnBeginEditing;
                textField.adjustsFontSizeToFitWidth = self.textFieldsAdjustsFontSizeToFitWidth;
                textField.minimumFontSize = self.textFieldsMinimumFontSize;
                textField.clearButtonMode = self.textFieldsClearButtonMode;

                if (i == self.numberOfTextFields - 1) {
                    textField.returnKeyType = UIReturnKeyDone;
                }
                else {
                    textField.returnKeyType = UIReturnKeyNext;
                }

                if (self.textFieldsSetupHandler) {
                    self.textFieldsSetupHandler(textField, i);
                }

                CGRect textFieldFrame = CGRectMake(0.0, offsetY, width, self.textFieldsHeight);

                if (LGAlertViewHelper.isNotRetina) {
                    textFieldFrame = CGRectIntegral(textFieldFrame);
                }

                textField.frame = textFieldFrame;
                [self.scrollView addSubview:textField];
                [textFieldsArray addObject:textField];

                offsetY = CGRectGetMinY(textField.frame) + CGRectGetHeight(textField.frame);
            }

            self.textFieldsArray = textFieldsArray;

            offsetY -= self.innerMarginHeight;
        }

        // -----

        if ([LGAlertViewHelper isCancelButtonSeparate:self] && self.cancelButtonTitle) {
            self.shadowCancelView = [LGAlertViewShadowView new];
            self.shadowCancelView.clipsToBounds = YES;
            self.shadowCancelView.userInteractionEnabled = NO;
            self.shadowCancelView.cornerRadius = self.layerCornerRadius;
            self.shadowCancelView.strokeColor = self.layerBorderColor;
            self.shadowCancelView.strokeWidth = self.layerBorderWidth;
            self.shadowCancelView.shadowColor = self.layerShadowColor;
            self.shadowCancelView.shadowBlur = self.layerShadowRadius;
            self.shadowCancelView.shadowOffset = self.layerShadowOffset;
            [self.view insertSubview:self.shadowCancelView belowSubview:self.scrollView];

            self.blurCancelView = [[UIVisualEffectView alloc] initWithEffect:self.backgroundBlurEffect];
            self.blurCancelView.contentView.backgroundColor = self.backgroundColor;
            self.blurCancelView.clipsToBounds = YES;
            self.blurCancelView.layer.cornerRadius = self.layerCornerRadius;
            self.blurCancelView.layer.borderWidth = self.layerBorderWidth;
            self.blurCancelView.layer.borderColor = self.layerBorderColor.CGColor;
            self.blurCancelView.userInteractionEnabled = NO;
            [self.view insertSubview:self.blurCancelView aboveSubview:self.shadowCancelView];

            [self cancelButtonInit];
            self.cancelButton.layer.masksToBounds = YES;
            self.cancelButton.layer.cornerRadius = self.layerCornerRadius - self.layerBorderWidth - (self.layerBorderWidth ? 1.0 : 0.0);
            [self.view insertSubview:self.cancelButton aboveSubview:self.blurCancelView];
        }

        // -----

        NSUInteger numberOfButtons = self.buttonTitles.count;

        if (self.destructiveButtonTitle) {
            numberOfButtons++;
        }

        if (self.cancelButtonTitle && ![LGAlertViewHelper isCancelButtonSeparate:self]) {
            numberOfButtons++;
        }

        BOOL showTable = NO;

        if (numberOfButtons) {
            if (!self.isOneRowOneButton &&
                ((self.style == LGAlertViewStyleAlert && numberOfButtons < 4) ||
                 (self.style == LGAlertViewStyleActionSheet && numberOfButtons == 1))) {
                    CGFloat buttonWidth = width/numberOfButtons;

                    if (buttonWidth < 64.0) {
                        showTable = YES;
                    }

                    if (self.destructiveButtonTitle && !showTable) {
                        self.destructiveButton = [LGAlertViewButton new];
                        self.destructiveButton.titleLabel.numberOfLines = self.destructiveButtonNumberOfLines;
                        self.destructiveButton.titleLabel.lineBreakMode = self.destructiveButtonLineBreakMode;
                        self.destructiveButton.titleLabel.adjustsFontSizeToFitWidth = self.destructiveButtonAdjustsFontSizeToFitWidth;
                        self.destructiveButton.titleLabel.minimumScaleFactor = self.destructiveButtonMinimumScaleFactor;
                        self.destructiveButton.titleLabel.font = self.destructiveButtonFont;
                        self.destructiveButton.titleLabel.textAlignment = self.destructiveButtonTextAlignment;
                        self.destructiveButton.iconPosition = self.destructiveButtonIconPosition;
                        [self.destructiveButton setTitle:self.destructiveButtonTitle forState:UIControlStateNormal];

                        [self.destructiveButton setTitleColor:self.destructiveButtonTitleColor forState:UIControlStateNormal];
                        [self.destructiveButton setTitleColor:self.destructiveButtonTitleColorHighlighted forState:UIControlStateHighlighted];
                        [self.destructiveButton setTitleColor:self.destructiveButtonTitleColorHighlighted forState:UIControlStateSelected];
                        [self.destructiveButton setTitleColor:self.destructiveButtonTitleColorDisabled forState:UIControlStateDisabled];

                        [self.destructiveButton setBackgroundColor:self.destructiveButtonBackgroundColor forState:UIControlStateNormal];
                        [self.destructiveButton setBackgroundColor:self.destructiveButtonBackgroundColorHighlighted forState:UIControlStateHighlighted];
                        [self.destructiveButton setBackgroundColor:self.destructiveButtonBackgroundColorHighlighted forState:UIControlStateSelected];
                        [self.destructiveButton setBackgroundColor:self.destructiveButtonBackgroundColorDisabled forState:UIControlStateDisabled];

                        [self.destructiveButton setImage:self.destructiveButtonIconImage forState:UIControlStateNormal];
                        [self.destructiveButton setImage:self.destructiveButtonIconImageHighlighted forState:UIControlStateHighlighted];
                        [self.destructiveButton setImage:self.destructiveButtonIconImageHighlighted forState:UIControlStateSelected];
                        [self.destructiveButton setImage:self.destructiveButtonIconImageDisabled forState:UIControlStateDisabled];

                        if (self.destructiveButtonTextAlignment == NSTextAlignmentLeft) {
                            self.destructiveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        }
                        else if (self.destructiveButtonTextAlignment == NSTextAlignmentRight) {
                            self.destructiveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                        }

                        if (self.destructiveButton.imageView.image && self.destructiveButton.titleLabel.text.length) {
                            self.destructiveButton.titleEdgeInsets = UIEdgeInsetsMake(0.0,
                                                                                      LGAlertViewButtonImageOffsetFromTitle / 2.0,
                                                                                      0.0,
                                                                                      LGAlertViewButtonImageOffsetFromTitle / 2.0);
                        }

                        self.destructiveButton.enabled = self.destructiveButtonEnabled;
                        [self.destructiveButton addTarget:self action:@selector(destructiveAction:) forControlEvents:UIControlEventTouchUpInside];

                        CGSize size = [self.destructiveButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];

                        if (size.width > buttonWidth) {
                            showTable = YES;
                        }
                    }

                    if (self.cancelButtonTitle && ![LGAlertViewHelper isCancelButtonSeparate:self] && !showTable) {
                        [self cancelButtonInit];

                        CGSize size = [self.cancelButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];

                        if (size.width > buttonWidth) {
                            showTable = YES;
                        }
                    }

                    if (self.buttonTitles.count > 0 && !showTable) {
                        LGAlertViewButtonProperties *properties = nil;

                        if (self.buttonsPropertiesDictionary) {
                            properties = self.buttonsPropertiesDictionary[@0];
                        }

                        self.firstButton = [LGAlertViewButton new];
                        self.firstButton.titleLabel.numberOfLines = (properties.isUserNumberOfLines ? properties.numberOfLines : self.buttonsNumberOfLines);
                        self.firstButton.titleLabel.lineBreakMode = (properties.isUserLineBreakMode ? properties.lineBreakMode : self.buttonsLineBreakMode);
                        self.firstButton.titleLabel.adjustsFontSizeToFitWidth = (properties.isAdjustsFontSizeToFitWidth ? properties.adjustsFontSizeToFitWidth : self.buttonsAdjustsFontSizeToFitWidth);
                        self.firstButton.titleLabel.minimumScaleFactor = (properties.isUserMinimimScaleFactor ? properties.minimumScaleFactor : self.buttonsMinimumScaleFactor);
                        self.firstButton.titleLabel.font = (properties.isUserFont ? properties.font : self.buttonsFont);
                        self.firstButton.titleLabel.textAlignment = (properties.isUserTextAlignment ? properties.textAlignment : self.buttonsTextAlignment);
                        self.firstButton.iconPosition = (properties.isUserIconPosition ? properties.iconPosition : self.buttonsIconPosition);
                        [self.firstButton setTitle:self.buttonTitles[0] forState:UIControlStateNormal];

                        [self.firstButton setTitleColor:(properties.isUserTitleColor ? properties.titleColor : self.buttonsTitleColor)
                                               forState:UIControlStateNormal];
                        [self.firstButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : self.buttonsTitleColorHighlighted)
                                               forState:UIControlStateHighlighted];
                        [self.firstButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : self.buttonsTitleColorHighlighted)
                                               forState:UIControlStateSelected];
                        [self.firstButton setTitleColor:(properties.isUserTitleColorDisabled ? properties.titleColorDisabled : self.buttonsTitleColorDisabled)
                                               forState:UIControlStateDisabled];

                        [self.firstButton setBackgroundColor:(properties.isUserBackgroundColor ? properties.backgroundColor : self.buttonsBackgroundColor)
                                                    forState:UIControlStateNormal];
                        [self.firstButton setBackgroundColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : self.buttonsBackgroundColorHighlighted)
                                                    forState:UIControlStateHighlighted];
                        [self.firstButton setBackgroundColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : self.buttonsBackgroundColorHighlighted)
                                                    forState:UIControlStateSelected];
                        [self.firstButton setBackgroundColor:(properties.isUserBackgroundColorDisabled ? properties.backgroundColorDisabled : self.buttonsBackgroundColorDisabled)
                                                    forState:UIControlStateDisabled];

                        UIImage *image = nil;
                        if (properties.isUserIconImage) {
                            image = properties.iconImage;
                        }
                        else if (self.buttonsIconImages.count > 0) {
                            image = self.buttonsIconImages[0];
                        }

                        [self.firstButton setImage:image forState:UIControlStateNormal];

                        UIImage *imageHighlighted = nil;
                        if (properties.isUserIconImageHighlighted) {
                            imageHighlighted = properties.iconImageHighlighted;
                        }
                        else if (self.buttonsIconImagesHighlighted.count > 0) {
                            imageHighlighted = self.buttonsIconImagesHighlighted[0];
                        }

                        [self.firstButton setImage:imageHighlighted forState:UIControlStateHighlighted];
                        [self.firstButton setImage:imageHighlighted forState:UIControlStateSelected];

                        UIImage *imageDisabled = nil;
                        if (properties.isUserIconImageDisabled) {
                            imageDisabled = properties.iconImageDisabled;
                        }
                        else if (self.buttonsIconImagesDisabled.count > 0) {
                            imageDisabled = self.buttonsIconImagesDisabled[0];
                        }

                        [self.firstButton setImage:imageDisabled forState:UIControlStateDisabled];

                        if (self.firstButton.titleLabel.textAlignment == NSTextAlignmentLeft) {
                            self.firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        }
                        else if (self.firstButton.titleLabel.textAlignment == NSTextAlignmentRight) {
                            self.firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                        }

                        if (self.firstButton.imageView.image && self.firstButton.titleLabel.text.length) {
                            self.firstButton.titleEdgeInsets = UIEdgeInsetsMake(0.0,
                                                                                LGAlertViewButtonImageOffsetFromTitle / 2.0,
                                                                                0.0,
                                                                                LGAlertViewButtonImageOffsetFromTitle / 2.0);
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
                                properties = self.buttonsPropertiesDictionary[@1];
                            }

                            self.secondButton = [LGAlertViewButton new];
                            self.secondButton.titleLabel.numberOfLines = (properties.isUserNumberOfLines ? properties.numberOfLines : self.buttonsNumberOfLines);
                            self.secondButton.titleLabel.lineBreakMode = (properties.isUserLineBreakMode ? properties.lineBreakMode : self.buttonsLineBreakMode);
                            self.secondButton.titleLabel.adjustsFontSizeToFitWidth = (properties.isAdjustsFontSizeToFitWidth ? properties.adjustsFontSizeToFitWidth : self.buttonsAdjustsFontSizeToFitWidth);
                            self.secondButton.titleLabel.minimumScaleFactor = (properties.isUserMinimimScaleFactor ? properties.minimumScaleFactor : self.buttonsMinimumScaleFactor);
                            self.secondButton.titleLabel.font = (properties.isUserFont ? properties.font : self.buttonsFont);
                            self.secondButton.titleLabel.textAlignment = (properties.isUserTextAlignment ? properties.textAlignment : self.buttonsTextAlignment);
                            self.secondButton.iconPosition = (properties.isUserIconPosition ? properties.iconPosition : self.buttonsIconPosition);
                            [self.secondButton setTitle:self.buttonTitles[1] forState:UIControlStateNormal];

                            [self.secondButton setTitleColor:(properties.isUserTitleColor ? properties.titleColor : self.buttonsTitleColor)
                                                    forState:UIControlStateNormal];
                            [self.secondButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : self.buttonsTitleColorHighlighted)
                                                    forState:UIControlStateHighlighted];
                            [self.secondButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : self.buttonsTitleColorHighlighted)
                                                    forState:UIControlStateSelected];
                            [self.secondButton setTitleColor:(properties.isUserTitleColorDisabled ? properties.titleColorDisabled : self.buttonsTitleColorDisabled)
                                                    forState:UIControlStateDisabled];

                            [self.secondButton setBackgroundColor:(properties.isUserBackgroundColor ? properties.backgroundColor : self.buttonsBackgroundColor)
                                                         forState:UIControlStateNormal];
                            [self.secondButton setBackgroundColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : self.buttonsBackgroundColorHighlighted)
                                                         forState:UIControlStateHighlighted];
                            [self.secondButton setBackgroundColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : self.buttonsBackgroundColorHighlighted)
                                                         forState:UIControlStateSelected];
                            [self.secondButton setBackgroundColor:(properties.isUserBackgroundColorDisabled ? properties.backgroundColorDisabled : self.buttonsBackgroundColorDisabled)
                                                         forState:UIControlStateDisabled];

                            UIImage *image = nil;
                            if (properties.isUserIconImage) {
                                image = properties.iconImage;
                            }
                            else if (self.buttonsIconImages.count > 1) {
                                image = self.buttonsIconImages[1];
                            }

                            [self.secondButton setImage:image forState:UIControlStateNormal];

                            UIImage *imageHighlighted = nil;
                            if (properties.isUserIconImageHighlighted) {
                                imageHighlighted = properties.iconImageHighlighted;
                            }
                            else if (self.buttonsIconImagesHighlighted.count > 1) {
                                imageHighlighted = self.buttonsIconImagesHighlighted[1];
                            }

                            [self.secondButton setImage:imageHighlighted forState:UIControlStateHighlighted];
                            [self.secondButton setImage:imageHighlighted forState:UIControlStateSelected];

                            UIImage *imageDisabled = nil;
                            if (properties.isUserIconImageDisabled) {
                                imageDisabled = properties.iconImageDisabled;
                            }
                            else if (self.buttonsIconImagesDisabled.count > 1) {
                                imageDisabled = self.buttonsIconImagesDisabled[1];
                            }

                            [self.secondButton setImage:imageDisabled forState:UIControlStateDisabled];

                            if (self.secondButton.titleLabel.textAlignment == NSTextAlignmentLeft) {
                                self.secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                            }
                            else if (self.secondButton.titleLabel.textAlignment == NSTextAlignmentRight) {
                                self.secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                            }

                            if (self.secondButton.imageView.image && self.secondButton.titleLabel.text.length) {
                                self.secondButton.titleEdgeInsets = UIEdgeInsetsMake(0.0,
                                                                                     LGAlertViewButtonImageOffsetFromTitle / 2.0,
                                                                                     0.0,
                                                                                     LGAlertViewButtonImageOffsetFromTitle / 2.0);
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
                                    properties = self.buttonsPropertiesDictionary[@2];
                                }

                                self.thirdButton = [LGAlertViewButton new];
                                self.thirdButton.titleLabel.numberOfLines = (properties.isUserNumberOfLines ? properties.numberOfLines : self.buttonsNumberOfLines);
                                self.thirdButton.titleLabel.lineBreakMode = (properties.isUserLineBreakMode ? properties.lineBreakMode : self.buttonsLineBreakMode);
                                self.thirdButton.titleLabel.adjustsFontSizeToFitWidth = (properties.isAdjustsFontSizeToFitWidth ? properties.adjustsFontSizeToFitWidth : self.buttonsAdjustsFontSizeToFitWidth);
                                self.thirdButton.titleLabel.minimumScaleFactor = (properties.isUserMinimimScaleFactor ? properties.minimumScaleFactor : self.buttonsMinimumScaleFactor);
                                self.thirdButton.titleLabel.font = (properties.isUserFont ? properties.font : self.buttonsFont);
                                self.thirdButton.titleLabel.textAlignment = (properties.isUserTextAlignment ? properties.textAlignment : self.buttonsTextAlignment);
                                self.thirdButton.iconPosition = (properties.isUserIconPosition ? properties.iconPosition : self.buttonsIconPosition);
                                [self.thirdButton setTitle:self.buttonTitles[2] forState:UIControlStateNormal];

                                [self.thirdButton setTitleColor:(properties.isUserTitleColor ? properties.titleColor : self.buttonsTitleColor)
                                                       forState:UIControlStateNormal];
                                [self.thirdButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : self.buttonsTitleColorHighlighted)
                                                       forState:UIControlStateHighlighted];
                                [self.thirdButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : self.buttonsTitleColorHighlighted)
                                                       forState:UIControlStateSelected];
                                [self.thirdButton setTitleColor:(properties.isUserTitleColorDisabled ? properties.titleColorDisabled : self.buttonsTitleColorDisabled)
                                                       forState:UIControlStateDisabled];

                                [self.thirdButton setBackgroundColor:(properties.isUserBackgroundColor ? properties.backgroundColor : self.buttonsBackgroundColor)
                                                            forState:UIControlStateNormal];
                                [self.thirdButton setBackgroundColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : self.buttonsBackgroundColorHighlighted)
                                                            forState:UIControlStateHighlighted];
                                [self.thirdButton setBackgroundColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : self.buttonsBackgroundColorHighlighted)
                                                            forState:UIControlStateSelected];
                                [self.thirdButton setBackgroundColor:(properties.isUserBackgroundColorDisabled ? properties.backgroundColorDisabled : self.buttonsBackgroundColorDisabled)
                                                            forState:UIControlStateDisabled];

                                UIImage *image = nil;
                                if (properties.isUserIconImage) {
                                    image = properties.iconImage;
                                }
                                else if (self.buttonsIconImages.count > 2) {
                                    image = self.buttonsIconImages[2];
                                }

                                [self.thirdButton setImage:image forState:UIControlStateNormal];

                                UIImage *imageHighlighted = nil;
                                if (properties.isUserIconImageHighlighted) {
                                    imageHighlighted = properties.iconImageHighlighted;
                                }
                                else if (self.buttonsIconImagesHighlighted.count > 2) {
                                    imageHighlighted = self.buttonsIconImagesHighlighted[2];
                                }

                                [self.thirdButton setImage:imageHighlighted forState:UIControlStateHighlighted];
                                [self.thirdButton setImage:imageHighlighted forState:UIControlStateSelected];

                                UIImage *imageDisabled = nil;
                                if (properties.isUserIconImageDisabled) {
                                    imageDisabled = properties.iconImageDisabled;
                                }
                                else if (self.buttonsIconImagesDisabled.count > 2) {
                                    imageDisabled = self.buttonsIconImagesDisabled[2];
                                }

                                [self.thirdButton setImage:imageDisabled forState:UIControlStateDisabled];

                                if (self.thirdButton.titleLabel.textAlignment == NSTextAlignmentLeft) {
                                    self.thirdButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                                }
                                else if (self.thirdButton.titleLabel.textAlignment == NSTextAlignmentRight) {
                                    self.thirdButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                                }

                                if (self.thirdButton.imageView.image && self.thirdButton.titleLabel.text.length) {
                                    self.thirdButton.titleEdgeInsets = UIEdgeInsetsMake(0.0,
                                                                                        LGAlertViewButtonImageOffsetFromTitle / 2.0,
                                                                                        0.0,
                                                                                        LGAlertViewButtonImageOffsetFromTitle / 2.0);
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

                        if (self.cancelButton && ![LGAlertViewHelper isCancelButtonSeparate:self]) {
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

                            CGRect separatorHorizontalViewFrame = CGRectMake(0.0, offsetY + self.innerMarginHeight, width, LGAlertViewHelper.separatorHeight);

                            if (LGAlertViewHelper.isNotRetina) {
                                separatorHorizontalViewFrame = CGRectIntegral(separatorHorizontalViewFrame);
                            }

                            self.separatorHorizontalView.frame = separatorHorizontalViewFrame;
                            [self.scrollView addSubview:self.separatorHorizontalView];

                            offsetY = CGRectGetMinY(self.separatorHorizontalView.frame) + CGRectGetHeight(self.separatorHorizontalView.frame);
                        }

                        // -----

                        CGRect firstButtonFrame = CGRectMake(0.0, offsetY, width / numberOfButtons, self.buttonsHeight);

                        if (LGAlertViewHelper.isNotRetina) {
                            firstButtonFrame = CGRectIntegral(firstButtonFrame);
                        }

                        firstButton.frame = firstButtonFrame;

                        CGRect secondButtonFrame = CGRectZero;
                        CGRect thirdButtonFrame = CGRectZero;

                        if (secondButton) {
                            secondButtonFrame = CGRectMake(CGRectGetMinX(firstButtonFrame) + CGRectGetWidth(firstButtonFrame) + LGAlertViewHelper.separatorHeight,
                                                           offsetY,
                                                           (width / numberOfButtons) - LGAlertViewHelper.separatorHeight,
                                                           self.buttonsHeight);

                            if (LGAlertViewHelper.isNotRetina) {
                                secondButtonFrame = CGRectIntegral(secondButtonFrame);
                            }

                            secondButton.frame = secondButtonFrame;

                            if (thirdButton) {
                                thirdButtonFrame = CGRectMake(CGRectGetMinX(secondButtonFrame) + CGRectGetWidth(secondButtonFrame) + LGAlertViewHelper.separatorHeight,
                                                              offsetY,
                                                              (width / numberOfButtons) - LGAlertViewHelper.separatorHeight,
                                                              self.buttonsHeight);

                                if (LGAlertViewHelper.isNotRetina) {
                                    thirdButtonFrame = CGRectIntegral(thirdButtonFrame);
                                }

                                thirdButton.frame = thirdButtonFrame;
                            }
                        }

                        // -----

                        if (secondButton) {
                            self.separatorVerticalView1 = [UIView new];
                            self.separatorVerticalView1.backgroundColor = self.separatorsColor;

                            CGRect separatorVerticalView1Frame = CGRectMake(CGRectGetMinX(firstButtonFrame) + CGRectGetWidth(firstButtonFrame),
                                                                            offsetY,
                                                                            LGAlertViewHelper.separatorHeight,
                                                                            MAX(CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds)));

                            if (LGAlertViewHelper.isNotRetina) {
                                separatorVerticalView1Frame = CGRectIntegral(separatorVerticalView1Frame);
                            }

                            self.separatorVerticalView1.frame = separatorVerticalView1Frame;
                            [self.scrollView addSubview:self.separatorVerticalView1];

                            if (thirdButton) {
                                self.separatorVerticalView2 = [UIView new];
                                self.separatorVerticalView2.backgroundColor = self.separatorsColor;

                                CGRect separatorVerticalView2Frame = CGRectMake(CGRectGetMinX(secondButtonFrame) + CGRectGetWidth(secondButtonFrame),
                                                                                offsetY,
                                                                                LGAlertViewHelper.separatorHeight,
                                                                                MAX(CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds)));

                                if (LGAlertViewHelper.isNotRetina) {
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
                if (![LGAlertViewHelper isCancelButtonSeparate:self]) {
                    self.cancelButton = nil;
                }

                self.destructiveButton = nil;
                self.firstButton = nil;
                self.secondButton = nil;
                self.thirdButton = nil;

                NSMutableArray *buttonTitles = nil;

                if (self.buttonTitles) {
                    buttonTitles = self.buttonTitles.mutableCopy;
                }
                else {
                    buttonTitles = [NSMutableArray new];
                }

                if (self.destructiveButtonTitle) {
                    [buttonTitles insertObject:self.destructiveButtonTitle atIndex:0];
                }

                if (self.cancelButtonTitle && ![LGAlertViewHelper isCancelButtonSeparate:self]) {
                    [buttonTitles addObject:self.cancelButtonTitle];
                }

                self.buttonTitles = buttonTitles;

                self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
                self.tableView.clipsToBounds = NO;
                self.tableView.backgroundColor = UIColor.clearColor;
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                self.tableView.dataSource = self;
                self.tableView.delegate = self;
                self.tableView.scrollEnabled = NO;
                [self.tableView registerClass:[LGAlertViewCell class] forCellReuseIdentifier:@"cell"];
                self.tableView.frame = CGRectMake(0.0, 0.0, width, CGFLOAT_MAX);
                [self.tableView reloadData];
                [self.tableView layoutIfNeeded];

                if (!offsetY) {
                    offsetY = -self.innerMarginHeight;
                }
                else {
                    self.separatorHorizontalView = [UIView new];
                    self.separatorHorizontalView.backgroundColor = self.separatorsColor;

                    CGRect separatorTitleViewFrame = CGRectMake(0.0, 0.0, width, LGAlertViewHelper.separatorHeight);

                    if (LGAlertViewHelper.isNotRetina) {
                        separatorTitleViewFrame = CGRectIntegral(separatorTitleViewFrame);
                    }

                    self.separatorHorizontalView.frame = separatorTitleViewFrame;
                    self.tableView.tableHeaderView = self.separatorHorizontalView;
                }

                CGRect tableViewFrame = CGRectMake(0.0, offsetY + self.innerMarginHeight, width, self.tableView.contentSize.height);

                if (LGAlertViewHelper.isNotRetina) {
                    tableViewFrame = CGRectIntegral(tableViewFrame);
                }

                self.tableView.frame = tableViewFrame;

                [self.scrollView addSubview:self.tableView];

                offsetY = CGRectGetMinY(self.tableView.frame) + CGRectGetHeight(self.tableView.frame);
            }
        }
        else {
            offsetY += self.innerMarginHeight;
        }

        // -----

        self.scrollView.contentSize = CGSizeMake(width, offsetY);
    }
}

- (void)layoutValidateWithSize:(CGSize)size {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = self.viewController.view.bounds.size;
    }

    // -----

    CGFloat width = self.width;

    // -----

    self.view.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    self.backgroundView.frame = CGRectMake(0.0, 0.0, size.width, size.height);

    // -----

    CGFloat heightMax = size.height - self.keyboardHeight - (self.offsetVertical * 2.0);

    if (self.windowLevel == LGAlertViewWindowLevelBelowStatusBar) {
        heightMax -= LGAlertViewHelper.statusBarHeight;
    }

    if (self.heightMax != NSNotFound && self.heightMax < heightMax) {
        heightMax = self.heightMax;
    }

    if ([LGAlertViewHelper isCancelButtonSeparate:self] && self.cancelButton) {
        heightMax -= self.buttonsHeight + self.cancelButtonOffsetY;
    }
    else if (self.cancelOnTouch && !self.cancelButtonTitle && size.width < width + (self.buttonsHeight * 2.0)) {
        heightMax -= self.buttonsHeight * 2.0;
    }

    if (self.scrollView.contentSize.height < heightMax) {
        heightMax = self.scrollView.contentSize.height;
    }

    // -----

    CGRect scrollViewFrame = CGRectZero;
    CGAffineTransform scrollViewTransform = CGAffineTransformIdentity;
    CGFloat scrollViewAlpha = 1.0;

    if (self.style == LGAlertViewStyleAlert || [LGAlertViewHelper isPadAndNotForce:self]) {
        scrollViewFrame = CGRectMake((size.width - width) / 2.0, (size.height - self.keyboardHeight - heightMax) / 2.0, width, heightMax);

        if (self.windowLevel == LGAlertViewWindowLevelBelowStatusBar) {
            scrollViewFrame.origin.y += LGAlertViewHelper.statusBarHeight / 2.0;
        }

        if (!self.isShowing) {
            scrollViewTransform = CGAffineTransformMakeScale(self.initialScale, self.initialScale);

            scrollViewAlpha = 0.0;
        }
    }
    else
    {
        CGFloat bottomShift = self.offsetVertical;

        if ([LGAlertViewHelper isCancelButtonSeparate:self] && self.cancelButton) {
            bottomShift += self.buttonsHeight+self.cancelButtonOffsetY;
        }

        scrollViewFrame = CGRectMake((size.width - width) / 2.0, size.height - bottomShift - heightMax, width, heightMax);
    }

    // -----

    if (self.style == LGAlertViewStyleActionSheet && ![LGAlertViewHelper isPadAndNotForce:self]) {
        CGRect cancelButtonFrame = CGRectZero;

        if ([LGAlertViewHelper isCancelButtonSeparate:self] && self.cancelButton) {
            cancelButtonFrame = CGRectMake((size.width - width) / 2.0, size.height - self.cancelButtonOffsetY - self.buttonsHeight, width, self.buttonsHeight);
        }

        self.scrollViewCenterShowed = CGPointMake(CGRectGetMinX(scrollViewFrame) + (CGRectGetWidth(scrollViewFrame) / 2.0),
                                                  CGRectGetMinY(scrollViewFrame) + (CGRectGetHeight(scrollViewFrame) / 2.0));

        self.cancelButtonCenterShowed = CGPointMake(CGRectGetMinX(cancelButtonFrame) + (CGRectGetWidth(cancelButtonFrame) / 2.0),
                                                    CGRectGetMinY(cancelButtonFrame) + (CGRectGetHeight(cancelButtonFrame) / 2.0));

        // -----

        CGFloat commonHeight = CGRectGetHeight(scrollViewFrame) + self.offsetVertical;

        if ([LGAlertViewHelper isCancelButtonSeparate:self] && self.cancelButton) {
            commonHeight += self.buttonsHeight + self.cancelButtonOffsetY;
        }

        self.scrollViewCenterHidden = CGPointMake(CGRectGetMinX(scrollViewFrame) + (CGRectGetWidth(scrollViewFrame) / 2.0),
                                                  CGRectGetMinY(scrollViewFrame) + (CGRectGetHeight(scrollViewFrame) / 2.0) + commonHeight + self.layerBorderWidth + self.layerShadowRadius);

        self.cancelButtonCenterHidden = CGPointMake(CGRectGetMinX(cancelButtonFrame) + (CGRectGetWidth(cancelButtonFrame) / 2.0),
                                                    CGRectGetMinY(cancelButtonFrame) + (CGRectGetHeight(cancelButtonFrame) / 2.0) + commonHeight);

        if (!self.isShowing) {
            scrollViewFrame.origin.y += commonHeight;

            if ([LGAlertViewHelper isCancelButtonSeparate:self] && self.cancelButton) {
                cancelButtonFrame.origin.y += commonHeight;
            }
        }

        // -----

        if ([LGAlertViewHelper isCancelButtonSeparate:self] && self.cancelButton) {
            if (LGAlertViewHelper.isNotRetina) {
                cancelButtonFrame = CGRectIntegral(cancelButtonFrame);
            }

            self.cancelButton.frame = cancelButtonFrame;

            CGFloat offset = self.layerBorderWidth + self.layerShadowRadius;
            self.shadowCancelView.frame = CGRectInset(cancelButtonFrame, -offset, -offset);
            [self.shadowCancelView setNeedsDisplay];

            self.blurCancelView.frame = CGRectInset(cancelButtonFrame, -self.layerBorderWidth, -self.layerBorderWidth);
        }
    }

    // -----

    if (LGAlertViewHelper.isNotRetina) {
        scrollViewFrame = CGRectIntegral(scrollViewFrame);

        if (CGRectGetHeight(scrollViewFrame) - self.scrollView.contentSize.height == 1.0) {
            scrollViewFrame.size.height -= 2.0;
        }
    }

    // -----

    self.scrollView.frame = scrollViewFrame;
    self.scrollView.transform = scrollViewTransform;
    self.scrollView.alpha = scrollViewAlpha;

    // -----

    CGFloat offset = self.layerBorderWidth + self.layerShadowRadius;
    self.shadowView.frame = CGRectInset(scrollViewFrame, -offset, -offset);
    self.shadowView.transform = scrollViewTransform;
    self.shadowView.alpha = scrollViewAlpha;
    [self.shadowView setNeedsDisplay];

    // -----

    self.blurView.frame = CGRectInset(scrollViewFrame, -self.layerBorderWidth, -self.layerBorderWidth);
    self.blurView.transform = scrollViewTransform;
    self.blurView.alpha = scrollViewAlpha;
}

- (void)cancelButtonInit {
    self.cancelButton = [LGAlertViewButton new];
    self.cancelButton.titleLabel.numberOfLines = self.cancelButtonNumberOfLines;
    self.cancelButton.titleLabel.lineBreakMode = self.cancelButtonLineBreakMode;
    self.cancelButton.titleLabel.adjustsFontSizeToFitWidth = self.cancelButtonAdjustsFontSizeToFitWidth;
    self.cancelButton.titleLabel.minimumScaleFactor = self.cancelButtonMinimumScaleFactor;
    self.cancelButton.titleLabel.font = self.cancelButtonFont;
    self.cancelButton.titleLabel.textAlignment = self.cancelButtonTextAlignment;
    self.cancelButton.iconPosition = self.cancelButtonIconPosition;
    [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];

    [self.cancelButton setTitleColor:self.cancelButtonTitleColor forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:self.cancelButtonTitleColorHighlighted forState:UIControlStateHighlighted];
    [self.cancelButton setTitleColor:self.cancelButtonTitleColorHighlighted forState:UIControlStateSelected];
    [self.cancelButton setTitleColor:self.cancelButtonTitleColorDisabled forState:UIControlStateDisabled];

    [self.cancelButton setBackgroundColor:self.cancelButtonBackgroundColor forState:UIControlStateNormal];
    [self.cancelButton setBackgroundColor:self.cancelButtonBackgroundColorHighlighted forState:UIControlStateHighlighted];
    [self.cancelButton setBackgroundColor:self.cancelButtonBackgroundColorHighlighted forState:UIControlStateSelected];
    [self.cancelButton setBackgroundColor:self.cancelButtonBackgroundColorDisabled forState:UIControlStateDisabled];

    [self.cancelButton setImage:self.cancelButtonIconImage forState:UIControlStateNormal];
    [self.cancelButton setImage:self.cancelButtonIconImageHighlighted forState:UIControlStateHighlighted];
    [self.cancelButton setImage:self.cancelButtonIconImageHighlighted forState:UIControlStateSelected];
    [self.cancelButton setImage:self.cancelButtonIconImageDisabled forState:UIControlStateDisabled];

    if (self.cancelButtonTextAlignment == NSTextAlignmentLeft) {
        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    else if (self.cancelButtonTextAlignment == NSTextAlignmentRight) {
        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }

    if (self.cancelButton.imageView.image && self.cancelButton.titleLabel.text.length) {
        self.cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0.0,
                                                             LGAlertViewButtonImageOffsetFromTitle / 2.0,
                                                             0.0,
                                                             LGAlertViewButtonImageOffsetFromTitle / 2.0);
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
        [self dismissAnimated:self.shouldDismissAnimated completionHandler:^{
            if (self.didDismissAfterCancelHandler) {
                self.didDismissAfterCancelHandler(self);
            }

            if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidDismissAfterCancelled:)]) {
                [self.delegate alertViewDidDismissAfterCancelled:self];
            }

            [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewDidDismissAfterCancelNotification object:self userInfo:nil];
        }];
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

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDestructed:)]) {
        [self.delegate alertViewDestructed:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewDestructiveNotification object:self userInfo:nil];

    // -----

    if (self.dismissOnAction) {
        [self dismissAnimated:self.shouldDismissAnimated completionHandler:^{
            if (self.didDismissAfterDestructiveHandler) {
                self.didDismissAfterDestructiveHandler(self);
            }

            if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidDismissAfterDestructed:)]) {
                [self.delegate alertViewDidDismissAfterDestructed:self];
            }

            [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewDidDismissAfterDestructiveNotification object:self userInfo:nil];
        }];
    }
}

- (void)actionActionAtIndex:(NSUInteger)index title:(NSString *)title {
    if (self.actionHandler) {
        self.actionHandler(self, index, title);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:title:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:index title:title];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewActionNotification
                                                        object:self
                                                      userInfo:@{@"title": title,
                                                                 @"index": @(index)}];

    // -----

    if (self.dismissOnAction) {
        [self dismissAnimated:self.shouldDismissAnimated completionHandler:^{
            if (self.didDismissAfterActionHandler) {
                self.didDismissAfterActionHandler(self, index, title);
            }

            if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:didDismissAfterClickedButtonAtIndex:title:)]) {
                [self.delegate alertView:self didDismissAfterClickedButtonAtIndex:index title:title];
            }

            [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewDidDismissAfterActionNotification
                                                                object:self
                                                              userInfo:@{@"title": title,
                                                                         @"index": @(index)}];
        }];
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

#pragma mark - Callbacks

- (void)willShowCallback {
    if (self.willShowHandler) {
        self.willShowHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewWillShow:)]) {
        [self.delegate alertViewWillShow:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewWillShowNotification object:self userInfo:nil];
}

- (void)didShowCallback {
    if (self.didShowHandler) {
        self.didShowHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidShow:)]) {
        [self.delegate alertViewDidShow:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewDidShowNotification object:self userInfo:nil];
}

- (void)willDismissCallback {
    if (self.willDismissHandler) {
        self.willDismissHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewWillDismiss:)]) {
        [self.delegate alertViewWillDismiss:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewWillDismissNotification object:self userInfo:nil];
}

- (void)didDismissCallback {
    if (self.didDismissHandler) {
        self.didDismissHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidDismiss:)]) {
        [self.delegate alertViewDidDismiss:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:LGAlertViewDidDismissNotification object:self userInfo:nil];
}

#pragma mark - Helpers

- (BOOL)isAlertViewValid:(LGAlertView *)alertView {
    NSAssert(alertView.isInitialized, @"You need to use one of \"- initWith...\" or \"+ alertViewWith...\" methods to initialize LGAlertView");

    return YES;
}

- (BOOL)isValid {
    return [self isAlertViewValid:self];
}

- (CGFloat)innerMarginHeight {
    return self.style == LGAlertViewStyleAlert ? 16.0 : 12.0;
}

@end

#pragma mark - Deprecated

@implementation LGAlertView (Deprecated)

- (void)setLayerShadowOpacity:(CGFloat)layerShadowOpacity {
    if (!self.layerShadowColor) return;

    self.layerShadowColor = [self.layerShadowColor colorWithAlphaComponent:layerShadowOpacity];
}

- (CGFloat)layerShadowOpacity {
    CGFloat alpha = 0.0;

    if (!self.layerShadowColor) return alpha;

    [self.layerShadowColor getWhite:nil alpha:&alpha];

    return alpha;
}

- (void)setButtonAtIndex:(NSUInteger)index enabled:(BOOL)enabled {
    [self setButtonEnabled:enabled atIndex:index];
}

@end
