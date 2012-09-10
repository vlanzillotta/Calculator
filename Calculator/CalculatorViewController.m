//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Vince Lanzillotta on 12-03-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"
#import "SplitViewDetailButtonPresenter.h"
#include <math.h>

@interface CalculatorViewController() <UISplitViewControllerDelegate>
@property(nonatomic) BOOL userIsinTheMiddleOfEnteringANumber;
@property(nonatomic) BOOL userHasPressedDecimal;
@property(nonatomic, strong) CalculatorBrain* brain;
@end

@implementation CalculatorViewController


@synthesize userIsinTheMiddleOfEnteringANumber;
@synthesize display;
@synthesize equationDisplay;
@synthesize brain = _brain;
@synthesize userHasPressedDecimal;


- (void) awakeFromNib{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
    
}

- (id <SplitViewDetailButtonPresenter>) ButtonShowingDetailView {
    
    id BSDV = [self.splitViewController.viewControllers lastObject];
    
    if(![BSDV conformsToProtocol:@protocol(SplitViewDetailButtonPresenter)]){
        BSDV = nil;
    }
    
    return BSDV;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

- (BOOL) splitViewController:(UISplitViewController *)svc 
    shouldHideViewController:(UIViewController *)vc 
               inOrientation:(UIInterfaceOrientation)orientation {
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)splitViewController:(UISplitViewController *)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)pc{
    
    
    barButtonItem.title = @"Calculator";
    [self ButtonShowingDetailView].splitViewBarButtonItem = barButtonItem;
    
}

- (void) splitViewController:(UISplitViewController *)svc 
        willShowViewController:(UIViewController *)aViewController
   invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    
    
    
    [self ButtonShowingDetailView].splitViewBarButtonItem = nil;
    
    
}

- (GraphViewController *) currentGraphViewControler {
    
    id CGVC = [self.splitViewController.viewControllers lastObject];
    
    if(![CGVC isKindOfClass:[GraphViewController class]]){
        CGVC = nil;
        
    }
    
    return CGVC;
}



- (IBAction)graphButtonPressed:(id)sender {
    NSLog(@"Graph Was pushed");
    
    [self currentGraphViewControler].programToUse = self.brain.program;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"squeing %@", segue.identifier);
    
    if([segue.identifier isEqualToString:@"ShowGraph"]){
        NSLog(@"Program I am sending %@", self.brain.program);
        [segue.destinationViewController setProgramToUse:self.brain.program];
    }
    
    
}

- (CalculatorBrain *) brain{
    if(_brain == nil){
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    if(self.userIsinTheMiddleOfEnteringANumber){    
        self.display.text = [self.display.text stringByAppendingString:[sender currentTitle]];
    }else{
        self.display.text = [sender currentTitle];
        userIsinTheMiddleOfEnteringANumber = YES;
    }
}
- (IBAction)enterPressed {
    [self.brain pushOperand:self.display.text.doubleValue];
    self.userIsinTheMiddleOfEnteringANumber = NO;
    self.userHasPressedDecimal = NO;
    
    self.equationDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (IBAction)decimalPressed:(UIButton *)sender {
    self.userHasPressedDecimal = YES;
    [self digitPressed:sender];
    
}

- (IBAction)piPressed:(UIButton *)sender {
    if(self.userIsinTheMiddleOfEnteringANumber){    
        self.display.text = [NSString stringWithFormat:@"%f", 3.14159265];
    }else{
        self.display.text = [NSString stringWithFormat:@"%f", 3.14159265];
        userIsinTheMiddleOfEnteringANumber = YES;
    }
}


- (IBAction)operandPressed:(UIButton *)sender {
    NSLog(@"step 1 - %@", [self.brain.program description]);
    
    
    if(self.userIsinTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    
    NSLog(@"step 2 - %@", [self.brain.program description]);
    
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    
    self.equationDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}


- (IBAction)clearPressed:(UIButton *)sender {
    [self operandPressed:sender];
    self.display.text = @"0";
    self.equationDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    
    
}






- (void)viewDidUnload {
    [self setEquationDisplay:nil];
    [super viewDidUnload];
}
@end
