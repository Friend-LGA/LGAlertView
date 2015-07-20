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
#import "LGAlertViewCell.h"
#import "LGAlertViewTextField.h"
#import "LGAlertViewShared.h"

#define kLGAlertViewSeparatorHeight ([UIScreen mainScreen].scale == 1.f || [UIDevice currentDevice].systemVersion.floatValue < 7.0 ? 1.f : 0.5)

static CGFloat const kLGAlertViewInnerMarginH       = 10.f;
static CGFloat const kLGAlertViewButtonTitleMarginH = 5.f;
static CGFloat const kLGAlertViewButtonHeight       = 44.f;
static CGFloat const kLGAlertViewTextFieldHeight    = 44.f;

@interface UIWindow (LGAlertView)

- (UIViewController *)currentViewController;

@end

@interface LGAlertViewViewController : UIViewController

@property (strong, nonatomic) LGAlertView *alertView;

@end

@interface LGAlertView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

typedef enum
{
    LGAlertViewStyleNone              = 0,
    LGAlertViewStyleActivityIndicator = 1,
    LGAlertViewStyleProgressView      = 2,
    LGAlertViewStyleTextFields        = 3
}
LGAlertViewStyle;

@property (assign, nonatomic, getter=isExists) BOOL exists;

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) UIWindow *windowPrevious;
@property (assign, nonatomic) UIWindow *windowNotice;

@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) LGAlertViewViewController *viewController;

@property (strong, nonatomic) UIView *backgroundView;

@property (strong, nonatomic) UIView       *styleView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITableView  *tableView;

@property (strong, nonatomic) NSString       *title;
@property (strong, nonatomic) NSString       *message;
@property (strong, nonatomic) UIView         *innerView;
@property (strong, nonatomic) NSMutableArray *buttonTitles;
@property (strong, nonatomic) NSString       *cancelButtonTitle;
@property (strong, nonatomic) NSString       *destructiveButtonTitle;

@property (strong, nonatomic) UILabel  *titleLabel;
@property (strong, nonatomic) UILabel  *messageLabel;
@property (strong, nonatomic) UIButton *destructiveButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *firstButton;
@property (strong, nonatomic) UIButton *secondButton;

@property (strong, nonatomic) NSMutableArray *textFieldSeparatorsArray;

@property (strong, nonatomic) UIView *separatorHorizontalView;
@property (strong, nonatomic) UIView *separatorVerticalView;

@property (assign, nonatomic) CGPoint scrollViewCenterShowed;
@property (assign, nonatomic) CGPoint scrollViewCenterHidden;

@property (assign, nonatomic) CGPoint cancelButtonCenterShowed;
@property (assign, nonatomic) CGPoint cancelButtonCenterHidden;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UILabel        *progressLabel;

@property (strong, nonatomic) NSString *progressLabelText;

@property (assign, nonatomic) LGAlertViewStyle style;

@property (assign, nonatomic) CGFloat keyboardHeight;

- (void)layoutInvalidateWithSize:(CGSize)size;

@end

#pragma mark -

@implementation UIWindow (LGAlertView)

- (NSString *)className
{
    return NSStringFromClass([self class]);
}

- (UIViewController *)currentViewController
{
    UIViewController *viewController = self.rootViewController;
    
    if (viewController.presentedViewController)
        viewController = viewController.presentedViewController;
    
    return viewController;
}

@end

@implementation LGAlertViewViewController

- (instancetype)initWithAlertView:(LGAlertView *)alertView
{
    self = [super init];
    if (self)
    {
        if ([UIDevice currentDevice].systemVersion.floatValue < 7.0)
            self.wantsFullScreenLayout = YES;
        
        _alertView = alertView;
        
        self.view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_alertView.view];
    }
    return self;
}

- (BOOL)shouldAutorotate
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    return window.currentViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    return window.currentViewController.supportedInterfaceOrientations;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0

#pragma mark iOS <= 7

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    CGSize size = self.view.frame.size;
    
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
        size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
    else
        size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
    
    [_alertView layoutInvalidateWithSize:size];
}

#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

#pragma mark iOS == 8

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [_alertView layoutInvalidateWithSize:size];
     }
                                 completion:nil];
}

#endif

@end

@implementation LGAlertView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    self = [super init];
    if (self)
    {
        _title = title;
        _message = message;
        _buttonTitles = buttonTitles.mutableCopy;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        
        [self setupDefaults];
    }
    return self;
}

- (instancetype)initWithViewStyleWithTitle:(NSString *)title
                                   message:(NSString *)message
                                      view:(UIView *)view
                              buttonTitles:(NSArray *)buttonTitles
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                    destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    self = [super init];
    if (self)
    {
        if ([view isKindOfClass:[UIScrollView class]])
            NSLog(@"LGFilterView: WARNING !!! view can not be subclass of UIScrollView !!!");
        
        // -----
        
        _title = title;
        _message = message;
        _innerView = view;
        _buttonTitles = buttonTitles.mutableCopy;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        
        [self setupDefaults];
    }
    return self;
}

- (instancetype)initWithActivityIndicatorStyleWithTitle:(NSString *)title
                                                message:(NSString *)message
                                           buttonTitles:(NSArray *)buttonTitles
                                      cancelButtonTitle:(NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    self = [super init];
    if (self)
    {
        _title = title;
        _message = message;
        _buttonTitles = buttonTitles.mutableCopy;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        
        _style = LGAlertViewStyleActivityIndicator;
        
        [self setupDefaults];
    }
    return self;
}

- (instancetype)initWithProgressViewStyleWithTitle:(NSString *)title
                                           message:(NSString *)message
                                 progressLabelText:(NSString *)progressLabelText
                                      buttonTitles:(NSArray *)buttonTitles
                                 cancelButtonTitle:(NSString *)cancelButtonTitle
                            destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    self = [super init];
    if (self)
    {
        _title = title;
        _message = message;
        _buttonTitles = buttonTitles.mutableCopy;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        _progressLabelText = progressLabelText;
        
        _style = LGAlertViewStyleProgressView;
        
        [self setupDefaults];
    }
    return self;
}

- (instancetype)initWithTextFieldsStyleWithTitle:(NSString *)title
                                         message:(NSString *)message
                              numberOfTextFields:(NSUInteger)numberOfTextFields
                          textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                                    buttonTitles:(NSArray *)buttonTitles
                               cancelButtonTitle:(NSString *)cancelButtonTitle
                          destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    self = [super init];
    if (self)
    {
        _title = title;
        _message = message;
        _buttonTitles = buttonTitles.mutableCopy;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        
        _style = LGAlertViewStyleTextFields;
        
        _textFieldsArray = [NSMutableArray new];
        _textFieldSeparatorsArray = [NSMutableArray new];
        
        for (NSUInteger i=0; i<numberOfTextFields; i++)
        {
            LGAlertViewTextField *textField = [LGAlertViewTextField new];
            textField.delegate = self;
            textField.tag = i;
                        
            if (i == numberOfTextFields-1)
                textField.returnKeyType = UIReturnKeyDone;
            else
                textField.returnKeyType = UIReturnKeyNext;
            
            if (textFieldsSetupHandler) textFieldsSetupHandler(textField, i);
            
            [_textFieldsArray addObject:textField];
            
            // -----
            
            UIView *separatorView = [UIView new];
            [_textFieldSeparatorsArray addObject:separatorView];
        }
        
        [self setupDefaults];
    }
    return self;
}

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                      buttonTitles:(NSArray *)buttonTitles
                 cancelButtonTitle:(NSString *)cancelButtonTitle
            destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    return [[self alloc] initWithTitle:title
                               message:message
                          buttonTitles:buttonTitles
                     cancelButtonTitle:cancelButtonTitle
                destructiveButtonTitle:destructiveButtonTitle];
}

+ (instancetype)alertViewWithViewStyleWithTitle:(NSString *)title
                                        message:(NSString *)message
                                           view:(UIView *)view
                                   buttonTitles:(NSArray *)buttonTitles
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    return [[self alloc] initWithViewStyleWithTitle:title
                                            message:message
                                               view:view
                                       buttonTitles:buttonTitles
                                  cancelButtonTitle:cancelButtonTitle
                             destructiveButtonTitle:destructiveButtonTitle];
}

+ (instancetype)alertViewWithActivityIndicatorStyleWithTitle:(NSString *)title
                                                     message:(NSString *)message
                                                buttonTitles:(NSArray *)buttonTitles
                                           cancelButtonTitle:(NSString *)cancelButtonTitle
                                      destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    return [[self alloc] initWithActivityIndicatorStyleWithTitle:title
                                                         message:message
                                                    buttonTitles:buttonTitles
                                               cancelButtonTitle:cancelButtonTitle
                                          destructiveButtonTitle:destructiveButtonTitle];
}

