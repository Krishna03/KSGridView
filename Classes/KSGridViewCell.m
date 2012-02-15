/*
 * KSGridViewCell.m
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

#import "KSGridViewCell.h"

@implementation KSGridViewCell

@synthesize row;
@synthesize numberOfColumns;
@synthesize numberOfVisibleItems;
@synthesize itemSize;
@synthesize delegate;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        itemSize = CGSizeZero;
        items = nil;
    }
    return self;
}

- (void) dealloc
{
    [items release];

    [super dealloc];
}

- (void) setItems:(NSArray *)anItems
{
    if (anItems == items) {
        return;
    }

    for (UIView *itemView in items) {
        [itemView removeFromSuperview];
    }
    [items release];
    items = [anItems mutableCopy];
    for (UIView *itemView in items) {
        itemView.userInteractionEnabled = NO; // for touchesBegan
        [self.contentView addSubview:itemView];
    }

    // default to all items
    numberOfColumns = [items count];
    self.numberOfVisibleItems = numberOfColumns;

    [self setNeedsLayout];
}

- (NSUInteger) numberOfMissingItems
{
    if (numberOfColumns <= [items count]) {
        return 0;
    }
    return numberOfColumns - [items count];
}

- (void) appendItem:(UIView *)itemView
{
    itemView.userInteractionEnabled = NO; // for touchesBegan
    [items addObject:itemView];
    [self.contentView addSubview:itemView];

    [self setNeedsLayout];
}

- (void) setNumberOfColumns:(NSUInteger)aNumberOfColumns
{
    numberOfColumns = aNumberOfColumns;

    // cap visible items
    self.numberOfVisibleItems = MIN(numberOfColumns, numberOfVisibleItems);

    [self setNeedsLayout];
}

- (void) setNumberOfVisibleItems:(NSUInteger)aNumberOfVisibleItems
{
    NSAssert2(aNumberOfVisibleItems <= numberOfColumns,
              @"numberOfVisibleItems must be <= numberOfColumns (%d > %d)",
              aNumberOfVisibleItems, numberOfColumns);

    numberOfVisibleItems = aNumberOfVisibleItems;

    NSUInteger i = 0;
    for (UIView *itemView in items) {
        itemView.hidden = (i >= numberOfVisibleItems);
        ++i;
    }
}

- (UIView *) itemAtIndex:(NSUInteger)index
{
    if (([items count] == 0) || (index >= [items count])) {
        return nil;
    }
    return [items objectAtIndex:index];
}

#pragma mark - Layout

- (void) layoutSubviews
{
    // outer item size
    CGSize outerSize;
    outerSize.width = (NSUInteger)(self.bounds.size.width / numberOfColumns);
    outerSize.height = (NSUInteger) self.bounds.size.height;

    // pad for centering
    CGPoint itemPadding;
    itemPadding.x = (NSInteger)(outerSize.width - itemSize.width) / 2;
    itemPadding.y = (NSInteger)(outerSize.height - itemSize.height) / 2;

    CGRect itemFrame;
    itemFrame.size = itemSize;
    NSUInteger i = 0;
    for (UIView *itemView in items) {
        itemFrame.origin.x = i * outerSize.width + itemPadding.x;
        itemFrame.origin.y = itemPadding.y;
        itemView.frame = itemFrame;

        ++i;
    }
}

#pragma mark - Events

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    const CGPoint location = [touch locationInView:self];

    // notify touched item
    NSUInteger i = 0;
    for (UIView *itemView in items) {
        if (CGRectContainsPoint(itemView.frame, location)) {
            [delegate gridViewCell:self didSelectItemIndex:i];
            return;
        }
        ++i;
    }
}

@end
