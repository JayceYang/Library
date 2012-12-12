//
//  TableBasedViewController.m
//  Pull
//
//  Created by Jayce Yang on 12-11-30.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import "TableBasedViewController.h"
#import "UITableView+PullToRefresh.h"
#import "UITableView+PullToLoadMore.h"

#import "UIViewController+ASCategory.h"

@interface TableBasedViewController () <PullToRefreshViewDelegate, PullToLoadMoreViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TableBasedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    self.tableView = [[[UITableView alloc] initWithFrame:[self mainBounds] style:UITableViewStylePlain] autorelease];
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    [self.tableView addPullToRefresh];
//    self.tableView.pullToRefreshView.delegate = self;
    [self.tableView addPullToLoadMore];
    self.tableView.pullToLoadMoreView.delegate = self;
//    [self.tableView addPullToLoadMoreWithActionHandler:^{
//        [target performSelectorOnMainThread:@selector(loadMore) withObject:nil waitUntilDone:NO];
//    }];
    
//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
//    label1.textAlignment = NSTextAlignmentCenter;
//    label1.text = @"Fetch More";
//    label1.textColor = [UIColor redColor];
//    [self.tableView.pullToLoadMoreView setCustomView:label1 forState:PullToLoadMoreStateTriggered];
//    
//    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
//    label2.textAlignment = NSTextAlignmentCenter;
//    label2.text = @"Loading";
//    label2.textColor = [UIColor greenColor];
//    [self.tableView.pullToLoadMoreView setCustomView:label2 forState:PullToLoadMoreStateLoading];
//    
//    UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
//    label0.textAlignment = NSTextAlignmentCenter;
//    label0.text = @"Stoped";
//    label0.textColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)beginRefreshing
{
    [self.tableView.pullToRefreshView startAnimating];
}

- (void)endRefreshing
{
    [self.tableView.pullToRefreshView stopAnimating];
}

- (void)endLoadingMore
{
    [self.tableView.pullToLoadMoreView stopAnimating];
}

- (void)refresh
{
    
}

- (void)loadMore
{
    
}

- (void)pullToRefreshViewDidBeginRefreshing
{
    [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
}

- (void)pullToLoadMoreViewDidBeginLoadingMore
{
    [self performSelectorOnMainThread:@selector(loadMore) withObject:nil waitUntilDone:NO];
}

@end
