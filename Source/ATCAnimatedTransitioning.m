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
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    
    [self animateTransitionWithContext:transitionContext fromViewController:fromViewController toViewController:toViewController fromView:fromView toView:toView];
}

-(void)animateTransitionWithContext:(id<UIViewControllerContextTransitioning>)transitionContext
                 fromViewController:(UIViewController *)fromViewController
                   toViewController:(UIViewController *)toViewController
                           fromView:(UIView *)fromView
                             toView:(UIView *)toView  {
    
}

-(NSString *)description {
    NSString *direction;
    switch (self.direction) {
        case ATCTransitionAnimationDirectionNone: {
            direction = @"None";
            break;
        }
        case ATCTransitionAnimationDirectionLeft: {
            direction = @"Left";
            break;
        }
        case ATCTransitionAnimationDirectionTop: {
            direction = @"Top";
            break;
        }
        case ATCTransitionAnimationDirectionBottom: {
            direction = @"Bottom";
            break;
        }
        case ATCTransitionAnimationDirectionRight: {
            direction = @"Right";
            break;
        }
        default:
            break;
    }
    
    NSString *dismissal = (self.isDismissal) ? @"Dismissing" : @"Presenting";
    return [dismissal stringByAppendingFormat:@" with direction: %@", direction];
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)recognizer inViewController:(UIViewController *)controller {
    
}

-(ATCTransitionAnimationDirection)adjustDirectionForOrientation:(UIInterfaceOrientation)orientation {
    ATCTransitionAnimationDirection direction = self.direction;
    if ( !self.isPush ) {
        if ( orientation == UIInterfaceOrientationLandscapeRight ) {
            if ( direction != ATCTransitionAnimationDirectionNone ) {
                direction = (self.direction - 1 == 0) ? 4 : self.direction - 1;
            }
        } else if ( orientation == UIInterfaceOrientationLandscapeLeft ) {
            if ( direction != ATCTransitionAnimationDirectionNone ) {
                direction = (self.direction + 1 > 4) ? 1 : self.direction + 1;
            }
        }
    }
    return direction;
}

@end
