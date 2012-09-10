//
//  GraphView.m
//  Graph
//
//  Created by Vince Lanzillotta on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#include "AxesDrawer.h"

#define SCALE 10.0


@implementation GraphView

@synthesize deligate = _deligate;
@synthesize Scale = _Scale;


- (CGFloat) Scale {
    
    
    
    if(!_Scale){
        return SCALE;
    }else{
        return _Scale;
    }
}

- (void) setScale:(CGFloat)Scale{
    
    
    if(Scale > 100){
        Scale = 100;
    }
    
    if(Scale < 1){
        Scale = 1;
    }
    
    
    
    if(Scale != _Scale){
        _Scale = Scale;
        [self setNeedsDisplay];
    }
}
- (void) pinch:(UIPinchGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded){
        self.Scale *= gesture.scale;
        gesture.scale=1;
    }
    
    if(gesture.state == UIGestureRecognizerStateEnded){
        //NSLog(@"%f", self.Scale);
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    
    CGPoint rectsCenter;
    rectsCenter.x = (self.bounds.size.width/2 + self.bounds.origin.x);
    rectsCenter.y = (self.bounds.size.height/2 + self.bounds.origin.y);
    [AxesDrawer drawAxesInRect:rect originAtPoint:rectsCenter scale:self.Scale];
    
    
    //draw the line
    
//    CGPoint lineStartPoint = CGPointMake(0, 0);
//    CGPoint lineDestinationPoint = CGPointMake(0, 0);
    CGFloat navigatorPoint = 0;
    

    CGContextBeginPath(context);
    
    
    while (navigatorPoint < self.bounds.size.width ) {
        //solve for Y where X is navigatorPoint.x
    //NSLog(@"%f", navigatorPoint);
        
        
        //adjust x
        CGFloat XPoint = (navigatorPoint - (self.bounds.size.width/2))/self.Scale;        
        CGFloat YPoint = [self.deligate calculateYForXFrom:self Using:XPoint];
        
        //Now lets adjust y
        YPoint = YPoint * self.Scale;
        YPoint += (self.bounds.size.height/2); 
        YPoint = (self.bounds.size.height) - YPoint;
        
        
        
        if(navigatorPoint == 0){
            //This should be the first point calculated.
            CGContextMoveToPoint(context, 0, YPoint );
        }
        CGContextAddLineToPoint(context, navigatorPoint, YPoint);
        navigatorPoint++;
        
    }
    
    //CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
    
    
    
    UIGraphicsPopContext();

    
}


@end
