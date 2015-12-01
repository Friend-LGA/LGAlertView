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
#import "UIWindow+LGAlertView.h"

#define kLGAlertViewStatusBarHeight                   ([UIApplication sharedApplication].isStatusBarHidden ? 0.f : 20.f)
#define kLGAlertViewSeparatorHeight                   ([UIScreen mainScreen].scale == 1.f || [UIDevice currentDevice].systemVersion.floatValue < 7.0 ? 1.f : 0.5)
#define kLGAlertViewOffsetV                           (_offsetVertical != NSNotFound ? _offsetVertical : 8.f)
#define kLGAlertViewOffsetH                           8.f
#define kLGAlertViewButtonTitleMarginH                8.f
#define kLGAlertViewWidthStyleAlert                   (320.f - 20*2)
#define kLGAlertViewWidthStyleActionSheet             (320.f - 16*2)
#define kLGAlertViewInnerMarginH                      (_style == LGAlertViewStyleAlert ? 16.f : 12.f)
#define kLGAlertViewIsCancelButtonSeparate(alertView) (alertView.style == LGAlertViewStyleActionSheet && alertView.cancelButtonOffsetY != NSNotFound && alertView.cancelButtonOffsetY > 0.f && !kLGAlertViewPadAndNotForce(alertView))
#define kLGAlertViewButtonWidthMin                    64.f
#define kLGAlertViewWindowPrevious(index)             (index > 0 && index < kLGAlertViewWindowsArray.count ? [kLGAlertViewWindowsArray objectAtIndex:(index-1)] : nil)
#define kLGAlertViewWindowNext(index)                 (kLGAlertViewWindowsArray.count > index+1 ? [kLGAlertViewWindowsArray objectAtIndex:(index+1)] : nil)
#define kLGAlertViewPadAndNotForce(alertView)         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && !alertView.isPadShowActionSheetFromBottom)

#define kLGAlertViewPointIsNil(point) CGPointEqualToPoint(point, CGPointMake(NSNotFound, NSNotFound))

static NSMutableArray *kLGAlertViewWindowsArray;
static NSMutableArray *kLGAlertViewArray;

static LGAlertViewWindowLevel kLGAlertViewWindowLevel = NSNotFound;

static NSNumber *kLGAlertViewColorful;
static UIColor  *kLGAlertViewTintColor;
static UIColor  *kLGAlertViewCoverColor;
static UIColor  *kLGAlertViewBackgroundColor;
static CGFloat  kLGAlertViewButtonsHeight = NSNotFound;
static CGFloat  kLGAlertViewTextFieldsHeight = NSNotFound;
static CGFloat  kLGAlertViewOffsetVertical = NSNotFound;
static CGFloat  kLGAlertViewCancelButtonOffsetY = NSNotFound;
static CGFloat  kLGAlertViewHeightMax = NSNotFound;
static CGFloat  kLGAlertViewWidth = NSNotFound;

static CGFloat  kLGAlertViewLayerCornerRadius = NSNotFound;
static UIColor  *kLGAlertViewLayerBorderColor;
static CGFloat  kLGAlertViewLayerBorderWidth = NSNotFound;
static UIColor  *kLGAlertViewLayerShadowColor;
static CGFloat  kLGAlertViewLayerShadowRadius = NSNotFound;
static CGFloat  kLGAlertViewLayerShadowOpacity = NSNotFound;
static NSString *kLGAlertViewLayerShadowOffset;

static UIColor         *kLGAlertViewTitleTextColor;
static NSTextAlignment kLGAlertViewTitleTextAlignment = NSNotFound;
static UIFont          *kLGAlertViewTitleFont;

static UIColor         *kLGAlertViewMessageTextColor;
static NSTextAlignment kLGAlertViewMessageTextAlignment = NSNotFound;
static UIFont          *kLGAlertViewMessageFont;

static UIColor         *kLGAlertViewButtonsTitleColor;
static UIColor         *kLGAlertViewButtonsTitleColorHighlighted;
static UIColor         *kLGAlertViewButtonsTitleColorDisabled;
static NSTextAlignment kLGAlertViewButtonsTextAlignment = NSNotFound;
static UIFont          *kLGAlertViewButtonsFont;
static UIColor         *kLGAlertViewButtonsBackgroundColor;
static UIColor         *kLGAlertViewButtonsBackgroundColorHighlighted;
static UIColor         *kLGAlertViewButtonsBackgroundColorDisabled;
static NSUInteger      kLGAlertViewButtonsNumberOfLines = NSNotFound;
static NSLineBreakMode kLGAlertViewButtonsLineBreakMode = NSNotFound;
static CGFloat         kLGAlertViewButtonsMinimumScaleFactor = NSNotFound;
static NSNumber        *kLGAlertViewButtonsAdjustsFontSizeToFitWidth;

static UIColor         *kLGAlertViewCancelButtonTitleColor;
static UIColor         *kLGAlertViewCancelButtonTitleColorHighlighted;
static UIColor         *kLGAlertViewCancelButtonTitleColorDisabled;
static NSTextAlignment kLGAlertViewCancelButtonTextAlignment = NSNotFound;
static UIFont          *kLGAlertViewCancelButtonFont;
static UIColor         *kLGAlertViewCancelButtonBackgroundColor;
static UIColor         *kLGAlertViewCancelButtonBackgroundColorHighlighted;
static UIColor         *kLGAlertViewCancelButtonBackgroundColorDisabled;
static NSUInteger      kLGAlertViewCancelButtonNumberOfLines = NSNotFound;
static NSLineBreakMode kLGAlertViewCancelButtonLineBreakMode = NSNotFound;
static CGFloat         kLGAlertViewCancelButtonMinimumScaleFactor = NSNotFound;
static NSNumber        *kLGAlertViewCancelButtonAdjustsFontSizeToFitWidth;

static UIColor         *kLGAlertViewDestructiveButtonTitleColor;
static UIColor         *kLGAlertViewDestructiveButtonTitleColorHighlighted;
static UIColor         *kLGAlertViewDestructiveButtonTitleColorDisabled;
static NSTextAlignment kLGAlertViewDestructiveButtonTextAlignment = NSNotFound;
static UIFont          *kLGAlertViewDestructiveButtonFont;
static UIColor         *kLGAlertViewDestructiveButtonBackgroundColor;
static UIColor         *kLGAlertViewDestructiveButtonBackgroundColorHighlighted;
static UIColor         *kLGAlertViewDestructiveButtonBackgroundColorDisabled;
static NSUInteger      kLGAlertViewDestructiveButtonNumberOfLines = NSNotFound;
static NSLineBreakMode kLGAlertViewDestructiveButtonLineBreakMode = NSNotFound;
static CGFloat         kLGAlertViewDestructiveButtonMinimumScaleFactor = NSNotFound;
static NSNumber        *kLGAlertViewDestructiveButtonAdjustsFontSizeToFitWidth;

static UIActivityIndicatorViewStyle kLGAlertViewActivityIndicatorViewStyle = NSNotFound;
static UIColor                      *kLGAlertViewActivityIndicatorViewColor;

static UIColor         *kLGAlertViewProgressViewProgressTintColor;
static UIColor         *kLGAlertViewProgressViewTrackTintColor;
static UIImage         *kLGAlertViewProgressViewProgressImage;
static UIImage         *kLGAlertViewProgressViewTrackImage;
static UIColor         *kLGAlertViewProgressLabelTextColor;
static NSTextAlignment kLGAlertViewProgressLabelTextAlignment = NSNotFound;
static UIFont          *kLGAlertViewProgressLabelFont;

static UIColor                    *kLGAlertViewSeparatorsColor;
static UIScrollViewIndicatorStyle kLGAlertViewIndicatorStyle = NSNotFound;
static NSNumber                   *kLGAlertViewShowsVerticalScrollIndicator;
static NSNumber                   *kLGAlertViewPadShowActionSheetFromBottom;
static NSNumber                   *kLGAlertViewOneRowOneButton;

#pragma mark - Interface

@interface LGAlertView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

typedef enum
{
    LGAlertViewTypeDefault           = 0,
    LGAlertViewTypeActivityIndicator = 1,
    LGAlertViewTypeProgressView      = 2,
    LGAlertViewTypeTextFields        = 3
}
LGAlertViewType;

@property (assign, nonatomic, getter=isExists) BOOL exists;

@property (strong, nonatomic) LGAlertViewWindow *window;

@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) LGAlertViewController *viewController;

@property (strong, nonatomic) UIView *backgroundView;

@property (strong, nonatomic) UIView *styleView;
@property (strong, nonatomic) UIView *styleCancelView;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITableView  *tableView;

@property (assign, nonatomic) LGAlertViewStyle style;
@property (strong, nonatomic) NSString         *title;
@property (strong, nonatomic) NSString         *message;
@property (strong, nonatomic) UIView           *innerView;
@property (strong, nonatomic) NSMutableArray   *buttonTitles;
@property (strong, nonatomic) NSString         *cancelButtonTitle;
@property (strong, nonatomic) NSString         *destructiveButtonTitle;

@property (strong, nonatomic) UILabel  *titleLabel;
@property (strong, nonatomic) UILabel  *messageLabel;
@property (strong, nonatomic) UIButton *destructiveButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *firstButton;
@property (strong, nonatomic) UIButton *secondButton;
@property (strong, nonatomic) UIButton *thirdButton;

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

- (void)layoutInvalidateWithSize:(CGSize)size;

@end

#pragma mark - Implementation

@implementation LGAlertView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                        style:(LGAlertViewStyle)style
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    self = [super init];
    if (self)
    {
        _style = style;
        _title = title;
        _message = message;
        _buttonTitles = buttonTitles.mutableCopy;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;

        [self setupDefaults];
    }
    return self;
}

- (instancetype)initWithViewAndTitle:(NSString *)title
                             message:(NSString *)message
                               style:(LGAlertViewStyle)style
                                view:(UIView *)view
                        buttonTitles:(NSArray *)buttonTitles
                   cancelButtonTitle:(NSString *)cancelButtonTitle
              destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    self = [super init];
    if (self)
    {
        _style = style;
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

- (instancetype)initWithActivityIndicatorAndTitle:(NSString *)title
                                          message:(NSString *)message
                                            style:(LGAlertViewStyle)style
                                     buttonTitles:(NSArray *)buttonTitles
                                cancelButtonTitle:(NSString *)cancelButtonTitle
                           destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    self = [super init];
    if (self)
    {
        _style = style;
        _title = title;
        _message = message;
        _buttonTitles = buttonTitles.mutableCopy;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;

        _type = LGAlertViewTypeActivityIndicator;

        [self setupDefaults];
    }
    return self;
}

- (instancetype)initWithProgressViewAndTitle:(NSString *)title
                                     message:(NSString *)message
                                       style:(LGAlertViewStyle)style
                           progressLabelText:(NSString *)progressLabelText
                                buttonTitles:(NSArray *)buttonTitles
                           cancelButtonTitle:(NSString *)cancelButtonTitle
                      destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    self = [super init];
    if (self)
    {
        _style = style;
        _title = title;
        _message = message;
        _buttonTitles = buttonTitles.mutableCopy;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        _progressLabelText = progressLabelText;

        _type = LGAlertViewTypeProgressView;

        [self setupDefaults];
    }
    return self;
}

- (instancetype)initWithTextFieldsAndTitle:(NSString *)title
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

        _type = LGAlertViewTypeTextFields;

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
                             style:(LGAlertViewStyle)style
                      buttonTitles:(NSArray *)buttonTitles
                 cancelButtonTitle:(NSString *)cancelButtonTitle
            destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    return [[self alloc] initWithTitle:title
                               message:message
                                 style:style
                          buttonTitles:buttonTitles
                     cancelButtonTitle:cancelButtonTitle
                destructiveButtonTitle:destructiveButtonTitle];
}

+ (instancetype)alertViewWithViewAndTitle:(NSString *)title
                                  message:(NSString *)message
                                    style:(LGAlertViewStyle)style
                                     view:(UIView *)view
                             buttonTitles:(NSArray *)buttonTitles
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    return [[self alloc] initWithViewAndTitle:title
                                      message:message
                                        style:style
                                         view:view
                                 buttonTitles:buttonTitles
                            cancelButtonTitle:cancelButtonTitle
                       destructiveButtonTitle:destructiveButtonTitle];
}

+ (instancetype)alertViewWithActivityIndicatorAndTitle:(NSString *)title
                                               message:(NSString *)message
                                                 style:(LGAlertViewStyle)style
                                          buttonTitles:(NSArray *)buttonTitles
                                     cancelButtonTitle:(NSString *)cancelButtonTitle
                                destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    return [[self alloc] initWithActivityIndicatorAndTitle:title
                                                   message:message
                                                     style:style
                                              buttonTitles:buttonTitles
                                         cancelButtonTitle:cancelButtonTitle
                                    destructiveButtonTitle:destructiveButtonTitle];
}

+ (instancetype)alertViewWithProgressViewAndTitle:(NSString *)title
                                          message:(NSString *)message
                                            style:(LGAlertViewStyle)style
                                progressLabelText:(NSString *)progressLabelText
                                     buttonTitles:(NSArray *)buttonTitles
                                cancelButtonTitle:(NSString *)cancelButtonTitle
                           destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    return [[self alloc] initWithProgressViewAndTitle:title
                                              message:message
                                                style:style
                                    progressLabelText:progressLabelText
                                         buttonTitles:buttonTitles
                                    cancelButtonTitle:cancelButtonTitle
                               destructiveButtonTitle:destructiveButtonTitle];
}

