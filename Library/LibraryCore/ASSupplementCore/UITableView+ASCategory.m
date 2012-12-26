//
//  UITableView+ASCategory.m
//  ASSupplement
//
//  Created by Jayce Yang on 12-8-3.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "UITableView+ASCategory.h"

@implementation UITableView (ASCategory)

- (void)scrollToBottom
{
    CGFloat result = self.contentSize.height - self.frame.size.height;
    if (result > 0) {
        CGPoint offset = CGPointMake(0, result);
        [self setContentOffset:offset animated:YES];
    }
}

- (void)hideEmptyCells
{
    self.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (void)reloadDataWithCompletion:(void(^)(void))completionBlock
{
    [self reloadData];
    if (completionBlock) {
        completionBlock();
    }
}

@end
