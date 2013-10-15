//
//  ATCTransitioningDelegate.m
//  Animated Transition Collection
//
//  Created by Simon Fairbairn on 11/10/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import "ATCTransitioningDelegate.h"
#import "ATCAnimatedTransitioningFade.h"
#import "ATCAnimatedTransitioningBounce.h"

@interface ATCTransitioningDelegate ()

@property (nonatomic, strong) ATCAnimatedTransitioning *transition;

@end

@implementation ATCTransitioningDelegate

#pragma mark - Properties

// If the type changes, create a new object.
-(void)setType:(ATCTransitionAnimationType)type {
    _type = type;
    self.transition = nil;
}

-(ATCAnimatedTransitioning *)transition {
    if ( !_transition ) {
        switch (self.type) {
            case ATCTransitionAnimationTypeFade: {
                _transition = [ATCAnimatedTransitioningFade new];
                break;
            }
            case ATCTransitionAnimationTypeBounce: {
                _transition = [ATCAnimatedTransitioningBounce new];
                break;
            }
            default: {
                _transition = [ATCAnimatedTransitioningFade new];
                break;
            }
        }
    }
    return _transition;
}

#pragma mark - Initialisation

-(instancetype)initWithTransitionType:(ATCTransitionAnimationType)type
                            direction:(ATCTransitionAnimationDirection)direction
                             duration:(NSTimeInterval)duration; {
    self = [super init];
    if ( self ) {
        _direction = direction;
        _duration = duration;
        _type = type;

    }
    return self;
}

-(instancetype)init {
    return [self initWithTransitionType:ATCTransitionAnimationTypeFade direction:ATCTransitionAnimationDirectionNone duration:1.0f];
}

#pragma mark - UINavigationControllerDelegate

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                 animationControllerForOperation:(UINavigationControllerOperation)operation
                                              fromViewController:(UIViewController *)fromVC
                                                toViewController:(UIViewController *)toVC {
    
    self.transition.isPush = YES;
    if ( operation == UINavigationControllerOperationPop ) {
        return [self setupTransitionIsDismissal:YES];
    }
    
    // If we're presenting, let the transition know what it's getting
    self.transition.destinationViewController = toVC;
    return [self setupTransitionIsDismissal:NO];

}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                        interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (self.transition.isInteracting ) {
        return self.transition.interactiveTransition;
    }
    return nil;
}


#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                 presentingController:(UIViewController *)presenting
                                                                     sourceController:(UIViewController *)source {
    
    // Can't dismiss a controller with a gesture if it has no idea which controller it's dismissing.
    self.transition.destinationViewController = presented;
    return [self setupTransitionIsDismissal:NO];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [self setupTransitionIsDismissal:YES];
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    if ( self.transition.isInteracting ) {
        return self.transition.interactiveTransition;
    }
    return nil;
}

#pragma mark - Helper methods

-(id<UIViewControllerAnimatedTransitioning>)setupTransitionIsDismissal:(BOOL)isDismissal {
    self.transition.dismissal = isDismissal;
    self.transition.direction = self.direction;
    self.transition.duration = self.duration;
    self.transition.isInteractive = self.interactive;
    return self.transition;
}


@end
