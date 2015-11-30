# LGAlertView

Customizable implementation of UIAlertViewController, UIAlertView and UIActionSheet. All in one.
You can customize every detail. Make AlertView of your dream! :)

## Preview

### Default Alert View Style

<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Alert_View_Style/Preview.gif" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Alert_View_Style/1.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Alert_View_Style/2.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Alert_View_Style/3.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Alert_View_Style/4.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Alert_View_Style/5.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Alert_View_Style/6.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Alert_View_Style/7.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Alert_View_Style/8.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Alert_View_Style/9.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Alert_View_Style/10.png" width="218"/>

### Default Action Sheet Style

<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Action_Sheet_Style/Preview.gif" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Action_Sheet_Style/1.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Action_Sheet_Style/2.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Action_Sheet_Style/3.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Action_Sheet_Style/4.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Action_Sheet_Style/5.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Default_Action_Sheet_Style/6.png" width="218"/>

### Custom Alert View Styles

<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Custom_Alert_View_Styles/1.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Custom_Alert_View_Styles/2.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Custom_Alert_View_Styles/3.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Custom_Alert_View_Styles/4.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Custom_Alert_View_Styles/5.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Custom_Alert_View_Styles/6.png" width="218"/>

### Custom Action Sheet Styles

<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Custom_Action_Sheet_Styles/1.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Custom_Action_Sheet_Styles/2.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Custom_Action_Sheet_Styles/3.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Custom_Action_Sheet_Styles/4.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Custom_Action_Sheet_Styles/5.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGAlertView/Custom_Action_Sheet_Styles/6.png" width="218"/>

## Installation

### With source code

[Download repository](https://github.com/Friend-LGA/LGAlertView/archive/master.zip), then add [LGAlertView directory](https://github.com/Friend-LGA/LGAlertView/blob/master/LGAlertView/) to your project.

### With CocoaPods

CocoaPods is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. To install with cocoaPods, follow the "Get Started" section on [CocoaPods](https://cocoapods.org/).

#### Podfile
```ruby
platform :ios, '6.0'
pod 'LGAlertView', '~> 2.0.0'
```

### With Carthage

Carthage is a lightweight dependency manager for Swift and Objective-C. It leverages CocoaTouch modules and is less invasive than CocoaPods. To install with carthage, follow the instruction on [Carthage](https://github.com/Carthage/Carthage/).

#### Cartfile
```
github "Friend-LGA/LGAlertView" ~> 2.0.0
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
```

More init methods you can find in [LGAlertView.h](https://github.com/Friend-LGA/LGAlertView/blob/master/LGAlertView/LGAlertView.h)

### Handle actions

To handle actions you can use blocks, delegate, or notifications:

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

```objective-c
kLGAlertViewWillShowNotification;
kLGAlertViewWillDismissNotification;
kLGAlertViewDidShowNotification;
kLGAlertViewDidDismissNotification;
kLGAlertViewActionNotification;
kLGAlertViewCancelNotification;
kLGAlertViewDestructiveNotification;
```

### More

For more details try Xcode [Demo project](https://github.com/Friend-LGA/LGAlertView/blob/master/Demo) and see [LGAlertView.h](https://github.com/Friend-LGA/LGAlertView/blob/master/LGAlertView/LGAlertView.h)

## License

LGAlertView is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/Friend-LGA/LGAlertView/master/LICENSE) for details.
