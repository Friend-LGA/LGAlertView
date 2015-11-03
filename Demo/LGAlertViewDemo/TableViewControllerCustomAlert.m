//
//  TableViewControllerCustomAlert.m
//  LGAlertViewDemo
//
//  Created by Grigory Lutkov on 28.10.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "TableViewControllerCustomAlert.h"
#import "LGAlertView.h"

@interface TableViewControllerCustomAlert ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation TableViewControllerCustomAlert

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.title = @"Custom AlertView Styles";

        _titlesArray = @[@"Default Style",
                         @"",
                         @"Custom Style 1",
                         @"Custom Style 2",
                         @"Custom Style 3",
                         @"Custom Style 4",
                         @"Custom Style 5",
                         @"Custom Style 6"];

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

    cell.userInteractionEnabled = (indexPath.row != 1);

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
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                            message:@"Message"
                                                              style:LGAlertViewStyleAlert
                                                       buttonTitles:@[@"Button"]
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Destructive"
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];

        [alertView showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 2)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                            message:@"Message"
                                                              style:LGAlertViewStyleAlert
                                                       buttonTitles:@[@"Button"]
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Destructive"
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];

        alertView.coverColor = [UIColor colorWithWhite:1.f alpha:0.9];
        alertView.layerShadowColor = [UIColor colorWithWhite:0.f alpha:0.3];
        alertView.layerShadowRadius = 4.f;
        [alertView showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 3)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                            message:@"Message"
                                                              style:LGAlertViewStyleAlert
                                                       buttonTitles:@[@"Button"]
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Destructive"
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];

        alertView.coverColor = [UIColor colorWithWhite:1.f alpha:0.9];
        alertView.layerShadowColor = [UIColor colorWithWhite:0.f alpha:0.3];
        alertView.layerShadowRadius = 4.f;
        alertView.layerCornerRadius = 0.f;
        alertView.layerBorderWidth = 2.f;
        alertView.layerBorderColor = [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f];
        alertView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.7];
        [alertView showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 4)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                            message:@"Message"
                                                              style:LGAlertViewStyleAlert
                                                       buttonTitles:@[@"Button"]
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Destructive"
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];

        alertView.coverColor = [UIColor colorWithWhite:1.f alpha:0.9];
        alertView.layerShadowColor = [UIColor colorWithWhite:0.f alpha:0.3];
        alertView.layerShadowRadius = 4.f;
        alertView.layerCornerRadius = 0.f;
        alertView.layerBorderWidth = 2.f;
        alertView.layerBorderColor = [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f];
        alertView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.7];
        alertView.width = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
        [alertView showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 5)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                            message:@"Message"
                                                              style:LGAlertViewStyleAlert
                                                       buttonTitles:@[@"Button"]
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Destructive"
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];

        alertView.coverColor = [UIColor colorWithWhite:1.f alpha:0.9];
        alertView.layerShadowColor = [UIColor colorWithWhite:0.f alpha:0.3];
        alertView.layerShadowRadius = 4.f;
        alertView.layerCornerRadius = 0.f;
        alertView.layerBorderWidth = 2.f;
        alertView.layerBorderColor = [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f];
        alertView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.7];
        alertView.width = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
        alertView.titleTextAlignment = NSTextAlignmentLeft;
        alertView.messageTextAlignment = NSTextAlignmentLeft;
        alertView.oneRowOneButton = YES;
        alertView.buttonsTextAlignment = NSTextAlignmentRight;
        alertView.cancelButtonTextAlignment = NSTextAlignmentRight;
        alertView.destructiveButtonTextAlignment = NSTextAlignmentRight;
        [alertView showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 6)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                            message:@"Message"
                                                              style:LGAlertViewStyleAlert
                                                       buttonTitles:@[@"Button"]
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Destructive"
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];

        alertView.coverColor = [UIColor colorWithWhite:1.f alpha:0.9];
        alertView.layerShadowColor = [UIColor colorWithWhite:0.f alpha:0.3];
        alertView.layerShadowRadius = 4.f;
        alertView.layerCornerRadius = 0.f;
        alertView.layerBorderWidth = 2.f;
        alertView.layerBorderColor = [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f];
        alertView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.7];
        alertView.width = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
        alertView.titleTextAlignment = NSTextAlignmentLeft;
        alertView.messageTextAlignment = NSTextAlignmentLeft;
        alertView.oneRowOneButton = YES;
        alertView.destructiveButtonTextAlignment = NSTextAlignmentRight;
        alertView.buttonsTextAlignment = NSTextAlignmentRight;
        alertView.cancelButtonTextAlignment = NSTextAlignmentRight;
        alertView.separatorsColor = nil;
        [alertView showAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 7)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                            message:@"Message"
                                                              style:LGAlertViewStyleAlert
                                                       buttonTitles:@[@"Button"]
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Destructive"
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];

        alertView.coverColor = [UIColor colorWithWhite:1.f alpha:0.9];
        alertView.layerShadowColor = [UIColor colorWithWhite:0.f alpha:0.3];
        alertView.layerShadowRadius = 4.f;
        alertView.layerCornerRadius = 0.f;
        alertView.layerBorderWidth = 2.f;
        alertView.layerBorderColor = [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f];
        alertView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.7];
        alertView.width = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
        alertView.titleTextAlignment = NSTextAlignmentLeft;
        alertView.messageTextAlignment = NSTextAlignmentLeft;
        alertView.oneRowOneButton = YES;
        alertView.destructiveButtonTextAlignment = NSTextAlignmentRight;
        alertView.buttonsTextAlignment = NSTextAlignmentRight;
        alertView.cancelButtonTextAlignment = NSTextAlignmentRight;
        alertView.separatorsColor = nil;
        alertView.destructiveButtonTitleColor = [UIColor whiteColor];
        alertView.buttonsTitleColor = [UIColor whiteColor];
        alertView.cancelButtonTitleColor = [UIColor whiteColor];
        alertView.destructiveButtonBackgroundColor = [UIColor colorWithRed:1.f green:0.f blue:0.f alpha:0.5];
        alertView.buttonsBackgroundColor = [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:0.5];
        alertView.cancelButtonBackgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        alertView.destructiveButtonBackgroundColorHighlighted = [UIColor colorWithRed:1.f green:0.f blue:0.f alpha:1.f];
        alertView.buttonsBackgroundColorHighlighted = [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f];
        alertView.cancelButtonBackgroundColorHighlighted = [UIColor colorWithWhite:0.5 alpha:1.f];
        [alertView showAnimated:YES completionHandler:nil];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
