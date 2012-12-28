//
//  MasterViewController.m
//  ASSupplementDemo
//
//  Created by Jayce Yang on 12-12-6.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "ASSupplement.h"
#import "NSDate+Helper.h"
#import "NSDate+ASCategory.h"

#import "UITableView+PullToRefresh.h"
#import "UITableView+PullToLoadMore.h"

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *objects;

@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}

- (void)dealloc
{
    ASLog();
    [_detailViewController release];
    [_objects release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //    [self.tableView addPullToLoadMore];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)] autorelease];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIImage *image = [UIImage imageNamed:@"Cloud.png"];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
    tableHeaderView.backgroundColor = [UIColor blackColor];
    UIButton *avatarButton = [self.view buttonWithFrame:CGRectInset(tableHeaderView.bounds, (tableHeaderView.bounds.size.width - width) * .5, 0) target:self action:NULL title:nil backgroundImage:image];
    avatarButton.maskLabel.textAlignment = UITextAlignmentLeft;
    avatarButton.maskLabel.text = @"Chinese:Jayce Yang";
    [tableHeaderView addSubview:avatarButton];
    
    self.tableView.tableHeaderView = tableHeaderView;
    [tableHeaderView release];
    
    [self showLoadingView];
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self hideLoadingView];
    });
    
    ASLog(@"%@",[[UIDevice currentDevice] detailModel]);
    
    [CLGeocoder reverseGeocodeCoordinate:CLLocationCoordinate2DMake(22.53820898, 113.95764800) completionHandler:^(NSString *address, NSError *error) {
        ASLog(@"%@",address);
    }];
    [CLGeocoder reverseGeocodeLocation:[[[CLLocation alloc] initWithLatitude:22.541201 longitude:113.95275] autorelease] completionHandler:^(NSString *address, NSError *error) {
        ASLog(@"%@",address);
    }];
    
    [LocationManager sharedManager].corrective = YES;
    [[LocationManager sharedManager] startUpdatingLocationWithSuccessHandler:^(CLLocation *location) {
        ASLog(@"%@",location);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        self.objects = [[[NSMutableArray alloc] init] autorelease];
    }
    //    [_objects insertObject:[NSDate date] atIndex:0];
    [_objects addObject:[NSDate date]];
    //    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)refresh
{
    //    [super refresh];
    //
    //    ASLog();
    //    int64_t delayInSeconds = 2.0;
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //        [self endRefreshing];
    //    });
}

- (void)loadMore
{
    //[super loadMore];
    
    ASLog();
    [self insertNewObject:nil];
    
    //[self endLoadingMore];
}

- (void)toNewPage
{
    MasterViewController *masterViewController = [[MasterViewController alloc] init];
    [self.navigationController pushViewController:masterViewController animated:YES];
    [masterViewController release];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = _objects.count;
    //    ASLog(@"%d",count);
    return count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    NSDate *object = _objects[indexPath.row];
    //    cell.textLabel.text = [[object today] timestamp];
    NSDate *testDate = [object dateByAddingDayInterval:-4];
    //    ASLog(@"%d\t%d\t%@\t%@",[object thisDay],[testDate year],[object midnight],[object midday]);
    cell.textLabel.text = [(NSDate *)testDate timestamp];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[[DetailViewController alloc] init] autorelease];
    }
    NSDate *object = _objects[indexPath.row];
    self.detailViewController.detailItem = object;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