+ (instancetype)alertViewWithTextFieldsAndTitle:(NSString *)title
                                        message:(NSString *)message
                             numberOfTextFields:(NSUInteger)numberOfTextFields
                         textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                                   buttonTitles:(NSArray *)buttonTitles
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    return [[self alloc] initWithTextFieldsAndTitle:title
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
                        style:(LGAlertViewStyle)style
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
                actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
           destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
    self = [self initWithTitle:title
                       message:message
                         style:style
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

- (instancetype)initWithViewAndTitle:(NSString *)title
                             message:(NSString *)message
                               style:(LGAlertViewStyle)style
                                view:(UIView *)view
                        buttonTitles:(NSArray *)buttonTitles
                   cancelButtonTitle:(NSString *)cancelButtonTitle
              destructiveButtonTitle:(NSString *)destructiveButtonTitle
                       actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                       cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                  destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
    self = [self initWithViewAndTitle:title
                              message:message
                                style:style
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

- (instancetype)initWithActivityIndicatorAndTitle:(NSString *)title
                                          message:(NSString *)message
                                            style:(LGAlertViewStyle)style
                                     buttonTitles:(NSArray *)buttonTitles
                                cancelButtonTitle:(NSString *)cancelButtonTitle
                           destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                    actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                    cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                               destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
    self = [self initWithActivityIndicatorAndTitle:title
                                           message:message
                                             style:style
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

- (instancetype)initWithProgressViewAndTitle:(NSString *)title
                                     message:(NSString *)message
                                       style:(LGAlertViewStyle)style
                           progressLabelText:(NSString *)progressLabelText
                                buttonTitles:(NSArray *)buttonTitles
                           cancelButtonTitle:(NSString *)cancelButtonTitle
                      destructiveButtonTitle:(NSString *)destructiveButtonTitle
                               actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                               cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                          destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
    self = [self initWithProgressViewAndTitle:title
                                      message:message
                                        style:style
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

- (instancetype)initWithTextFieldsAndTitle:(NSString *)title
                                   message:(NSString *)message
                        numberOfTextFields:(NSUInteger)numberOfTextFields
                    textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                              buttonTitles:(NSArray *)buttonTitles
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                    destructiveButtonTitle:(NSString *)destructiveButtonTitle
                             actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                             cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                        destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
    self = [self initWithTextFieldsAndTitle:title
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
                             style:(LGAlertViewStyle)style
                      buttonTitles:(NSArray *)buttonTitles
                 cancelButtonTitle:(NSString *)cancelButtonTitle
            destructiveButtonTitle:(NSString *)destructiveButtonTitle
                     actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                     cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
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

+ (instancetype)alertViewWithViewAndTitle:(NSString *)title
                                  message:(NSString *)message
                                    style:(LGAlertViewStyle)style
                                     view:(UIView *)view
                             buttonTitles:(NSArray *)buttonTitles
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
                            actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                            cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                       destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
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

+ (instancetype)alertViewWithActivityIndicatorAndTitle:(NSString *)title
                                               message:(NSString *)message
                                                 style:(LGAlertViewStyle)style
                                          buttonTitles:(NSArray *)buttonTitles
                                     cancelButtonTitle:(NSString *)cancelButtonTitle
                                destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                         actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                         cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                                    destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
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

+ (instancetype)alertViewWithProgressViewAndTitle:(NSString *)title
                                          message:(NSString *)message
                                            style:(LGAlertViewStyle)style
                                progressLabelText:(NSString *)progressLabelText
                                     buttonTitles:(NSArray *)buttonTitles
                                cancelButtonTitle:(NSString *)cancelButtonTitle
                           destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                    actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                    cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                               destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
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

+ (instancetype)alertViewWithTextFieldsAndTitle:(NSString *)title
                                        message:(NSString *)message
                             numberOfTextFields:(NSUInteger)numberOfTextFields
                         textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                                   buttonTitles:(NSArray *)buttonTitles
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                  actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                                  cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
                             destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
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

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                        style:(LGAlertViewStyle)style
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
                     delegate:(id<LGAlertViewDelegate>)delegate
{
    self = [self initWithTitle:title
                       message:message
                         style:style
                  buttonTitles:buttonTitles
             cancelButtonTitle:cancelButtonTitle
        destructiveButtonTitle:destructiveButtonTitle];
    if (self)
    {
        _delegate = delegate;
    }
    return self;
}

- (instancetype)initWithViewAndTitle:(NSString *)title
                             message:(NSString *)message
                               style:(LGAlertViewStyle)style
                                view:(UIView *)view
                        buttonTitles:(NSArray *)buttonTitles
                   cancelButtonTitle:(NSString *)cancelButtonTitle
              destructiveButtonTitle:(NSString *)destructiveButtonTitle
                            delegate:(id<LGAlertViewDelegate>)delegate
{
    self = [self initWithViewAndTitle:title
                              message:message
                                style:style
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

- (instancetype)initWithActivityIndicatorAndTitle:(NSString *)title
                                          message:(NSString *)message
                                            style:(LGAlertViewStyle)style
                                     buttonTitles:(NSArray *)buttonTitles
                                cancelButtonTitle:(NSString *)cancelButtonTitle
                           destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                         delegate:(id<LGAlertViewDelegate>)delegate
{
    self = [self initWithActivityIndicatorAndTitle:title
                                           message:message
                                             style:style
                                      buttonTitles:buttonTitles
                                 cancelButtonTitle:cancelButtonTitle
                            destructiveButtonTitle:destructiveButtonTitle];
    if (self)
    {
        _delegate = delegate;
    }
    return self;
}

- (instancetype)initWithProgressViewAndTitle:(NSString *)title
                                     message:(NSString *)message
                                       style:(LGAlertViewStyle)style
                           progressLabelText:(NSString *)progressLabelText
                                buttonTitles:(NSArray *)buttonTitles
                           cancelButtonTitle:(NSString *)cancelButtonTitle
                      destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                    delegate:(id<LGAlertViewDelegate>)delegate
{
    self = [self initWithProgressViewAndTitle:title
                                      message:message
                                        style:style
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

- (instancetype)initWithTextFieldsAndTitle:(NSString *)title
                                   message:(NSString *)message
                        numberOfTextFields:(NSUInteger)numberOfTextFields
                    textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                              buttonTitles:(NSArray *)buttonTitles
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                    destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                  delegate:(id<LGAlertViewDelegate>)delegate
{
    self = [self initWithTextFieldsAndTitle:title
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
                             style:(LGAlertViewStyle)style
                      buttonTitles:(NSArray *)buttonTitles
                 cancelButtonTitle:(NSString *)cancelButtonTitle
            destructiveButtonTitle:(NSString *)destructiveButtonTitle
                          delegate:(id<LGAlertViewDelegate>)delegate
{
    return [[self alloc] initWithTitle:title
                               message:message
                                 style:style
                          buttonTitles:buttonTitles
                     cancelButtonTitle:cancelButtonTitle
                destructiveButtonTitle:destructiveButtonTitle
                              delegate:delegate];
}

+ (instancetype)alertViewWithViewAndTitle:(NSString *)title
                                  message:(NSString *)message
                                    style:(LGAlertViewStyle)style
                                     view:(UIView *)view
                             buttonTitles:(NSArray *)buttonTitles
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                 delegate:(id<LGAlertViewDelegate>)delegate
{
    return [[self alloc] initWithViewAndTitle:title
                                      message:message
                                        style:style
                                         view:view
                                 buttonTitles:buttonTitles
                            cancelButtonTitle:cancelButtonTitle
                       destructiveButtonTitle:destructiveButtonTitle
                                     delegate:delegate];
}

+ (instancetype)alertViewWithActivityIndicatorAndTitle:(NSString *)title
                                               message:(NSString *)message
                                                 style:(LGAlertViewStyle)style
                                          buttonTitles:(NSArray *)buttonTitles
                                     cancelButtonTitle:(NSString *)cancelButtonTitle
                                destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                              delegate:(id<LGAlertViewDelegate>)delegate
{
    return [[self alloc] initWithActivityIndicatorAndTitle:title
                                                   message:message
                                                     style:style
                                              buttonTitles:buttonTitles
                                         cancelButtonTitle:cancelButtonTitle
                                    destructiveButtonTitle:destructiveButtonTitle
                                                  delegate:delegate];
}

+ (instancetype)alertViewWithProgressViewAndTitle:(NSString *)title
                                          message:(NSString *)message
                                            style:(LGAlertViewStyle)style
                                progressLabelText:(NSString *)progressLabelText
                                     buttonTitles:(NSArray *)buttonTitles
                                cancelButtonTitle:(NSString *)cancelButtonTitle
                           destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                         delegate:(id<LGAlertViewDelegate>)delegate
{
    return [[self alloc] initWithProgressViewAndTitle:title
                                              message:message
                                                style:style
                                    progressLabelText:progressLabelText
                                         buttonTitles:buttonTitles
                                    cancelButtonTitle:cancelButtonTitle
                               destructiveButtonTitle:destructiveButtonTitle
                                             delegate:delegate];
}

+ (instancetype)alertViewWithTextFieldsAndTitle:(NSString *)title
                                        message:(NSString *)message
                             numberOfTextFields:(NSUInteger)numberOfTextFields
                         textFieldsSetupHandler:(void(^)(UITextField *textField, NSUInteger index))textFieldsSetupHandler
                                   buttonTitles:(NSArray *)buttonTitles
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                       delegate:(id<LGAlertViewDelegate>)delegate
{
    return [[self alloc] alertViewWithTextFieldsAndTitle:title
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
    if (!kLGAlertViewWindowsArray)
        kLGAlertViewWindowsArray = [NSMutableArray new];

    if (!kLGAlertViewArray)
        kLGAlertViewArray = [NSMutableArray new];

    // -----

    _buttonsEnabledArray = [NSMutableArray new];

    for (NSUInteger i=0; i<_buttonTitles.count; i++)
        [_buttonsEnabledArray addObject:[NSNumber numberWithBool:YES]];

    // -----

    _windowLevel = (kLGAlertViewWindowLevel != NSNotFound ? kLGAlertViewWindowLevel : LGAlertViewWindowLevelAboveStatusBar);

    _cancelOnTouch       = !(_type == LGAlertViewTypeActivityIndicator || _type == LGAlertViewTypeProgressView || _type == LGAlertViewTypeTextFields);
    _dismissOnAction     = YES;
    _coverColor          = (kLGAlertViewCoverColor ? kLGAlertViewCoverColor : [UIColor colorWithWhite:0.f alpha:0.5]);
    _backgroundColor     = (kLGAlertViewBackgroundColor ? kLGAlertViewBackgroundColor : [UIColor whiteColor]);
    _buttonsHeight       = (kLGAlertViewButtonsHeight != NSNotFound ? kLGAlertViewButtonsHeight : ([UIDevice currentDevice].systemVersion.floatValue < 9.0 || _style == LGAlertViewStyleAlert) ? 44.f : 56.f);
    _textFieldsHeight    = (kLGAlertViewTextFieldsHeight != NSNotFound ? kLGAlertViewTextFieldsHeight : 44.f);
    _offsetVertical      = (kLGAlertViewOffsetVertical != NSNotFound ? kLGAlertViewOffsetVertical : NSNotFound);
    _cancelButtonOffsetY = (kLGAlertViewCancelButtonOffsetY != NSNotFound ? kLGAlertViewCancelButtonOffsetY : kLGAlertViewOffsetH);
    _heightMax           = (kLGAlertViewHeightMax != NSNotFound ? kLGAlertViewHeightMax : NSNotFound);
    _width               = (kLGAlertViewWidth != NSNotFound ? kLGAlertViewWidth : NSNotFound);

    _layerCornerRadius  = (kLGAlertViewLayerCornerRadius != NSNotFound ? kLGAlertViewLayerCornerRadius : ([UIDevice currentDevice].systemVersion.floatValue < 9.0 ? 6.f : 12.f));
    _layerBorderColor   = (kLGAlertViewLayerBorderColor ? kLGAlertViewLayerBorderColor : nil);
    _layerBorderWidth   = (kLGAlertViewLayerBorderWidth != NSNotFound ? kLGAlertViewLayerBorderWidth : 0.f);
    _layerShadowColor   = (kLGAlertViewLayerShadowColor ? kLGAlertViewLayerShadowColor : nil);
    _layerShadowRadius  = (kLGAlertViewLayerShadowRadius != NSNotFound ? kLGAlertViewLayerShadowRadius : 0.f);
    _layerShadowOpacity = (kLGAlertViewLayerShadowOpacity != NSNotFound ? kLGAlertViewLayerShadowOpacity : 0.f);
    _layerShadowOffset  = (kLGAlertViewLayerShadowOffset ? CGSizeFromString(kLGAlertViewLayerShadowOffset) : CGSizeZero);

    _titleTextColor     = (kLGAlertViewTitleTextColor ? kLGAlertViewTitleTextColor : (_style == LGAlertViewStyleAlert ? [UIColor blackColor] : [UIColor grayColor]));
    _titleTextAlignment = (kLGAlertViewTitleTextAlignment != NSNotFound ? kLGAlertViewTitleTextAlignment : NSTextAlignmentCenter);
    _titleFont          = (kLGAlertViewTitleFont ? kLGAlertViewTitleFont : (_style == LGAlertViewStyleAlert ? [UIFont boldSystemFontOfSize:18.f] : [UIFont boldSystemFontOfSize:14.f]));

    _messageTextColor     = (kLGAlertViewMessageTextColor ? kLGAlertViewMessageTextColor : (_style == LGAlertViewStyleAlert ? [UIColor blackColor] : [UIColor grayColor]));
    _messageTextAlignment = (kLGAlertViewMessageTextAlignment != NSNotFound ? kLGAlertViewMessageTextAlignment : NSTextAlignmentCenter);
    _messageFont          = (kLGAlertViewMessageFont ? kLGAlertViewMessageFont : (_style == LGAlertViewStyleAlert ? [UIFont systemFontOfSize:14.f] : [UIFont systemFontOfSize:14.f]));

    _tintColor = (kLGAlertViewTintColor ? kLGAlertViewTintColor : [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f]);

    _buttonsTitleColor                 = (kLGAlertViewButtonsTitleColor ? kLGAlertViewButtonsTitleColor : _tintColor);
    _buttonsTitleColorHighlighted      = (kLGAlertViewButtonsTitleColorHighlighted ? kLGAlertViewButtonsTitleColorHighlighted : [UIColor whiteColor]);
    _buttonsTitleColorDisabled         = (kLGAlertViewButtonsTitleColorDisabled ? kLGAlertViewButtonsTitleColorDisabled : [UIColor grayColor]);
    _buttonsTextAlignment              = (kLGAlertViewButtonsTextAlignment != NSNotFound ? kLGAlertViewButtonsTextAlignment : NSTextAlignmentCenter);
    _buttonsFont                       = (kLGAlertViewButtonsFont ? kLGAlertViewButtonsFont : [UIFont systemFontOfSize:18.f]);
    _buttonsNumberOfLines              = (kLGAlertViewButtonsNumberOfLines != NSNotFound ? kLGAlertViewButtonsNumberOfLines : 1);
    _buttonsLineBreakMode              = (kLGAlertViewButtonsLineBreakMode != NSNotFound ? kLGAlertViewButtonsLineBreakMode : NSLineBreakByTruncatingMiddle);
    _buttonsAdjustsFontSizeToFitWidth  = (kLGAlertViewButtonsAdjustsFontSizeToFitWidth ? kLGAlertViewButtonsAdjustsFontSizeToFitWidth.boolValue : YES);
    _buttonsMinimumScaleFactor         = (kLGAlertViewButtonsMinimumScaleFactor != NSNotFound ? kLGAlertViewButtonsMinimumScaleFactor : 14.f/18.f);
    _buttonsBackgroundColor            = (kLGAlertViewButtonsBackgroundColor ? kLGAlertViewButtonsBackgroundColor : nil);
    _buttonsBackgroundColorHighlighted = (kLGAlertViewButtonsBackgroundColorHighlighted ? kLGAlertViewButtonsBackgroundColorHighlighted : _tintColor);
    _buttonsBackgroundColorDisabled    = (kLGAlertViewButtonsBackgroundColorDisabled ? kLGAlertViewButtonsBackgroundColorDisabled : nil);
    _buttonsEnabled                    = YES;

    _cancelButtonTitleColor                 = (kLGAlertViewCancelButtonTitleColor ? kLGAlertViewCancelButtonTitleColor : _tintColor);
    _cancelButtonTitleColorHighlighted      = (kLGAlertViewCancelButtonTitleColorHighlighted ? kLGAlertViewCancelButtonTitleColorHighlighted : [UIColor whiteColor]);
    _cancelButtonTitleColorDisabled         = (kLGAlertViewCancelButtonTitleColorDisabled ? kLGAlertViewCancelButtonTitleColorDisabled : [UIColor grayColor]);
    _cancelButtonTextAlignment              = (kLGAlertViewCancelButtonTextAlignment != NSNotFound ? kLGAlertViewCancelButtonTextAlignment : NSTextAlignmentCenter);
    _cancelButtonFont                       = (kLGAlertViewCancelButtonFont ? kLGAlertViewCancelButtonFont : [UIFont boldSystemFontOfSize:18.f]);
    _cancelButtonNumberOfLines              = (kLGAlertViewCancelButtonNumberOfLines != NSNotFound ? kLGAlertViewCancelButtonNumberOfLines : 1);
    _cancelButtonLineBreakMode              = (kLGAlertViewCancelButtonLineBreakMode != NSNotFound ? kLGAlertViewCancelButtonLineBreakMode : NSLineBreakByTruncatingMiddle);
    _cancelButtonAdjustsFontSizeToFitWidth  = (kLGAlertViewCancelButtonAdjustsFontSizeToFitWidth ? kLGAlertViewCancelButtonAdjustsFontSizeToFitWidth.boolValue : YES);
    _cancelButtonMinimumScaleFactor         = (kLGAlertViewCancelButtonMinimumScaleFactor != NSNotFound ? kLGAlertViewCancelButtonMinimumScaleFactor : 14.f/18.f);
    _cancelButtonBackgroundColor            = (kLGAlertViewCancelButtonBackgroundColor ? kLGAlertViewCancelButtonBackgroundColor : nil);
    _cancelButtonBackgroundColorHighlighted = (kLGAlertViewCancelButtonBackgroundColorHighlighted ? kLGAlertViewCancelButtonBackgroundColorHighlighted : _tintColor);
    _cancelButtonBackgroundColorDisabled    = (kLGAlertViewCancelButtonBackgroundColorDisabled ? kLGAlertViewCancelButtonBackgroundColorDisabled : nil);
    _cancelButtonEnabled                    = YES;

    _destructiveButtonTitleColor                 = (kLGAlertViewDestructiveButtonTitleColor ? kLGAlertViewDestructiveButtonTitleColor : [UIColor redColor]);
    _destructiveButtonTitleColorHighlighted      = (kLGAlertViewDestructiveButtonTitleColorHighlighted ? kLGAlertViewDestructiveButtonTitleColorHighlighted : [UIColor whiteColor]);
    _destructiveButtonTitleColorDisabled         = (kLGAlertViewDestructiveButtonTitleColorDisabled ? kLGAlertViewDestructiveButtonTitleColorDisabled : [UIColor grayColor]);
    _destructiveButtonTextAlignment              = (kLGAlertViewDestructiveButtonTextAlignment != NSNotFound ? kLGAlertViewDestructiveButtonTextAlignment : NSTextAlignmentCenter);
    _destructiveButtonFont                       = (kLGAlertViewDestructiveButtonFont ? kLGAlertViewDestructiveButtonFont : [UIFont systemFontOfSize:18.f]);
    _destructiveButtonNumberOfLines              = (kLGAlertViewDestructiveButtonNumberOfLines != NSNotFound ? kLGAlertViewDestructiveButtonNumberOfLines : 1);
    _destructiveButtonLineBreakMode              = (kLGAlertViewDestructiveButtonLineBreakMode != NSNotFound ? kLGAlertViewDestructiveButtonLineBreakMode : NSLineBreakByTruncatingMiddle);
    _destructiveButtonAdjustsFontSizeToFitWidth  = (kLGAlertViewDestructiveButtonAdjustsFontSizeToFitWidth ? kLGAlertViewDestructiveButtonAdjustsFontSizeToFitWidth.boolValue : YES);
    _destructiveButtonMinimumScaleFactor         = (kLGAlertViewDestructiveButtonMinimumScaleFactor != NSNotFound ? kLGAlertViewDestructiveButtonMinimumScaleFactor : 14.f/18.f);
    _destructiveButtonBackgroundColor            = (kLGAlertViewDestructiveButtonBackgroundColor ? kLGAlertViewDestructiveButtonBackgroundColor : nil);
    _destructiveButtonBackgroundColorHighlighted = (kLGAlertViewDestructiveButtonBackgroundColorHighlighted ? kLGAlertViewDestructiveButtonBackgroundColorHighlighted : [UIColor redColor]);
    _destructiveButtonBackgroundColorDisabled    = (kLGAlertViewDestructiveButtonBackgroundColorDisabled ? kLGAlertViewDestructiveButtonBackgroundColorDisabled : nil);
    _destructiveButtonEnabled                    = YES;

    _activityIndicatorViewStyle = (kLGAlertViewActivityIndicatorViewStyle != NSNotFound ? kLGAlertViewActivityIndicatorViewStyle : UIActivityIndicatorViewStyleWhiteLarge);
    _activityIndicatorViewColor = (kLGAlertViewActivityIndicatorViewColor ? kLGAlertViewActivityIndicatorViewColor : _tintColor);

    _progressViewProgressTintColor = (kLGAlertViewProgressViewProgressTintColor ? kLGAlertViewProgressViewProgressTintColor : _tintColor);
    _progressViewTrackTintColor    = (kLGAlertViewProgressViewTrackTintColor ? kLGAlertViewProgressViewTrackTintColor : [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.f]);
    _progressViewProgressImage     = (kLGAlertViewProgressViewProgressImage ? kLGAlertViewProgressViewProgressImage : nil);
    _progressViewTrackImage        = (kLGAlertViewProgressViewTrackImage ? kLGAlertViewProgressViewTrackImage : nil);
    _progressLabelTextColor        = (kLGAlertViewProgressLabelTextColor ? kLGAlertViewProgressLabelTextColor : [UIColor blackColor]);
    _progressLabelTextAlignment    = (kLGAlertViewProgressLabelTextAlignment != NSNotFound ? kLGAlertViewProgressLabelTextAlignment : NSTextAlignmentCenter);
    _progressLabelFont             = (kLGAlertViewProgressLabelFont ? kLGAlertViewProgressLabelFont : [UIFont systemFontOfSize:14.f]);

    _separatorsColor               = (kLGAlertViewSeparatorsColor ? kLGAlertViewSeparatorsColor : [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.f]);
    _indicatorStyle                = (kLGAlertViewIndicatorStyle ? kLGAlertViewIndicatorStyle : UIScrollViewIndicatorStyleBlack);
    _showsVerticalScrollIndicator  = (kLGAlertViewShowsVerticalScrollIndicator ? kLGAlertViewShowsVerticalScrollIndicator.boolValue : NO);
    _padShowsActionSheetFromBottom = (kLGAlertViewPadShowActionSheetFromBottom ? kLGAlertViewPadShowActionSheetFromBottom.boolValue : NO);
    _oneRowOneButton               = (kLGAlertViewOneRowOneButton ? kLGAlertViewOneRowOneButton.boolValue : NO);

    self.colorful = (kLGAlertViewColorful ? kLGAlertViewColorful.boolValue : YES);

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

    _viewController = [[LGAlertViewController alloc] initWithAlertView:self view:_view];

    _window = [[LGAlertViewWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.hidden = YES;
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
    NSUInteger windowIndex = [kLGAlertViewWindowsArray indexOfObject:_window];

    //NSLog(@"windowVisibleChanged: %@", notification);

    UIWindow *windowNotif = notification.object;

    //NSLog(@"%@", NSStringFromClass([window class]));

    if ([NSStringFromClass([windowNotif class]) isEqualToString:@"UITextEffectsWindow"] ||
        [NSStringFromClass([windowNotif class]) isEqualToString:@"UIRemoteKeyboardWindow"] ||
        [NSStringFromClass([windowNotif class]) isEqualToString:@"LGAlertViewWindow"] ||
        [windowNotif isEqual:_window]) return;

    if (notification.name == UIWindowDidBecomeVisibleNotification)
    {
        if ([windowNotif isEqual:kLGAlertViewWindowPrevious(windowIndex)])
        {
            windowNotif.hidden = YES;

            [_window makeKeyAndVisible];
        }
        else if (!kLGAlertViewWindowNext(windowIndex))
        {
            _window.hidden = YES;

            [kLGAlertViewWindowsArray addObject:windowNotif];
        }
    }
    else if (notification.name == UIWindowDidBecomeHiddenNotification)
    {
        if ([windowNotif isEqual:kLGAlertViewWindowNext(windowIndex)] && [windowNotif isEqual:kLGAlertViewWindowsArray.lastObject])
        {
            [_window makeKeyAndVisible];

            [kLGAlertViewWindowsArray removeLastObject];
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

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.isCancelOnTouch;
}

#pragma mark - Setters and Getters

- (void)setColorful:(BOOL)colorful
{
    _colorful = colorful;

    if (!self.isUserButtonsTitleColorHighlighted && !kLGAlertViewButtonsTitleColorHighlighted)
        _buttonsTitleColorHighlighted = (colorful ? [UIColor whiteColor] : _buttonsTitleColorHighlighted);
    if (!self.isUserButtonsBackgroundColorHighlighted && !kLGAlertViewButtonsBackgroundColorHighlighted)
        _buttonsBackgroundColorHighlighted = (colorful ? _tintColor : [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.f]);

    if (!self.isUserCancelButtonTitleColorHighlighted && !kLGAlertViewCancelButtonTitleColorHighlighted)
        _cancelButtonTitleColorHighlighted = (colorful ? [UIColor whiteColor] : _cancelButtonTitleColorHighlighted);
    if (!self.isUserCancelButtonBackgroundColorHighlighted && !kLGAlertViewCancelButtonBackgroundColorHighlighted)
        _cancelButtonBackgroundColorHighlighted = (colorful ? _tintColor : [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.f]);

    if (!self.isUserDestructiveButtonTitleColorHighlighted && !kLGAlertViewDestructiveButtonTitleColorHighlighted)
        _destructiveButtonTitleColorHighlighted = (colorful ? [UIColor whiteColor] : _destructiveButtonTitleColorHighlighted);
    if (!self.isUserDestructiveButtonBackgroundColorHighlighted && !kLGAlertViewDestructiveButtonBackgroundColorHighlighted)
        _destructiveButtonBackgroundColorHighlighted = (colorful ? [UIColor redColor] : [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.f]);
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;

    if (!self.isUserButtonsTitleColor && !kLGAlertViewButtonsTitleColor)
        _buttonsTitleColor = tintColor;
    if (!self.isUserCancelButtonTitleColor && !kLGAlertViewCancelButtonTitleColor)
        _cancelButtonTitleColor = tintColor;

    if (!self.isColorful)
    {
        if (!self.isUserButtonsTitleColorHighlighted && !kLGAlertViewButtonsTitleColorHighlighted)
            _buttonsTitleColorHighlighted = tintColor;
        if (!self.isUserCancelButtonTitleColorHighlighted && !kLGAlertViewCancelButtonTitleColorHighlighted)
            _cancelButtonTitleColorHighlighted = tintColor;
    }

    if (!self.isUserButtonsBackgroundColorHighlighted && !kLGAlertViewButtonsBackgroundColorHighlighted)
        _buttonsBackgroundColorHighlighted = tintColor;
    if (!self.isUserCancelButtonBackgroundColorHighlighted && !kLGAlertViewCancelButtonBackgroundColorHighlighted)
        _cancelButtonBackgroundColorHighlighted = tintColor;

    if (!self.isUserActivityIndicatorViewColor && !kLGAlertViewActivityIndicatorViewColor)
        _activityIndicatorViewColor = tintColor;
    if (!self.isUserProgressViewProgressTintColor && !kLGAlertViewProgressViewProgressTintColor)
        _progressViewProgressTintColor = tintColor;
}

- (void)setButtonsHeight:(CGFloat)buttonsHeight
{
    NSAssert(buttonsHeight >= 0, @"Buttons height can not be less then 0.f");

    _buttonsHeight = buttonsHeight;
}

- (void)setTextFieldsHeight:(CGFloat)textFieldsHeight
{
    NSAssert(textFieldsHeight >= 0, @"Text fields height can not be less then 0.f");

    _textFieldsHeight = textFieldsHeight;
}

- (void)setButtonsTitleColor:(UIColor *)buttonsTitleColor
{
    _buttonsTitleColor = buttonsTitleColor;

    _userButtonsTitleColor = YES;
}

- (void)setButtonsTitleColorHighlighted:(UIColor *)buttonsTitleColorHighlighted
{
    _buttonsTitleColorHighlighted = buttonsTitleColorHighlighted;

    _userButtonsTitleColorHighlighted = YES;
}

- (void)setButtonsBackgroundColorHighlighted:(UIColor *)buttonsBackgroundColorHighlighted
{
    _buttonsBackgroundColorHighlighted = buttonsBackgroundColorHighlighted;

    _userButtonsBackgroundColorHighlighted = YES;
}

- (void)setCancelButtonTitleColor:(UIColor *)cancelButtonTitleColor
{
    _cancelButtonTitleColor = cancelButtonTitleColor;

    _userCancelButtonTitleColor = YES;
}

- (void)setCancelButtonTitleColorHighlighted:(UIColor *)cancelButtonTitleColorHighlighted
{
    _cancelButtonTitleColorHighlighted = cancelButtonTitleColorHighlighted;

    _userCancelButtonTitleColorHighlighted = YES;
}

- (void)setCancelButtonBackgroundColorHighlighted:(UIColor *)cancelButtonBackgroundColorHighlighted
{
    _cancelButtonBackgroundColorHighlighted = cancelButtonBackgroundColorHighlighted;

    _userCancelButtonBackgroundColorHighlighted = YES;
}

- (void)setDestructiveButtonTitleColorHighlighted:(UIColor *)destructiveButtonTitleColorHighlighted
{
    _destructiveButtonTitleColorHighlighted = destructiveButtonTitleColorHighlighted;

    _userDestructiveButtonTitleColorHighlighted = YES;
}

- (void)setDestructiveButtonBackgroundColorHighlighted:(UIColor *)destructiveButtonBackgroundColorHighlighted
{
    _destructiveButtonBackgroundColorHighlighted = destructiveButtonBackgroundColorHighlighted;

    _userDestructiveButtonBackgroundColorHighlighted = YES;
}

- (void)setActivityIndicatorViewColor:(UIColor *)activityIndicatorViewColor
{
    _activityIndicatorViewColor = activityIndicatorViewColor;

    _userActivityIndicatorViewColor = YES;
}

- (void)setProgressViewProgressTintColor:(UIColor *)progressViewProgressTintColor
{
    _progressViewProgressTintColor = progressViewProgressTintColor;

    _userProgressViewProgressTintColor = YES;
}

- (void)setWidth:(CGFloat)width
{
    NSAssert(width >= 0, @"LGAlertView width can not be less then 0.f");

    _width = width;
}

- (BOOL)isShowing
{
    return (_showing && _window.isKeyWindow && !_window.isHidden);
}

#pragma mark -

- (void)setProgress:(float)progress progressLabelText:(NSString *)progressLabelText
{
    if (_type == LGAlertViewTypeProgressView)
    {
        [_progressView setProgress:progress animated:YES];

        _progressLabel.text = progressLabelText;
    }
}

- (float)progress
{
    float progress = 0.f;

    if (_type == LGAlertViewTypeProgressView)
        progress = _progressView.progress;

    return progress;
}

- (void)setButtonAtIndex:(NSUInteger)index enabled:(BOOL)enabled
{
    if (_buttonTitles.count > index)
    {
        _buttonsEnabledArray[index] = [NSNumber numberWithBool:enabled];

        if (_tableView)
        {
            if (_destructiveButtonTitle.length)
                index++;

            LGAlertViewCell *cell = (LGAlertViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            cell.enabled = enabled;
        }
        else if (_scrollView)
        {
            switch (index)
            {
                case 0:
                    _firstButton.enabled = enabled;
                    break;
                case 1:
                    _secondButton.enabled = enabled;
                    break;
                case 2:
                    _thirdButton.enabled = enabled;
                    break;
                default:
                    break;
            }
        }
    }
}

- (void)setCancelButtonEnabled:(BOOL)cancelButtonEnabled
{
    _cancelButtonEnabled = cancelButtonEnabled;

    if (_cancelButtonTitle.length)
    {
        if (_tableView)
        {
            LGAlertViewCell *cell = (LGAlertViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(_buttonTitles.count-1) inSection:0]];
            cell.enabled = cancelButtonEnabled;
        }
        else if (_scrollView)
            _cancelButton.enabled = cancelButtonEnabled;
    }
}

- (void)setDestructiveButtonEnabled:(BOOL)destructiveButtonEnabled
{
    _destructiveButtonEnabled = destructiveButtonEnabled;

    if (_destructiveButtonTitle.length)
    {
        if (_tableView)
        {
            LGAlertViewCell *cell = (LGAlertViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.enabled = destructiveButtonEnabled;
        }
        else if (_scrollView)
            _destructiveButton.enabled = destructiveButtonEnabled;
    }
}

- (BOOL)isButtonEnabledAtIndex:(NSUInteger)index
{
    return [_buttonsEnabledArray[index] boolValue];
}

- (void)setButtonPropertiesAtIndex:(NSUInteger)index
                           handler:(void(^)(LGAlertViewButtonProperties *properties))handler;
{
    if (handler && _buttonTitles.count > index)
    {
        if (!_buttonsPropertiesDictionary)
            _buttonsPropertiesDictionary = [NSMutableDictionary new];

        LGAlertViewButtonProperties *properties = _buttonsPropertiesDictionary[[NSNumber numberWithInteger:index]];
        if (!properties) properties = [LGAlertViewButtonProperties new];

        handler(properties);

        if (properties.isUserEnabled)
            _buttonsEnabledArray[index] = [NSNumber numberWithBool:properties.enabled];

        [_buttonsPropertiesDictionary setObject:properties forKey:[NSNumber numberWithInteger:index]];
    }
}

- (void)forceCancel
{
    NSAssert(_cancelButtonTitle.length > 0, @"Cancel button is not exists");

    [self cancelAction:nil];
}

- (void)forceDestructive
{
    NSAssert(_destructiveButtonTitle.length > 0, @"Destructive button is not exists");

    [self destructiveAction:nil];
}

- (void)forceActionAtIndex:(NSUInteger)index
{
    NSAssert(_buttonTitles.count > index, @"Button at index %lu is not exists", (long unsigned)index);

    [self actionActionAtIndex:index title:_buttonTitles[index + (_tableView && _destructiveButtonTitle.length ? 1 : 0)]];
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
        cell.titleColorDisabled         = _destructiveButtonTitleColorDisabled;
        cell.backgroundColorNormal      = _destructiveButtonBackgroundColor;
        cell.backgroundColorHighlighted = _destructiveButtonBackgroundColorHighlighted;
        cell.backgroundColorDisabled    = _destructiveButtonBackgroundColorDisabled;
        cell.separatorVisible           = (indexPath.row != _buttonTitles.count-1);
        cell.separatorColor_            = _separatorsColor;
        cell.textAlignment              = _destructiveButtonTextAlignment;
        cell.font                       = _destructiveButtonFont;
        cell.numberOfLines              = _destructiveButtonNumberOfLines;
        cell.lineBreakMode              = _destructiveButtonLineBreakMode;
        cell.adjustsFontSizeToFitWidth  = _destructiveButtonAdjustsFontSizeToFitWidth;
        cell.minimumScaleFactor         = _destructiveButtonMinimumScaleFactor;
        cell.enabled                    = _destructiveButtonEnabled;
    }
    else if (_cancelButtonTitle.length && !kLGAlertViewIsCancelButtonSeparate(self) && indexPath.row == _buttonTitles.count-1)
    {
        cell.titleColor                 = _cancelButtonTitleColor;
        cell.titleColorHighlighted      = _cancelButtonTitleColorHighlighted;
        cell.titleColorDisabled         = _cancelButtonTitleColorDisabled;
        cell.backgroundColorNormal      = _cancelButtonBackgroundColor;
        cell.backgroundColorHighlighted = _cancelButtonBackgroundColorHighlighted;
        cell.backgroundColorDisabled    = _cancelButtonBackgroundColorDisabled;
        cell.separatorVisible           = NO;
        cell.separatorColor_            = _separatorsColor;
        cell.textAlignment              = _cancelButtonTextAlignment;
        cell.font                       = _cancelButtonFont;
        cell.numberOfLines              = _cancelButtonNumberOfLines;
        cell.lineBreakMode              = _cancelButtonLineBreakMode;
        cell.adjustsFontSizeToFitWidth  = _cancelButtonAdjustsFontSizeToFitWidth;
        cell.minimumScaleFactor         = _cancelButtonMinimumScaleFactor;
        cell.enabled                    = _cancelButtonEnabled;
    }
    else
    {
        LGAlertViewButtonProperties *properties = nil;
        if (_buttonsPropertiesDictionary)
            properties = _buttonsPropertiesDictionary[[NSNumber numberWithInteger:(indexPath.row - (_destructiveButtonTitle.length ? 1 : 0))]];

        cell.titleColor                 = (properties.isUserTitleColor ? properties.titleColor : _buttonsTitleColor);
        cell.titleColorHighlighted      = (properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : _buttonsTitleColorHighlighted);
        cell.titleColorDisabled         = (properties.isUserTitleColorDisabled ? properties.titleColorDisabled : _buttonsTitleColorDisabled);
        cell.backgroundColorNormal      = (properties.isUserBackgroundColor ? properties.backgroundColor : _buttonsBackgroundColor);
        cell.backgroundColorHighlighted = (properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : _buttonsBackgroundColorHighlighted);
        cell.backgroundColorDisabled    = (properties.isUserBackgroundColorDisabled ? properties.backgroundColorDisabled : _buttonsBackgroundColorDisabled);
        cell.separatorVisible           = (indexPath.row != _buttonTitles.count-1);
        cell.separatorColor_            = _separatorsColor;
        cell.textAlignment              = (properties.isUserTextAlignment ? properties.textAlignment : _buttonsTextAlignment);
        cell.font                       = (properties.isUserFont ? properties.font : _buttonsFont);
        cell.numberOfLines              = (properties.isUserNumberOfLines ? properties.numberOfLines : _buttonsNumberOfLines);
        cell.lineBreakMode              = (properties.isUserLineBreakMode ? properties.lineBreakMode : _buttonsLineBreakMode);
        cell.adjustsFontSizeToFitWidth  = (properties.isUserAdjustsFontSizeTofitWidth ? properties.adjustsFontSizeToFitWidth : _buttonsAdjustsFontSizeToFitWidth);
        cell.minimumScaleFactor         = (properties.isUserMinimimScaleFactor ? properties.minimumScaleFactor : _buttonsMinimumScaleFactor);
        cell.enabled                    = [_buttonsEnabledArray[indexPath.row - (_destructiveButtonTitle.length ? 1 : 0)] boolValue];
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

        CGSize size = [label sizeThatFits:CGSizeMake(tableView.frame.size.width-kLGAlertViewPaddingW*2, CGFLOAT_MAX)];
        size.height += kLGAlertViewButtonTitleMarginH*2;

        if (size.height < _buttonsHeight)
            size.height = _buttonsHeight;

        return size.height;
    }
    else if (_cancelButtonTitle.length && !kLGAlertViewIsCancelButtonSeparate(self) && indexPath.row == _buttonTitles.count-1 && _cancelButtonNumberOfLines != 1)
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

        CGSize size = [label sizeThatFits:CGSizeMake(tableView.frame.size.width-kLGAlertViewPaddingW*2, CGFLOAT_MAX)];
        size.height += kLGAlertViewButtonTitleMarginH*2;

        if (size.height < _buttonsHeight)
            size.height = _buttonsHeight;

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

        CGSize size = [label sizeThatFits:CGSizeMake(tableView.frame.size.width-kLGAlertViewPaddingW*2, CGFLOAT_MAX)];
        size.height += kLGAlertViewButtonTitleMarginH*2;

        if (size.height < _buttonsHeight)
            size.height = _buttonsHeight;

        return size.height;
    }
    else return _buttonsHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_destructiveButtonTitle.length && indexPath.row == 0)
    {
        [self destructiveAction:nil];
    }
    else if (_cancelButtonTitle.length && indexPath.row == _buttonTitles.count-1 && !kLGAlertViewIsCancelButtonSeparate(self))
    {
        [self cancelAction:nil];
    }
    else
    {
        NSUInteger index = indexPath.row;
        if (_destructiveButtonTitle.length) index--;

        NSString *title = _buttonTitles[indexPath.row];

        // -----

        [self actionActionAtIndex:index title:title];
    }
}

#pragma mark -

- (void)showAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler
{
    [self showAnimated:animated hidden:NO completionHandler:completionHandler];
}

- (void)showAnimated:(BOOL)animated hidden:(BOOL)hidden completionHandler:(void(^)())completionHandler
{
    if (_showing) return;

    _window.windowLevel = UIWindowLevelStatusBar + (_windowLevel == LGAlertViewWindowLevelAboveStatusBar ? 1 : -1);
    _view.userInteractionEnabled = NO;

    CGSize size = _viewController.view.bounds.size;

    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
    {
        if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
            size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
        else
            size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));

        _viewController.view.frame = CGRectMake(0.f, 0.f, size.width, size.height);
    }

    [self subviewsInvalidateWithSize:size];
    [self layoutInvalidateWithSize:size];

    _showing = YES;

    if (![kLGAlertViewArray containsObject:self])
        [kLGAlertViewArray addObject:self];

    // -----

    [self addObservers];

    // -----

    UIWindow *windowApp = [UIApplication sharedApplication].delegate.window;
    NSAssert(windowApp != nil, @"Application needs to have at least one window");

    UIWindow *windowKey = [UIApplication sharedApplication].keyWindow;
    NSAssert(windowKey != nil, @"Application needs to have at least one key and visible window");

    if (!kLGAlertViewWindowsArray.count)
        [kLGAlertViewWindowsArray addObject:windowApp];

    if (![windowKey isEqual:windowApp])
        if (![kLGAlertViewWindowsArray containsObject:windowKey])
            [kLGAlertViewWindowsArray addObject:windowKey];

    if (![kLGAlertViewWindowsArray containsObject:_window])
        [kLGAlertViewWindowsArray addObject:_window];

    if (!hidden)
    {
        if (![windowKey isEqual:windowApp])
            windowKey.hidden = YES;
    }

    [_window makeKeyAndVisible];

    // -----

    if (_willShowHandler) _willShowHandler(self);

    if (_delegate && [_delegate respondsToSelector:@selector(alertViewWillShow:)])
        [_delegate alertViewWillShow:self];

    [[NSNotificationCenter defaultCenter] postNotificationName:kLGAlertViewWillShowNotification object:self userInfo:nil];

    // -----

    if (hidden)
    {
        _backgroundView.hidden = YES;
        _scrollView.hidden = YES;
        _styleView.hidden = YES;

        if (kLGAlertViewIsCancelButtonSeparate(self))
        {
            _cancelButton.hidden = YES;
            _styleCancelView.hidden = YES;
        }
    }

    // -----

    if (animated)
    {
        [LGAlertView animateStandardWithAnimations:^(void)
         {
             [self showAnimations];
         }
                                        completion:^(BOOL finished)
         {
             if (!hidden)
                 [self showComplete];

             if (completionHandler) completionHandler();
         }];
    }
    else
    {
        [self showAnimations];

        if (!hidden)
            [self showComplete];

        if (completionHandler) completionHandler();
    }
}

- (void)showAnimations
{
    _backgroundView.alpha = 1.f;

    if (_style == LGAlertViewStyleAlert || kLGAlertViewPadAndNotForce(self))
    {
        _scrollView.transform = CGAffineTransformIdentity;
        _scrollView.alpha = 1.f;

        _styleView.transform = CGAffineTransformIdentity;
        _styleView.alpha = 1.f;
    }
    else
    {
        _scrollView.center = _scrollViewCenterShowed;

        _styleView.center = _scrollViewCenterShowed;
    }

    if (kLGAlertViewIsCancelButtonSeparate(self) && _cancelButton)
    {
        _cancelButton.center = _cancelButtonCenterShowed;

        _styleCancelView.center = _cancelButtonCenterShowed;
    }
}

- (void)showComplete
{
    if (_type == LGAlertViewTypeTextFields && _textFieldsArray.count)
        [_textFieldsArray[0] becomeFirstResponder];

    // -----

    if (_didShowHandler) _didShowHandler(self);

    if (_delegate && [_delegate respondsToSelector:@selector(alertViewDidShow:)])
        [_delegate alertViewDidShow:self];

    [[NSNotificationCenter defaultCenter] postNotificationName:kLGAlertViewDidShowNotification object:self userInfo:nil];

    // -----

    _view.userInteractionEnabled = YES;
}

- (void)dismissAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler
{
    if (!_showing) return;

    _view.userInteractionEnabled = NO;

    _showing = NO;

    [self removeObservers];

    [_view endEditing:YES];

    // -----

    if (_willDismissHandler) _willDismissHandler(self);

    if (_delegate && [_delegate respondsToSelector:@selector(alertViewWillDismiss:)])
        [_delegate alertViewWillDismiss:self];

    [[NSNotificationCenter defaultCenter] postNotificationName:kLGAlertViewWillDismissNotification object:self userInfo:nil];

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

    if (_style == LGAlertViewStyleAlert || kLGAlertViewPadAndNotForce(self))
    {
        _scrollView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        _scrollView.alpha = 0.f;

        _styleView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        _styleView.alpha = 0.f;
    }
    else
    {
        _scrollView.center = _scrollViewCenterHidden;

        _styleView.center = _scrollViewCenterHidden;
    }

    if (kLGAlertViewIsCancelButtonSeparate(self) && _cancelButton)
    {
        _cancelButton.center = _cancelButtonCenterHidden;

        _styleCancelView.center = _cancelButtonCenterHidden;
    }
}

- (void)dismissComplete
{
    _window.hidden = YES;

    if ([kLGAlertViewWindowsArray.lastObject isEqual:_window])
    {
        NSUInteger windowIndex = [kLGAlertViewWindowsArray indexOfObject:_window];

        [kLGAlertViewWindowPrevious(windowIndex) makeKeyAndVisible];
    }

    // -----

    if (_didDismissHandler) _didDismissHandler(self);

    if (_delegate && [_delegate respondsToSelector:@selector(alertViewDidDismiss:)])
        [_delegate alertViewDidDismiss:self];

    [[NSNotificationCenter defaultCenter] postNotificationName:kLGAlertViewDidDismissNotification object:self userInfo:nil];

    // -----

    if ([kLGAlertViewWindowsArray containsObject:_window])
        [kLGAlertViewWindowsArray removeObject:_window];

    if ([kLGAlertViewArray containsObject:self])
        [kLGAlertViewArray removeObject:self];

    _view = nil;
    _viewController = nil;
    _window = nil;
    _delegate = nil;
}

- (void)transitionToAlertView:(LGAlertView *)alertView completionHandler:(void(^)())completionHandler
{
    _view.userInteractionEnabled = NO;

    [alertView showAnimated:NO
                     hidden:YES
          completionHandler:^(void)
     {
         NSTimeInterval duration = 0.3;

         BOOL cancelButtonSelf = kLGAlertViewIsCancelButtonSeparate(self) && _cancelButtonTitle.length;
         BOOL cancelButtonNext = kLGAlertViewIsCancelButtonSeparate(alertView) && alertView.cancelButtonTitle.length;

         // -----

         [UIView animateWithDuration:duration
                          animations:^(void)
          {
              _scrollView.alpha = 0.f;

              if (cancelButtonSelf)
              {
                  _cancelButton.alpha = 0.f;

                  if (!cancelButtonNext)
                      _styleCancelView.alpha = 0.f;
              }
          }
                          completion:^(BOOL finished)
          {
              alertView.backgroundView.alpha = 0.f;
              alertView.backgroundView.hidden = NO;

              [UIView animateWithDuration:duration*2.f
                               animations:^(void)
               {
                   _backgroundView.alpha = 0.f;
                   alertView.backgroundView.alpha = 1.f;
               }];

              // -----

              CGRect styleViewFrame = alertView.styleView.frame;

              alertView.styleView.frame = _styleView.frame;

              alertView.styleView.hidden = NO;
              _styleView.hidden = YES;

              // -----

              if (cancelButtonNext)
              {
                  alertView.styleCancelView.hidden = NO;

                  if (!cancelButtonSelf)
                      alertView.styleCancelView.alpha = 0.f;
              }

              // -----

              if (cancelButtonSelf && cancelButtonNext)
                  _styleCancelView.hidden = YES;

              // -----

              [UIView animateWithDuration:duration
                               animations:^(void)
               {
                   alertView.styleView.frame = styleViewFrame;
               }
                               completion:^(BOOL finished)
               {
                   alertView.scrollView.alpha = 0.f;
                   alertView.scrollView.hidden = NO;

                   if (cancelButtonNext)
                   {
                       alertView.cancelButton.alpha = 0.f;
                       alertView.cancelButton.hidden = NO;
                   }

                   [UIView animateWithDuration:duration
                                    animations:^(void)
                    {
                        _scrollView.alpha = 0.f;
                        alertView.scrollView.alpha = 1.f;

                        if (cancelButtonNext)
                        {
                            alertView.cancelButton.alpha = 1.f;

                            if (!cancelButtonSelf)
                                alertView.styleCancelView.alpha = 1.f;
                        }
                    }
                                    completion:^(BOOL finished)
                    {
                        [self dismissAnimated:NO
                            completionHandler:^(void)
                         {
                             [alertView showComplete];

                             if (completionHandler) completionHandler();
                         }];
                    }];
               }];
          }];
     }];
}

#pragma mark -

- (void)subviewsInvalidateWithSize:(CGSize)size
{
    CGFloat width = 0.f;

    if (_width != NSNotFound)
    {
        width = MIN(size.width, size.height);

        if (_width < width) width = _width;
    }
    else
    {
        if (_style == LGAlertViewStyleAlert)
            width = kLGAlertViewWidthStyleAlert;
        else
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                width = kLGAlertViewWidthStyleActionSheet;
            else
                width = MIN(size.width, size.height)-kLGAlertViewOffsetH*2;
        }
    }

    // -----

    if (!self.isExists)
    {
        _exists = YES;

        _backgroundView.backgroundColor = _coverColor;

        _styleView = [UIView new];
        _styleView.backgroundColor = _backgroundColor;
        _styleView.layer.masksToBounds = NO;
        _styleView.layer.cornerRadius = _layerCornerRadius+(_layerCornerRadius == 0.f ? 0.f : _layerBorderWidth+1.f);
        _styleView.layer.borderColor = _layerBorderColor.CGColor;
        _styleView.layer.borderWidth = _layerBorderWidth;
        _styleView.layer.shadowColor = _layerShadowColor.CGColor;
        _styleView.layer.shadowRadius = _layerShadowRadius;
        _styleView.layer.shadowOpacity = _layerShadowOpacity;
        _styleView.layer.shadowOffset = _layerShadowOffset;
        [_view addSubview:_styleView];

        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.indicatorStyle = _indicatorStyle;
        _scrollView.showsVerticalScrollIndicator = _showsVerticalScrollIndicator;
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

            CGSize titleLabelSize = [_titleLabel sizeThatFits:CGSizeMake(width-kLGAlertViewPaddingW*2, CGFLOAT_MAX)];
            CGRect titleLabelFrame = CGRectMake(kLGAlertViewPaddingW, kLGAlertViewInnerMarginH, width-kLGAlertViewPaddingW*2, titleLabelSize.height);
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
            else if (_style == LGAlertViewStyleActionSheet) offsetY -= kLGAlertViewInnerMarginH/3;

            CGSize messageLabelSize = [_messageLabel sizeThatFits:CGSizeMake(width-kLGAlertViewPaddingW*2, CGFLOAT_MAX)];
            CGRect messageLabelFrame = CGRectMake(kLGAlertViewPaddingW, offsetY+kLGAlertViewInnerMarginH/2, width-kLGAlertViewPaddingW*2, messageLabelSize.height);
            if ([UIScreen mainScreen].scale == 1.f)
                messageLabelFrame = CGRectIntegral(messageLabelFrame);

            _messageLabel.frame = messageLabelFrame;
            [_scrollView addSubview:_messageLabel];

            offsetY = _messageLabel.frame.origin.y+_messageLabel.frame.size.height;
        }

        if (_innerView)
        {
            CGRect innerViewFrame = CGRectMake(width/2-_innerView.frame.size.width/2, offsetY+kLGAlertViewInnerMarginH, _innerView.frame.size.width, _innerView.frame.size.height);
            if ([UIScreen mainScreen].scale == 1.f)
                innerViewFrame = CGRectIntegral(innerViewFrame);

            _innerView.frame = innerViewFrame;
            [_scrollView addSubview:_innerView];

            offsetY = _innerView.frame.origin.y+_innerView.frame.size.height;
        }
        else if (_type == LGAlertViewTypeActivityIndicator)
        {
            _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:_activityIndicatorViewStyle];
            _activityIndicator.color = _activityIndicatorViewColor;
            _activityIndicator.backgroundColor = [UIColor clearColor];
            [_activityIndicator startAnimating];

            CGRect activityIndicatorFrame = CGRectMake(width/2-_activityIndicator.frame.size.width/2, offsetY+kLGAlertViewInnerMarginH, _activityIndicator.frame.size.width, _activityIndicator.frame.size.height);
            if ([UIScreen mainScreen].scale == 1.f)
                activityIndicatorFrame = CGRectIntegral(activityIndicatorFrame);

            _activityIndicator.frame = activityIndicatorFrame;
            [_scrollView addSubview:_activityIndicator];

            offsetY = _activityIndicator.frame.origin.y+_activityIndicator.frame.size.height;
        }
        else if (_type == LGAlertViewTypeProgressView)
        {
            _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
            _progressView.backgroundColor = [UIColor clearColor];
            _progressView.progressTintColor = _progressViewProgressTintColor;
            _progressView.trackTintColor = _progressViewTrackTintColor;
            if (_progressViewProgressImage)
                _progressView.progressImage = _progressViewProgressImage;
            if (_progressViewTrackImage)
                _progressView.trackImage = _progressViewTrackImage;

            CGRect progressViewFrame = CGRectMake(kLGAlertViewPaddingW, offsetY+kLGAlertViewInnerMarginH, width-kLGAlertViewPaddingW*2, _progressView.frame.size.height);
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

            CGSize progressLabelSize = [_progressLabel sizeThatFits:CGSizeMake(width-kLGAlertViewPaddingW*2, CGFLOAT_MAX)];
            CGRect progressLabelFrame = CGRectMake(kLGAlertViewPaddingW, offsetY+kLGAlertViewInnerMarginH/2, width-kLGAlertViewPaddingW*2, progressLabelSize.height);
            if ([UIScreen mainScreen].scale == 1.f)
                progressLabelFrame = CGRectIntegral(progressLabelFrame);

            _progressLabel.frame = progressLabelFrame;
            [_scrollView addSubview:_progressLabel];

            offsetY = _progressLabel.frame.origin.y+_progressLabel.frame.size.height;
        }
        else if (_type == LGAlertViewTypeTextFields)
        {
            for (NSUInteger i=0; i<_textFieldsArray.count; i++)
            {
                UIView *separatorView = _textFieldSeparatorsArray[i];
                separatorView.backgroundColor = _separatorsColor;

                CGRect separatorViewFrame = CGRectMake(0.f, offsetY+(i == 0 ? kLGAlertViewInnerMarginH : 0.f), width, kLGAlertViewSeparatorHeight);
                if ([UIScreen mainScreen].scale == 1.f)
                    separatorViewFrame = CGRectIntegral(separatorViewFrame);

                separatorView.frame = separatorViewFrame;
                [_scrollView addSubview:separatorView];

                offsetY = separatorView.frame.origin.y+separatorView.frame.size.height;

                // -----

                LGAlertViewTextField *textField = _textFieldsArray[i];

                CGRect textFieldFrame = CGRectMake(0.f, offsetY, width, _textFieldsHeight);
                if ([UIScreen mainScreen].scale == 1.f)
                    textFieldFrame = CGRectIntegral(textFieldFrame);

                textField.frame = textFieldFrame;
                [_scrollView addSubview:textField];

                offsetY = textField.frame.origin.y+textField.frame.size.height;
            }

            offsetY -= kLGAlertViewInnerMarginH;
        }

        // -----

        if (kLGAlertViewIsCancelButtonSeparate(self) && _cancelButtonTitle)
        {
            _styleCancelView = [UIView new];
            _styleCancelView.backgroundColor = _backgroundColor;
            _styleCancelView.layer.masksToBounds = NO;
            _styleCancelView.layer.cornerRadius = _layerCornerRadius+(_layerCornerRadius == 0.f ? 0.f : _layerBorderWidth+1.f);;
            _styleCancelView.layer.borderColor = _layerBorderColor.CGColor;
            _styleCancelView.layer.borderWidth = _layerBorderWidth;
            _styleCancelView.layer.shadowColor = _layerShadowColor.CGColor;
            _styleCancelView.layer.shadowRadius = _layerShadowRadius;
            _styleCancelView.layer.shadowOpacity = _layerShadowOpacity;
            _styleCancelView.layer.shadowOffset = _layerShadowOffset;
            [_view insertSubview:_styleCancelView belowSubview:_scrollView];

            [self cancelButtonInit];
            _cancelButton.layer.masksToBounds = YES;
            _cancelButton.layer.cornerRadius = _layerCornerRadius;
            [_view insertSubview:_cancelButton aboveSubview:_styleCancelView];
        }

        // -----

        NSUInteger numberOfButtons = _buttonTitles.count;

        if (_destructiveButtonTitle.length)
            numberOfButtons++;
        if (_cancelButtonTitle.length && !kLGAlertViewIsCancelButtonSeparate(self))
            numberOfButtons++;

        BOOL showTable = NO;

        if (numberOfButtons)
        {
            if (!self.isOneRowOneButton &&
                ((_style == LGAlertViewStyleAlert && numberOfButtons < 4) ||
                 (_style == LGAlertViewStyleActionSheet && numberOfButtons == 1)))
            {
                CGFloat buttonWidth = width/numberOfButtons;
                if (buttonWidth < kLGAlertViewButtonWidthMin)
                    showTable = YES;

                if (_destructiveButtonTitle.length && !showTable)
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
                    [_destructiveButton setTitleColor:_destructiveButtonTitleColorDisabled forState:UIControlStateDisabled];
                    [_destructiveButton setBackgroundImage:[LGAlertView image1x1WithColor:_destructiveButtonBackgroundColor] forState:UIControlStateNormal];
                    [_destructiveButton setBackgroundImage:[LGAlertView image1x1WithColor:_destructiveButtonBackgroundColorHighlighted] forState:UIControlStateHighlighted];
                    [_destructiveButton setBackgroundImage:[LGAlertView image1x1WithColor:_destructiveButtonBackgroundColorHighlighted] forState:UIControlStateSelected];
                    [_destructiveButton setBackgroundImage:[LGAlertView image1x1WithColor:_destructiveButtonBackgroundColorDisabled] forState:UIControlStateDisabled];
                    _destructiveButton.contentEdgeInsets = UIEdgeInsetsMake(kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW, kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW);
                    _destructiveButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    if (_destructiveButtonTextAlignment == NSTextAlignmentCenter)
                        _destructiveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    else if (_destructiveButtonTextAlignment == NSTextAlignmentLeft)
                        _destructiveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    else if (_destructiveButtonTextAlignment == NSTextAlignmentRight)
                        _destructiveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                    _destructiveButton.enabled = _destructiveButtonEnabled;
                    [_destructiveButton addTarget:self action:@selector(destructiveAction:) forControlEvents:UIControlEventTouchUpInside];

                    CGSize size = [_destructiveButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];

                    if (size.width > buttonWidth)
                        showTable = YES;
                }

                if (_cancelButtonTitle.length && !kLGAlertViewIsCancelButtonSeparate(self) && !showTable)
                {
                    [self cancelButtonInit];

                    CGSize size = [_cancelButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];

                    if (size.width > buttonWidth)
                        showTable = YES;
                }

                if (_buttonTitles.count > 0 && !showTable)
                {
                    LGAlertViewButtonProperties *properties = nil;
                    if (_buttonsPropertiesDictionary)
                        properties = _buttonsPropertiesDictionary[[NSNumber numberWithInteger:0]];

                    _firstButton = [UIButton new];
                    _firstButton.backgroundColor = [UIColor clearColor];
                    _firstButton.titleLabel.numberOfLines = (properties.isUserNumberOfLines ? properties.numberOfLines : _buttonsNumberOfLines);
                    _firstButton.titleLabel.lineBreakMode = (properties.isUserLineBreakMode ? properties.lineBreakMode : _buttonsLineBreakMode);
                    _firstButton.titleLabel.adjustsFontSizeToFitWidth = (properties.isAdjustsFontSizeToFitWidth ? properties.adjustsFontSizeToFitWidth : _buttonsAdjustsFontSizeToFitWidth);
                    _firstButton.titleLabel.minimumScaleFactor = (properties.isUserMinimimScaleFactor ? properties.minimumScaleFactor : _buttonsMinimumScaleFactor);
                    _firstButton.titleLabel.font = (properties.isUserFont ? properties.font : _buttonsFont);
                    [_firstButton setTitle:_buttonTitles[0] forState:UIControlStateNormal];
                    [_firstButton setTitleColor:(properties.isUserTitleColor ? properties.titleColor : _buttonsTitleColor) forState:UIControlStateNormal];
                    [_firstButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : _buttonsTitleColorHighlighted) forState:UIControlStateHighlighted];
                    [_firstButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : _buttonsTitleColorHighlighted) forState:UIControlStateSelected];
                    [_firstButton setTitleColor:(properties.isUserTitleColorDisabled ? properties.titleColorDisabled : _buttonsTitleColorDisabled) forState:UIControlStateDisabled];
                    [_firstButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColor ? properties.backgroundColor : _buttonsBackgroundColor)] forState:UIControlStateNormal];
                    [_firstButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : _buttonsBackgroundColorHighlighted)] forState:UIControlStateHighlighted];
                    [_firstButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : _buttonsBackgroundColorHighlighted)] forState:UIControlStateSelected];
                    [_firstButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorDisabled ? properties.backgroundColorDisabled : _buttonsBackgroundColorDisabled)] forState:UIControlStateDisabled];
                    _firstButton.contentEdgeInsets = UIEdgeInsetsMake(kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW, kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW);
                    _firstButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    NSTextAlignment textAlignment = (properties.isUserTextAlignment ? properties.textAlignment : _buttonsTextAlignment);
                    if (textAlignment == NSTextAlignmentCenter)
                        _firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    else if (textAlignment == NSTextAlignmentLeft)
                        _firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    else if (textAlignment == NSTextAlignmentRight)
                        _firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                    _firstButton.enabled = [_buttonsEnabledArray[0] boolValue];
                    [_firstButton addTarget:self action:@selector(firstButtonAction:) forControlEvents:UIControlEventTouchUpInside];

                    CGSize size = [_firstButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];

                    if (size.width > buttonWidth)
                        showTable = YES;

                    if (_buttonTitles.count > 1 && !showTable)
                    {
                        LGAlertViewButtonProperties *properties = nil;
                        if (_buttonsPropertiesDictionary)
                            properties = _buttonsPropertiesDictionary[[NSNumber numberWithInteger:1]];

                        _secondButton = [UIButton new];
                        _secondButton.backgroundColor = [UIColor clearColor];
                        _secondButton.titleLabel.numberOfLines = (properties.isUserNumberOfLines ? properties.numberOfLines : _buttonsNumberOfLines);
                        _secondButton.titleLabel.lineBreakMode = (properties.isUserLineBreakMode ? properties.lineBreakMode : _buttonsLineBreakMode);
                        _secondButton.titleLabel.adjustsFontSizeToFitWidth = (properties.isAdjustsFontSizeToFitWidth ? properties.adjustsFontSizeToFitWidth : _buttonsAdjustsFontSizeToFitWidth);
                        _secondButton.titleLabel.minimumScaleFactor = (properties.isUserMinimimScaleFactor ? properties.minimumScaleFactor : _buttonsMinimumScaleFactor);
                        _secondButton.titleLabel.font = (properties.isUserFont ? properties.font : _buttonsFont);
                        [_secondButton setTitle:_buttonTitles[1] forState:UIControlStateNormal];
                        [_secondButton setTitleColor:(properties.isUserTitleColor ? properties.titleColor : _buttonsTitleColor) forState:UIControlStateNormal];
                        [_secondButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : _buttonsTitleColorHighlighted) forState:UIControlStateHighlighted];
                        [_secondButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : _buttonsTitleColorHighlighted) forState:UIControlStateSelected];
                        [_secondButton setTitleColor:(properties.isUserTitleColorDisabled ? properties.titleColorDisabled : _buttonsTitleColorDisabled) forState:UIControlStateDisabled];
                        [_secondButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColor ? properties.backgroundColor : _buttonsBackgroundColor)] forState:UIControlStateNormal];
                        [_secondButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : _buttonsBackgroundColorHighlighted)] forState:UIControlStateHighlighted];
                        [_secondButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : _buttonsBackgroundColorHighlighted)] forState:UIControlStateSelected];
                        [_secondButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorDisabled ? properties.backgroundColorDisabled : _buttonsBackgroundColorDisabled)] forState:UIControlStateDisabled];
                        _secondButton.contentEdgeInsets = UIEdgeInsetsMake(kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW, kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW);
                        _secondButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                        NSTextAlignment textAlignment = (properties.isUserTextAlignment ? properties.textAlignment : _buttonsTextAlignment);
                        if (textAlignment == NSTextAlignmentCenter)
                            _secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                        else if (textAlignment == NSTextAlignmentLeft)
                            _secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        else if (textAlignment == NSTextAlignmentRight)
                            _secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                        _secondButton.enabled = [_buttonsEnabledArray[1] boolValue];
                        [_secondButton addTarget:self action:@selector(secondButtonAction:) forControlEvents:UIControlEventTouchUpInside];

                        CGSize size = [_secondButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];

                        if (size.width > buttonWidth)
                            showTable = YES;

                        if (_buttonTitles.count > 2 && !showTable)
                        {
                            LGAlertViewButtonProperties *properties = nil;
                            if (_buttonsPropertiesDictionary)
                                properties = _buttonsPropertiesDictionary[[NSNumber numberWithInteger:2]];

                            _thirdButton = [UIButton new];
                            _thirdButton.backgroundColor = [UIColor clearColor];
                            _thirdButton.titleLabel.numberOfLines = (properties.isUserNumberOfLines ? properties.numberOfLines : _buttonsNumberOfLines);
                            _thirdButton.titleLabel.lineBreakMode = (properties.isUserLineBreakMode ? properties.lineBreakMode : _buttonsLineBreakMode);
                            _thirdButton.titleLabel.adjustsFontSizeToFitWidth = (properties.isAdjustsFontSizeToFitWidth ? properties.adjustsFontSizeToFitWidth : _buttonsAdjustsFontSizeToFitWidth);
                            _thirdButton.titleLabel.minimumScaleFactor = (properties.isUserMinimimScaleFactor ? properties.minimumScaleFactor : _buttonsMinimumScaleFactor);
                            _thirdButton.titleLabel.font = (properties.isUserFont ? properties.font : _buttonsFont);
                            [_thirdButton setTitle:_buttonTitles[2] forState:UIControlStateNormal];
                            [_thirdButton setTitleColor:(properties.isUserTitleColor ? properties.titleColor : _buttonsTitleColor) forState:UIControlStateNormal];
                            [_thirdButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : _buttonsTitleColorHighlighted) forState:UIControlStateHighlighted];
                            [_thirdButton setTitleColor:(properties.isUserTitleColorHighlighted ? properties.titleColorHighlighted : _buttonsTitleColorHighlighted) forState:UIControlStateSelected];
                            [_thirdButton setTitleColor:(properties.isUserTitleColorDisabled ? properties.titleColorDisabled : _buttonsTitleColorDisabled) forState:UIControlStateDisabled];
                            [_thirdButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColor ? properties.backgroundColor : _buttonsBackgroundColor)] forState:UIControlStateNormal];
                            [_thirdButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : _buttonsBackgroundColorHighlighted)] forState:UIControlStateHighlighted];
                            [_thirdButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorHighlighted ? properties.backgroundColorHighlighted : _buttonsBackgroundColorHighlighted)] forState:UIControlStateSelected];
                            [_thirdButton setBackgroundImage:[LGAlertView image1x1WithColor:(properties.isUserBackgroundColorDisabled ? properties.backgroundColorDisabled : _buttonsBackgroundColorDisabled)] forState:UIControlStateDisabled];
                            _thirdButton.contentEdgeInsets = UIEdgeInsetsMake(kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW, kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW);
                            _thirdButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                            NSTextAlignment textAlignment = (properties.isUserTextAlignment ? properties.textAlignment : _buttonsTextAlignment);
                            if (textAlignment == NSTextAlignmentCenter)
                                _thirdButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                            else if (textAlignment == NSTextAlignmentLeft)
                                _thirdButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                            else if (textAlignment == NSTextAlignmentRight)
                                _thirdButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                            _thirdButton.enabled = [_buttonsEnabledArray[2] boolValue];
                            [_thirdButton addTarget:self action:@selector(thirdButtonAction:) forControlEvents:UIControlEventTouchUpInside];

                            CGSize size = [_thirdButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];

                            if (size.width > buttonWidth)
                                showTable = YES;
                        }
                    }
                }

                if (!showTable)
                {
                    UIButton *firstButton = nil;
                    UIButton *secondButton = nil;
                    UIButton *thirdButton = nil;

                    if (_cancelButton && !kLGAlertViewIsCancelButtonSeparate(self))
                    {
                        [_scrollView addSubview:_cancelButton];

                        firstButton = _cancelButton;
                    }

                    if (_destructiveButton)
                    {
                        [_scrollView addSubview:_destructiveButton];

                        if (!firstButton) firstButton = _destructiveButton;
                        else secondButton = _destructiveButton;
                    }

                    if (_firstButton)
                    {
                        [_scrollView addSubview:_firstButton];

                        if (!firstButton) firstButton = _firstButton;
                        else if (!secondButton) secondButton = _firstButton;
                        else thirdButton = _firstButton;

                        if (_secondButton)
                        {
                            [_scrollView addSubview:_secondButton];

                            if (!secondButton) secondButton = _secondButton;
                            else thirdButton = _secondButton;

                            if (_thirdButton)
                            {
                                [_scrollView addSubview:_thirdButton];

                                thirdButton = _thirdButton;
                            }
                        }
                    }

                    // -----

                    if (offsetY)
                    {
                        _separatorHorizontalView = [UIView new];
                        _separatorHorizontalView.backgroundColor = _separatorsColor;

                        CGRect separatorHorizontalViewFrame = CGRectMake(0.f, offsetY+kLGAlertViewInnerMarginH, width, kLGAlertViewSeparatorHeight);
                        if ([UIScreen mainScreen].scale == 1.f)
                            separatorHorizontalViewFrame = CGRectIntegral(separatorHorizontalViewFrame);

                        _separatorHorizontalView.frame = separatorHorizontalViewFrame;
                        [_scrollView addSubview:_separatorHorizontalView];

                        offsetY = _separatorHorizontalView.frame.origin.y+_separatorHorizontalView.frame.size.height;
                    }

                    // -----

                    CGRect firstButtonFrame = CGRectMake(0.f, offsetY, width/numberOfButtons, _buttonsHeight);
                    if ([UIScreen mainScreen].scale == 1.f)
                        firstButtonFrame = CGRectIntegral(firstButtonFrame);
                    firstButton.frame = firstButtonFrame;

                    CGRect secondButtonFrame = CGRectZero;
                    CGRect thirdButtonFrame = CGRectZero;
                    if (secondButton)
                    {
                        secondButtonFrame = CGRectMake(firstButtonFrame.origin.x+firstButtonFrame.size.width+kLGAlertViewSeparatorHeight, offsetY, width/numberOfButtons-kLGAlertViewSeparatorHeight, _buttonsHeight);
                        if ([UIScreen mainScreen].scale == 1.f)
                            secondButtonFrame = CGRectIntegral(secondButtonFrame);
                        secondButton.frame = secondButtonFrame;

                        if (thirdButton)
                        {
                            thirdButtonFrame = CGRectMake(secondButtonFrame.origin.x+secondButtonFrame.size.width+kLGAlertViewSeparatorHeight, offsetY, width/numberOfButtons-kLGAlertViewSeparatorHeight, _buttonsHeight);
                            if ([UIScreen mainScreen].scale == 1.f)
                                thirdButtonFrame = CGRectIntegral(thirdButtonFrame);
                            thirdButton.frame = thirdButtonFrame;
                        }
                    }

                    // -----

                    if (secondButton)
                    {
                        _separatorVerticalView1 = [UIView new];
                        _separatorVerticalView1.backgroundColor = _separatorsColor;

                        CGRect separatorVerticalView1Frame = CGRectMake(firstButtonFrame.origin.x+firstButtonFrame.size.width, offsetY, kLGAlertViewSeparatorHeight, MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height));
                        if ([UIScreen mainScreen].scale == 1.f)
                            separatorVerticalView1Frame = CGRectIntegral(separatorVerticalView1Frame);

                        _separatorVerticalView1.frame = separatorVerticalView1Frame;
                        [_scrollView addSubview:_separatorVerticalView1];

                        if (thirdButton)
                        {
                            _separatorVerticalView2 = [UIView new];
                            _separatorVerticalView2.backgroundColor = _separatorsColor;

                            CGRect separatorVerticalView2Frame = CGRectMake(secondButtonFrame.origin.x+secondButtonFrame.size.width, offsetY, kLGAlertViewSeparatorHeight, MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height));
                            if ([UIScreen mainScreen].scale == 1.f)
                                separatorVerticalView2Frame = CGRectIntegral(separatorVerticalView2Frame);

                            _separatorVerticalView2.frame = separatorVerticalView2Frame;
                            [_scrollView addSubview:_separatorVerticalView2];
                        }
                    }

                    // -----

                    offsetY += _buttonsHeight;
                }
            }
            else showTable = YES;

            if (showTable)
            {
                if (!kLGAlertViewIsCancelButtonSeparate(self))
                    _cancelButton = nil;
                _destructiveButton = nil;
                _firstButton = nil;
                _secondButton = nil;
                _thirdButton = nil;

                if (!_buttonTitles)
                    _buttonTitles = [NSMutableArray new];

                if (_destructiveButtonTitle.length)
                    [_buttonTitles insertObject:_destructiveButtonTitle atIndex:0];

                if (_cancelButtonTitle.length && !kLGAlertViewIsCancelButtonSeparate(self))
                    [_buttonTitles addObject:_cancelButtonTitle];

                _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
                _tableView.clipsToBounds = NO;
                _tableView.backgroundColor = [UIColor clearColor];
                _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                _tableView.dataSource = self;
                _tableView.delegate = self;
                _tableView.scrollEnabled = NO;
                [_tableView registerClass:[LGAlertViewCell class] forCellReuseIdentifier:@"cell"];
                _tableView.frame = CGRectMake(0.f, 0.f, width, CGFLOAT_MAX);
                [_tableView reloadData];

                if (!offsetY) offsetY = -kLGAlertViewInnerMarginH;
                else
                {
                    _separatorHorizontalView = [UIView new];
                    _separatorHorizontalView.backgroundColor = _separatorsColor;

                    CGRect separatorTitleViewFrame = CGRectMake(0.f, 0.f, width, kLGAlertViewSeparatorHeight);
                    if ([UIScreen mainScreen].scale == 1.f)
                        separatorTitleViewFrame = CGRectIntegral(separatorTitleViewFrame);

                    _separatorHorizontalView.frame = separatorTitleViewFrame;
                    _tableView.tableHeaderView = _separatorHorizontalView;
                }

                CGRect tableViewFrame = CGRectMake(0.f, offsetY+kLGAlertViewInnerMarginH, width, _tableView.contentSize.height);
                if ([UIScreen mainScreen].scale == 1.f)
                    tableViewFrame = CGRectIntegral(tableViewFrame);
                _tableView.frame = tableViewFrame;

                [_scrollView addSubview:_tableView];

                offsetY = _tableView.frame.origin.y+_tableView.frame.size.height;
            }
        }
        else offsetY += kLGAlertViewInnerMarginH;

        // -----

        _scrollView.contentSize = CGSizeMake(width, offsetY);
    }
}

