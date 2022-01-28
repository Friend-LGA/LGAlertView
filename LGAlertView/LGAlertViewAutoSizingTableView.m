//
//  LGAlertViewAutoSizingTableView.m
//  LGAlertViewDemo
//
//  Created by Nik Kov on 12.03.2019.
//  Copyright © 2019 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGAlertViewAutoSizingTableView.h"

@implementation LGAlertViewAutoSizingTableView: UITableView

- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    return self.contentSize;
}

@end