+ (instancetype)alertViewWithProgressViewStyleWithTitle:(NSString *)title
                                                message:(NSString *)message
                                      progressLabelText:(NSString *)progressLabelText
                                           buttonTitles:(NSArray *)buttonTitles
                                      cancelButtonTitle:(NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    return [[self alloc] initWithProgressViewStyleWithTitle:title
                                                    message:message
                                          progressLabelText:progressLabelText
                                               buttonTitles:buttonTitles
                                          cancelButtonTitle:cancelButtonTitle
                                     destructiveButtonTitle:destructiveButtonTitle];
}

+ (instancetype)alertViewWithTextFieldsStyleWithTitle:(NSString *)title
                                              message:(NSString *)message
                                   numberOfTextFields:(NSUInteger)numberOfTextFields
                               textFieldsSetupHandler:(void (^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                                         buttonTitles:(NSArray *)buttonTitles
                                    cancelButtonTitle:(NSString *)cancelButtonTitle
                               destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    return [[self alloc] initWithTextFieldsStyleWithTitle:title
                                                  message:message
                                       numberOfTextFields:numberOfTextFields
                                   textFieldsSetupHandler:textFieldsSetupHandler
                                             buttonTitles:buttonTitles
                                        cancelButtonTitle:cancelButtonTitle
                                   destructiveButtonTitle:destructiveButtonTitle];
}

#pragma mark -

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
                actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
           destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
    self = [self initWithTitle:title
                       message:message
                  buttonTitles:buttonTitles
             cancelButtonTitle:cancelButtonTitle
        destructiveButtonTitle:destructiveButtonTitle];
    if (self)
    {
        _actionHandler = actionHandler;
        _cancelHandler = cancelHandler;
        _destructiveHandler = destructiveHandler;
    }
    return self;
}

- (instancetype)initWithViewStyleWithTitle:(NSString *)title
                                   message:(NSString *)message
                                      view:(UIView *)view
                              buttonTitles:(NSArray *)buttonTitles
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                    destructiveButtonTitle:(NSString *)destructiveButtonTitle
                             actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                             cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                        destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
    self = [self initWithViewStyleWithTitle:title
                                    message:message
                                       view:view
                               buttonTitles:buttonTitles
                          cancelButtonTitle:cancelButtonTitle
                     destructiveButtonTitle:destructiveButtonTitle];
    if (self)
    {
        _actionHandler = actionHandler;
        _cancelHandler = cancelHandler;
        _destructiveHandler = destructiveHandler;
    }
    return self;
}

- (instancetype)initWithActivityIndicatorStyleWithTitle:(NSString *)title
                                                message:(NSString *)message
                                           buttonTitles:(NSArray *)buttonTitles
                                      cancelButtonTitle:(NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                          actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                          cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                                     destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
    self = [self initWithActivityIndicatorStyleWithTitle:title
                                                 message:message
                                            buttonTitles:buttonTitles
                                       cancelButtonTitle:cancelButtonTitle
                                  destructiveButtonTitle:destructiveButtonTitle];
    if (self)
    {
        _actionHandler = actionHandler;
        _cancelHandler = cancelHandler;
        _destructiveHandler = destructiveHandler;
    }
    return self;
}

- (instancetype)initWithProgressViewStyleWithTitle:(NSString *)title
                                           message:(NSString *)message
                                 progressLabelText:(NSString *)progressLabelText
                                      buttonTitles:(NSArray *)buttonTitles
                                 cancelButtonTitle:(NSString *)cancelButtonTitle
                            destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                     actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                     cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                                destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
    self = [self initWithProgressViewStyleWithTitle:title
                                            message:message
                                  progressLabelText:progressLabelText
                                       buttonTitles:buttonTitles
                                  cancelButtonTitle:cancelButtonTitle
                             destructiveButtonTitle:destructiveButtonTitle];
    if (self)
    {
        _actionHandler = actionHandler;
        _cancelHandler = cancelHandler;
        _destructiveHandler = destructiveHandler;
    }
    return self;
}

- (instancetype)initWithTextFieldsStyleWithTitle:(NSString *)title
                                         message:(NSString *)message
                              numberOfTextFields:(NSUInteger)numberOfTextFields
                          textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                                    buttonTitles:(NSArray *)buttonTitles
                               cancelButtonTitle:(NSString *)cancelButtonTitle
                          destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                   actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                   cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                              destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
    self = [self initWithTextFieldsStyleWithTitle:title
                                          message:message
                               numberOfTextFields:numberOfTextFields
                           textFieldsSetupHandler:textFieldsSetupHandler
                                     buttonTitles:buttonTitles
                                cancelButtonTitle:cancelButtonTitle
                           destructiveButtonTitle:destructiveButtonTitle];
    if (self)
    {
        _actionHandler = actionHandler;
        _cancelHandler = cancelHandler;
        _destructiveHandler = destructiveHandler;
    }
    return self;
}

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                      buttonTitles:(NSArray *)buttonTitles
                 cancelButtonTitle:(NSString *)cancelButtonTitle
            destructiveButtonTitle:(NSString *)destructiveButtonTitle
                     actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                     cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
    return [[self alloc] initWithTitle:title
                               message:message
                          buttonTitles:buttonTitles
                     cancelButtonTitle:cancelButtonTitle
                destructiveButtonTitle:destructiveButtonTitle
                         actionHandler:actionHandler
                         cancelHandler:cancelHandler
                    destructiveHandler:destructiveHandler];
}

+ (instancetype)alertViewWithViewStyleWithTitle:(NSString *)title
                                        message:(NSString *)message
                                           view:(UIView *)view
                                   buttonTitles:(NSArray *)buttonTitles
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                  actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                  cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                             destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
    return [[self alloc] initWithViewStyleWithTitle:title
                                            message:message
                                               view:view
                                       buttonTitles:buttonTitles
                                  cancelButtonTitle:cancelButtonTitle
                             destructiveButtonTitle:destructiveButtonTitle
                                      actionHandler:actionHandler
                                      cancelHandler:cancelHandler
                                 destructiveHandler:destructiveHandler];
}

+ (instancetype)alertViewWithActivityIndicatorStyleWithTitle:(NSString *)title
                                                     message:(NSString *)message
                                                buttonTitles:(NSArray *)buttonTitles
                                           cancelButtonTitle:(NSString *)cancelButtonTitle
                                      destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                               actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                               cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                                          destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
    return [[self alloc] initWithActivityIndicatorStyleWithTitle:title
                                                         message:message
                                                    buttonTitles:buttonTitles
                                               cancelButtonTitle:cancelButtonTitle
                                          destructiveButtonTitle:destructiveButtonTitle
                                                   actionHandler:actionHandler
                                                   cancelHandler:cancelHandler
                                              destructiveHandler:destructiveHandler];
}

+ (instancetype)alertViewWithProgressViewStyleWithTitle:(NSString *)title
                                                message:(NSString *)message
                                      progressLabelText:(NSString *)progressLabelText
                                           buttonTitles:(NSArray *)buttonTitles
                                      cancelButtonTitle:(NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                          actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                          cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                                     destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
    return [[self alloc] initWithProgressViewStyleWithTitle:title
                                                    message:message
                                          progressLabelText:progressLabelText
                                               buttonTitles:buttonTitles
                                          cancelButtonTitle:cancelButtonTitle
                                     destructiveButtonTitle:destructiveButtonTitle
                                              actionHandler:actionHandler
                                              cancelHandler:cancelHandler
                                         destructiveHandler:destructiveHandler];
}