- (void)layoutInvalidateWithSize:(CGSize)size
{
    _view.frame = CGRectMake(0.f, 0.f, size.width, size.height);

    _backgroundView.frame = CGRectMake(0.f, 0.f, size.width, size.height);

    // -----

    CGFloat width = 0.f;

    if (_width != NSNotFound)
    {
        width = MIN(size.width, size.height);

        if (_width < width) width = _width;
    }
    else
    {
        if (_style == LGAlertViewStyleAlert)
            width = kLGAlertViewWidthStyleAlert;
        else
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                width = kLGAlertViewWidthStyleActionSheet;
            else
                width = MIN(size.width, size.height)-kLGAlertViewOffsetH*2;
        }
    }

    // -----

    CGFloat heightMax = size.height-_keyboardHeight-kLGAlertViewOffsetV*2;

    if (_windowLevel == LGAlertViewWindowLevelBelowStatusBar)
        heightMax -= kLGAlertViewStatusBarHeight;

    if (_heightMax != NSNotFound && _heightMax < heightMax)
        heightMax = _heightMax;

    if (kLGAlertViewIsCancelButtonSeparate(self) && _cancelButton)
        heightMax -= (_buttonsHeight+_cancelButtonOffsetY);
    else if (_cancelOnTouch &&
             !_cancelButtonTitle.length &&
             size.width < width+_buttonsHeight*2)
        heightMax -= _buttonsHeight*2;

    if (_scrollView.contentSize.height < heightMax)
        heightMax = _scrollView.contentSize.height;

    // -----

    CGRect scrollViewFrame = CGRectZero;
    CGAffineTransform scrollViewTransform = CGAffineTransformIdentity;
    CGFloat scrollViewAlpha = 1.f;

    if (_style == LGAlertViewStyleAlert || kLGAlertViewPadAndNotForce(self))
    {
        scrollViewFrame = CGRectMake(size.width/2-width/2, size.height/2-_keyboardHeight/2-heightMax/2, width, heightMax);

        if (_windowLevel == LGAlertViewWindowLevelBelowStatusBar)
            scrollViewFrame.origin.y += kLGAlertViewStatusBarHeight/2;

        if (!self.isShowing)
        {
            scrollViewTransform = CGAffineTransformMakeScale(1.2, 1.2);

            scrollViewAlpha = 0.f;
        }
    }
    else
    {
        CGFloat bottomShift = kLGAlertViewOffsetV;
        if (kLGAlertViewIsCancelButtonSeparate(self) && _cancelButton)
            bottomShift += _buttonsHeight+_cancelButtonOffsetY;

        scrollViewFrame = CGRectMake(size.width/2-width/2, size.height-bottomShift-heightMax, width, heightMax);
    }

    // -----

    if (_style == LGAlertViewStyleActionSheet && !kLGAlertViewPadAndNotForce(self))
    {
        CGRect cancelButtonFrame = CGRectZero;
        if (kLGAlertViewIsCancelButtonSeparate(self) && _cancelButton)
            cancelButtonFrame = CGRectMake(size.width/2-width/2, size.height-_cancelButtonOffsetY-_buttonsHeight, width, _buttonsHeight);

        _scrollViewCenterShowed = CGPointMake(scrollViewFrame.origin.x+scrollViewFrame.size.width/2, scrollViewFrame.origin.y+scrollViewFrame.size.height/2);
        _cancelButtonCenterShowed = CGPointMake(cancelButtonFrame.origin.x+cancelButtonFrame.size.width/2, cancelButtonFrame.origin.y+cancelButtonFrame.size.height/2);

        // -----

        CGFloat commonHeight = scrollViewFrame.size.height+kLGAlertViewOffsetV;
        if (kLGAlertViewIsCancelButtonSeparate(self) && _cancelButton)
            commonHeight += _buttonsHeight+_cancelButtonOffsetY;

        _scrollViewCenterHidden = CGPointMake(scrollViewFrame.origin.x+scrollViewFrame.size.width/2, scrollViewFrame.origin.y+scrollViewFrame.size.height/2+commonHeight+_layerBorderWidth+_layerShadowRadius);
        _cancelButtonCenterHidden = CGPointMake(cancelButtonFrame.origin.x+cancelButtonFrame.size.width/2, cancelButtonFrame.origin.y+cancelButtonFrame.size.height/2+commonHeight);

        if (!self.isShowing)
        {
            scrollViewFrame.origin.y += commonHeight;

            if (kLGAlertViewIsCancelButtonSeparate(self) && _cancelButton)
                cancelButtonFrame.origin.y += commonHeight;
        }

        // -----

        if (kLGAlertViewIsCancelButtonSeparate(self) && _cancelButton)
        {
            if ([UIScreen mainScreen].scale == 1.f)
                cancelButtonFrame = CGRectIntegral(cancelButtonFrame);

            _cancelButton.frame = cancelButtonFrame;

            CGFloat borderWidth = _layerBorderWidth;
            _styleCancelView.frame = CGRectMake(cancelButtonFrame.origin.x-borderWidth, cancelButtonFrame.origin.y-borderWidth, cancelButtonFrame.size.width+borderWidth*2, cancelButtonFrame.size.height+borderWidth*2);
        }
    }

    // -----

    if ([UIScreen mainScreen].scale == 1.f)
    {
        scrollViewFrame = CGRectIntegral(scrollViewFrame);

        if (scrollViewFrame.size.height - _scrollView.contentSize.height == 1.f)
            scrollViewFrame.size.height -= 2.f;
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

- (void)cancelButtonInit
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
    [_cancelButton setTitleColor:_cancelButtonTitleColorDisabled forState:UIControlStateDisabled];
    [_cancelButton setBackgroundImage:[LGAlertView image1x1WithColor:_cancelButtonBackgroundColor] forState:UIControlStateNormal];
    [_cancelButton setBackgroundImage:[LGAlertView image1x1WithColor:_cancelButtonBackgroundColorHighlighted] forState:UIControlStateHighlighted];
    [_cancelButton setBackgroundImage:[LGAlertView image1x1WithColor:_cancelButtonBackgroundColorHighlighted] forState:UIControlStateSelected];
    [_cancelButton setBackgroundImage:[LGAlertView image1x1WithColor:_cancelButtonBackgroundColorDisabled] forState:UIControlStateDisabled];
    _cancelButton.contentEdgeInsets = UIEdgeInsetsMake(kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW, kLGAlertViewButtonTitleMarginH, kLGAlertViewPaddingW);
    _cancelButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if (_cancelButtonTextAlignment == NSTextAlignmentCenter)
        _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    else if (_cancelButtonTextAlignment == NSTextAlignmentLeft)
        _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    else if (_cancelButtonTextAlignment == NSTextAlignmentRight)
        _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _cancelButton.enabled = _cancelButtonEnabled;
    [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -

- (void)cancelAction:(id)sender
{
    if (sender && [sender isKindOfClass:[UIButton class]])
        [(UIButton *)sender setSelected:YES];

    // -----

    if (_cancelHandler) _cancelHandler(self);

    if (_delegate && [_delegate respondsToSelector:@selector(alertViewCancelled:)])
        [_delegate alertViewCancelled:self];

    [[NSNotificationCenter defaultCenter] postNotificationName:kLGAlertViewCancelNotification object:self userInfo:nil];

    // -----

    if (_dismissOnAction)
        [self dismissAnimated:YES completionHandler:nil];
}

- (void)destructiveAction:(id)sender
{
    if (sender && [sender isKindOfClass:[UIButton class]])
        [(UIButton *)sender setSelected:YES];

    // -----

    if (_destructiveHandler) _destructiveHandler(self);

    if (_delegate && [_delegate respondsToSelector:@selector(alertViewDestructiveButtonPressed:)])
        [_delegate alertViewDestructiveButtonPressed:self];

    [[NSNotificationCenter defaultCenter] postNotificationName:kLGAlertViewDestructiveNotification object:self userInfo:nil];

    // -----

    if (_dismissOnAction)
        [self dismissAnimated:YES completionHandler:nil];
}

- (void)actionActionAtIndex:(NSUInteger)index title:(NSString *)title
{
    if (_actionHandler) _actionHandler(self, title, index);

    if (_delegate && [_delegate respondsToSelector:@selector(alertView:buttonPressedWithTitle:index:)])
        [_delegate alertView:self buttonPressedWithTitle:title index:index];

    [[NSNotificationCenter defaultCenter] postNotificationName:kLGAlertViewActionNotification
                                                        object:self
                                                      userInfo:@{@"title" : title,
                                                                 @"index" : [NSNumber numberWithInteger:index]}];

    // -----

    if (_dismissOnAction)
        [self dismissAnimated:YES completionHandler:nil];
}

- (void)firstButtonAction:(id)sender
{
    if (sender && [sender isKindOfClass:[UIButton class]])
        [(UIButton *)sender setSelected:YES];

    // -----

    NSUInteger index = 0;

    NSString *title = _buttonTitles[0];

    // -----

    [self actionActionAtIndex:index title:title];
}

- (void)secondButtonAction:(id)sender
{
    if (sender && [sender isKindOfClass:[UIButton class]])
        [(UIButton *)sender setSelected:YES];

    // -----

    NSUInteger index = 1;

    NSString *title = _buttonTitles[1];

    // -----

    [self actionActionAtIndex:index title:title];
}

- (void)thirdButtonAction:(id)sender
{
    if (sender && [sender isKindOfClass:[UIButton class]])
        [(UIButton *)sender setSelected:YES];

    // -----

    NSUInteger index = 2;

    NSString *title = _buttonTitles[2];

    // -----

    [self actionActionAtIndex:index title:title];
}

#pragma mark - Class methods

/** Setup LGAlertView globally for all instances of LGAlertViews */
+ (void)setWindowLevel:(LGAlertViewWindowLevel)windowLevel
{
    kLGAlertViewWindowLevel = windowLevel;
}

+ (LGAlertViewWindowLevel)windowLevel
{
    return kLGAlertViewWindowLevel;
}

+ (void)setColorful:(BOOL)colorful
{
    kLGAlertViewColorful = [NSNumber numberWithBool:colorful];
}

+ (BOOL)colorful
{
    return (kLGAlertViewColorful ? kLGAlertViewColorful.boolValue : YES);
}

+ (void)setTintColor:(UIColor *)tintColor
{
    kLGAlertViewTintColor = tintColor;
}

+ (UIColor *)tintColor
{
    return kLGAlertViewTintColor;
}

+ (void)setCoverColor:(UIColor *)coverColor
{
    kLGAlertViewCoverColor = coverColor;
}

+ (UIColor *)coverColor
{
    return kLGAlertViewCoverColor;
}

+ (void)setBackgroundColor:(UIColor *)backgroundColor
{
    kLGAlertViewBackgroundColor = backgroundColor;
}

+ (UIColor *)backgroundColor
{
    return kLGAlertViewBackgroundColor;
}

+ (void)setButtonsHeight:(CGFloat)buttonsHeight
{
    NSAssert(buttonsHeight >= 0, @"Buttons height can not be less then 0.f");

    kLGAlertViewButtonsHeight = buttonsHeight;
}

+ (CGFloat)buttonsHeight
{
    return kLGAlertViewButtonsHeight;
}

+ (void)setTextFieldsHeight:(CGFloat)textFieldsHeight
{
    NSAssert(textFieldsHeight >= 0, @"Text fields height can not be less then 0.f");

    kLGAlertViewTextFieldsHeight = textFieldsHeight;
}

+ (CGFloat)textFieldsHeight
{
    return kLGAlertViewTextFieldsHeight;
}

+ (void)setOffsetVertical:(CGFloat)offsetVertical
{
    kLGAlertViewOffsetVertical = offsetVertical;
}

+ (CGFloat)offsetVertical
{
    return kLGAlertViewOffsetVertical;
}

+ (void)setCancelButtonOffsetY:(CGFloat)cancelButtonOffsetY
{
    kLGAlertViewCancelButtonOffsetY = cancelButtonOffsetY;
}

+ (CGFloat)cancelButtonOffsetY
{
    return kLGAlertViewCancelButtonOffsetY;
}

+ (void)setHeightMax:(CGFloat)heightMax
{
    kLGAlertViewHeightMax = heightMax;
}

+ (CGFloat)heightMax
{
    return kLGAlertViewHeightMax;
}

+ (void)setWidth:(CGFloat)width
{
    NSAssert(width >= 0, @"LGAlertView width can not be less then 0.f");

    kLGAlertViewWidth = width;
}

+ (CGFloat)width
{
    return kLGAlertViewWidth;
}

#pragma mark -


+ (void)setLayerCornerRadius:(CGFloat)layerCornerRadius
{
    kLGAlertViewLayerCornerRadius = layerCornerRadius;
}

+ (CGFloat)layerCornerRadius
{
    return kLGAlertViewLayerCornerRadius;
}

+ (void)setLayerBorderColor:(UIColor *)layerBorderColor
{
    kLGAlertViewLayerBorderColor = layerBorderColor;
}

+ (UIColor *)layerBorderColor
{
    return kLGAlertViewLayerBorderColor;
}

+ (void)setLayerBorderWidth:(CGFloat)layerBorderWidth
{
    kLGAlertViewLayerBorderWidth = layerBorderWidth;
}

+ (CGFloat)layerBorderWidth
{
    return kLGAlertViewLayerBorderWidth;
}

+ (void)setLayerShadowColor:(UIColor *)layerShadowColor
{
    kLGAlertViewLayerShadowColor = layerShadowColor;
}

+ (UIColor *)layerShadowColor
{
    return kLGAlertViewLayerShadowColor;
}

+ (void)setLayerShadowRadius:(CGFloat)layerShadowRadius
{
    kLGAlertViewLayerShadowRadius = layerShadowRadius;
}

+ (CGFloat)layerShadowRadius
{
    return kLGAlertViewLayerShadowRadius;
}

+ (void)setLayerShadowOpacity:(CGFloat)layerShadowOpacity
{
    kLGAlertViewLayerShadowOpacity = layerShadowOpacity;
}

+ (CGFloat)layerShadowOpacity
{
    return kLGAlertViewLayerShadowOpacity;
}

+ (void)setLayerShadowOffset:(CGSize)layerShadowOffset
{
    kLGAlertViewLayerShadowOffset = NSStringFromCGSize(layerShadowOffset);
}

+ (CGSize)layerShadowOffset
{
    return CGSizeFromString(kLGAlertViewLayerShadowOffset);
}

#pragma mark -

+ (void)setTitleTextColor:(UIColor *)titleTextColor
{
    kLGAlertViewTitleTextColor = titleTextColor;
}

+ (UIColor *)titleTextColor
{
    return kLGAlertViewTitleTextColor;
}

+ (void)setTitleTextAlignment:(NSTextAlignment)titleTextAlignment
{
    kLGAlertViewTitleTextAlignment = titleTextAlignment;
}

+ (NSTextAlignment)titleTextAlignment
{
    return kLGAlertViewTitleTextAlignment;
}

+ (void)setTitleFont:(UIFont *)titleFont
{
    kLGAlertViewTitleFont = titleFont;
}

+ (UIFont *)titleFont
{
    return kLGAlertViewTitleFont;
}

#pragma mark -

+ (void)setMessageTextColor:(UIColor *)messageTextColor
{
    kLGAlertViewMessageTextColor = messageTextColor;
}

+ (UIColor *)messageTextColor
{
    return kLGAlertViewMessageTextColor;
}

+ (void)setMessageTextAlignment:(NSTextAlignment)messageTextAlignment
{
    kLGAlertViewMessageTextAlignment = messageTextAlignment;
}

+ (NSTextAlignment)messageTextAlignment
{
    return kLGAlertViewMessageTextAlignment;
}

+ (void)setMessageFont:(UIFont *)messageFont
{
    kLGAlertViewMessageFont = messageFont;
}

+ (UIFont *)messageFont
{
    return kLGAlertViewMessageFont;
}

#pragma mark -

+ (void)setButtonsTitleColor:(UIColor *)buttonsTitleColor
{
    kLGAlertViewButtonsTitleColor = buttonsTitleColor;
}

+ (UIColor *)buttonsTitleColor
{
    return kLGAlertViewButtonsTitleColor;
}

+ (void)setButtonsTitleColorHighlighted:(UIColor *)buttonsTitleColorHighlighted
{
    kLGAlertViewButtonsTitleColorHighlighted = buttonsTitleColorHighlighted;
}

+ (UIColor *)buttonsTitleColorHighlighted
{
    return kLGAlertViewButtonsTitleColorHighlighted;
}

+ (void)setButtonsTitleColorDisabled:(UIColor *)buttonsTitleColorDisabled
{
    kLGAlertViewButtonsTitleColorDisabled = buttonsTitleColorDisabled;
}

+ (UIColor *)buttonsTitleColorDisabled
{
    return kLGAlertViewButtonsTitleColorDisabled;
}

+ (void)setButtonsTextAlignment:(NSTextAlignment)buttonsTextAlignment
{
    kLGAlertViewButtonsTextAlignment = buttonsTextAlignment;
}

+ (NSTextAlignment)buttonsTextAlignment
{
    return kLGAlertViewButtonsTextAlignment;
}

+ (void)setButtonsFont:(UIFont *)buttonsFont
{
    kLGAlertViewButtonsFont = buttonsFont;
}

+ (UIFont *)buttonsFont
{
    return kLGAlertViewButtonsFont;
}

+ (void)setButtonsBackgroundColor:(UIColor *)buttonsBackgroundColor
{
    kLGAlertViewButtonsBackgroundColor = buttonsBackgroundColor;
}

+ (UIColor *)buttonsBackgroundColor
{
    return kLGAlertViewButtonsBackgroundColor;
}

+ (void)setButtonsBackgroundColorHighlighted:(UIColor *)buttonsBackgroundColorHighlighted
{
    kLGAlertViewButtonsBackgroundColorHighlighted = buttonsBackgroundColorHighlighted;
}

+ (UIColor *)buttonsBackgroundColorHighlighted
{
    return kLGAlertViewButtonsBackgroundColorHighlighted;
}

+ (void)setButtonsBackgroundColorDisabled:(UIColor *)buttonsBackgroundColorDisabled
{
    kLGAlertViewButtonsBackgroundColorDisabled = buttonsBackgroundColorDisabled;
}

+ (UIColor *)buttonsBackgroundColorDisabled
{
    return kLGAlertViewButtonsBackgroundColorDisabled;
}

+ (void)setButtonsNumberOfLines:(NSUInteger)buttonsNumberOfLines
{
    kLGAlertViewButtonsNumberOfLines = buttonsNumberOfLines;
}

+ (NSUInteger)buttonsNumberOfLines
{
    return kLGAlertViewButtonsNumberOfLines;
}

+ (void)setButtonsLineBreakMode:(NSLineBreakMode)buttonsLineBreakMode
{
    kLGAlertViewButtonsLineBreakMode = buttonsLineBreakMode;
}

+ (NSLineBreakMode)buttonsLineBreakMode
{
    return kLGAlertViewButtonsLineBreakMode;
}

+ (void)setButtonsMinimumScaleFactor:(CGFloat)buttonsMinimumScaleFactor
{
    kLGAlertViewButtonsMinimumScaleFactor = buttonsMinimumScaleFactor;
}

+ (CGFloat)buttonsMinimumScaleFactor
{
    return kLGAlertViewButtonsMinimumScaleFactor;
}

+ (void)setButtonsAdjustsFontSizeToFitWidth:(BOOL)buttonsAdjustsFontSizeToFitWidth
{
    kLGAlertViewButtonsAdjustsFontSizeToFitWidth = [NSNumber numberWithBool:buttonsAdjustsFontSizeToFitWidth];
}

+ (BOOL)buttonsAdjustsFontSizeToFitWidth
{
    return (kLGAlertViewButtonsAdjustsFontSizeToFitWidth ? kLGAlertViewButtonsAdjustsFontSizeToFitWidth.boolValue : YES);
}

#pragma mark -

+ (void)setCancelButtonTitleColor:(UIColor *)cancelButtonTitleColor
{
    kLGAlertViewCancelButtonTitleColor = cancelButtonTitleColor;
}

+ (UIColor *)cancelButtonTitleColor
{
    return kLGAlertViewCancelButtonTitleColor;
}

+ (void)setCancelButtonTitleColorHighlighted:(UIColor *)cancelButtonTitleColorHighlighted
{
    kLGAlertViewCancelButtonTitleColorHighlighted = cancelButtonTitleColorHighlighted;
}

+ (UIColor *)cancelButtonTitleColorHighlighted
{
    return kLGAlertViewCancelButtonTitleColorHighlighted;
}

+ (void)setCancelButtonTitleColorDisabled:(UIColor *)cancelButtonTitleColorDisabled
{
    kLGAlertViewCancelButtonTitleColorDisabled = cancelButtonTitleColorDisabled;
}

+ (UIColor *)cancelButtonTitleColorDisabled
{
    return kLGAlertViewCancelButtonTitleColorDisabled;
}

+ (void)setCancelButtonTextAlignment:(NSTextAlignment)cancelButtonTextAlignment
{
    kLGAlertViewCancelButtonTextAlignment = cancelButtonTextAlignment;
}

+ (NSTextAlignment)cancelButtonTextAlignment
{
    return kLGAlertViewCancelButtonTextAlignment;
}

+ (void)setCancelButtonFont:(UIFont *)cancelButtonFont
{
    kLGAlertViewCancelButtonFont = cancelButtonFont;
}

+ (UIFont *)cancelButtonFont
{
    return kLGAlertViewCancelButtonFont;
}

+ (void)setCancelButtonBackgroundColor:(UIColor *)cancelButtonBackgroundColor
{
    kLGAlertViewCancelButtonBackgroundColor = cancelButtonBackgroundColor;
}

+ (UIColor *)cancelButtonBackgroundColor
{
    return kLGAlertViewCancelButtonBackgroundColor;
}

+ (void)setCancelButtonBackgroundColorHighlighted:(UIColor *)cancelButtonBackgroundColorHighlighted
{
    kLGAlertViewCancelButtonBackgroundColorHighlighted = cancelButtonBackgroundColorHighlighted;
}

+ (UIColor *)cancelButtonBackgroundColorHighlighted
{
    return kLGAlertViewCancelButtonBackgroundColorHighlighted;
}

+ (void)setCancelButtonBackgroundColorDisabled:(UIColor *)cancelButtonBackgroundColorDisabled
{
    kLGAlertViewCancelButtonBackgroundColorDisabled = cancelButtonBackgroundColorDisabled;
}

+ (UIColor *)cancelButtonBackgroundColorDisabled
{
    return kLGAlertViewCancelButtonBackgroundColorDisabled;
}

+ (void)setCancelButtonNumberOfLines:(NSUInteger)cancelButtonNumberOfLines
{
    kLGAlertViewCancelButtonNumberOfLines = cancelButtonNumberOfLines;
}

+ (NSUInteger)cancelButtonNumberOfLines
{
    return kLGAlertViewCancelButtonNumberOfLines;
}

+ (void)setCancelButtonLineBreakMode:(NSLineBreakMode)cancelButtonLineBreakMode
{
    kLGAlertViewCancelButtonLineBreakMode = cancelButtonLineBreakMode;
}

+ (NSLineBreakMode)cancelButtonLineBreakMode
{
    return kLGAlertViewCancelButtonLineBreakMode;
}

+ (void)setCancelButtonMinimumScaleFactor:(CGFloat)cancelButtonMinimumScaleFactor
{
    kLGAlertViewCancelButtonMinimumScaleFactor = cancelButtonMinimumScaleFactor;
}

+ (CGFloat)cancelButtonMinimumScaleFactor
{
    return kLGAlertViewCancelButtonMinimumScaleFactor;
}

+ (void)setCancelButtonAdjustsFontSizeToFitWidth:(BOOL)cancelButtonAdjustsFontSizeToFitWidth
{
    kLGAlertViewCancelButtonAdjustsFontSizeToFitWidth = [NSNumber numberWithBool:cancelButtonAdjustsFontSizeToFitWidth];
}

+ (BOOL)cancelButtonAdjustsFontSizeToFitWidth
{
    return (kLGAlertViewCancelButtonAdjustsFontSizeToFitWidth ? kLGAlertViewCancelButtonAdjustsFontSizeToFitWidth.boolValue : YES);
}

#pragma mark -

+ (void)setDestructiveButtonTitleColor:(UIColor *)destructiveButtonTitleColor
{
    kLGAlertViewDestructiveButtonTitleColor = destructiveButtonTitleColor;
}

+ (UIColor *)destructiveButtonTitleColor
{
    return kLGAlertViewDestructiveButtonTitleColor;
}

+ (void)setDestructiveButtonTitleColorHighlighted:(UIColor *)destructiveButtonTitleColorHighlighted
{
    kLGAlertViewDestructiveButtonTitleColorHighlighted = destructiveButtonTitleColorHighlighted;
}

+ (UIColor *)destructiveButtonTitleColorHighlighted
{
    return kLGAlertViewDestructiveButtonTitleColorHighlighted;
}

+ (void)setDestructiveButtonTitleColorDisabled:(UIColor *)destructiveButtonTitleColorDisabled
{
    kLGAlertViewDestructiveButtonTitleColorDisabled = destructiveButtonTitleColorDisabled;
}

+ (UIColor *)destructiveButtonTitleColorDisabled
{
    return kLGAlertViewDestructiveButtonTitleColorDisabled;
}

+ (void)setDestructiveButtonTextAlignment:(NSTextAlignment)destructiveButtonTextAlignment
{
    kLGAlertViewDestructiveButtonTextAlignment = destructiveButtonTextAlignment;
}

+ (NSTextAlignment)destructiveButtonTextAlignment
{
    return kLGAlertViewDestructiveButtonTextAlignment;
}

+ (void)setDestructiveButtonFont:(UIFont *)destructiveButtonFont
{
    kLGAlertViewDestructiveButtonFont = destructiveButtonFont;
}

+ (UIFont *)destructiveButtonFont
{
    return kLGAlertViewDestructiveButtonFont;
}

+ (void)setDestructiveButtonBackgroundColor:(UIColor *)destructiveButtonBackgroundColor
{
    kLGAlertViewDestructiveButtonBackgroundColor = destructiveButtonBackgroundColor;
}

+ (UIColor *)destructiveButtonBackgroundColor
{
    return kLGAlertViewDestructiveButtonBackgroundColor;
}

+ (void)setDestructiveButtonBackgroundColorHighlighted:(UIColor *)destructiveButtonBackgroundColorHighlighted
{
    kLGAlertViewDestructiveButtonBackgroundColorHighlighted = destructiveButtonBackgroundColorHighlighted;
}

+ (UIColor *)destructiveButtonBackgroundColorHighlighted
{
    return kLGAlertViewDestructiveButtonBackgroundColorHighlighted;
}

+ (void)setDestructiveButtonBackgroundColorDisabled:(UIColor *)destructiveButtonBackgroundColorDisabled
{
    kLGAlertViewDestructiveButtonBackgroundColorDisabled = destructiveButtonBackgroundColorDisabled;
}

+ (UIColor *)destructiveButtonBackgroundColorDisabled
{
    return kLGAlertViewDestructiveButtonBackgroundColorDisabled;
}

+ (void)setDestructiveButtonNumberOfLines:(NSUInteger)destructiveButtonNumberOfLines
{
    kLGAlertViewDestructiveButtonNumberOfLines = destructiveButtonNumberOfLines;
}

+ (NSUInteger)destructiveButtonNumberOfLines
{
    return kLGAlertViewDestructiveButtonNumberOfLines;
}

+ (void)setDestructiveButtonLineBreakMode:(NSLineBreakMode)destructiveButtonLineBreakMode
{
    kLGAlertViewDestructiveButtonLineBreakMode = destructiveButtonLineBreakMode;
}

+ (NSLineBreakMode)destructiveButtonLineBreakMode
{
    return kLGAlertViewDestructiveButtonLineBreakMode;
}

+ (void)setDestructiveButtonMinimumScaleFactor:(CGFloat)destructiveButtonMinimumScaleFactor
{
    kLGAlertViewDestructiveButtonMinimumScaleFactor = destructiveButtonMinimumScaleFactor;
}

+ (CGFloat)destructiveButtonMinimumScaleFactor
{
    return kLGAlertViewDestructiveButtonMinimumScaleFactor;
}

+ (void)setDestructiveButtonAdjustsFontSizeToFitWidth:(BOOL)destructiveButtonAdjustsFontSizeToFitWidth
{
    kLGAlertViewDestructiveButtonAdjustsFontSizeToFitWidth = [NSNumber numberWithBool:destructiveButtonAdjustsFontSizeToFitWidth];
}

+ (BOOL)destructiveButtonAdjustsFontSizeToFitWidth
{
    return (kLGAlertViewDestructiveButtonAdjustsFontSizeToFitWidth ? kLGAlertViewDestructiveButtonAdjustsFontSizeToFitWidth.boolValue : YES);
}

#pragma mark -

+ (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    kLGAlertViewActivityIndicatorViewStyle = activityIndicatorViewStyle;
}

+ (UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    return kLGAlertViewActivityIndicatorViewStyle;
}

+ (void)setActivityIndicatorViewColor:(UIColor *)activityIndicatorViewColor
{
    kLGAlertViewActivityIndicatorViewColor = activityIndicatorViewColor;
}

+ (UIColor *)activityIndicatorViewColor
{
    return kLGAlertViewActivityIndicatorViewColor;
}

#pragma mark -

+ (void)setProgressViewProgressTintColor:(UIColor *)progressViewProgressTintColor
{
    kLGAlertViewProgressViewProgressTintColor = progressViewProgressTintColor;
}

+ (UIColor *)progressViewProgressTintColor
{
    return kLGAlertViewProgressViewProgressTintColor;
}

+ (void)setProgressViewTrackTintColor:(UIColor *)progressViewTrackTintColor
{
    kLGAlertViewProgressViewTrackTintColor = progressViewTrackTintColor;
}

+ (UIColor *)progressViewTrackTintColor
{
    return kLGAlertViewProgressViewTrackTintColor;
}

+ (void)setProgressViewProgressImage:(UIImage *)progressViewProgressImage
{
    kLGAlertViewProgressViewProgressImage = progressViewProgressImage;
}

+ (UIImage *)progressViewProgressImage
{
    return kLGAlertViewProgressViewProgressImage;
}

+ (void)setProgressViewTrackImage:(UIImage *)progressViewTrackImage
{
    kLGAlertViewProgressViewTrackImage = progressViewTrackImage;
}

+ (UIImage *)progressViewTrackImage
{
    return kLGAlertViewProgressViewTrackImage;
}

+ (void)setProgressLabelTextColor:(UIColor *)progressLabelTextColor
{
    kLGAlertViewProgressLabelTextColor = progressLabelTextColor;
}

+ (UIColor *)progressLabelTextColor
{
    return kLGAlertViewProgressLabelTextColor;
}

+ (void)setProgressLabelTextAlignment:(NSTextAlignment)progressLabelTextAlignment
{
    kLGAlertViewProgressLabelTextAlignment = progressLabelTextAlignment;
}

+ (NSTextAlignment)progressLabelTextAlignment
{
    return kLGAlertViewProgressLabelTextAlignment;
}

+ (void)setProgressLabelFont:(UIFont *)progressLabelFont
{
    kLGAlertViewProgressLabelFont = progressLabelFont;
}

+ (UIFont *)progressLabelFont
{
    return kLGAlertViewProgressLabelFont;
}

#pragma mark -

+ (void)setSeparatorsColor:(UIColor *)separatorsColor
{
    kLGAlertViewSeparatorsColor = separatorsColor;
}

+ (UIColor *)separatorsColor
{
    return kLGAlertViewSeparatorsColor;
}

+ (void)setIndicatorStyle:(UIScrollViewIndicatorStyle)indicatorStyle
{
    kLGAlertViewIndicatorStyle = indicatorStyle;
}

+ (UIScrollViewIndicatorStyle)indicatorStyle
{
    return kLGAlertViewIndicatorStyle;
}

+ (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator
{
    kLGAlertViewShowsVerticalScrollIndicator = [NSNumber numberWithBool:showsVerticalScrollIndicator];
}

+ (BOOL)showsVerticalScrollIndicator
{
    return (kLGAlertViewShowsVerticalScrollIndicator ? kLGAlertViewShowsVerticalScrollIndicator.boolValue : NO);
}

+ (void)setPadShowsActionSheetFromBottom:(BOOL)padShowActionSheetFromBottom
{
    kLGAlertViewPadShowActionSheetFromBottom = [NSNumber numberWithBool:padShowActionSheetFromBottom];
}

+ (BOOL)padShowsActionSheetFromBottom
{
    return (kLGAlertViewPadShowActionSheetFromBottom ? kLGAlertViewPadShowActionSheetFromBottom.boolValue : NO);
}

+ (void)setOneRowOneButton:(BOOL)oneRowOneButton
{
    kLGAlertViewOneRowOneButton = [NSNumber numberWithBool:oneRowOneButton];
}

+ (BOOL)oneRowOneButton
{
    return (kLGAlertViewOneRowOneButton ? kLGAlertViewOneRowOneButton.boolValue : NO);
}

#pragma mark -

+ (NSArray *)alertViewsArray
{
    if (!kLGAlertViewArray)
        kLGAlertViewArray = [NSMutableArray new];
    
    return kLGAlertViewArray;
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
    if (!color) return nil;
    
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
    CGFloat keyboardHeight = (notificationUserInfo[UIKeyboardFrameEndUserInfoKey] ? [notificationUserInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height : 0.f);
    
    if (!keyboardHeight) return;
    
    NSTimeInterval animationDuration = [notificationUserInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int animationCurve = [notificationUserInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (animations) animations(keyboardHeight);
    
    [UIView commitAnimations];
}

@end
