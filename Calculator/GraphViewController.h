//
//  GraphViewController.h
//  Graph
//
//  Created by Vince Lanzillotta on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "SplitViewDetailButtonPresenter.h"

@interface GraphViewController : UIViewController <graphViewDataSource, SplitViewDetailButtonPresenter>

@property(nonatomic, strong) id programToUse;
@property(nonatomic, strong) UIBarButtonItem *splitViewBarButtonItem;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;


@end
