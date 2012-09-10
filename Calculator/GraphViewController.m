//
//  GraphViewController.m
//  Graph
//
//  Created by Vince Lanzillotta on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController() 
    @property(nonatomic, weak) IBOutlet GraphView *graphView;
@end

@implementation GraphViewController

@synthesize graphView = _graphView;
@synthesize programToUse = _programToUse;

@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;



- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem    {
    
    
    NSLog(@"lets set this thing");
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];     
    if(_splitViewBarButtonItem)[toolbarItems removeObject:_splitViewBarButtonItem];
    
    
    if(splitViewBarButtonItem){
        NSLog(@"adding the button");
        [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    }
    self.toolbar.items = toolbarItems;
    
    _splitViewBarButtonItem = splitViewBarButtonItem;
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



- (void) splitViewController:(UISplitViewController *)svc 
      willShowViewController:(UIViewController *)aViewController 
   invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    
}


-(id) programToUse{
    if(!_programToUse){
     return [NSArray arrayWithObjects:@"x", @"x", @"*",  nil];   
    }
    return _programToUse;
}



-(void)setProgramToUse:(id)programToUse{
    _programToUse = programToUse;
    
    NSLog(@"Program was set to %@", _programToUse);
    [self.graphView setNeedsDisplay];
    
    
}




-(void) setGraphView:(GraphView *)graphView{
    _graphView = graphView;
    self.graphView.deligate = self;
    
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self.graphView action:@selector(pinch:)]];
    
}

- (CGFloat)calculateYForXFrom:(GraphView *)semder Using:(CGFloat)x{
//    NSLog(@"solving for x = %f", x);
//    NSLog(@"the current program is %@", self.programToUse);
    
   // NSLog(@"Program I'm sending %@", self.programToUse);
    
    return [CalculatorBrain runProgram:self.programToUse usingVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:x], @"x", nil]];
    
    //this should sove for Y by running a colculator program with x as a variable.
    //But we need a program to be sent to us durring a segway so we know what the prigram is
}


- (void)viewDidUnload {
    [self setToolbar:nil];
    [super viewDidUnload];
}
@end