+ (instancetype)alertViewWithTextFieldsStyleWithTitle:(NSString *)title
                                              message:(NSString *)message
                                   numberOfTextFields:(NSUInteger)numberOfTextFields
                               textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                                         buttonTitles:(NSArray *)buttonTitles
                                    cancelButtonTitle:(NSString *)cancelButtonTitle
                               destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                        actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                        cancelHandler:(void(^)(LGAlertView *alertView, BOOL onButton))cancelHandler
                                   destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
    return [[self alloc] alertViewWithTextFieldsStyleWithTitle:title
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

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
                     delegate:(id<LGAlertViewDelegate>)delegate
{
    self = [self initWithTitle:title
                       message:message
                  buttonTitles:buttonTitles
             cancelButtonTitle:cancelButtonTitle
        destructiveButtonTitle:destructiveButtonTitle];
    if (self)
    {
        _delegate = delegate;
    }
    return self;
}

- (instancetype)initWithViewStyleWithTitle:(NSString *)title
                                   message:(NSString *)message
                                      view:(UIView *)view
                              buttonTitles:(NSArray *)buttonTitles
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                    destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                  delegate:(id<LGAlertViewDelegate>)delegate
{
    self = [self initWithViewStyleWithTitle:title
                                    message:message
                                       view:view
                               buttonTitles:buttonTitles
                          cancelButtonTitle:cancelButtonTitle
                     destructiveButtonTitle:destructiveButtonTitle];
    if (self)
    {
        _delegate = delegate;
    }
    return self;
}

- (instancetype)initWithActivityIndicatorStyleWithTitle:(NSString *)title
                                                message:(NSString *)message
                                           buttonTitles:(NSArray *)buttonTitles
                                      cancelButtonTitle:(NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                               delegate:(id<LGAlertViewDelegate>)delegate
{
    self = [self initWithActivityIndicatorStyleWithTitle:title
                                                 message:message
                                            buttonTitles:buttonTitles
                                       cancelButtonTitle:cancelButtonTitle
                                  destructiveButtonTitle:destructiveButtonTitle];
    if (self)
    {
        _delegate = delegate;
    }
    return self;
}

- (instancetype)initWithProgressViewStyleWithTitle:(NSString *)title
                                           message:(NSString *)message
                                 progressLabelText:(NSString *)progressLabelText
                                      buttonTitles:(NSArray *)buttonTitles
                                 cancelButtonTitle:(NSString *)cancelButtonTitle
                            destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                          delegate:(id<LGAlertViewDelegate>)delegate
{
    self = [self initWithProgressViewStyleWithTitle:title
                                            message:message
                                  progressLabelText:progressLabelText
                                       buttonTitles:buttonTitles
                                  cancelButtonTitle:cancelButtonTitle
                             destructiveButtonTitle:destructiveButtonTitle];
    if (self)
    {
        _delegate = delegate;
    }
    return self;
}

- (instancetype)initWithTextFieldsStyleWithTitle:(NSString *)title
                                         message:(NSString *)message
                              numberOfTextFields:(NSUInteger)numberOfTextFields
                          textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                                    buttonTitles:(NSArray *)buttonTitles
                               cancelButtonTitle:(NSString *)cancelButtonTitle
                          destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                        delegate:(id<LGAlertViewDelegate>)delegate
{
    self = [self initWithTextFieldsStyleWithTitle:title
                                          message:message
                               numberOfTextFields:numberOfTextFields
                           textFieldsSetupHandler:textFieldsSetupHandler
                                     buttonTitles:buttonTitles
                                cancelButtonTitle:cancelButtonTitle
                           destructiveButtonTitle:destructiveButtonTitle];
    if (self)
    {
        _delegate = delegate;
    }
    return self;
}

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                      buttonTitles:(NSArray *)buttonTitles
                 cancelButtonTitle:(NSString *)cancelButtonTitle
            destructiveButtonTitle:(NSString *)destructiveButtonTitle
                          delegate:(id<LGAlertViewDelegate>)delegate
{
    return [[self alloc] initWithTitle:title
                               message:message
                          buttonTitles:buttonTitles
                     cancelButtonTitle:cancelButtonTitle
                destructiveButtonTitle:destructiveButtonTitle
                              delegate:delegate];
}

+ (instancetype)alertViewWithViewStyleWithTitle:(NSString *)title
                                        message:(NSString *)message
                                           view:(UIView *)view
                                   buttonTitles:(NSArray *)buttonTitles
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                       delegate:(id<LGAlertViewDelegate>)delegate
{
    return [[self alloc] initWithViewStyleWithTitle:title
                                            message:message
                                               view:view
                                       buttonTitles:buttonTitles
                                  cancelButtonTitle:cancelButtonTitle
                             destructiveButtonTitle:destructiveButtonTitle
                                           delegate:delegate];
}

+ (instancetype)alertViewWithActivityIndicatorStyleWithTitle:(NSString *)title
                                                     message:(NSString *)message
                                                buttonTitles:(NSArray *)buttonTitles
                                           cancelButtonTitle:(NSString *)cancelButtonTitle
                                      destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                                    delegate:(id<LGAlertViewDelegate>)delegate
{
    return [[self alloc] initWithActivityIndicatorStyleWithTitle:title
                                                         message:message
                                                    buttonTitles:buttonTitles
                                               cancelButtonTitle:cancelButtonTitle
                                          destructiveButtonTitle:destructiveButtonTitle
                                                        delegate:delegate];
}

+ (instancetype)alertViewWithProgressViewStyleWithTitle:(NSString *)title
                                                message:(NSString *)message
                                      progressLabelText:(NSString *)progressLabelText
                                           buttonTitles:(NSArray *)buttonTitles
                                      cancelButtonTitle:(NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                               delegate:(id<LGAlertViewDelegate>)delegate
{
    return [[self alloc] initWithProgressViewStyleWithTitle:title
                                                    message:message
                                          progressLabelText:progressLabelText
                                               buttonTitles:buttonTitles
                                          cancelButtonTitle:cancelButtonTitle
                                     destructiveButtonTitle:destructiveButtonTitle
                                                   delegate:delegate];
}

+ (instancetype)alertViewWithTextFieldsStyleWithTitle:(NSString *)title
                                              message:(NSString *)message
                                   numberOfTextFields:(NSUInteger)numberOfTextFields
                               textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                                         buttonTitles:(NSArray *)buttonTitles
                                    cancelButtonTitle:(NSString *)cancelButtonTitle
                               destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                             delegate:(id<LGAlertViewDelegate>)delegate
{
    return [[self alloc] alertViewWithTextFieldsStyleWithTitle:title
                                                       message:message
                                            numberOfTextFields:numberOfTextFields
                                        textFieldsSetupHandler:textFieldsSetupHandler
                                                  buttonTitles:buttonTitles
                                             cancelButtonTitle:cancelButtonTitle
                                        destructiveButtonTitle:destructiveButtonTitle
                                                      delegate:delegate];
}

#pragma mark -

- (void)setupDefaults
{
    _cancelOnTouch = YES;
    
    self.tintColor = [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f];
    
    _coverColor = [UIColor colorWithWhite:0.f alpha:0.5];
    
    _backgroundColor = [UIColor whiteColor];
    _layerCornerRadius = 8.f;
    _layerBorderColor = nil;
    _layerBorderWidth = 0.f;
    _layerShadowColor = nil;
    _layerShadowRadius = 0.f;
    
    _titleTextColor     = [UIColor blackColor];
    _titleTextAlignment = NSTextAlignmentCenter;
    _titleFont          = [UIFont boldSystemFontOfSize:18.f];
    
    _messageTextColor     = [UIColor blackColor];
    _messageTextAlignment = NSTextAlignmentCenter;
    _messageFont          = [UIFont systemFontOfSize:14.f];
    
    _buttonsTitleColor                 = _tintColor;
    _buttonsTitleColorHighlighted      = [UIColor whiteColor];
    _buttonsTextAlignment              = NSTextAlignmentCenter;
    _buttonsFont                       = [UIFont systemFontOfSize:18.f];
    _buttonsNumberOfLines              = 1;
    _buttonsLineBreakMode              = NSLineBreakByTruncatingMiddle;
    _buttonsAdjustsFontSizeToFitWidth  = YES;
    _buttonsMinimumScaleFactor         = 14.f/18.f;
    _buttonsBackgroundColorHighlighted = _tintColor;
    
    _cancelButtonTitleColor                 = _tintColor;
    _cancelButtonTitleColorHighlighted      = [UIColor whiteColor];
    _cancelButtonTextAlignment              = NSTextAlignmentCenter;
    _cancelButtonFont                       = [UIFont boldSystemFontOfSize:18.f];
    _cancelButtonNumberOfLines              = 1;
    _cancelButtonLineBreakMode              = NSLineBreakByTruncatingMiddle;
    _cancelButtonAdjustsFontSizeToFitWidth  = YES;
    _cancelButtonMinimumScaleFactor         = 14.f/18.f;
    _cancelButtonBackgroundColorHighlighted = _tintColor;
    
    _destructiveButtonTitleColor                 = [UIColor redColor];
    _destructiveButtonTitleColorHighlighted      = [UIColor whiteColor];
    _destructiveButtonTextAlignment              = NSTextAlignmentCenter;
    _destructiveButtonFont                       = [UIFont systemFontOfSize:18.f];
    _destructiveButtonNumberOfLines              = 1;
    _destructiveButtonLineBreakMode              = NSLineBreakByTruncatingMiddle;
    _destructiveButtonAdjustsFontSizeToFitWidth  = YES;
    _destructiveButtonMinimumScaleFactor         = 14.f/18.f;
    _destructiveButtonBackgroundColorHighlighted = [UIColor redColor];
    
    _activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _activityIndicatorViewColor = _tintColor;
    
    _progressViewProgressTintColor = _tintColor;
    _progressViewTrackTintColor    = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.f];
    _progressViewProgressImage     = nil;
    _progressViewTrackImage        = nil;
    
    _progressLabelTextColor     = [UIColor blackColor];
    _progressLabelTextAlignment = NSTextAlignmentCenter;
    _progressLabelFont          = [UIFont systemFontOfSize:14.f];
    
    self.colorful = YES;
    
    _separatorsColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.f];
    
    _indicatorStyle = UIScrollViewIndicatorStyleBlack;
    
    // -----
    
    _view = [UIView new];
    _view.backgroundColor = [UIColor clearColor];
    _view.userInteractionEnabled = YES;
    _view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _backgroundView = [UIView new];
    _backgroundView.alpha = 0.f;
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_view addSubview:_backgroundView];
    
    // -----
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction:)];
    tapGesture.delegate = self;
    [_backgroundView addGestureRecognizer:tapGesture];
    
    // -----
    
    _viewController = [[LGAlertViewViewController alloc] initWithAlertView:self];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.hidden = YES;
    _window.windowLevel = UIWindowLevelStatusBar+1;
    _window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _window.opaque = NO;
    _window.backgroundColor = [UIColor clearColor];
    _window.rootViewController = _viewController;
}

