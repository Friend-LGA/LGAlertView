//
//  TableViewControllerAlert.m
//  LGAlertViewDemo
//

#import "TableViewControllerAlert.h"
#import "LGAlertView.h"

@interface TableViewControllerAlert () <UITextFieldDelegate, LGAlertViewDelegate>

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
                             @"LGAlertView + Icons left",
                             @"LGAlertView + Icons right",
                             @"LGAlertView + Icons only",
                             @"LGAlertView + Long texts adjusted",
                             @"LGAlertView + Long texts multiline",
                             @"LGAlertView + No cancel gesture",
                             @"LGAlertView + A lot of buttons long",
                             @"LGAlertView + A lot of buttons short",
                             @"LGAlertView + TextFileds",
                             @"LGAlertView + A lot of textFields",
                             @"LGAlertView + UIView",
                             @"LGAlertView + UIScrollView",
                             @"LGAlertView + XIB",
                             @"LGAlertView + ActivityIndicator",
                             @"LGAlertView + ActivityIndicator cancel",
                             @"LGAlertView + ProgressView",
                             @"LGAlertView + ProgressView cancel",
                             @"",
                             @"LGAlertView + Transition 1",
                             @"LGAlertView + Transition 2",
                             @"LGAlertView + Transition 3"];

        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
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
    cell.userInteractionEnabled = [self.titlesArray[indexPath.row] length] > 0;

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
                                       delegate:self] showAnimated:YES completionHandler:nil];

            break;
        }
        case 4: {
            [[[LGAlertView alloc] initWithTitle:@"Title"
                                        message:@"2 buttons in a row"
                                          style:LGAlertViewStyleAlert
                                   buttonTitles:nil
                              cancelButtonTitle:@"Cancel"
                         destructiveButtonTitle:@"Destructive"
                                       delegate:self] showAnimated:YES completionHandler:nil];

            break;
        }
        case 5: {
            [[[LGAlertView alloc] initWithTitle:@"Title"
                                        message:@"3 buttons in a row"
                                          style:LGAlertViewStyleAlert
                                   buttonTitles:@[@"1 - A", @"2 - B", @"3 - C"]
                              cancelButtonTitle:nil
                         destructiveButtonTitle:nil
                                       delegate:self] showAnimated:YES completionHandler:nil];

            break;
        }
        case 6: {
            [[[LGAlertView alloc] initWithTitle:@"Title"
                                        message:@"Message"
                                          style:LGAlertViewStyleAlert
                                   buttonTitles:@[@"Button 1", @"Button 2"]
                              cancelButtonTitle:@"Cancel"
                         destructiveButtonTitle:@"Destructive"
                                       delegate:self] showAnimated:YES completionHandler:nil];

            break;
        }
        case 7: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"With icons"
                                                                message:@"On left side"
                                                                  style:LGAlertViewStyleAlert
                                                           buttonTitles:@[@"Button"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"
                                                               delegate:self];

            alertView.buttonsIconImages = @[[UIImage imageNamed:@"Button"]];
            alertView.buttonsIconImagesHighlighted = @[[UIImage imageNamed:@"ButtonHighlighted"]];
            alertView.buttonsTextAlignment = NSTextAlignmentLeft;

            alertView.cancelButtonIconImage = [UIImage imageNamed:@"Cancel"];
            alertView.cancelButtonIconImageHighlighted = [UIImage imageNamed:@"CancelHighlighted"];
            alertView.cancelButtonTextAlignment = NSTextAlignmentLeft;

            alertView.destructiveButtonIconImage = [UIImage imageNamed:@"Destructive"];
            alertView.destructiveButtonIconImageHighlighted = [UIImage imageNamed:@"DestructiveHighlighted"];
            alertView.destructiveButtonTextAlignment = NSTextAlignmentLeft;

            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 8: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"With icons"
                                                                message:@"On right side"
                                                                  style:LGAlertViewStyleAlert
                                                           buttonTitles:@[@"Button"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"
                                                               delegate:self];

            alertView.buttonsIconImages = @[[UIImage imageNamed:@"Button"]];
            alertView.buttonsIconImagesHighlighted = @[[UIImage imageNamed:@"ButtonHighlighted"]];
            alertView.buttonsIconPosition = LGAlertViewButtonIconPositionRight;
            alertView.buttonsTextAlignment = NSTextAlignmentLeft;

            alertView.cancelButtonIconImage = [UIImage imageNamed:@"Cancel"];
            alertView.cancelButtonIconImageHighlighted = [UIImage imageNamed:@"CancelHighlighted"];
            alertView.cancelButtonIconPosition = LGAlertViewButtonIconPositionRight;
            alertView.cancelButtonTextAlignment = NSTextAlignmentLeft;

            alertView.destructiveButtonIconImage = [UIImage imageNamed:@"Destructive"];
            alertView.destructiveButtonIconImageHighlighted = [UIImage imageNamed:@"DestructiveHighlighted"];
            alertView.destructiveButtonIconPosition = LGAlertViewButtonIconPositionRight;
            alertView.destructiveButtonTextAlignment = NSTextAlignmentLeft;

            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 9: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"With icons"
                                                                message:@"Without titles"
                                                                  style:LGAlertViewStyleAlert
                                                           buttonTitles:@[@""]
                                                      cancelButtonTitle:@""
                                                 destructiveButtonTitle:@""
                                                               delegate:self];

            alertView.buttonsIconImages = @[[UIImage imageNamed:@"Button"]];
            alertView.buttonsIconImagesHighlighted = @[[UIImage imageNamed:@"ButtonHighlighted"]];

            alertView.cancelButtonIconImage = [UIImage imageNamed:@"Cancel"];
            alertView.cancelButtonIconImageHighlighted = [UIImage imageNamed:@"CancelHighlighted"];

            alertView.destructiveButtonIconImage = [UIImage imageNamed:@"Destructive"];
            alertView.destructiveButtonIconImageHighlighted = [UIImage imageNamed:@"DestructiveHighlighted"];

            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 10: {
            [[[LGAlertView alloc] initWithTitle:@"Some very really unbelievable long title text"
                                        message:@"Some unbelievable really very long message text"
                                          style:LGAlertViewStyleAlert
                                   buttonTitles:@[@"Other button 1 with longest title text ever exists",
                                                  @"Other button 2 with longest title text ever exists"]
                              cancelButtonTitle:@"Cancel"
                         destructiveButtonTitle:@"Destructive"
                                       delegate:self] showAnimated:YES completionHandler:nil];

            break;
        }
        case 11: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Some very really unbelievable long title text"
                                                                message:@"Some unbelievable really very long message text"
                                                                  style:LGAlertViewStyleAlert
                                                           buttonTitles:@[@"Other button 1 with longest title text ever exists",
                                                                          @"Other button 2 with longest title text ever exists"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"
                                                               delegate:self];

            alertView.buttonsNumberOfLines = 0;
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 12: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"No cancel here"
                                                                message:@"You need to make a decision"
                                                                  style:LGAlertViewStyleAlert
                                                           buttonTitles:@[@"Blue pill"]
                                                      cancelButtonTitle:nil
                                                 destructiveButtonTitle:@"Red pill"
                                                               delegate:self];

            alertView.cancelOnTouch = NO;
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 13: {
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
                                                               delegate:self];

            alertView.windowLevel = LGAlertViewWindowLevelBelowStatusBar;
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 14: {
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
                                                               delegate:self];

            alertView.heightMax = 256.0;
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 15: {
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
                                                                            delegate:self];

            [self.securityAlertView setButtonEnabled:NO atIndex:0];
            [self.securityAlertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 16: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTextFieldsAndTitle:@"A lot of textFields"
                                                                             message:@"When you select some, alertView will change size"
                                                                  numberOfTextFields:25
                                                              textFieldsSetupHandler:^(UITextField *textField, NSUInteger index) {
                                                                  textField.placeholder = [NSString stringWithFormat:@"Placeholder %lu", (long unsigned)index+1];
                                                              }
                                                                        buttonTitles:@[@"Done"]
                                                                   cancelButtonTitle:@"Cancel"
                                                              destructiveButtonTitle:nil
                                                                            delegate:self];

            alertView.windowLevel = LGAlertViewWindowLevelBelowStatusBar;
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 17: {
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
                                              delegate:self] showAnimated:YES completionHandler:nil];

            break;
        }
        case 18: {
            UIScrollView *scrollView = [UIScrollView new];

            UILabel *label = [UILabel new];
            label.numberOfLines = 0;
            label.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce bibendum sagittis magna, at pulvinar leo. Vestibulum eu ex ut ligula mollis tempus in sit amet lacus. Nullam fermentum tortor sit amet arcu ornare, a fringilla arcu vulputate. Pellentesque accumsan imperdiet viverra. Praesent et bibendum turpis. Morbi condimentum risus non neque vehicula, a laoreet neque lacinia. Nullam et lorem non magna pharetra ullamcorper. Duis malesuada sem quis venenatis pulvinar. Pellentesque consectetur dolor non elit pretium laoreet. Praesent condimentum tristique sapien, non lacinia erat ullamcorper eu. Pellentesque turpis nisl, mollis id arcu eget, commodo commodo massa. Duis pretium et libero sed fringilla. Donec a nunc sem. Phasellus eget est eget quam commodo egestas.\n\nNam rhoncus vehicula interdum. Praesent urna lorem, iaculis id sem eu, varius gravida sapien. Sed et purus bibendum ipsum feugiat placerat. Donec iaculis urna nisl, vel condimentum elit auctor quis. Phasellus mollis vehicula facilisis. Vivamus commodo arcu sed justo consectetur interdum. Suspendisse pharetra malesuada sem eleifend bibendum. Suspendisse quis tempus lorem. Cras viverra congue nisi, sed molestie sem. Etiam accumsan tincidunt arcu, quis feugiat mi lacinia quis. Curabitur sit amet tincidunt nisl.\n\nProin sit amet tempor augue. Proin eget arcu quis ipsum semper condimentum nec ac purus. Aliquam vestibulum iaculis mi in fermentum. Nunc venenatis magna in tristique pulvinar. Nulla vitae ipsum libero. Cras ex arcu, rhoncus id finibus vel, feugiat ut dolor. Duis condimentum, nunc volutpat accumsan elementum, nibh nisl dapibus massa, in tristique ligula tellus in nibh. Mauris vel urna suscipit, mollis quam vel, tempus diam. Donec velit felis, laoreet vitae eleifend id, fermentum sit amet justo.\n\nNunc rhoncus arcu quam, vel egestas metus accumsan quis. Phasellus posuere ullamcorper turpis, at luctus quam semper non. Interdum et malesuada fames ac ante ipsum primis in faucibus. Quisque vel porttitor felis, pellentesque blandit turpis. Pellentesque id mauris nisl. Donec imperdiet, quam rhoncus tincidunt bibendum, sapien est maximus sapien, eu suscipit turpis diam eget neque. Integer eu lorem accumsan, faucibus nulla in, varius purus. Morbi in aliquet risus.\n\nDuis pellentesque nunc ac lacinia suscipit. Suspendisse accumsan molestie pulvinar. Sed dolor turpis, tempor a facilisis id, fringilla eget enim. Suspendisse condimentum placerat faucibus. Mauris risus magna, posuere id finibus nec, semper ut nisl. Sed quis lorem dapibus, volutpat magna quis, porta leo. Praesent eu diam maximus quam dapibus pharetra. Pellentesque tincidunt vel magna at ullamcorper. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin sit amet lectus at tortor pharetra accumsan.";
            [scrollView addSubview:label];

            LGAlertView *alertView = [[LGAlertView alloc] initWithViewAndTitle:@"Scroll view with text"
                                                                       message:@"Please, read it:"
                                                                         style:LGAlertViewStyleAlert
                                                                          view:scrollView
                                                                  buttonTitles:@[@"Agree"]
                                                             cancelButtonTitle:@"Cancel"
                                                        destructiveButtonTitle:nil
                                                                      delegate:self];

            scrollView.frame = CGRectMake(0.0, 0.0, alertView.width, 160.0);

            label.textColor = alertView.messageTextColor;
            label.font = alertView.messageFont;

            CGSize labelSize = [label sizeThatFits:CGSizeMake(alertView.width - 16.0, CGFLOAT_MAX)];
            label.frame = CGRectMake(8.0, 0.0, labelSize.width, labelSize.height);

            scrollView.contentSize = CGSizeMake(alertView.width, labelSize.height);

            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 19: {
            [[[LGAlertView alloc] initWithViewAndTitle:@"Autolayouts"
                                               message:@"You need to set width and height constraints"
                                                 style:LGAlertViewStyleAlert
                                                  view:[[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil].lastObject
                                          buttonTitles:@[@"Done"]
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:nil
                                              delegate:self] showAnimated:YES completionHandler:nil];

            break;
        }
        case 20: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithActivityIndicatorAndTitle:@"Loading"
                                                                                    message:@"Waiting please"
                                                                                      style:LGAlertViewStyleAlert
                                                                          progressLabelText:@"Connecting to server..."
                                                                               buttonTitles:nil
                                                                          cancelButtonTitle:nil
                                                                     destructiveButtonTitle:nil
                                                                                   delegate:self];

            [alertView showAnimated:YES completionHandler:nil];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                if (alertView && alertView.isShowing) {
                    alertView.progressLabelText = @"Done, will be closed after 3...";

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                        alertView.progressLabelText = @"Done, will be closed after 2...";

                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                            alertView.progressLabelText = @"Done, will be closed after 1...";

                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                                if (alertView && alertView.isShowing) {
                                    [alertView dismissAnimated:YES completionHandler:nil];
                                }
                            });
                        });
                    });
                }
            });

            break;
        }
        case 21: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithActivityIndicatorAndTitle:@"Loading"
                                                                                    message:@"Waiting please"
                                                                                      style:LGAlertViewStyleAlert
                                                                          progressLabelText:@"Connecting to server..."
                                                                               buttonTitles:nil
                                                                          cancelButtonTitle:@"I'm hurry"
                                                                     destructiveButtonTitle:nil
                                                                                   delegate:self];

            [alertView showAnimated:YES completionHandler:nil];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                if (alertView && alertView.isShowing) {
                    alertView.progressLabelText = @"Done, will be closed after 3...";

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                        alertView.progressLabelText = @"Done, will be closed after 2...";

                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                            alertView.progressLabelText = @"Done, will be closed after 1...";

                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                                if (alertView && alertView.isShowing) {
                                    [alertView dismissAnimated:YES completionHandler:nil];
                                }
                            });
                        });
                    });
                }
            });

            break;
        }
        case 22: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithProgressViewAndTitle:@"Loading"
                                                                               message:@"Waiting please"
                                                                                 style:LGAlertViewStyleAlert
                                                                              progress:0.0
                                                                     progressLabelText:@"Connecting to server..."
                                                                          buttonTitles:nil
                                                                     cancelButtonTitle:nil
                                                                destructiveButtonTitle:nil
                                                                              delegate:self];

            [alertView showAnimated:YES completionHandler:nil];

            [self updateProgressWithAlertView:alertView];

            break;
        }
        case 23: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithProgressViewAndTitle:@"Loading"
                                                                               message:@"Waiting please"
                                                                                 style:LGAlertViewStyleAlert
                                                                              progress:0.0
                                                                     progressLabelText:@"Connecting to server..."
                                                                          buttonTitles:nil
                                                                     cancelButtonTitle:@"I'm hurry"
                                                                destructiveButtonTitle:nil
                                                                              delegate:self];

            [alertView showAnimated:YES completionHandler:nil];

            [self updateProgressWithAlertView:alertView];

            break;
        }
        case 25: {
            LGAlertView *alertView1 = [[LGAlertView alloc] initWithActivityIndicatorAndTitle:@"Loading"
                                                                                     message:@"Waiting please"
                                                                                       style:LGAlertViewStyleAlert
                                                                           progressLabelText:nil
                                                                                buttonTitles:nil
                                                                           cancelButtonTitle:@"I'm hurry"
                                                                      destructiveButtonTitle:nil
                                                                                    delegate:self];

            [alertView1 showAnimated:YES completionHandler:nil];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                LGAlertView *alertView2 = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                     message:@"Message"
                                                                       style:LGAlertViewStyleAlert
                                                                buttonTitles:@[@"Button 1", @"Button 2"]
                                                           cancelButtonTitle:@"Cancel"
                                                      destructiveButtonTitle:@"Destructive"
                                                                    delegate:self];

                if (alertView1 && alertView1.isShowing) {
                    [alertView1 transitionToAlertView:alertView2 completionHandler:nil];
                }
            });

            break;
        }
        case 26: {
            LGAlertView *alertView1 = [[LGAlertView alloc] initWithActivityIndicatorAndTitle:@"Loading"
                                                                                     message:@"Waiting please"
                                                                                       style:LGAlertViewStyleAlert
                                                                           progressLabelText:nil
                                                                                buttonTitles:nil
                                                                           cancelButtonTitle:@"I'm hurry"
                                                                      destructiveButtonTitle:nil
                                                                                    delegate:self];

            [alertView1 showAnimated:YES completionHandler:nil];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                LGAlertView *alertView2 = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                     message:@"Message"
                                                                       style:LGAlertViewStyleActionSheet
                                                                buttonTitles:@[@"Button 1", @"Button 2"]
                                                           cancelButtonTitle:nil
                                                      destructiveButtonTitle:@"Destructive"
                                                                    delegate:self];

                if (alertView1 && alertView1.isShowing) {
                    [alertView1 transitionToAlertView:alertView2 completionHandler:nil];
                }
            });

            break;
        }
        case 27: {
            LGAlertView *alertView1 = [[LGAlertView alloc] initWithActivityIndicatorAndTitle:@"Loading"
                                                                                     message:@"Waiting please"
                                                                                       style:LGAlertViewStyleAlert
                                                                           progressLabelText:nil
                                                                                buttonTitles:nil
                                                                           cancelButtonTitle:@"I'm hurry"
                                                                      destructiveButtonTitle:nil
                                                                                    delegate:self];

            [alertView1 showAnimated:YES completionHandler:nil];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                LGAlertView *alertView2 = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                     message:@"Message"
                                                                       style:LGAlertViewStyleActionSheet
                                                                buttonTitles:@[@"Button 1", @"Button 2"]
                                                           cancelButtonTitle:@"Cancel"
                                                      destructiveButtonTitle:@"Destructive"
                                                                    delegate:self];

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

    [self.securityAlertView setButtonEnabled:(currentString.length > 2 && secondTextField.text.length > 2) atIndex:0];

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
            float progress = alertView.progress + 0.0025;

            if (progress > 1.0) {
                progress = 1.0;
            }

            float percentage = progress * 100.0;

            alertView.progress = progress;
            alertView.progressLabelText = [NSString stringWithFormat:@"%.0f %%", percentage];

            [self updateProgressWithAlertView:alertView];
        }
    });
}

#pragma mark - LGAlertViewDelegate

- (void)alertView:(LGAlertView *)alertView clickedButtonAtIndex:(NSUInteger)index title:(nullable NSString *)title {
    NSLog(@"action {title: %@, index: %lu}", title, (long unsigned)index);
}

- (void)alertViewCancelled:(LGAlertView *)alertView {
    NSLog(@"cancel");
}

- (void)alertViewDestructed:(LGAlertView *)alertView {
    NSLog(@"destructive");
}

@end
