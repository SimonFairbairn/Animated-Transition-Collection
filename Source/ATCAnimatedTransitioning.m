//
//  ATCAnimatedTransitioning.m
//  Animated Transition Collection
//
//  Created by Simon Fairbairn on 11/10/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import "ATCAnimatedTransitioning.h"

@implementation ATCAnimatedTransitioning

#pragma mark - Properties

-(UIPercentDrivenInteractiveTransition *)interactiveTransition {
    if (self.isInteracting && !_interactiveTransition ) {
        _interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
    } 
    return _interactiveTransition;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // Abstract method
}



@end
