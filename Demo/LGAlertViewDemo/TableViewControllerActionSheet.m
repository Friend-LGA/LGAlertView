//
//  TableViewControllerActionSheet.m
//  LGAlertViewDemo
//
//  Created by Grigory Lutkov on 28.10.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "TableViewControllerActionSheet.h"
#import "LGAlertView.h"

@interface TableViewControllerActionSheet ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation TableViewControllerActionSheet

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.title = @"ActionSheet Style";

        _titlesArray = @[@"UIActionSheet + 4 Buttons",
                         @"UIAlertController + 4 Buttons",
                         @"",
                         @"LGAlertView + 4 Buttons",
                         @"LGAlertView + Long texts adjusted",
                         @"LGAlertView + Long texts multiline",
                         @"LGAlertView + No cancel gesture",
                         @"LGAlertView + A lot of buttons long",
                         @"LGAlertView + A lot of buttons short",
                         @"LGAlertView + UIView",
                         @"LGAlertView + ActivityIndicator",
                         @"LGAlertView + ActivityIndicator cancel",
                         @"LGAlertView + ProgressView cancel"];

        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        UIEdgeInsets contentInset = self.tableView.contentInset;
        contentInset.bottom = 44.f*2;
        self.tableView.contentInset = contentInset;
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

    cell.userInteractionEnabled = (indexPath.row != 2);

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
        [[[UIActionSheet alloc] initWithTitle:@"Title"
                                     delegate:nil
                            cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:@"Destructive"
                            otherButtonTitles:@"Button 1", @"Button 2", nil] showInView:self.view];
    }
    else if (indexPath.row == 1)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title"
                                                                                 message:@"Message"
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
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
    }
    else if (indexPath.row == 3)
    {
        [[[LGAlertView alloc] initWithTitle:@"Title"
                                    message:@"Message"
                                      style:LGAlertViewStyleActionSheet
                               buttonTitles:@[@"Button 1", @"Button 2"]
                          cancelButtonTitle:@"Cancel"
                     destructiveButtonTitle:@"Destructive"
                              actionHandler:nil
                              cancelHandler:nil
                         destructiveHandler:nil] showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 4)
    {
        [[[LGAlertView alloc] initWithTitle:@"Some very really unbelievable long title text. For iPhone 6 and 6 Plus is even longer."
                                    message:@"Some unbelievable really very long message text. For iPhone 6 and 6 Plus is even longer."
                                      style:LGAlertViewStyleActionSheet
                               buttonTitles:@[@"Other button 1 with longest title text ever exists. For iPhone 6 and 6 Plus is even longer.",
                                              @"Other button 2 with longest title text ever exists. For iPhone 6 and 6 Plus is even longer."]
                          cancelButtonTitle:@"Cancel"
                     destructiveButtonTitle:@"Destructive"
                              actionHandler:nil
                              cancelHandler:nil
                         destructiveHandler:nil] showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 5)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Some very really unbelievable long title text. For iPhone 6 and 6 Plus is even longer."
                                                            message:@"Some unbelievable really very long message text. For iPhone 6 and 6 Plus is even longer."
                                                              style:LGAlertViewStyleActionSheet
                                                       buttonTitles:@[@"Other button 1 with longest title text ever exists. For iPhone 6 and 6 Plus is even longer.",
                                                                      @"Other button 2 with longest title text ever exists. For iPhone 6 and 6 Plus is even longer."]
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Destructive"
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];
        alertView.buttonsNumberOfLines = 0;
        [alertView showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 6)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"No cancel here"
                                                            message:@"You need to make a decision"
                                                              style:LGAlertViewStyleActionSheet
                                                       buttonTitles:@[@"Blue pill"]
                                                  cancelButtonTitle:nil
                                             destructiveButtonTitle:@"Red pill"
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];
        alertView.cancelOnTouch = NO;
        [alertView showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 7)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"A lot of buttons"
                                                            message:@"You can scroll it"
                                                              style:LGAlertViewStyleActionSheet
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
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];
        alertView.windowLevel = LGAlertViewWindowLevelBelowStatusBar;
        [alertView showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 8)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"A lot of buttons"
                                                            message:@"You can scroll it"
                                                              style:LGAlertViewStyleActionSheet
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
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];
        alertView.heightMax = 256.f;
        [alertView showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 9)
    {
        UIDatePicker *datePicker = [UIDatePicker new];
        datePicker.datePickerMode = UIDatePickerModeTime;
        datePicker.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, 110.f);

        [[[LGAlertView alloc] initWithViewAndTitle:@"WOW, it's DatePicker here"
                                           message:@"Choose any time, please"
                                             style:LGAlertViewStyleActionSheet
                                              view:datePicker
                                      buttonTitles:@[@"Done"]
                                 cancelButtonTitle:@"Cancel"
                            destructiveButtonTitle:nil
                                     actionHandler:nil
                                     cancelHandler:nil
                                destructiveHandler:nil] showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 10)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithActivityIndicatorAndTitle:@"Loading"
                                                                                message:@"Waiting please"
                                                                                  style:LGAlertViewStyleActionSheet
                                                                           buttonTitles:nil
                                                                      cancelButtonTitle:nil
                                                                 destructiveButtonTitle:nil
                                                                          actionHandler:nil
                                                                          cancelHandler:nil
                                                                     destructiveHandler:nil];
        [alertView showAnimated:YES completionHandler:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                       {
                           [alertView dismissAnimated:YES completionHandler:nil];
                       });
    }
    else if (indexPath.row == 11)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithActivityIndicatorAndTitle:@"Loading"
                                                                                message:@"Waiting please"
                                                                                  style:LGAlertViewStyleActionSheet
                                                                           buttonTitles:nil
                                                                      cancelButtonTitle:@"I'm hurry"
                                                                 destructiveButtonTitle:nil
                                                                          actionHandler:nil
                                                                          cancelHandler:nil
                                                                     destructiveHandler:nil];
        [alertView showAnimated:YES completionHandler:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                       {
                           [alertView dismissAnimated:YES completionHandler:nil];
                       });
    }
    else if (indexPath.row == 12)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithProgressViewAndTitle:@"Loading"
                                                                           message:@"Waiting please"
                                                                             style:LGAlertViewStyleActionSheet
                                                                 progressLabelText:@"0 %"
                                                                      buttonTitles:nil
                                                                 cancelButtonTitle:@"I'm hurry"
                                                            destructiveButtonTitle:nil
                                                                     actionHandler:nil
                                                                     cancelHandler:nil
                                                                destructiveHandler:nil];
        [alertView showAnimated:YES completionHandler:nil];

        [self updateProgressWithAlertView:alertView];
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