#pragma mark - Dealloc

- (void)dealloc
{
#if DEBUG
    NSLog(@"%s [Line %d]", __PRETTY_FUNCTION__, __LINE__);
#endif
    
    [self removeObservers];
}

#pragma mark - Observers

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowVisibleChanged:) name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowVisibleChanged:) name:UIWindowDidBecomeHiddenNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardVisibleChanged:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardVisibleChanged:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - Window notifications

- (void)windowVisibleChanged:(NSNotification *)notification
{
    //NSLog(@"windowVisibleChanged: %@", notification);
    
    UIWindow *window = notification.object;
    
    if ([NSStringFromClass([window class]) isEqualToString:@"UITextEffectsWindow"]) return;
    
    if (notification.name == UIWindowDidBecomeVisibleNotification)
    {
        if ([window isEqual:_windowPrevious])
        {
            window.hidden = YES;
        }
        else if (![window isEqual:_window] && !_windowNotice)
        {
            _windowNotice = window;
            
            _window.hidden = YES;
        }
    }
    else if (notification.name == UIWindowDidBecomeHiddenNotification)
    {
        __weak UIView *view = window.subviews.lastObject;
        
        if (![window isEqual:_window] && [window isEqual:_windowNotice])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                           {
                               if (!view)
                               {
                                   _windowNotice = nil;
                                   
                                   [_window makeKeyAndVisible];
                               }
                           });
        }
    }
}

#pragma mark - Keyboard notifications

- (void)keyboardVisibleChanged:(NSNotification *)notification
{
    [LGAlertView keyboardAnimateWithNotificationUserInfo:notification.userInfo
                                              animations:^(CGFloat keyboardHeight)
     {
         if ([notification.name isEqualToString:UIKeyboardWillShowNotification])
             _keyboardHeight = keyboardHeight;
         else
             _keyboardHeight = 0.f;
         
         [self layoutInvalidateWithSize:_view.frame.size];
     }];
}

- (void)keyboardFrameChanged:(NSNotification *)notification
{
    //NSLog(@"%@", notification);
    
    if ([notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] == 0.f)
        _keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(LGAlertViewTextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext)
    {
        if (_textFieldsArray.count > textField.tag+1)
        {
            LGAlertViewTextField *nextTextField = _textFieldsArray[textField.tag+1];
            [nextTextField becomeFirstResponder];
        }
    }
    else if (textField.returnKeyType == UIReturnKeyDone)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Setters and Getters

- (void)setColorful:(BOOL)colorful
{
    _colorful = colorful;
    
    if (_colorful)
    {
        _buttonsTitleColorHighlighted      = [UIColor whiteColor];
        _buttonsBackgroundColorHighlighted = _tintColor;
        
        _cancelButtonTitleColorHighlighted      = [UIColor whiteColor];
        _cancelButtonBackgroundColorHighlighted = _tintColor;
        
        _destructiveButtonTitleColorHighlighted      = [UIColor whiteColor];
        _destructiveButtonBackgroundColorHighlighted = [UIColor redColor];
    }
    else
    {
        _buttonsTitleColorHighlighted      = _buttonsTitleColor;
        _buttonsBackgroundColorHighlighted = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.f];
        
        _cancelButtonTitleColorHighlighted      = _cancelButtonTitleColor;
        _cancelButtonBackgroundColorHighlighted = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.f];
        
        _destructiveButtonTitleColorHighlighted      = _destructiveButtonTitleColor;
        _destructiveButtonBackgroundColorHighlighted = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.f];
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    
    _buttonsBackgroundColorHighlighted      = _tintColor;
    _cancelButtonBackgroundColorHighlighted = _tintColor;
    
    _buttonsTitleColor      = _tintColor;
    _cancelButtonTitleColor = _tintColor;
    
    if (!self.isColorful)
    {
        _buttonsTitleColorHighlighted      = _tintColor;
        _cancelButtonTitleColorHighlighted = _tintColor;
    }
    
    _activityIndicatorViewColor    = _tintColor;
    _progressViewProgressTintColor = _tintColor;
}

- (void)setProgress:(float)progress progressLabelText:(NSString *)progressLabelText
{
    if (_style == LGAlertViewStyleProgressView)
    {
        [_progressView setProgress:progress animated:YES];
        
        _progressLabel.text = progressLabelText;
    }
}

- (float)progress
{
    float progress = 0.f;
    
    if (_style == LGAlertViewStyleProgressView)
        progress = _progressView.progress;
    
    return progress;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _buttonTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LGAlertViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.title = _buttonTitles[indexPath.row];
    
    if (_destructiveButtonTitle.length && indexPath.row == 0)
    {
        cell.titleColor                 = _destructiveButtonTitleColor;
        cell.titleColorHighlighted      = _destructiveButtonTitleColorHighlighted;
        cell.backgroundColorHighlighted = _destructiveButtonBackgroundColorHighlighted;
        cell.separatorVisible           = (indexPath.row != _buttonTitles.count-1);
        cell.separatorColor_            = _separatorsColor;
        cell.textAlignment              = _destructiveButtonTextAlignment;
        cell.font                       = _destructiveButtonFont;
        cell.numberOfLines              = _destructiveButtonNumberOfLines;
        cell.lineBreakMode              = _destructiveButtonLineBreakMode;
        cell.adjustsFontSizeToFitWidth  = _destructiveButtonAdjustsFontSizeToFitWidth;
        cell.minimumScaleFactor         = _destructiveButtonMinimumScaleFactor;
    }
    else if (_cancelButtonTitle.length && indexPath.row == _buttonTitles.count-1)
    {
        cell.titleColor                 = _cancelButtonTitleColor;
        cell.titleColorHighlighted      = _cancelButtonTitleColorHighlighted;
        cell.backgroundColorHighlighted = _cancelButtonBackgroundColorHighlighted;
        cell.separatorVisible           = NO;
        cell.separatorColor_            = _separatorsColor;
        cell.textAlignment              = _cancelButtonTextAlignment;
        cell.font                       = _cancelButtonFont;
        cell.numberOfLines              = _cancelButtonNumberOfLines;
        cell.lineBreakMode              = _cancelButtonLineBreakMode;
        cell.adjustsFontSizeToFitWidth  = _cancelButtonAdjustsFontSizeToFitWidth;
        cell.minimumScaleFactor         = _cancelButtonMinimumScaleFactor;
    }
    else
    {
        cell.titleColor                 = _buttonsTitleColor;
        cell.titleColorHighlighted      = _buttonsTitleColorHighlighted;
        cell.backgroundColorHighlighted = _buttonsBackgroundColorHighlighted;
        cell.separatorVisible           = (indexPath.row != _buttonTitles.count-1);
        cell.separatorColor_            = _separatorsColor;
        cell.textAlignment              = _buttonsTextAlignment;
        cell.font                       = _buttonsFont;
        cell.numberOfLines              = _buttonsNumberOfLines;
        cell.lineBreakMode              = _buttonsLineBreakMode;
        cell.adjustsFontSizeToFitWidth  = _buttonsAdjustsFontSizeToFitWidth;
        cell.minimumScaleFactor         = _buttonsMinimumScaleFactor;
    }
    
    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_destructiveButtonTitle.length && indexPath.row == 0 && _destructiveButtonNumberOfLines != 1)
    {
        NSString *title = _buttonTitles[indexPath.row];
        
        UILabel *label = [UILabel new];
        label.text = title;
        label.textAlignment             = _destructiveButtonTextAlignment;
        label.font                      = _destructiveButtonFont;
        label.numberOfLines             = _destructiveButtonNumberOfLines;
        label.lineBreakMode             = _destructiveButtonLineBreakMode;
        label.adjustsFontSizeToFitWidth = _destructiveButtonAdjustsFontSizeToFitWidth;
        label.minimumScaleFactor        = _destructiveButtonMinimumScaleFactor;
        
        CGSize size = [label sizeThatFits:CGSizeMake(tableView.frame.size.width-kLGAlertViewInnerMarginW*2, CGFLOAT_MAX)];
        size.height += kLGAlertViewButtonTitleMarginH*2;
        
        if (size.height < kLGAlertViewButtonHeight)
            size.height = kLGAlertViewButtonHeight;
        
        return size.height;
    }
    else if (_cancelButtonTitle.length && indexPath.row == _buttonTitles.count-1 && _cancelButtonNumberOfLines != 1)
    {
        NSString *title = _buttonTitles[indexPath.row];
        
        UILabel *label = [UILabel new];
        label.text = title;
        label.textAlignment             = _cancelButtonTextAlignment;
        label.font                      = _cancelButtonFont;
        label.numberOfLines             = _cancelButtonNumberOfLines;
        label.lineBreakMode             = _cancelButtonLineBreakMode;
        label.adjustsFontSizeToFitWidth = _cancelButtonAdjustsFontSizeToFitWidth;
        label.minimumScaleFactor        = _cancelButtonMinimumScaleFactor;
        
        CGSize size = [label sizeThatFits:CGSizeMake(tableView.frame.size.width-kLGAlertViewInnerMarginW*2, CGFLOAT_MAX)];
        size.height += kLGAlertViewButtonTitleMarginH*2;
        
        if (size.height < kLGAlertViewButtonHeight)
            size.height = kLGAlertViewButtonHeight;
        
        return size.height;
    }
    else if (_buttonsNumberOfLines != 1)
    {
        NSString *title = _buttonTitles[indexPath.row];
        
        UILabel *label = [UILabel new];
        label.text = title;
        label.textAlignment             = _buttonsTextAlignment;
        label.font                      = _buttonsFont;
        label.numberOfLines             = _buttonsNumberOfLines;
        label.lineBreakMode             = _buttonsLineBreakMode;
        label.adjustsFontSizeToFitWidth = _buttonsAdjustsFontSizeToFitWidth;
        label.minimumScaleFactor        = _buttonsMinimumScaleFactor;
        
        CGSize size = [label sizeThatFits:CGSizeMake(tableView.frame.size.width-kLGAlertViewInnerMarginW*2, CGFLOAT_MAX)];
        size.height += kLGAlertViewButtonTitleMarginH*2;
        
        if (size.height < kLGAlertViewButtonHeight)
            size.height = kLGAlertViewButtonHeight;
        
        return size.height;
    }
    else return kLGAlertViewButtonHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_destructiveButtonTitle.length && indexPath.row == 0)
    {
        [self destructiveAction:nil];
    }
    else if (_cancelButtonTitle.length && indexPath.row == _buttonTitles.count-1)
    {
        [self cancelAction:nil];
    }
    else
    {
        [self dismissAnimated:YES completionHandler:nil];
        
        NSUInteger index = indexPath.row;
        if (_destructiveButtonTitle.length) index--;
        
        NSString *title = _buttonTitles[indexPath.row];
        
        if (_actionHandler) _actionHandler(self, title, index);
        
        if (_delegate && [_delegate respondsToSelector:@selector(alertView:buttonPressedWithTitle:index:)])
            [_delegate alertView:self buttonPressedWithTitle:title index:index];
    }
}

