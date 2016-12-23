//
//  TableViewController.m
//  LGAlertViewDemo
//

#import "TableViewController.h"
#import "TableViewControllerAlert.h"
#import "TableViewControllerActionSheet.h"
#import "TableViewControllerCustomAlert.h"
#import "TableViewControllerCustomActionSheet.h"
#import "LGAlertView.h"

@interface TableViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation TableViewController

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"LGAlertView";

        self.titlesArray = @[@"AlertView Style",
                             @"ActionSheet Style",
                             @"Custom AlertView Styles",
                             @"Custom ActionSheet Styles"];

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

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.text = self.titlesArray[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewController *tableViewController;

    switch (indexPath.row) {
        case 0:
            tableViewController = [TableViewControllerAlert new];
            break;
        case 1:
            tableViewController = [TableViewControllerActionSheet new];
            break;
        case 2:
            tableViewController = [TableViewControllerCustomAlert new];
            break;
        case 3:
            tableViewController = [TableViewControllerCustomActionSheet new];
            break;
    }

    [self.navigationController pushViewController:tableViewController animated:YES];
}

@end
