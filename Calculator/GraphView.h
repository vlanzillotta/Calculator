//
//  GraphView.h
//  Graph
//
//  Created by Vince Lanzillotta on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewDetailButtonPresenter.h"

@class GraphView;
@protocol graphViewDataSource
-(CGFloat)calculateYForXFrom:(GraphView *)self Using:(CGFloat)x;
@end

@interface GraphView : UIView

@property (nonatomic) CGFloat Scale;
@property (nonatomic, weak) id <graphViewDataSource> deligate;


@end