#pragma mark -

- (void)showAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler
{
    if (self.isShowing) return;
    
    CGSize size = _viewController.view.frame.size;
    
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
        size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
    else
        size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
    
    [self subviewsInvalidateWithSize:size];
    [self layoutInvalidateWithSize:size];
    
    _showing = YES;
    
    // -----
    
    [self addObservers];
    
    // -----
    
    UIWindow *windowApp = [UIApplication sharedApplication].delegate.window;
    _windowPrevious = [UIApplication sharedApplication].keyWindow;
    
    if (![windowApp isEqual:_windowPrevious])
        _windowPrevious.hidden = YES;
    
    [_window makeKeyAndVisible];
    
    // -----
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLGAlertViewWillShowNotification object:self userInfo:nil];
    
    if (_willShowHandler) _willShowHandler(self);
    
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewWillShow:)])
        [_delegate alertViewWillShow:self];
    
    // -----
    
    if (animated)
    {
        [LGAlertView animateStandardWithAnimations:^(void)
         {
             [self showAnimations];
         }
                                        completion:^(BOOL finished)
         {
             [self showComplete];
             
             if (completionHandler) completionHandler();
         }];
    }
    else
    {
        [self showAnimations];
        
        [self showComplete];
        
        if (completionHandler) completionHandler();
    }
}

- (void)showAnimations
{
    _backgroundView.alpha = 1.f;
    
    _scrollView.transform = CGAffineTransformIdentity;
    _scrollView.alpha = 1.f;
    
    _styleView.transform = CGAffineTransformIdentity;
    _styleView.alpha = 1.f;
}

- (void)showComplete
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLGAlertViewDidShowNotification object:self userInfo:nil];
    
    if (_didShowHandler) _didShowHandler(self);
    
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewDidShow:)])
        [_delegate alertViewDidShow:self];
}

- (void)dismissAnimated:(BOOL)animated completionHandler:(void (^)())completionHandler
{
    if (!self.isShowing) return;
    
    _showing = NO;
    
    [self removeObservers];
    
    [_view endEditing:YES];
    
    // -----
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLGAlertViewWillDismissNotification object:self userInfo:nil];
    
    if (_willDismissHandler) _willDismissHandler(self);
    
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewWillDismiss:)])
        [_delegate alertViewWillDismiss:self];
    
    // -----
    
    if (animated)
    {
        [LGAlertView animateStandardWithAnimations:^(void)
         {
             [self dismissAnimations];
         }
                                        completion:^(BOOL finished)
         {
             [self dismissComplete];
             
             if (completionHandler) completionHandler();
         }];
    }
    else
    {
        [self dismissAnimations];
        
        [self dismissComplete];
        
        if (completionHandler) completionHandler();
    }
}

- (void)dismissAnimations
{
    _backgroundView.alpha = 0.f;
    
    _scrollView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    _scrollView.alpha = 0.f;
    
    _styleView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    _styleView.alpha = 0.f;
}

- (void)dismissComplete
{
    _window.hidden = YES;
    
    [_windowPrevious makeKeyAndVisible];
    
    self.viewController = nil;
    self.window = nil;
    
    // -----
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLGAlertViewDidDismissNotification object:self userInfo:nil];
    
    if (_didDismissHandler) _didDismissHandler(self);
    
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewDidDismiss:)])
        [_delegate alertViewDidDismiss:self];
}

#pragma mark -

