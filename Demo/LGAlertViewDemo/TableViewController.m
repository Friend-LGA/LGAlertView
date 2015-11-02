//
//  TableViewController.m
//  LGAlertViewDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewControllerAlert.h"
#import "TableViewControllerActionSheet.h"
#import "TableViewControllerCustomAlert.h"
#import "TableViewControllerCustomActionSheet.h"

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

        _titlesArray = @[@"AlertView Style",
                         @"ActionSheet Style",
                         @"Custom AlertView Styles",
                         @"Custom ActionSheet Styles"];

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

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
        TableViewControllerAlert *tableViewController = [TableViewControllerAlert new];
        [self.navigationController pushViewController:tableViewController animated:YES];
    }
    else if (indexPath.row == 1)
    {
        TableViewControllerActionSheet *tableViewController = [TableViewControllerActionSheet new];
        [self.navigationController pushViewController:tableViewController animated:YES];
    }
    else if (indexPath.row == 2)
    {
        TableViewControllerCustomAlert *tableViewController = [TableViewControllerCustomAlert new];
        [self.navigationController pushViewController:tableViewController animated:YES];
    }
    else if (indexPath.row == 3)
    {
        TableViewControllerCustomActionSheet *tableViewController = [TableViewControllerCustomActionSheet new];
        [self.navigationController pushViewController:tableViewController animated:YES];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
