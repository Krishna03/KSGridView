/*
 * KSGridView.m
 *
 * Copyright 2012 Davide De Rosa
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "KSGridView.h"
#import "KSGridViewCell.h"

@interface KSGridView ()

@property (nonatomic, retain) UITableView *table;

- (void) didChangeStatusBarOrientation:(NSNotification *)notification;

@end

@implementation KSGridView

// public
@synthesize dataSource;
@synthesize delegate;

// private
@synthesize table;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        table = [[UITableView alloc] initWithFrame:self.bounds];
        table.backgroundColor = [UIColor clearColor];
        table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.dataSource = self;
        table.delegate = self;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didChangeStatusBarOrientation:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];

        [self addSubview:table];
    }
    return self;
}

- (void) dealloc
{
    self.table = nil;

    [super dealloc];
}

- (void) reloadData
{
    [table reloadData];
}

#pragma mark - Layout

- (void) didChangeStatusBarOrientation:(NSNotification *)notification
{
    [table reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource numberOfItemsInGridView:self] / [dataSource numberOfColumnsInGridView:self] + 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"RowCell";

    // data source size
    const NSUInteger numberOfItems = [dataSource numberOfItemsInGridView:self];
    const NSUInteger numberOfColumns = [dataSource numberOfColumnsInGridView:self];
    const NSUInteger numberOfRows = numberOfItems / numberOfColumns + 1;

    KSGridViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[KSGridViewCell alloc] initWithReuseIdentifier:identifier] autorelease];
        cell.delegate = self;

        // fixed item size
        cell.itemSize = [dataSource sizeForItemInGridView:self];

        // add initial items
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < numberOfColumns; ++i) {
            [items addObject:[dataSource viewForItemInGridView:self]];
        }
        cell.items = items;
        [items release];
    }

    // set current row and number of columns
    cell.row = indexPath.row;
    cell.numberOfColumns = numberOfColumns;

    // append new items if necessary
    const NSUInteger missingItems = cell.numberOfMissingItems;
    for (NSUInteger i = 0; i < missingItems; ++i) {
        [cell appendItem:[dataSource viewForItemInGridView:self]];
    }

    // remark number of visible items (different for last row)
    if (cell.row < numberOfRows - 1) {
        cell.numberOfVisibleItems = numberOfColumns;
    } else {
        cell.numberOfVisibleItems = numberOfItems - (numberOfRows - 1) * numberOfColumns;
    }

    // fill item content
    for (NSUInteger i = 0; i < cell.numberOfVisibleItems; ++i) {
        UIView *itemView = [cell itemAtIndex:i];

        // provide compound index to data source
        KSGridViewIndex *index = [KSGridViewIndex indexWithCell:cell column:i];
        [dataSource gridView:self fillItemView:itemView atIndex:index];
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [dataSource sizeForItemInGridView:self].height;
}

#pragma mark - KSGridViewCellDelegate

- (void) gridViewCell:(KSGridViewCell *)cell didSelectItemIndex:(NSInteger)itemIndex
{
    KSGridViewIndex *index = [KSGridViewIndex indexWithCell:cell column:itemIndex];
    [delegate gridView:self didSelectIndex:index];
}

@end