- (void)subviewsInvalidateWithSize:(CGSize)size
{
    CGFloat widthMax = kLGAlertViewWidth;
    
    if (_widthMax)
    {
        widthMax = MIN(size.width, size.height)-kLGAlertViewMargin*2;
        
        if (_widthMax < widthMax)
            widthMax = _widthMax;
    }
    
    // -----
    
    if (!self.isExists)
    {
        _exists = YES;
        
        _backgroundView.backgroundColor = _coverColor;
        
        _styleView = [UIView new];
        _styleView.backgroundColor = _backgroundColor;
        _styleView.layer.masksToBounds = NO;
        _styleView.layer.cornerRadius = _layerCornerRadius;
        _styleView.layer.borderColor = _layerBorderColor.CGColor;
        _styleView.layer.borderWidth = _layerBorderWidth;
        _styleView.layer.shadowColor = _layerShadowColor.CGColor;
        _styleView.layer.shadowRadius = _layerShadowRadius;
        _styleView.layer.shadowOpacity = 1.f;
        _styleView.layer.shadowOffset = CGSizeZero;
        [_view addSubview:_styleView];
        
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.indicatorStyle = _indicatorStyle;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.layer.masksToBounds = YES;
        _scrollView.layer.cornerRadius = _layerCornerRadius;
        [_view addSubview:_scrollView];
        
        CGFloat offsetY = 0.f;
        
        if (_title.length)
        {
            _titleLabel = [UILabel new];
            _titleLabel.text = _title;
            _titleLabel.textColor = _titleTextColor;
            _titleLabel.textAlignment = _titleTextAlignment;
            _titleLabel.numberOfLines = 0;
            _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.font = _titleFont;
            
            CGSize titleLabelSize = [_titleLabel sizeThatFits:CGSizeMake(widthMax-kLGAlertViewInnerMarginW*2, CGFLOAT_MAX)];
            CGRect titleLabelFrame = CGRectMake(kLGAlertViewInnerMarginW, kLGAlertViewInnerMarginH, widthMax-kLGAlertViewInnerMarginW*2, titleLabelSize.height);
            if ([UIScreen mainScreen].scale == 1.f)
                titleLabelFrame = CGRectIntegral(titleLabelFrame);
            
            _titleLabel.frame = titleLabelFrame;
            [_scrollView addSubview:_titleLabel];
            
            offsetY = _titleLabel.frame.origin.y+_titleLabel.frame.size.height;
        }
        
        if (_message.length)
        {
            _messageLabel = [UILabel new];
            _messageLabel.text = _message;
            _messageLabel.textColor = _messageTextColor;
            _messageLabel.textAlignment = _messageTextAlignment;
            _messageLabel.numberOfLines = 0;
            _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _messageLabel.backgroundColor = [UIColor clearColor];
            _messageLabel.font = _messageFont;
            
            if (!offsetY) offsetY = kLGAlertViewInnerMarginH/2;
            
            CGSize messageLabelSize = [_messageLabel sizeThatFits:CGSizeMake(widthMax-kLGAlertViewInnerMarginW*2, CGFLOAT_MAX)];
            CGRect messageLabelFrame = CGRectMake(kLGAlertViewInnerMarginW, offsetY+kLGAlertViewInnerMarginH/2, widthMax-kLGAlertViewInnerMarginW*2, messageLabelSize.height);
            if ([UIScreen mainScreen].scale == 1.f)
                messageLabelFrame = CGRectIntegral(messageLabelFrame);
            
            _messageLabel.frame = messageLabelFrame;
            [_scrollView addSubview:_messageLabel];
            
            offsetY = _messageLabel.frame.origin.y+_messageLabel.frame.size.height;
        }
        
        if (_innerView)
        {
            CGRect innerViewFrame = CGRectMake(widthMax/2-_innerView.frame.size.width/2, offsetY+kLGAlertViewInnerMarginH, _innerView.frame.size.width, _innerView.frame.size.height);
            if ([UIScreen mainScreen].scale == 1.f)
                innerViewFrame = CGRectIntegral(innerViewFrame);
            
            _innerView.frame = innerViewFrame;
            [_scrollView addSubview:_innerView];
            
            offsetY = _innerView.frame.origin.y+_innerView.frame.size.height;
        }
        else if (_style == LGAlertViewStyleActivityIndicator)
        {
            _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:_activityIndicatorViewStyle];
            _activityIndicator.color = _activityIndicatorViewColor;
            _activityIndicator.backgroundColor = [UIColor clearColor];
            [_activityIndicator startAnimating];
            
            CGRect activityIndicatorFrame = CGRectMake(widthMax/2-_activityIndicator.frame.size.width/2, offsetY+kLGAlertViewInnerMarginH, _activityIndicator.frame.size.width, _activityIndicator.frame.size.height);
            if ([UIScreen mainScreen].scale == 1.f)
                activityIndicatorFrame = CGRectIntegral(activityIndicatorFrame);
            
            _activityIndicator.frame = activityIndicatorFrame;
            [_scrollView addSubview:_activityIndicator];
            
            offsetY = _activityIndicator.frame.origin.y+_activityIndicator.frame.size.height;
        }
        else if (_style == LGAlertViewStyleProgressView)
        {
            _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
            _progressView.backgroundColor = [UIColor clearColor];
            _progressView.progressTintColor = _progressViewProgressTintColor;
            _progressView.trackTintColor = _progressViewTrackTintColor;
            if (_progressViewProgressImage)
                _progressView.progressImage = _progressViewProgressImage;
            if (_progressViewTrackImage)
                _progressView.trackImage = _progressViewTrackImage;
            
            CGRect progressViewFrame = CGRectMake(kLGAlertViewInnerMarginW, offsetY+kLGAlertViewInnerMarginH, widthMax-kLGAlertViewInnerMarginW*2, _progressView.frame.size.height);
            if ([UIScreen mainScreen].scale == 1.f)
                progressViewFrame = CGRectIntegral(progressViewFrame);
            
            _progressView.frame = progressViewFrame;
            [_scrollView addSubview:_progressView];
            
            offsetY = _progressView.frame.origin.y+_progressView.frame.size.height;
            
            _progressLabel = [UILabel new];
            _progressLabel.text = _progressLabelText;
            _progressLabel.textColor = _progressLabelTextColor;
            _progressLabel.textAlignment = _progressLabelTextAlignment;
            _progressLabel.numberOfLines = 1;
            _progressLabel.backgroundColor = [UIColor clearColor];
            _progressLabel.font = _progressLabelFont;
            
            CGSize progressLabelSize = [_progressLabel sizeThatFits:CGSizeMake(widthMax-kLGAlertViewInnerMarginW*2, CGFLOAT_MAX)];
            CGRect progressLabelFrame = CGRectMake(kLGAlertViewInnerMarginW, offsetY+kLGAlertViewInnerMarginH/2, widthMax-kLGAlertViewInnerMarginW*2, progressLabelSize.height);
            if ([UIScreen mainScreen].scale == 1.f)
                progressLabelFrame = CGRectIntegral(progressLabelFrame);
            
            _progressLabel.frame = progressLabelFrame;
            [_scrollView addSubview:_progressLabel];
            
            offsetY = _progressLabel.frame.origin.y+_progressLabel.frame.size.height;
        }
        else if (_style == LGAlertViewStyleTextFields)
        {
            for (NSUInteger i=0; i<_textFieldsArray.count; i++)
            {
                UIView *separatorView = _textFieldSeparatorsArray[i];
                separatorView.backgroundColor = _separatorsColor;
                
                CGRect separatorViewFrame = CGRectMake(0.f, offsetY+(i == 0 ? kLGAlertViewInnerMarginH : 0.f), widthMax, kLGAlertViewSeparatorHeight);
                if ([UIScreen mainScreen].scale == 1.f)
                    separatorViewFrame = CGRectIntegral(separatorViewFrame);
                
                separatorView.frame = separatorViewFrame;
                [_scrollView addSubview:separatorView];
                
                offsetY = separatorView.frame.origin.y+separatorView.frame.size.height;
                
                // -----
                
                LGAlertViewTextField *textField = _textFieldsArray[i];
                
                CGRect textFieldFrame = CGRectMake(0.f, offsetY, widthMax, kLGAlertViewTextFieldHeight);
                if ([UIScreen mainScreen].scale == 1.f)
                    textFieldFrame = CGRectIntegral(textFieldFrame);
                
                textField.frame = textFieldFrame;
                [_scrollView addSubview:textField];
                
                offsetY = textField.frame.origin.y+textField.frame.size.height;
            }
            
            offsetY -= kLGAlertViewInnerMarginH;
        }
        
        NSUInteger numberOfButtons = _buttonTitles.count;
        
        if (_destructiveButtonTitle.length)
            numberOfButtons++;
        if (_cancelButtonTitle.length)
            numberOfButtons++;
        
        BOOL showTable = NO;
        
        if (numberOfButtons == 2)
        {
            if (_destructiveButtonTitle.length)
            {
                _destructiveButton = [UIButton new];
                _destructiveButton.backgroundColor = [UIColor clearColor];
                _destructiveButton.titleLabel.numberOfLines = _destructiveButtonNumberOfLines;
                _destructiveButton.titleLabel.lineBreakMode = _destructiveButtonLineBreakMode;
                _destructiveButton.titleLabel.adjustsFontSizeToFitWidth = _destructiveButtonAdjustsFontSizeToFitWidth;
                _destructiveButton.titleLabel.minimumScaleFactor = _destructiveButtonMinimumScaleFactor;
                _destructiveButton.titleLabel.font = _destructiveButtonFont;
                [_destructiveButton setTitle:_destructiveButtonTitle forState:UIControlStateNormal];
                [_destructiveButton setTitleColor:_destructiveButtonTitleColor forState:UIControlStateNormal];
                [_destructiveButton setTitleColor:_destructiveButtonTitleColorHighlighted forState:UIControlStateHighlighted];
                [_destructiveButton setTitleColor:_destructiveButtonTitleColorHighlighted forState:UIControlStateSelected];
                [_destructiveButton setBackgroundImage:[LGAlertView image1x1WithColor:_destructiveButtonBackgroundColorHighlighted] forState:UIControlStateHighlighted];
                [_destructiveButton setBackgroundImage:[LGAlertView image1x1WithColor:_destructiveButtonBackgroundColorHighlighted] forState:UIControlStateSelected];
                _destructiveButton.contentEdgeInsets = UIEdgeInsetsMake(kLGAlertViewButtonTitleMarginH, kLGAlertViewInnerMarginW, kLGAlertViewButtonTitleMarginH, kLGAlertViewInnerMarginW);
                _destructiveButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                if (_destructiveButtonTextAlignment == NSTextAlignmentCenter)
                    _destructiveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                else if (_destructiveButtonTextAlignment == NSTextAlignmentLeft)
                    _destructiveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                else if (_destructiveButtonTextAlignment == NSTextAlignmentRight)
                    _destructiveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                [_destructiveButton addTarget:self action:@selector(destructiveAction:) forControlEvents:UIControlEventTouchUpInside];
                
                CGSize size = [_destructiveButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
                
                if (size.width > kLGAlertViewWidth/2)
                    showTable = YES;
            }
            
            if (_cancelButtonTitle.length && !showTable)
            {
                _cancelButton = [UIButton new];
                _cancelButton.backgroundColor = [UIColor clearColor];
                _cancelButton.titleLabel.numberOfLines = _cancelButtonNumberOfLines;
                _cancelButton.titleLabel.lineBreakMode = _cancelButtonLineBreakMode;
                _cancelButton.titleLabel.adjustsFontSizeToFitWidth = _cancelButtonAdjustsFontSizeToFitWidth;
                _cancelButton.titleLabel.minimumScaleFactor = _cancelButtonMinimumScaleFactor;
                _cancelButton.titleLabel.font = _cancelButtonFont;
                [_cancelButton setTitle:_cancelButtonTitle forState:UIControlStateNormal];
                [_cancelButton setTitleColor:_cancelButtonTitleColor forState:UIControlStateNormal];
                [_cancelButton setTitleColor:_cancelButtonTitleColorHighlighted forState:UIControlStateHighlighted];
                [_cancelButton setTitleColor:_cancelButtonTitleColorHighlighted forState:UIControlStateSelected];
                [_cancelButton setBackgroundImage:[LGAlertView image1x1WithColor:_cancelButtonBackgroundColorHighlighted] forState:UIControlStateHighlighted];
                [_cancelButton setBackgroundImage:[LGAlertView image1x1WithColor:_cancelButtonBackgroundColorHighlighted] forState:UIControlStateSelected];
                _cancelButton.contentEdgeInsets = UIEdgeInsetsMake(kLGAlertViewButtonTitleMarginH, kLGAlertViewInnerMarginW, kLGAlertViewButtonTitleMarginH, kLGAlertViewInnerMarginW);
                _cancelButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                if (_cancelButtonTextAlignment == NSTextAlignmentCenter)
                    _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                else if (_cancelButtonTextAlignment == NSTextAlignmentLeft)
                    _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                else if (_cancelButtonTextAlignment == NSTextAlignmentRight)
                    _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
                
                CGSize size = [_cancelButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
                
                if (size.width > kLGAlertViewWidth/2)
                    showTable = YES;
            }
            
            if (_buttonTitles.count > 0  && !showTable)
            {
                _firstButton = [UIButton new];
                _firstButton.backgroundColor = [UIColor clearColor];
                _firstButton.titleLabel.numberOfLines = _buttonsNumberOfLines;
                _firstButton.titleLabel.lineBreakMode = _buttonsLineBreakMode;
                _firstButton.titleLabel.adjustsFontSizeToFitWidth = _buttonsAdjustsFontSizeToFitWidth;
                _firstButton.titleLabel.minimumScaleFactor = _buttonsMinimumScaleFactor;
                _firstButton.titleLabel.font = _buttonsFont;
                [_firstButton setTitle:_buttonTitles[0] forState:UIControlStateNormal];
                [_firstButton setTitleColor:_buttonsTitleColor forState:UIControlStateNormal];
                [_firstButton setTitleColor:_buttonsTitleColorHighlighted forState:UIControlStateHighlighted];
                [_firstButton setTitleColor:_buttonsTitleColorHighlighted forState:UIControlStateSelected];
                [_firstButton setBackgroundImage:[LGAlertView image1x1WithColor:_buttonsBackgroundColorHighlighted] forState:UIControlStateHighlighted];
                [_firstButton setBackgroundImage:[LGAlertView image1x1WithColor:_buttonsBackgroundColorHighlighted] forState:UIControlStateSelected];
                _firstButton.contentEdgeInsets = UIEdgeInsetsMake(kLGAlertViewButtonTitleMarginH, kLGAlertViewInnerMarginW, kLGAlertViewButtonTitleMarginH, kLGAlertViewInnerMarginW);
                _firstButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                if (_buttonsTextAlignment == NSTextAlignmentCenter)
                    _firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                else if (_buttonsTextAlignment == NSTextAlignmentLeft)
                    _firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                else if (_buttonsTextAlignment == NSTextAlignmentRight)
                    _firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                [_firstButton addTarget:self action:@selector(firstButtonAction) forControlEvents:UIControlEventTouchUpInside];
                
                CGSize size = [_firstButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
                
                if (size.width > kLGAlertViewWidth/2)
                    showTable = YES;
                
                if (_buttonTitles.count > 1  && !showTable)
                {
                    _secondButton = [UIButton new];
                    _secondButton.backgroundColor = [UIColor clearColor];
                    _secondButton.titleLabel.numberOfLines = _buttonsNumberOfLines;
                    _secondButton.titleLabel.lineBreakMode = _buttonsLineBreakMode;
                    _secondButton.titleLabel.adjustsFontSizeToFitWidth = _buttonsAdjustsFontSizeToFitWidth;
                    _secondButton.titleLabel.minimumScaleFactor = _buttonsMinimumScaleFactor;
                    _secondButton.titleLabel.font = _buttonsFont;
                    [_secondButton setTitle:_buttonTitles[1] forState:UIControlStateNormal];
                    [_secondButton setTitleColor:_buttonsTitleColor forState:UIControlStateNormal];
                    [_secondButton setTitleColor:_buttonsTitleColorHighlighted forState:UIControlStateHighlighted];
                    [_secondButton setTitleColor:_buttonsTitleColorHighlighted forState:UIControlStateSelected];
                    [_secondButton setBackgroundImage:[LGAlertView image1x1WithColor:_buttonsBackgroundColorHighlighted] forState:UIControlStateHighlighted];
                    [_secondButton setBackgroundImage:[LGAlertView image1x1WithColor:_buttonsBackgroundColorHighlighted] forState:UIControlStateSelected];
                    _secondButton.contentEdgeInsets = UIEdgeInsetsMake(kLGAlertViewButtonTitleMarginH, kLGAlertViewInnerMarginW, kLGAlertViewButtonTitleMarginH, kLGAlertViewInnerMarginW);
                    _secondButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    if (_buttonsTextAlignment == NSTextAlignmentCenter)
                        _secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    else if (_buttonsTextAlignment == NSTextAlignmentLeft)
                        _secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    else if (_buttonsTextAlignment == NSTextAlignmentRight)
                        _secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                    [_secondButton addTarget:self action:@selector(secondButtonAction) forControlEvents:UIControlEventTouchUpInside];
                    
                    CGSize size = [_secondButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
                    
                    if (size.width > kLGAlertViewWidth/2)
                        showTable = YES;
                }
            }
            
            if (!showTable)
            {
                UIButton *firstButton = nil;
                UIButton *secondButton = nil;
                
                if (_destructiveButton)
                {
                    [_scrollView addSubview:_destructiveButton];
                    
                    firstButton = _destructiveButton;
                }
                
                if (_cancelButton)
                {
                    [_scrollView addSubview:_cancelButton];
                    
                    secondButton = _cancelButton;
                }
                
                if (_firstButton)
                {
                    [_scrollView addSubview:_firstButton];
                    
                    if (!firstButton) firstButton = _firstButton;
                    else secondButton = _firstButton;
                    
                    if (_secondButton)
                    {
                        [_scrollView addSubview:_secondButton];
                        
                        secondButton = _secondButton;
                    }
                }
                
                // -----
                
                if (offsetY)
                {
                    _separatorHorizontalView = [UIView new];
                    _separatorHorizontalView.backgroundColor = _separatorsColor;
                    
                    CGRect separatorHorizontalViewFrame = CGRectMake(0.f, offsetY+kLGAlertViewInnerMarginH, widthMax, kLGAlertViewSeparatorHeight);
                    if ([UIScreen mainScreen].scale == 1.f)
                        separatorHorizontalViewFrame = CGRectIntegral(separatorHorizontalViewFrame);
                    
                    _separatorHorizontalView.frame = separatorHorizontalViewFrame;
                    [_scrollView addSubview:_separatorHorizontalView];
                    
                    offsetY = _separatorHorizontalView.frame.origin.y+_separatorHorizontalView.frame.size.height;
                }
                
                // -----
                
                _separatorVerticalView = [UIView new];
                _separatorVerticalView.backgroundColor = _separatorsColor;
                
                CGRect separatorVerticalViewFrame = CGRectMake(widthMax/2, offsetY, kLGAlertViewSeparatorHeight, MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height));
                if ([UIScreen mainScreen].scale == 1.f)
                    separatorVerticalViewFrame = CGRectIntegral(separatorVerticalViewFrame);
                
                _separatorVerticalView.frame = separatorVerticalViewFrame;
                [_scrollView addSubview:_separatorVerticalView];
                
                // -----
                
                CGRect firstButtonFrame = CGRectMake(0.f, offsetY, widthMax/2, kLGAlertViewButtonHeight);
                if ([UIScreen mainScreen].scale == 1.f)
                    firstButtonFrame = CGRectIntegral(firstButtonFrame);
                firstButton.frame = firstButtonFrame;
                
                CGRect secondButtonFrame = CGRectMake(widthMax/2+kLGAlertViewSeparatorHeight, offsetY, widthMax/2-kLGAlertViewSeparatorHeight, kLGAlertViewButtonHeight);
                if ([UIScreen mainScreen].scale == 1.f)
                    secondButtonFrame = CGRectIntegral(secondButtonFrame);
                secondButton.frame = secondButtonFrame;
                
                offsetY = firstButton.frame.origin.y+firstButton.frame.size.height;
            }
        }
        else showTable = YES;
        
        if (showTable)
        {
            if (!_buttonTitles)
                _buttonTitles = [NSMutableArray new];
            
            if (_destructiveButtonTitle.length)
                [_buttonTitles insertObject:_destructiveButtonTitle atIndex:0];
            
            if (_cancelButtonTitle.length)
                [_buttonTitles addObject:_cancelButtonTitle];
            
            _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            _tableView.clipsToBounds = NO;
            _tableView.backgroundColor = [UIColor clearColor];
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _tableView.dataSource = self;
            _tableView.delegate = self;
            _tableView.scrollEnabled = NO;
            [_tableView registerClass:[LGAlertViewCell class] forCellReuseIdentifier:@"cell"];
            _tableView.frame = CGRectMake(0.f, 0.f, widthMax, CGFLOAT_MAX);
            [_tableView reloadData];
            
            if (!offsetY) offsetY = -kLGAlertViewInnerMarginH;
            else
            {
                _separatorHorizontalView = [UIView new];
                _separatorHorizontalView.backgroundColor = _separatorsColor;
                
                CGRect separatorTitleViewFrame = CGRectMake(0.f, 0.f, widthMax, kLGAlertViewSeparatorHeight);
                if ([UIScreen mainScreen].scale == 1.f)
                    separatorTitleViewFrame = CGRectIntegral(separatorTitleViewFrame);
                
                _separatorHorizontalView.frame = separatorTitleViewFrame;
                _tableView.tableHeaderView = _separatorHorizontalView;
            }
            
            CGRect tableViewFrame = CGRectMake(0.f, offsetY+kLGAlertViewInnerMarginH, widthMax, _tableView.contentSize.height);
            if ([UIScreen mainScreen].scale == 1.f)
                tableViewFrame = CGRectIntegral(tableViewFrame);
            _tableView.frame = tableViewFrame;
            
            [_scrollView addSubview:_tableView];
            
            offsetY = _tableView.frame.origin.y+_tableView.frame.size.height;
        }
        
        // -----
        
        _scrollView.contentSize = CGSizeMake(widthMax, offsetY);
    }
}

- (void)layoutInvalidateWithSize:(CGSize)size
{
    _view.frame = CGRectMake(0.f, 0.f, size.width, size.height);
    
    _backgroundView.frame = CGRectMake(0.f, 0.f, size.width, size.height);
    
    // -----
    
    CGFloat widthMax = kLGAlertViewWidth;
    
    if (_widthMax)
    {
        widthMax = MIN(size.width, size.height)-kLGAlertViewMargin*2;
        
        if (_widthMax < widthMax)
            widthMax = _widthMax;
    }
    
    // -----
    
    CGFloat heightMax = size.height-_keyboardHeight-kLGAlertViewMargin;
    
    if (_heightMax && _heightMax < heightMax)
        heightMax = _heightMax;
    
    if (_cancelOnTouch &&
        !_cancelButtonTitle.length &&
        size.width < widthMax+kLGAlertViewButtonHeight*2)
        heightMax -= kLGAlertViewButtonHeight*2;
    
    if (_scrollView.contentSize.height < heightMax)
        heightMax = _scrollView.contentSize.height;
    
    // -----
    
    CGRect scrollViewFrame = CGRectZero;
    CGAffineTransform scrollViewTransform = CGAffineTransformIdentity;
    CGFloat scrollViewAlpha = 1.f;
    
    scrollViewFrame = CGRectMake(size.width/2-widthMax/2, size.height/2-_keyboardHeight/2-heightMax/2, widthMax, heightMax);
    
    if (!self.isShowing)
    {
        scrollViewTransform = CGAffineTransformMakeScale(1.2, 1.2);
        
        scrollViewAlpha = 0.f;
    }
    
    if ([UIScreen mainScreen].scale == 1.f)
    {
        scrollViewFrame = CGRectIntegral(scrollViewFrame);
        
        if (_tableView)
        {
            if (_tableView.frame.origin.y+_tableView.frame.size.height < scrollViewFrame.size.height)
                scrollViewFrame.size.height = _tableView.frame.origin.y+_tableView.frame.size.height;
        }
        else
        {
            if (_separatorVerticalView && _separatorVerticalView.frame.origin.y+kLGAlertViewButtonHeight < scrollViewFrame.size.height)
                scrollViewFrame.size.height = _separatorVerticalView.frame.origin.y+kLGAlertViewButtonHeight;
        }
    }
    
    // -----
    
    _scrollView.frame = scrollViewFrame;
    _scrollView.transform = scrollViewTransform;
    _scrollView.alpha = scrollViewAlpha;
    
    CGFloat borderWidth = _layerBorderWidth;
    _styleView.frame = CGRectMake(scrollViewFrame.origin.x-borderWidth, scrollViewFrame.origin.y-borderWidth, scrollViewFrame.size.width+borderWidth*2, scrollViewFrame.size.height+borderWidth*2);
    _styleView.transform = scrollViewTransform;
    _styleView.alpha = scrollViewAlpha;
}

#pragma mark -

- (void)cancelAction:(id)sender
{
    BOOL onButton = [sender isKindOfClass:[UIButton class]];
    
    if (sender)
    {
        if (onButton)
            [(UIButton *)sender setSelected:YES];
        else if ([sender isKindOfClass:[UIGestureRecognizer class]] && !self.isCancelOnTouch)
            return;
    }
    
    [self dismissAnimated:YES completionHandler:nil];
    
    // -----
    
    if (_cancelHandler) _cancelHandler(self, onButton);
    
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewCancelled:)])
        [_delegate alertViewCancelled:self];
}

