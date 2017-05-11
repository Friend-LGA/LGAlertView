//
//  TableViewController.m
//  LGAlertViewDemo
//

#import "TableViewController.h"
#import "TableViewControllerAlert.h"
#import "TableViewControllerActionSheet.h"
#import "TableViewControllerBlurredAlert.h"
#import "TableViewControllerBlurredActionSheet.h"
#import "TableViewControllerCustomAlert.h"
#import "TableViewControllerCustomActionSheet.h"
#import "LGAlertView.h"

@interface TableViewController () <LGAlertViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation TableViewController

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"LGAlertView";

        self.titlesArray = @[@"Default AlertView",
                             @"Default ActionSheet",
                             @"Blurred AlertView",
                             @"Blurred ActionSheet",
                             @"Custom AlertView",
                             @"Custom ActionSheet",
                             @"Alerts Cycle",
                             @"Mix of Alerts"];

        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

        self.clearsSelectionOnViewWillAppear = YES;
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

    if (indexPath.row < 5) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UIViewController *nextViewController;

    switch (indexPath.row) {
        case 0:
            nextViewController = [TableViewControllerAlert new];
            break;
        case 1:
            nextViewController = [TableViewControllerActionSheet new];
            break;
        case 2:
            nextViewController = [TableViewControllerBlurredAlert new];
            break;
        case 3:
            nextViewController = [TableViewControllerBlurredActionSheet new];
            break;
        case 4:
            nextViewController = [TableViewControllerCustomAlert new];
            break;
        case 5:
            nextViewController = [TableViewControllerCustomActionSheet new];
            break;
        case 6:
            [self showRandomAlertWithNumber:NSNotFound];
            break;
        case 7:
            for (NSUInteger i=0; i<10; i++) {
                [self showRandomAlertWithNumber:(i + 1) delay:(i * 1.0)];
            }
    }

    if (nextViewController) {
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

#pragma mark -

- (void)showRandomAlertWithNumber:(NSUInteger)number {
    NSUInteger random = arc4random() % 4;

    switch (random) {
        case 0:
            [self showLGAlertViewWithNumber:number];
            break;
        case 1:
            [self showLGActionSheetWithNumber:number];
            break;
        case 2:
            [self showUIAlertViewWithNumber:number];
            break;
        case 3:
            [self showUIActionSheetWithNumber:number];
            break;
    }
}

- (void)showRandomAlertWithNumber:(NSUInteger)number delay:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showRandomAlertWithNumber:number];
    });
}

- (void)showLGAlertViewWithNumber:(NSUInteger)number {
    NSMutableString *title = @"LGAlertView".mutableCopy;
    if (number != NSNotFound) {
        [title appendFormat:@" %lu", (unsigned long)number];
    }

    LGAlertView *alertView = [LGAlertView alertViewWithTitle:title
                                                     message:nil
                                                       style:LGAlertViewStyleAlert
                                                buttonTitles:@[@"Random", @"LGAlertView", @"LGActionSheet", @"UIAlertView", @"UIActionSheet"]
                                           cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                                    delegate:self];
    alertView.tag = number;
    [alertView showAnimated];
}

- (void)showLGActionSheetWithNumber:(NSUInteger)number {
    NSMutableString *title = @"LGActionSheet".mutableCopy;
    if (number != NSNotFound) {
        [title appendFormat:@" %lu", (unsigned long)number];
    }

    LGAlertView *actionSheet = [LGAlertView alertViewWithTitle:title
                                                       message:nil
                                                         style:LGAlertViewStyleActionSheet
                                                  buttonTitles:@[@"Random", @"LGAlertView", @"LGActionSheet", @"UIAlertView", @"UIActionSheet"]
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                                      delegate:self];
    actionSheet.tag = number;
    [actionSheet showAnimated];
}

- (void)showUIAlertViewWithNumber:(NSUInteger)number {
    NSMutableString *title = @"UIAlertView".mutableCopy;
    if (number != NSNotFound) {
        [title appendFormat:@" %lu", (unsigned long)number];
    }

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Random", @"LGAlertView", @"LGActionSheet", @"UIAlertView", @"UIActionSheet", nil];
    alertView.tag = number;
    [alertView show];
}

- (void)showUIActionSheetWithNumber:(NSUInteger)number {
    NSMutableString *title = @"UIActionSheet".mutableCopy;
    if (number != NSNotFound) {
        [title appendFormat:@" %lu", (unsigned long)number];
    }

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Random", @"LGAlertView", @"LGActionSheet", @"UIAlertView", @"UIActionSheet", nil];
    actionSheet.tag = number;
    [actionSheet showInView:self.view];
}

#pragma mark - Delegates

- (void)alertView:(LGAlertView *)alertView clickedButtonAtIndex:(NSUInteger)index title:(NSString *)title {
    switch (index) {
        case 0:
            [self showRandomAlertWithNumber:alertView.tag];
            break;
        case 1:
            [self showLGAlertViewWithNumber:alertView.tag];
            break;
        case 2:
            [self showLGActionSheetWithNumber:alertView.tag];
            break;
        case 3:
            [self showUIAlertViewWithNumber:alertView.tag];
            break;
        case 4:
            [self showUIActionSheetWithNumber:alertView.tag];
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) return;

    switch (buttonIndex) {
        case 1:
            [self showRandomAlertWithNumber:alertView.tag];
            break;
        case 2:
            [self showLGAlertViewWithNumber:alertView.tag];
            break;
        case 3:
            [self showLGActionSheetWithNumber:alertView.tag];
            break;
        case 4:
            [self showUIAlertViewWithNumber:alertView.tag];
            break;
        case 5:
            [self showUIActionSheetWithNumber:alertView.tag];
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 5) return;

    switch (buttonIndex) {
        case 0:
            [self showRandomAlertWithNumber:actionSheet.tag];
            break;
        case 1:
            [self showLGAlertViewWithNumber:actionSheet.tag];
            break;
        case 2:
            [self showLGActionSheetWithNumber:actionSheet.tag];
            break;
        case 3:
            [self showUIAlertViewWithNumber:actionSheet.tag];
            break;
        case 4:
            [self showUIActionSheetWithNumber:actionSheet.tag];
            break;
    }
}

@end
