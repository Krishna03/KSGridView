/*
 * KSGridView.h
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

#import <UIKit/UIKit.h>
#import "KSGridViewCell.h"
#import "KSGridViewIndex.h"

@protocol KSGridViewDataSource;
@protocol KSGridViewDelegate;

@interface KSGridView : UIView<UITableViewDataSource, UITableViewDelegate, KSGridViewCellDelegate>

@property (nonatomic, assign) id<KSGridViewDataSource> dataSource;
@property (nonatomic, assign) id<KSGridViewDelegate> delegate;

- (void) reloadData;

@end

@protocol KSGridViewDataSource

- (NSInteger) numberOfItemsInGridView:(KSGridView *)gridView;
- (NSInteger) numberOfColumnsInGridView:(KSGridView *)gridView;

- (CGSize) sizeForItemInGridView:(KSGridView *)gridView;
- (UIView *) viewForItemInGridView:(KSGridView *)gridView;

- (void) gridView:(KSGridView *)gridView fillItemView:(UIView *)itemView atIndex:(KSGridViewIndex *)index;

@end

@protocol KSGridViewDelegate

- (void) gridView:(KSGridView *)gridView didSelectIndex:(KSGridViewIndex *)index;

@end
