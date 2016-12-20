//
//  TableViewControllerAlert.m
//  LGAlertViewDemo
//

#import "TableViewControllerAlert.h"
#import "LGAlertView.h"

@interface TableViewControllerAlert () <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *titlesArray;
@property (strong, nonatomic) LGAlertView *securityAlertView;

@end

@implementation TableViewControllerAlert

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"AlertView Style";

        self.titlesArray = @[@"UIAlertView + 4 Buttons",
                             @"UIAlertController + 4 Buttons",
                             @"",
                             @"LGAlertView + 1 Button",
                             @"LGAlertView + 2 Buttons in a row",
                             @"LGAlertView + 3 Buttons in a row",
                             @"LGAlertView + 4 Buttons",
                             @"LGAlertView + Long texts adjusted",
                             @"LGAlertView + Long texts multiline",
                             @"LGAlertView + No cancel gesture",
                             @"LGAlertView + A lot of buttons long",
                             @"LGAlertView + A lot of buttons short",
                             @"LGAlertView + TextFileds",
                             @"LGAlertView + A lot of textFields",
                             @"LGAlertView + UIView",
                             @"LGAlertView + ActivityIndicator",
                             @"LGAlertView + ActivityIndicator cancel",
                             @"LGAlertView + ProgressView cancel",
                             @"",
                             @"LGAlertView + Transition 1",
                             @"LGAlertView + Transition 2",
                             @"LGAlertView + Transition 3"];

        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        UIEdgeInsets contentInset = self.tableView.contentInset;
        contentInset.bottom = 88.0;
        self.tableView.contentInset = contentInset;
    }
    return self;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.text = self.titlesArray[indexPath.row];
    cell.userInteractionEnabled = (indexPath.row != 2 && indexPath.row != 18);

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            [[[UIAlertView alloc] initWithTitle:@"Title"
                                        message:@"Message"
                                       delegate:nil
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Button 1", @"Button 2", @"Destructive", nil] show];

            break;
        }
        case 1: {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title"
                                                                                     message:@"Message"
                                                                              preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:nil];

            UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"Destructive"
                                                                        style:UIAlertActionStyleDestructive
                                                                      handler:nil];

            UIAlertAction *otherButton1 = [UIAlertAction actionWithTitle:@"Button 1"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];

            UIAlertAction *otherButton2 = [UIAlertAction actionWithTitle:@"Button 2"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];

            [alertController addAction:cancelButton];
            [alertController addAction:destructiveButton];
            [alertController addAction:otherButton1];
            [alertController addAction:otherButton2];

            [self presentViewController:alertController animated:YES completion:nil];

            break;
        }
        case 3: {
            [[[LGAlertView alloc] initWithTitle:@"Title"
                                        message:@"1 button"
                                          style:LGAlertViewStyleAlert
                                   buttonTitles:nil
                              cancelButtonTitle:@"OK"
                         destructiveButtonTitle:nil
                                  actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                      NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                  }
                                  cancelHandler:^(LGAlertView *alertView) {
                                      NSLog(@"cancelHandler");
                                  }
                             destructiveHandler:^(LGAlertView *alertView) {
                                 NSLog(@"destructiveHandler");
                             }] showAnimated:YES completionHandler:nil];

            break;
        }
        case 4: {
            [[[LGAlertView alloc] initWithTitle:@"Title"
                                        message:@"2 buttons in a row"
                                          style:LGAlertViewStyleAlert
                                   buttonTitles:nil
                              cancelButtonTitle:@"Cancel"
                         destructiveButtonTitle:@"Destructive"
                                  actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                      NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                  }
                                  cancelHandler:^(LGAlertView *alertView) {
                                      NSLog(@"cancelHandler");
                                  }
                             destructiveHandler:^(LGAlertView *alertView) {
                                 NSLog(@"destructiveHandler");
                             }] showAnimated:YES completionHandler:nil];

            break;
        }
        case 5: {
            [[[LGAlertView alloc] initWithTitle:@"Title"
                                        message:@"3 buttons in a row"
                                          style:LGAlertViewStyleAlert
                                   buttonTitles:@[@"1 - A", @"2 - B", @"3 - C"]
                              cancelButtonTitle:nil
                         destructiveButtonTitle:nil
                                  actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                      NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                  }
                                  cancelHandler:^(LGAlertView *alertView) {
                                      NSLog(@"cancelHandler");
                                  }
                             destructiveHandler:^(LGAlertView *alertView) {
                                 NSLog(@"destructiveHandler");
                             }] showAnimated:YES completionHandler:nil];

            break;
        }
        case 6: {
            [[[LGAlertView alloc] initWithTitle:@"Title"
                                        message:@"Message"
                                          style:LGAlertViewStyleAlert
                                   buttonTitles:@[@"Button 1", @"Button 2"]
                              cancelButtonTitle:@"Cancel"
                         destructiveButtonTitle:@"Destructive"
                                  actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                      NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                  }
                                  cancelHandler:^(LGAlertView *alertView) {
                                      NSLog(@"cancelHandler");
                                  }
                             destructiveHandler:^(LGAlertView *alertView) {
                                 NSLog(@"destructiveHandler");
                             }] showAnimated:YES completionHandler:nil];

            break;
        }
        case 7: {
            [[[LGAlertView alloc] initWithTitle:@"Some very really unbelievable long title text"
                                        message:@"Some unbelievable really very long message text"
                                          style:LGAlertViewStyleAlert
                                   buttonTitles:@[@"Other button 1 with longest title text ever exists",
                                                  @"Other button 2 with longest title text ever exists"]
                              cancelButtonTitle:@"Cancel"
                         destructiveButtonTitle:@"Destructive"
                                  actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                      NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                  }
                                  cancelHandler:^(LGAlertView *alertView) {
                                      NSLog(@"cancelHandler");
                                  }
                             destructiveHandler:^(LGAlertView *alertView) {
                                 NSLog(@"destructiveHandler");
                             }] showAnimated:YES completionHandler:nil];

            break;
        }
        case 8: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Some very really unbelievable long title text"
                                                                message:@"Some unbelievable really very long message text"
                                                                  style:LGAlertViewStyleAlert
                                                           buttonTitles:@[@"Other button 1 with longest title text ever exists",
                                                                          @"Other button 2 with longest title text ever exists"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"
                                                          actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                              NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                                          }
                                                          cancelHandler:^(LGAlertView *alertView) {
                                                              NSLog(@"cancelHandler");
                                                          }
                                                     destructiveHandler:^(LGAlertView *alertView) {
                                                         NSLog(@"destructiveHandler");
                                                     }];

            alertView.buttonsNumberOfLines = 0;
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 9: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"No cancel here"
                                                                message:@"You need to make a decision"
                                                                  style:LGAlertViewStyleAlert
                                                           buttonTitles:@[@"Blue pill"]
                                                      cancelButtonTitle:nil
                                                 destructiveButtonTitle:@"Red pill"
                                                          actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                              NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                                          }
                                                          cancelHandler:^(LGAlertView *alertView) {
                                                              NSLog(@"cancelHandler");
                                                          }
                                                     destructiveHandler:^(LGAlertView *alertView) {
                                                         NSLog(@"destructiveHandler");
                                                     }];

            alertView.cancelOnTouch = NO;
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 10: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"A lot of buttons"
                                                                message:@"You can scroll it"
                                                                  style:LGAlertViewStyleAlert
                                                           buttonTitles:@[@"Button 1",
                                                                          @"Button 2",
                                                                          @"Button 3",
                                                                          @"Button 4",
                                                                          @"Button 5",
                                                                          @"Button 6",
                                                                          @"Button 7",
                                                                          @"Button 8",
                                                                          @"Button 9",
                                                                          @"Button 10",
                                                                          @"Button 12",
                                                                          @"Button 13",
                                                                          @"Button 14",
                                                                          @"Button 15",
                                                                          @"Button 16",
                                                                          @"Button 17",
                                                                          @"Button 18",
                                                                          @"Button 19",
                                                                          @"Button 20",
                                                                          @"Button 21",
                                                                          @"Button 22",
                                                                          @"Button 23",
                                                                          @"Button 24",
                                                                          @"Button 25"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"
                                                          actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                              NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                                          }
                                                          cancelHandler:^(LGAlertView *alertView) {
                                                              NSLog(@"cancelHandler");
                                                          }
                                                     destructiveHandler:^(LGAlertView *alertView) {
                                                         NSLog(@"destructiveHandler");
                                                     }];

            alertView.windowLevel = LGAlertViewWindowLevelBelowStatusBar;
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 11: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"A lot of buttons"
                                                                message:@"You can scroll it"
                                                                  style:LGAlertViewStyleAlert
                                                           buttonTitles:@[@"Button 1",
                                                                          @"Button 2",
                                                                          @"Button 3",
                                                                          @"Button 4",
                                                                          @"Button 5",
                                                                          @"Button 6",
                                                                          @"Button 7",
                                                                          @"Button 8",
                                                                          @"Button 9",
                                                                          @"Button 10",
                                                                          @"Button 12",
                                                                          @"Button 13",
                                                                          @"Button 14",
                                                                          @"Button 15",
                                                                          @"Button 16",
                                                                          @"Button 17",
                                                                          @"Button 18",
                                                                          @"Button 19",
                                                                          @"Button 20",
                                                                          @"Button 21",
                                                                          @"Button 22",
                                                                          @"Button 23",
                                                                          @"Button 24",
                                                                          @"Button 25"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"
                                                          actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                              NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                                          }
                                                          cancelHandler:^(LGAlertView *alertView) {
                                                              NSLog(@"cancelHandler");
                                                          }
                                                     destructiveHandler:^(LGAlertView *alertView) {
                                                         NSLog(@"destructiveHandler");
                                                     }];

            alertView.heightMax = 256.0;
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 12: {
            self.securityAlertView = [[LGAlertView alloc] initWithTextFieldsAndTitle:@"Security"
                                                                             message:@"Enter your login and password"
                                                                  numberOfTextFields:2
                                                              textFieldsSetupHandler:^(UITextField *textField, NSUInteger index) {
                                                                  if (index == 0) {
                                                                      textField.placeholder = @"Login";
                                                                  }
                                                                  else if (index == 1) {
                                                                      textField.placeholder = @"Password";
                                                                      textField.secureTextEntry = YES;
                                                                  }

                                                                  textField.tag = index;
                                                                  textField.delegate = self;
                                                                  textField.enablesReturnKeyAutomatically = YES;
                                                                  textField.autocapitalizationType = NO;
                                                                  textField.autocorrectionType = NO;
                                                              }
                                                                        buttonTitles:@[@"Done"]
                                                                   cancelButtonTitle:@"Cancel"
                                                              destructiveButtonTitle:nil
                                                                       actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                                           NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                                                       }
                                                                       cancelHandler:^(LGAlertView *alertView) {
                                                                           NSLog(@"cancelHandler");
                                                                       }
                                                                  destructiveHandler:^(LGAlertView *alertView) {
                                                                      NSLog(@"destructiveHandler");
                                                                  }];

            [self.securityAlertView setButtonAtIndex:0 enabled:NO];
            [self.securityAlertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 13: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTextFieldsAndTitle:@"A lot of textFields"
                                                                             message:@"When you select some, alertView will change size"
                                                                  numberOfTextFields:25
                                                              textFieldsSetupHandler:^(UITextField *textField, NSUInteger index) {
                                                                  textField.placeholder = [NSString stringWithFormat:@"Placeholder %lu", (long unsigned)index+1];
                                                              }
                                                                        buttonTitles:@[@"Done"]
                                                                   cancelButtonTitle:@"Cancel"
                                                              destructiveButtonTitle:nil
                                                                       actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                                           NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                                                       }
                                                                       cancelHandler:^(LGAlertView *alertView) {
                                                                           NSLog(@"cancelHandler");
                                                                       }
                                                                  destructiveHandler:^(LGAlertView *alertView) {
                                                                      NSLog(@"destructiveHandler");
                                                                  }];

            alertView.windowLevel = LGAlertViewWindowLevelBelowStatusBar;
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 14: {
            UIDatePicker *datePicker = [UIDatePicker new];
            datePicker.datePickerMode = UIDatePickerModeTime;
            datePicker.frame = CGRectMake(0.0, 0.0, datePicker.frame.size.width, 160.0);

            [[[LGAlertView alloc] initWithViewAndTitle:@"WOW, it's DatePicker here"
                                               message:@"Choose any time, please"
                                                 style:LGAlertViewStyleAlert
                                                  view:datePicker
                                          buttonTitles:@[@"Done"]
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:nil
                                         actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                             NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                         }
                                         cancelHandler:^(LGAlertView *alertView) {
                                             NSLog(@"cancelHandler");
                                         }
                                    destructiveHandler:^(LGAlertView *alertView) {
                                        NSLog(@"destructiveHandler");
                                    }] showAnimated:YES completionHandler:nil];

            break;
        }
        case 15: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithActivityIndicatorAndTitle:@"Loading"
                                                                                    message:@"Waiting please"
                                                                                      style:LGAlertViewStyleAlert
                                                                               buttonTitles:nil
                                                                          cancelButtonTitle:nil
                                                                     destructiveButtonTitle:nil
                                                                              actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                                                  NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                                                              }
                                                                              cancelHandler:^(LGAlertView *alertView) {
                                                                                  NSLog(@"cancelHandler");
                                                                              }
                                                                         destructiveHandler:^(LGAlertView *alertView) {
                                                                             NSLog(@"destructiveHandler");
                                                                         }];

            [alertView showAnimated:YES completionHandler:nil];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                if (alertView && alertView.isShowing) {
                    [alertView dismissAnimated:YES completionHandler:nil];
                }
            });

            break;
        }
        case 16: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithActivityIndicatorAndTitle:@"Loading"
                                                                                    message:@"Waiting please"
                                                                                      style:LGAlertViewStyleAlert
                                                                               buttonTitles:nil
                                                                          cancelButtonTitle:@"I'm hurry"
                                                                     destructiveButtonTitle:nil
                                                                              actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                                                  NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                                                              }
                                                                              cancelHandler:^(LGAlertView *alertView) {
                                                                                  NSLog(@"cancelHandler");
                                                                              }
                                                                         destructiveHandler:^(LGAlertView *alertView) {
                                                                             NSLog(@"destructiveHandler");
                                                                         }];

            [alertView showAnimated:YES completionHandler:nil];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                if (alertView && alertView.isShowing) {
                    [alertView dismissAnimated:YES completionHandler:nil];
                }
            });

            break;
        }
        case 17: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithProgressViewAndTitle:@"Loading"
                                                                               message:@"Waiting please"
                                                                                 style:LGAlertViewStyleAlert
                                                                     progressLabelText:@"0 %"
                                                                          buttonTitles:nil
                                                                     cancelButtonTitle:@"I'm hurry"
                                                                destructiveButtonTitle:nil
                                                                         actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                                             NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                                                         }
                                                                         cancelHandler:^(LGAlertView *alertView) {
                                                                             NSLog(@"cancelHandler");
                                                                         }
                                                                    destructiveHandler:^(LGAlertView *alertView) {
                                                                        NSLog(@"destructiveHandler");
                                                                    }];

            [alertView showAnimated:YES completionHandler:nil];

            [self updateProgressWithAlertView:alertView];

            break;
        }
        case 19: {
            LGAlertView *alertView1 = [[LGAlertView alloc] initWithActivityIndicatorAndTitle:@"Loading"
                                                                                     message:@"Waiting please"
                                                                                       style:LGAlertViewStyleAlert
                                                                                buttonTitles:nil
                                                                           cancelButtonTitle:@"I'm hurry"
                                                                      destructiveButtonTitle:nil
                                                                               actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                                                   NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                                                               }
                                                                               cancelHandler:^(LGAlertView *alertView) {
                                                                                   NSLog(@"cancelHandler");
                                                                               }
                                                                          destructiveHandler:^(LGAlertView *alertView) {
                                                                              NSLog(@"destructiveHandler");
                                                                          }];

            [alertView1 showAnimated:YES completionHandler:nil];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                LGAlertView *alertView2 = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                     message:@"Message"
                                                                       style:LGAlertViewStyleAlert
                                                                buttonTitles:@[@"Button 1", @"Button 2"]
                                                           cancelButtonTitle:@"Cancel"
                                                      destructiveButtonTitle:@"Destructive"
                                                               actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                                   NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                                               }
                                                               cancelHandler:^(LGAlertView *alertView) {
                                                                   NSLog(@"cancelHandler");
                                                               }
                                                          destructiveHandler:^(LGAlertView *alertView) {
                                                              NSLog(@"destructiveHandler");
                                                          }];

                if (alertView1 && alertView1.isShowing) {
                    [alertView1 transitionToAlertView:alertView2 completionHandler:nil];
                }
            });

            break;
        }
        case 20: {
            LGAlertView *alertView1 = [[LGAlertView alloc] initWithActivityIndicatorAndTitle:@"Loading"
                                                                                     message:@"Waiting please"
                                                                                       style:LGAlertViewStyleAlert
                                                                                buttonTitles:nil
                                                                           cancelButtonTitle:@"I'm hurry"
                                                                      destructiveButtonTitle:nil
                                                                               actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                                                   NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                                                               }
                                                                               cancelHandler:^(LGAlertView *alertView) {
                                                                                   NSLog(@"cancelHandler");
                                                                               }
                                                                          destructiveHandler:^(LGAlertView *alertView) {
                                                                              NSLog(@"destructiveHandler");
                                                                          }];

            [alertView1 showAnimated:YES completionHandler:nil];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                LGAlertView *alertView2 = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                     message:@"Message"
                                                                       style:LGAlertViewStyleActionSheet
                                                                buttonTitles:@[@"Button 1", @"Button 2"]
                                                           cancelButtonTitle:nil
                                                      destructiveButtonTitle:@"Destructive"
                                                               actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                                   NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                                               }
                                                               cancelHandler:^(LGAlertView *alertView) {
                                                                   NSLog(@"cancelHandler");
                                                               }
                                                          destructiveHandler:^(LGAlertView *alertView) {
                                                              NSLog(@"destructiveHandler");
                                                          }];

                if (alertView1 && alertView1.isShowing) {
                    [alertView1 transitionToAlertView:alertView2 completionHandler:nil];
                }
            });

            break;
        }
        case 21: {
            LGAlertView *alertView1 = [[LGAlertView alloc] initWithActivityIndicatorAndTitle:@"Loading"
                                                                                     message:@"Waiting please"
                                                                                       style:LGAlertViewStyleAlert
                                                                                buttonTitles:nil
                                                                           cancelButtonTitle:@"I'm hurry"
                                                                      destructiveButtonTitle:nil
                                                                               actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                                                   NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                                                               }
                                                                               cancelHandler:^(LGAlertView *alertView) {
                                                                                   NSLog(@"cancelHandler");
                                                                               }
                                                                          destructiveHandler:^(LGAlertView *alertView) {
                                                                              NSLog(@"destructiveHandler");
                                                                          }];

            [alertView1 showAnimated:YES completionHandler:nil];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                LGAlertView *alertView2 = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                     message:@"Message"
                                                                       style:LGAlertViewStyleActionSheet
                                                                buttonTitles:@[@"Button 1", @"Button 2"]
                                                           cancelButtonTitle:@"Cancel"
                                                      destructiveButtonTitle:@"Destructive"
                                                               actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                                   NSLog(@"actionHandler, %@, %lu", title, (long unsigned)index);
                                                               }
                                                               cancelHandler:^(LGAlertView *alertView) {
                                                                   NSLog(@"cancelHandler");
                                                               }
                                                          destructiveHandler:^(LGAlertView *alertView) {
                                                              NSLog(@"destructiveHandler");
                                                          }];

                if (alertView1 && alertView1.isShowing) {
                    [alertView1 transitionToAlertView:alertView2 completionHandler:nil];
                }
            });

            break;
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    UITextField *secondTextField = self.securityAlertView.textFieldsArray[(textField.tag == 0 ? 1 : 0)];

    NSMutableString *currentString = textField.text.mutableCopy;

    [currentString replaceCharactersInRange:range withString:string];

    [self.securityAlertView setButtonAtIndex:0 enabled:(currentString.length > 2 && secondTextField.text.length > 2)];

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag < 1) {
        [self.securityAlertView.textFieldsArray[(textField.tag + 1)] becomeFirstResponder];
    }
    else {
        if ([self.securityAlertView isButtonEnabledAtIndex:0]) {
            [self.securityAlertView dismissAnimated:YES completionHandler:nil];
        }
        else {
            [textField resignFirstResponder];
        }
    }

    return YES;
}

#pragma mark -

- (void)updateProgressWithAlertView:(LGAlertView *)alertView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
        if (alertView.progress >= 1.0) {
            [alertView dismissAnimated:YES completionHandler:nil];
        }
        else {
            float progress = alertView.progress+0.0025;
            
            if (progress > 1.0) {
                progress = 1.0;
            }
            
            [alertView setProgress:progress progressLabelText:[NSString stringWithFormat:@"%.0f %%", progress*100]];
            
            [self updateProgressWithAlertView:alertView];
        }
    });
}

@end