- (void)destructiveAction:(id)sender
{
    if (sender && [sender isKindOfClass:[UIButton class]])
        [(UIButton *)sender setSelected:YES];
    
    [self dismissAnimated:YES completionHandler:nil];
    
    if (_destructiveHandler) _destructiveHandler(self);
    
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewDestructiveButtonPressed:)])
        [_delegate alertViewDestructiveButtonPressed:self];
}

- (void)firstButtonAction
{
    _firstButton.selected = YES;
    
    [self dismissAnimated:YES completionHandler:nil];
    
    NSUInteger index = 0;
    
    NSString *title = _buttonTitles[0];
    
    if (_actionHandler) _actionHandler(self, title, index);
    
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:buttonPressedWithTitle:index:)])
        [_delegate alertView:self buttonPressedWithTitle:title index:index];
}

- (void)secondButtonAction
{
    _secondButton.selected = YES;
    
    [self dismissAnimated:YES completionHandler:nil];
    
    NSUInteger index = 1;
    
    NSString *title = _buttonTitles[1];
    
    if (_actionHandler) _actionHandler(self, title, index);
    
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:buttonPressedWithTitle:index:)])
        [_delegate alertView:self buttonPressedWithTitle:title index:index];
}

#pragma mark - Support

+ (void)animateStandardWithAnimations:(void(^)())animations completion:(void(^)(BOOL finished))completion
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        [UIView animateWithDuration:0.5
                              delay:0.0
             usingSpringWithDamping:1.f
              initialSpringVelocity:0.5
                            options:0
                         animations:animations
                         completion:completion];
    }
    else
    {
        [UIView animateWithDuration:0.5*0.66
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:animations
                         completion:completion];
    }
}

+ (UIImage *)image1x1WithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.f, 0.f, 1.f, 1.f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void)keyboardAnimateWithNotificationUserInfo:(NSDictionary *)notificationUserInfo animations:(void(^)(CGFloat keyboardHeight))animations
{
    CGFloat keyboardHeight = (notificationUserInfo[@"UIKeyboardBoundsUserInfoKey"] ? [notificationUserInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height : 0.f);
    if (!keyboardHeight)
        keyboardHeight = (notificationUserInfo[UIKeyboardFrameBeginUserInfoKey] ? [notificationUserInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height : 0.f);
    if (!keyboardHeight)
        keyboardHeight = (notificationUserInfo[UIKeyboardFrameEndUserInfoKey] ? [notificationUserInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height : 0.f);
    if (!keyboardHeight)
        return;
    
    NSTimeInterval animationDuration = [notificationUserInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int animationCurve = [notificationUserInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (animations) animations(keyboardHeight);
    
    [UIView commitAnimations];
}

@end
