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

-(instancetype)initWithTransitionType:(ATCTransitionAnimationType)type direction:(ATCTransitionAnimationDirection)direction duration:(NSTimeInterval)duration; {
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
    
    if ( operation == UINavigationControllerOperationPop ) {
        return [self returnTypeIsDismissal:YES];
    }
    
    return [self returnTypeIsDismissal:NO];

}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    
    if ( self.transition.isInteracting ) return self.transition.interactiveTransition;
    return nil;
}

#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [self returnTypeIsDismissal:NO];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [self returnTypeIsDismissal:YES];
}

-(id<UIViewControllerAnimatedTransitioning>)returnTypeIsDismissal:(BOOL)isDismissal {
    
    self.transition.modalView = self.modalView;
    self.transition.dismissal = isDismissal;
    self.transition.direction = self.direction;
    self.transition.duration = self.duration;
    self.transition.isInteractive = self.interactive;
    return self.transition;
}


@end
