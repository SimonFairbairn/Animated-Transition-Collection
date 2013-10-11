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

@implementation ATCTransitioningDelegate

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

#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [self returnTypeIsDismissal:NO];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [self returnTypeIsDismissal:YES];
}

-(id<UIViewControllerAnimatedTransitioning>)returnTypeIsDismissal:(BOOL)isDismissal {
    
    ATCAnimatedTransitioning *typeObject;
    
    switch (self.type) {
        case ATCTransitionAnimationTypeFade: {
            typeObject = [ATCAnimatedTransitioningFade new];
            break;
        }
        case ATCTransitionAnimationTypeBounce: {
            typeObject = [ATCAnimatedTransitioningBounce new];
            break;
        }
        default: {
            typeObject = [ATCAnimatedTransitioningFade new];
            break;
        }
    }
    typeObject.dismissal = isDismissal;
    typeObject.direction = self.direction;
    typeObject.duration = self.duration;
    
    return typeObject;
}


@end
