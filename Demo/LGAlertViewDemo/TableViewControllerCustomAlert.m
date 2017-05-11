//
//  TableViewControllerCustomAlert.m
//  LGAlertViewDemo
//

#import "TableViewControllerCustomAlert.h"
#import "LGAlertView.h"

@interface TableViewControllerCustomAlert ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation TableViewControllerCustomAlert

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"Custom AlertView Styles";

        self.titlesArray = @[@"Default Style",
                             @"",
                             @"Example 1",
                             @"Example 2",
                             @"Example 3",
                             @"Example 4",
                             @"Example 5",
                             @"Example 6",
                             @"Example 7"];

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

            break;
        }
        case 2: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                message:@"Message"
                                                                  style:LGAlertViewStyleAlert
                                                           buttonTitles:@[@"Button"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"
                                                          actionHandler:nil
                                                          cancelHandler:nil
                                                     destructiveHandler:nil];

            alertView.coverColor = [UIColor colorWithWhite:1.0 alpha:0.25];
            alertView.coverBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            alertView.coverAlpha = 0.85;
            alertView.layerShadowColor = [UIColor colorWithWhite:0.0 alpha:0.3];
            alertView.layerShadowRadius = 4.0;
            alertView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 3: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                message:@"Message"
                                                                  style:LGAlertViewStyleAlert
                                                           buttonTitles:@[@"Button"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"
                                                          actionHandler:nil
                                                          cancelHandler:nil
                                                     destructiveHandler:nil];

            alertView.coverColor = [UIColor colorWithWhite:1.0 alpha:0.25];
            alertView.coverBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            alertView.coverAlpha = 0.85;
            alertView.layerShadowColor = [UIColor colorWithWhite:0.0 alpha:0.3];
            alertView.layerShadowRadius = 4.0;
            alertView.layerBorderWidth = 2.0;
            alertView.layerBorderColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
            alertView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 4: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                message:@"Message"
                                                                  style:LGAlertViewStyleAlert
                                                           buttonTitles:@[@"Button"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"
                                                          actionHandler:nil
                                                          cancelHandler:nil
                                                     destructiveHandler:nil];

            alertView.coverColor = [UIColor colorWithWhite:1.0 alpha:0.25];
            alertView.coverBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            alertView.coverAlpha = 0.85;
            alertView.layerShadowColor = [UIColor colorWithWhite:0.0 alpha:0.3];
            alertView.layerShadowRadius = 4.0;
            alertView.layerCornerRadius = 0.0;
            alertView.layerBorderWidth = 2.0;
            alertView.layerBorderColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
            alertView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 5: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                message:@"Message"
                                                                  style:LGAlertViewStyleAlert
                                                           buttonTitles:@[@"Button"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"
                                                          actionHandler:nil
                                                          cancelHandler:nil
                                                     destructiveHandler:nil];

            alertView.coverColor = [UIColor colorWithWhite:1.0 alpha:0.25];
            alertView.coverBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            alertView.coverAlpha = 0.85;
            alertView.layerShadowColor = [UIColor colorWithWhite:0.0 alpha:0.3];
            alertView.layerShadowRadius = 4.0;
            alertView.layerCornerRadius = 0.0;
            alertView.layerBorderWidth = 2.0;
            alertView.layerBorderColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
            alertView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            alertView.width = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 6: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                message:@"Message"
                                                                  style:LGAlertViewStyleAlert
                                                           buttonTitles:@[@"Button"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"
                                                          actionHandler:nil
                                                          cancelHandler:nil
                                                     destructiveHandler:nil];

            alertView.coverColor = [UIColor colorWithWhite:1.0 alpha:0.25];
            alertView.coverBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            alertView.coverAlpha = 0.85;
            alertView.layerShadowColor = [UIColor colorWithWhite:0.0 alpha:0.3];
            alertView.layerShadowRadius = 4.0;
            alertView.layerCornerRadius = 0.0;
            alertView.layerBorderWidth = 2.0;
            alertView.layerBorderColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
            alertView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            alertView.width = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
            alertView.titleTextAlignment = NSTextAlignmentLeft;
            alertView.messageTextAlignment = NSTextAlignmentLeft;
            alertView.oneRowOneButton = YES;
            alertView.buttonsTextAlignment = NSTextAlignmentRight;
            alertView.cancelButtonTextAlignment = NSTextAlignmentRight;
            alertView.destructiveButtonTextAlignment = NSTextAlignmentRight;
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 7: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                message:@"Message"
                                                                  style:LGAlertViewStyleAlert
                                                           buttonTitles:@[@"Button"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"
                                                          actionHandler:nil
                                                          cancelHandler:nil
                                                     destructiveHandler:nil];

            alertView.coverColor = [UIColor colorWithWhite:1.0 alpha:0.25];
            alertView.coverBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            alertView.coverAlpha = 0.85;
            alertView.layerShadowColor = [UIColor colorWithWhite:0.0 alpha:0.3];
            alertView.layerShadowRadius = 4.0;
            alertView.layerCornerRadius = 0.0;
            alertView.layerBorderWidth = 2.0;
            alertView.layerBorderColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
            alertView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            alertView.width = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
            alertView.titleTextAlignment = NSTextAlignmentLeft;
            alertView.messageTextAlignment = NSTextAlignmentLeft;
            alertView.oneRowOneButton = YES;
            alertView.destructiveButtonTextAlignment = NSTextAlignmentRight;
            alertView.buttonsTextAlignment = NSTextAlignmentRight;
            alertView.cancelButtonTextAlignment = NSTextAlignmentRight;
            alertView.separatorsColor = nil;
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
        case 8: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                message:@"Message"
                                                                  style:LGAlertViewStyleAlert
                                                           buttonTitles:@[@"Button"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"
                                                          actionHandler:nil
                                                          cancelHandler:nil
                                                     destructiveHandler:nil];

            alertView.coverColor = [UIColor colorWithWhite:1.0 alpha:0.25];
            alertView.coverBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            alertView.coverAlpha = 0.85;
            alertView.layerShadowColor = [UIColor colorWithWhite:0.0 alpha:0.3];
            alertView.layerShadowRadius = 4.0;
            alertView.layerCornerRadius = 0.0;
            alertView.layerBorderWidth = 2.0;
            alertView.layerBorderColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
            alertView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
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
            alertView.destructiveButtonBackgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
            alertView.buttonsBackgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:0.5];
            alertView.cancelButtonBackgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
            alertView.destructiveButtonBackgroundColorHighlighted = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
            alertView.buttonsBackgroundColorHighlighted = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
            alertView.cancelButtonBackgroundColorHighlighted = [UIColor colorWithWhite:0.5 alpha:1.0];
            [alertView showAnimated:YES completionHandler:nil];

            break;
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
