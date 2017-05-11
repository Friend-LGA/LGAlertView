//
//  TableViewControllerBlurredActionSheet.m
//  LGAlertViewDemo
//

#import "TableViewControllerBlurredActionSheet.h"
#import "LGAlertView.h"

@interface TableViewControllerBlurredActionSheet ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation TableViewControllerBlurredActionSheet

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"Blur Effect";

        self.titlesArray = @[@"UIActionSheet",
                             @"UIAlertViewController",
                             @"",
                             @"LGAlertView extra light",
                             @"LGAlertView light",
                             @"LGAlertView dark",
                             @"LGAlertView cover light",
                             @"LGAlertView cover dark"];

        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image"]];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.tableView.backgroundView = self.imageView;

        self.tableView.separatorColor = UIColor.clearColor;
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

    cell.textLabel.textColor = UIColor.whiteColor;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    cell.textLabel.text = self.titlesArray[indexPath.row];
    cell.backgroundColor = [self.titlesArray[indexPath.row] length] > 0 ? [UIColor colorWithWhite:0.0 alpha:0.25] : UIColor.clearColor;
    cell.userInteractionEnabled = [self.titlesArray[indexPath.row] length] > 0;
    cell.textLabel.backgroundColor = UIColor.clearColor;

    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    cell.selectedBackgroundView = view;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            [[[UIActionSheet alloc] initWithTitle:@"Title"
                                         delegate:nil
                                cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:@"Destructive"
                                otherButtonTitles:@"Button 1", @"Button 2", nil] showInView:self.view];

            break;
        }
        case 1: {
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

            break;
        }
        case 3: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                message:@"Message"
                                                                  style:LGAlertViewStyleActionSheet
                                                           buttonTitles:@[@"Button 1", @"Button 2"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"];

            alertView.backgroundBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            alertView.backgroundColor = UIColor.clearColor;

            alertView.separatorsColor = [UIColor colorWithWhite:0.7 alpha:1.0];

            alertView.cancelButtonBackgroundColor = UIColor.whiteColor;

            [alertView showAnimated];

            break;
        }
        case 4: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                message:@"Message"
                                                                  style:LGAlertViewStyleActionSheet
                                                           buttonTitles:@[@"Button 1", @"Button 2"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"];

            alertView.backgroundBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            alertView.backgroundColor = UIColor.clearColor;

            alertView.separatorsColor = [UIColor colorWithWhite:0.3 alpha:1.0];

            alertView.titleTextColor = UIColor.blackColor;
            alertView.messageTextColor = UIColor.blackColor;

            alertView.tintColor = [UIColor colorWithRed:0.5 green:0.75 blue:1.0 alpha:1.0];
            alertView.buttonsBackgroundColorHighlighted = [alertView.tintColor colorWithAlphaComponent:0.5];
            alertView.cancelButtonBackgroundColorHighlighted = [alertView.tintColor colorWithAlphaComponent:0.5];
            alertView.destructiveButtonTitleColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.5 alpha:1.0];
            alertView.destructiveButtonBackgroundColorHighlighted = [alertView.destructiveButtonTitleColor colorWithAlphaComponent:0.5];

            [alertView showAnimated];

            break;
        }
        case 5: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                message:@"Message"
                                                                  style:LGAlertViewStyleActionSheet
                                                           buttonTitles:@[@"Button 1", @"Button 2"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"];

            alertView.backgroundBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            alertView.backgroundColor = UIColor.clearColor;

            alertView.separatorsColor = [UIColor colorWithWhite:0.25 alpha:1.0];

            alertView.titleTextColor = UIColor.lightGrayColor;
            alertView.messageTextColor = UIColor.lightGrayColor;

            alertView.buttonsTitleColorHighlighted = UIColor.blackColor;
            alertView.cancelButtonTitleColorHighlighted = UIColor.blackColor;
            alertView.destructiveButtonTitleColorHighlighted = UIColor.blackColor;

            alertView.cancelButtonBackgroundColor = UIColor.blackColor;

            [alertView showAnimated];

            break;
        }
        case 6: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                message:@"Message"
                                                                  style:LGAlertViewStyleActionSheet
                                                           buttonTitles:@[@"Button 1", @"Button 2"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"];

            alertView.coverColor = UIColor.clearColor;
            alertView.coverBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            alertView.coverAlpha = 0.9;

            alertView.backgroundBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            alertView.backgroundColor = UIColor.clearColor;

            alertView.separatorsColor = [UIColor colorWithWhite:0.75 alpha:1.0];

            alertView.cancelButtonBackgroundColor = UIColor.whiteColor;

            [alertView showAnimated];

            break;
        }
        case 7: {
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"Title"
                                                                message:@"Message"
                                                                  style:LGAlertViewStyleActionSheet
                                                           buttonTitles:@[@"Button 1", @"Button 2"]
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:@"Destructive"];

            alertView.coverColor = UIColor.clearColor;
            alertView.coverBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            alertView.coverAlpha = 0.9;

            alertView.backgroundBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            alertView.backgroundColor = UIColor.clearColor;

            alertView.separatorsColor = [UIColor colorWithWhite:0.25 alpha:1.0];

            alertView.titleTextColor = UIColor.lightGrayColor;
            alertView.messageTextColor = UIColor.lightGrayColor;

            alertView.buttonsTitleColorHighlighted = UIColor.blackColor;
            alertView.cancelButtonTitleColorHighlighted = UIColor.blackColor;
            alertView.destructiveButtonTitleColorHighlighted = UIColor.blackColor;

            alertView.cancelButtonBackgroundColor = UIColor.blackColor;

            [alertView showAnimated];

            break;
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
