//
//  ATCAnimatedTransitioning.m
//  Animated Transition Collection
//
//  Created by Simon Fairbairn on 11/10/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import "ATCAnimatedTransitioning.h"

@implementation ATCAnimatedTransitioning

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
}


@end
