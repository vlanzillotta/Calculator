//
//  SplitViewDetailButtonPresenter.h
//  Calculator
//
//  Created by Vince Lanzillotta on 12-07-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SplitViewDetailButtonPresenter <NSObject>
    @property (nonatomic, strong) UIBarButtonItem *splitViewBarButtonItem;
@end
