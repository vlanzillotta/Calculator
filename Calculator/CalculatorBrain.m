//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Vince Lanzillotta on 12-03-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"


@interface CalculatorBrain()  

@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSMutableArray *variableValues;

@end

@implementation CalculatorBrain

@synthesize programStack =_programStack;
@synthesize variableValues = _variableValues;



- (NSMutableArray *) programStack {
    
    if(_programStack == nil){
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

-(void) pushOperand:(double)operand{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
    
}

- (double)performOperation:(NSString *)operation{
    
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
    
    //return [CalculatorBrain runProgram:self.program usingVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:2] , @"x", nil]];
}

- (id) program  {
    return [self.programStack copy];
}

+(BOOL)isOperation:(NSString *)operation{
    NSSet *supportedOperations = [[NSSet alloc] 
                                  initWithObjects:@"+",@"-",@"*",@"/",@"sin",@"cos",@"sqrt",@"π", nil];
    return [supportedOperations containsObject:operation];
}


+ (NSString *) describeTopOfStack:(NSMutableArray *)stack{
    
    NSString *description;
    
    id topOfStack = [stack lastObject];
    if(topOfStack){
        [stack removeLastObject];
    }
    
    if([topOfStack isKindOfClass:[NSNumber class]]){
        description = [topOfStack stringValue];
        
    }else if([topOfStack isKindOfClass:[NSString class]]){
        
        NSString *operation = topOfStack;
        NSString *firstValue;
        NSString *secondvalue;
        
        if([operation isEqualToString:@"+"] || 
           [operation isEqualToString:@"-"]){
            secondvalue = [self describeTopOfStack:stack];
            firstValue  = [self describeTopOfStack:stack];
            description = [NSString stringWithFormat:@"%@ %@ %@", firstValue,operation,secondvalue];
        }else if([@"*" isEqualToString:operation] || 
                 [@"/" isEqualToString:operation]){
            secondvalue = [self describeTopOfStack:stack];
            firstValue  = [self describeTopOfStack:stack];
            description = [NSString stringWithFormat:@"(%@) %@ (%@)", firstValue,operation, secondvalue];
        }else if([@"cos" isEqualToString:operation] || 
                 [@"sin" isEqualToString:operation] || 
                 [@"sqrt" isEqualToString:operation] ){
            
            description = [NSString stringWithFormat:@"%@(%@)",operation, [self describeTopOfStack:stack]];
        }else if([@"π" isEqualToString:operation] || 
                 [@"a" isEqualToString:operation] ||
                 [@"b" isEqualToString:operation] ||
                 [@"x" isEqualToString:operation]){
             description = operation;
        }
    }
    
    return description;
    
}

+ (NSString *) descriptionOfProgram:(id)program{
    
    NSMutableArray *stack;
   // NSLog(@"%@", [program description]);
    
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self describeTopOfStack:stack];
}

+ (double) popOperandOfStack:(NSMutableArray *)stack{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if(topOfStack){
        [stack removeLastObject];
    }
    if([topOfStack isKindOfClass:[NSNumber class]]){
        result = [topOfStack doubleValue];
    }else if([topOfStack isKindOfClass:[NSString class]]){
        
        NSString *operation = topOfStack;
        
        if([operation isEqualToString:@"+"]){
            result = [self popOperandOfStack:stack] + [self popOperandOfStack:stack];
        }else if([@"*" isEqualToString:operation]){
            result = [self popOperandOfStack:stack] * [self popOperandOfStack:stack];
        }else if([@"/" isEqualToString:operation]){
            double divisor = [self popOperandOfStack:stack];
            result = [self popOperandOfStack:stack] / divisor;
        }else if([@"-" isEqualToString:operation]){
            double subtract = [self popOperandOfStack:stack];
            result = [self popOperandOfStack:stack] - subtract;
        }else if([@"cos" isEqualToString:operation]){
            result = cos([self popOperandOfStack:stack]) ;
        }else if([@"sin" isEqualToString:operation]){
            result = sin([self popOperandOfStack:stack]) ;
        }else if([@"sqrt" isEqualToString:operation]){
            result = sqrt([self popOperandOfStack:stack]) ;
        }else if([@"π" isEqualToString:operation]){
            result = M_PI;
        }else if([@"C" isEqualToString:operation]){
            
             //NSLog(@"shouldd be clearing he brain here");
            result = 0;
            //NSLog(@"before remove all is called - %@", [stack description]);
            [stack removeAllObjects];
            
            // NSLog(@"after remove all is called - %@", [stack description]);
            return result;
        }
    }
    
    //NSLog(@"returning %f", result);

    
    return result;
}

+ (double) runProgram:(id)program{
    NSMutableArray *stack;
    //BUG: if we send the C command, it will clear this stack, but not the stack being stored in the brain object.
   // NSLog(@"in runProgram, i dont think we will make the copy");

    if([program isKindOfClass:[NSArray class]]){
       // NSLog(@"making the copy");
        stack = [program mutableCopy];
    }
    
    //NSLog(@"before leaving");
   // NSLog(@"%@", [stack description]);
   return [self popOperandOfStack:stack];
}

+ (double) runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues{
    
    
   // NSLog(@"Program I recieved %@", program);
    //replace the variables in the stack (program) with the values in variableValues
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    
     //NSLog(@"program coming in %@", [program description]);
    if([program isKindOfClass:[NSArray class]]){
        //stack = [program mutableCopy];
        
        //do the replacement here
       
        for (NSString *key in program) {
           // NSLog(@"in the loop looking at  %@", key);

            
            if ([key isKindOfClass:[NSString class]] && [key isEqualToString:@"x"]) {
                
                
                [stack addObject:[variableValues objectForKey:key]];
               //NSLog(@"this is a string");

                
            }else{
                [stack addObject:key];
                //NSLog(@"this is not a string");
                
            }
        }
    }

   // NSLog(@"program we are running %@", stack);
   
    
    return [self runProgram:stack];
    
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    
    NSMutableArray *returnSet = [[NSMutableArray alloc]init];
    
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
   
    for (NSString *key in stack) {
        if ([key isEqualToString:@"x"]) {
            [returnSet addObject:key];
        }
    }
    
    return [[NSSet alloc] initWithArray:returnSet];
    
}


 
@end
