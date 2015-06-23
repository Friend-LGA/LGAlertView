# LGAlertView

Customizable implementation of UIAlertView.

## Preview

<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Preview.gif" width="230"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/1.png" width="230"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/2.png" width="230"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/3.png" width="230"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/4.png" width="230"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/5.png" width="230"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/6.png" width="230"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/7.png" width="230"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/8.png" width="230"/>

## Installation

### With source code

[Download repository](https://github.com/Friend-LGA/LGAlertView/archive/master.zip), then add [LGAlertView directory](https://github.com/Friend-LGA/LGAlertView/blob/master/LGAlertView/) to your project.

### With CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. See the "Get Started" section for more details.

#### Podfile

```
platform :ios, '6.0'
pod 'LGAlertView', '~> 1.0.0'
```

## Usage

In the source files where you need to use the library, import the header file:

```objective-c
#import "LGAlertView.h"
```

### Initialization

You have several methods for initialization:

```objective-c
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle;

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
```

More init methods you can find in [LGAlertView.h](https://github.com/Friend-LGA/LGAlertView/blob/master/LGAlertView/LGAlertView.h)

### Handle actions

To handle actions you can use initialization methods with blocks or delegate, or implement it after initialization.

#### Delegate

```objective-c
@property (assign, nonatomic) id<LGAlertViewDelegate> delegate;

- (void)alertViewWillShow:(LGAlertView *)alertView;
- (void)alertViewWillDismiss:(LGAlertView *)alertView;
- (void)alertViewDidShow:(LGAlertView *)alertView;
- (void)alertViewDidDismiss:(LGAlertView *)alertView;
- (void)alertView:(LGAlertView *)alertView buttonPressedWithTitle:(NSString *)title index:(NSUInteger)index;
- (void)alertViewCancelled:(LGAlertView *)alertView;
- (void)alertViewDestructiveButtonPressed:(LGAlertView *)alertView;
```

#### Blocks

```objective-c
@property (strong, nonatomic) void (^willShowHandler)(LGAlertView *alertView);
@property (strong, nonatomic) void (^willDismissHandler)(LGAlertView *alertView);
@property (strong, nonatomic) void (^didShowHandler)(LGAlertView *alertView);
@property (strong, nonatomic) void (^didDismissHandler)(LGAlertView *alertView);
@property (strong, nonatomic) void (^actionHandler)(LGAlertView *alertView, NSString *title, NSUInteger index);
@property (strong, nonatomic) void (^cancelHandler)(LGAlertView *alertView, BOOL onButton);
@property (strong, nonatomic) void (^destructiveHandler)(LGAlertView *alertView);
```

#### Notifications

Here is also some notifications, that you can add to NSNotificationsCenter:

```objective-c
kLGAlertViewWillShowNotification;
kLGAlertViewWillDismissNotification;
kLGAlertViewDidShowNotification;
kLGAlertViewDidDismissNotification;
```

### More

For more details try Xcode [Demo project](https://github.com/Friend-LGA/LGAlertView/blob/master/Demo) and see [LGAlertView.h](https://github.com/Friend-LGA/LGAlertView/blob/master/LGAlertView/LGAlertView.h)

## License

LGAlertView is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/Friend-LGA/LGAlertView/master/LICENSE) for details.
