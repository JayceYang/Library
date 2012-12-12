//
//  TableBasedViewController.h
//  Pull
//
//  Created by Jayce Yang on 12-11-30.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableBasedViewController : UIViewController

@property (readonly, strong, nonatomic) UITableView *tableView;

- (void)beginRefreshing;
- (void)endRefreshing;
//- (void)beginRefreshing;
- (void)endLoadingMore;
- (void)refresh;
- (void)loadMore;

@end
