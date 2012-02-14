//
//  ViewController.m
//  KS*Demo
//
//  Created by Davide De Rosa on 10/17/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void) dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    KSGridView *grid = [[KSGridView alloc] initWithFrame:self.view.bounds];
    grid.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.8 alpha:1.0];
    grid.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    grid.dataSource = self;
    grid.delegate = self;
    [self.view addSubview:grid];
    [grid release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - KSGridViewDataSource

- (NSInteger) numberOfItemsInGridView:(KSGridView *)gridView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 73;
    } else {
        return 37;
    }
}

- (NSInteger) numberOfColumnsInGridView:(KSGridView *)gridView
{
    const UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    if (UIInterfaceOrientationIsPortrait(orientation)) {
        return 2;
    } else {
        return 3;
    }
}

- (CGSize) sizeForItemInGridView:(KSGridView *)gridView
{
    return CGSizeMake(80, 50);
}

- (UIView *) viewForItemInGridView:(KSGridView *)gridView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor blueColor];
    label.textAlignment = UITextAlignmentCenter;
    return [label autorelease];
}

- (void) gridView:(KSGridView *)gridView fillItemView:(UIView *)itemView atIndex:(KSGridViewIndex *)index
{
    NSString *title = [NSString stringWithFormat:@"%d", index.position + 1];

    [(UILabel *)itemView setText:title];
}

#pragma mark - KSGridViewDelegate

- (void) gridView:(KSGridView *)gridView didSelectIndex:(KSGridViewIndex *)index
{
    NSLog(@"selected = %@", index);
}

@end
