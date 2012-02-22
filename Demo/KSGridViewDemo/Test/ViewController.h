//
//  ViewController.h
//  KS*Demo
//
//  Created by Davide De Rosa on 10/17/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSGridView.h"

@interface ViewController : UIViewController<KSGridViewDataSource, KSGridViewDelegate> {
    BOOL alternative;
}

@property (nonatomic, retain) KSGridView *grid;

@end
