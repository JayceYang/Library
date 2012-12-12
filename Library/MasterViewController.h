//
//  MasterViewController.h
//  ASSupplementDemo
//
//  Created by Jayce Yang on 12-12-6.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableBasedViewController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
