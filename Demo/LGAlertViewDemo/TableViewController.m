//
//  TableViewController.m
//  LGAlertViewDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "TableViewController.h"
#import "LGAlertView.h"

@interface TableViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation TableViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.title = @"LGAlertView";
        
        _titlesArray = @[@"UIAlertView",
                         @"LGAlertView + UIView",
                         @"LGAlertView + Buttons Short",
                         @"LGAlertView + Buttons Long",
                         @"LGAlertView + Buttons Multiline",
                         @"LGAlertView + Buttons (a lot of) 1",
                         @"LGAlertView + Buttons (a lot of) 2",
                         @"LGAlertView + No cancel gesture",
                         @"LGAlertView + TextFiled",
                         @"LGAlertView + TextFiled (a lot of)",
                         @"LGAlertView + ActivityIndicator",
                         @"LGAlertView + ProgressView",
                         @"LGAlertView + Crazy style"];
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return self;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.textLabel.text = _titlesArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Title"
                                    message:@"Message"
                                   delegate:nil
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Other 1", @"Other 2", @"Destructive", nil] show];
    }
    else if (indexPath.row == 1)
    {
        UIDatePicker *datePicker = [UIDatePicker new];
        datePicker.frame = CGRectMake(0.f, 0.f, datePicker.frame.size.width, 100.f);
        
        [[[LGAlertView alloc] initWithViewStyleWithTitle:@"WOW, it's DatePicker here"
                                                 message:@"Choose any date, please"
                                                    view:datePicker
                                            buttonTitles:@[@"Done"]
                                       cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                           actionHandler:nil
                                           cancelHandler:nil
                                      destructiveHandler:nil] showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 2)
    {
        [[[LGAlertView alloc] initWithTitle:@"Just title"
                                    message:@"2 buttons in a row"
                               buttonTitles:nil
                          cancelButtonTitle:@"Cancel"
                     destructiveButtonTitle:@"Destructive"
                              actionHandler:nil
                              cancelHandler:nil
                         destructiveHandler:nil] showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 3)
    {
        [[[LGAlertView alloc] initWithTitle:@"Some long title text, for iPhone 6 Plus even bigger."
                                    message:@"Some really unbelievable long message text. And for iPhone 6 Plus it needs to be even bigger."
                               buttonTitles:@[@"Other button 1 with longest title text, for iPhone 6 Plus even bigger.",
                                              @"Other button 2 with longest title text, for iPhone 6 Plus even bigger."]
                          cancelButtonTitle:@"Cancel"
                     destructiveButtonTitle:@"Destructive"
                              actionHandler:nil
                              cancelHandler:nil
                         destructiveHandler:nil] showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 4)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Some long title text, for iPhone 6 Plus even bigger."
                                                            message:@"Some really unbelievable long message text. And for iPhone 6 Plus it needs to be even bigger."
                                                       buttonTitles:@[@"Other button 1 with longest title text, for iPhone 6 Plus even bigger.",
                                                                      @"Other button 2 with longest title text, for iPhone 6 Plus even bigger."]
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Destructive"
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];
        alertView.buttonsNumberOfLines = 0;
        [alertView showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 5)
    {
        [[[LGAlertView alloc] initWithTitle:@"So many buttons..."
                                    message:@"Scroll it, if you can"
                               buttonTitles:@[@"Other 1",
                                              @"Other 2",
                                              @"Other 3",
                                              @"Other 4",
                                              @"Other 5",
                                              @"Other 6",
                                              @"Other 7",
                                              @"Other 8",
                                              @"Other 9",
                                              @"Other 10",
                                              @"Other 12",
                                              @"Other 13",
                                              @"Other 14",
                                              @"Other 15"]
                          cancelButtonTitle:@"Cancel"
                     destructiveButtonTitle:@"Destructive"
                              actionHandler:nil
                              cancelHandler:nil
                         destructiveHandler:nil] showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 6)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"So many buttons..."
                                                            message:@"On iPad width will be full screen size. And buttons highlighted colors are grey."
                                                       buttonTitles:@[@"Other 1",
                                                                      @"Other 2",
                                                                      @"Other 3",
                                                                      @"Other 4",
                                                                      @"Other 5",
                                                                      @"Other 6",
                                                                      @"Other 7",
                                                                      @"Other 8",
                                                                      @"Other 9",
                                                                      @"Other 10",
                                                                      @"Other 12",
                                                                      @"Other 13",
                                                                      @"Other 14",
                                                                      @"Other 15"]
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Destructive"
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];
        alertView.heightMax = 200.f;
        alertView.widthMax = CGFLOAT_MAX;
        alertView.colorful = NO;
        [alertView showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 7)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"No cancel here"
                                                            message:@"You need to make a decision"
                                                       buttonTitles:@[@"Blue pill"]
                                                  cancelButtonTitle:nil
                                             destructiveButtonTitle:@"Red pill"
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];
        alertView.cancelOnTouch = NO;
        [alertView showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 8)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTextFieldsStyleWithTitle:@"Security"
                                                                               message:@"Enter your login and password"
                                                                    numberOfTextFields:2
                                                                textFieldsSetupHandler:^(UITextField *textField, NSUInteger index)
                                  {
                                      if (index == 0)
                                          textField.placeholder = @"Login";
                                      else if (index == 1)
                                      {
                                          textField.placeholder = @"Password";
                                          textField.secureTextEntry = YES;
                                      }
                                  }
                                                                          buttonTitles:@[@"Done"]
                                                                     cancelButtonTitle:@"Cancel"
                                                                destructiveButtonTitle:nil
                                                                         actionHandler:nil
                                                                         cancelHandler:nil
                                                                    destructiveHandler:nil];
        
        alertView.cancelOnTouch = NO;
        [alertView showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 9)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTextFieldsStyleWithTitle:@"So many textFields..."
                                                                               message:@"When you select some, alertView will change size"
                                                                    numberOfTextFields:15
                                                                textFieldsSetupHandler:^(UITextField *textField, NSUInteger index)
                                  {
                                      textField.placeholder = [NSString stringWithFormat:@"Beautiful placeholder %i", (int)index];
                                  }
                                                                          buttonTitles:@[@"Done"]
                                                                     cancelButtonTitle:@"Cancel"
                                                                destructiveButtonTitle:nil
                                                                         actionHandler:nil
                                                                         cancelHandler:nil
                                                                    destructiveHandler:nil];
        
        alertView.cancelOnTouch = NO;
        [alertView showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 10)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithActivityIndicatorStyleWithTitle:@"Loading"
                                                                                      message:@"Waiting please"
                                                                                 buttonTitles:nil
                                                                            cancelButtonTitle:@"I'm hurry"
                                                                       destructiveButtonTitle:nil
                                                                                actionHandler:nil
                                                                                cancelHandler:nil
                                                                           destructiveHandler:nil];
        alertView.cancelOnTouch = NO;
        [alertView showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 11)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithProgressViewStyleWithTitle:@"Loading"
                                                                                 message:@"Waiting please"
                                                                       progressLabelText:@"0 %"
                                                                            buttonTitles:nil
                                                                       cancelButtonTitle:@"I'm hurry"
                                                                  destructiveButtonTitle:nil
                                                                           actionHandler:nil
                                                                           cancelHandler:nil
                                                                      destructiveHandler:nil];
        alertView.cancelOnTouch = NO;
        [alertView showAnimated:YES completionHandler:nil];
        
        [self updateProgressWithAlertView:alertView];
    }
    else if (indexPath.row == 12)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"CRAZY STYLE"
                                                            message:@"May be someone like it?"
                                                       buttonTitles:@[@"Awesome Button"]
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Destructive"
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];
        
        alertView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.8];
        
        alertView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];
        alertView.layerBorderWidth = 1.f;
        alertView.layerBorderColor = [UIColor redColor];
        alertView.layerCornerRadius = 0.f;
        alertView.layerShadowColor = [UIColor colorWithWhite:0.f alpha:0.5];
        alertView.layerShadowRadius = 5.f;
        
        alertView.titleTextAlignment = NSTextAlignmentRight;
        alertView.titleTextColor = [UIColor whiteColor];
        
        alertView.messageTextAlignment = NSTextAlignmentLeft;
        alertView.messageTextColor = [UIColor whiteColor];
        
        alertView.separatorsColor = [UIColor colorWithWhite:0.6 alpha:1.f];
        
        alertView.tintColor = [UIColor greenColor];
        
        alertView.buttonsTitleColorHighlighted = [UIColor blackColor];
        
        alertView.cancelButtonTitleColor = [UIColor cyanColor];
        alertView.cancelButtonTitleColorHighlighted = [UIColor blackColor];
        alertView.cancelButtonBackgroundColorHighlighted = [UIColor cyanColor];
        
        alertView.destructiveButtonTitleColor = [UIColor yellowColor];
        alertView.destructiveButtonTitleColorHighlighted = [UIColor blackColor];
        alertView.destructiveButtonBackgroundColorHighlighted = [UIColor yellowColor];
        
        // And much more settings you can apply, check it in LGAlertView class
        
        [alertView showAnimated:YES completionHandler:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateProgressWithAlertView:(LGAlertView *)alertView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                   {
                       if (alertView.progress >= 1.f)
                           [alertView dismissAnimated:YES completionHandler:nil];
                       else
                       {
                           float progress = alertView.progress+0.0025;
                           
                           if (progress > 1.f)
                               progress = 1.f;
                           
                           [alertView setProgress:progress progressLabelText:[NSString stringWithFormat:@"%.0f %%", progress*100]];
                           
                           [self updateProgressWithAlertView:alertView];
                       }
                   });
}

@end
