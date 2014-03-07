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
#import "ATCAnimatedTransitioningSquish.h"
#import "ATCAnimatedTransitioningFloat.h"

// Use this switch to enable debugging
#define ATCTransitioningDelegateDebugLog 0

@interface ATCTransitioningDelegate ()

@property (nonatomic, strong) ATCAnimatedTransitioning *presentationTransition;
@property (nonatomic, strong) ATCAnimatedTransitioning *dismissalTransition;

@property (nonatomic, strong) UIViewController *presentedViewController;

@end

@implementation ATCTransitioningDelegate

#pragma mark - Properties

// If the type changes, create a new object.
-(void)setPresentationType:(ATCTransitionAnimationType)presentationType {
    _presentationType = presentationType;
    self.presentationTransition = nil;
}

-(void)setDismissalType:(ATCTransitionAnimationType)dismissalType {
    _dismissalType = dismissalType;
    self.dismissalTransition = nil;
}

-(ATCAnimatedTransitioning *)presentationTransition {
    if ( !_presentationTransition ) {
        _presentationTransition = [self transitionForPresentation:YES];
    }
    return _presentationTransition;
}

-(ATCAnimatedTransitioning *)dismissalTransition {
    if ( !_dismissalTransition ) {
        if ( self.dismissalType == self.presentationType) {
            _dismissalTransition = self.presentationTransition;
        } else {
            _dismissalTransition = [self transitionForPresentation:NO];
        }

    }
    return _dismissalTransition;
}


-(ATCAnimatedTransitioning *)transitionForPresentation:(BOOL)isPresentation {

    ATCTransitionAnimationType presentationType = (isPresentation) ? self.presentationType : self.dismissalType;
    
    switch (presentationType) {
        case ATCTransitionAnimationTypeFade: {
            return [ATCAnimatedTransitioningFade new];
            break;
        }
        case ATCTransitionAnimationTypeBounce: {
            return [ATCAnimatedTransitioningBounce new];
            break;
        }
        case ATCTransitionAnimationTypeSquish: {
            return [ATCAnimatedTransitioningSquish new];
            break;
        }
        case ATCTransitionAnimationTypeFloat: {
            return [ATCAnimatedTransitioningFloat new];
            break;
        }
        default: {
            return [ATCAnimatedTransitioningFade new];
            break;
        }
    }
}

#pragma mark - Initialisation

-(instancetype)initWithTransitionType:(ATCTransitionAnimationType)type
                            direction:(ATCTransitionAnimationDirection)direction
                             duration:(NSTimeInterval)duration; {
    return [self initWithPresentationTransition:type dismissalTransition:type direction:direction duration:duration];
}

-(instancetype)initWithPresentationTransition:(ATCTransitionAnimationType)presentationType
                          dismissalTransition:(ATCTransitionAnimationType)dismissalType
                                    direction:(ATCTransitionAnimationDirection)direction
                                     duration:(NSTimeInterval)duration {
    self = [super init];
    if ( self ) {
        _direction = direction;
        _duration = duration;
        _presentationType = presentationType;
        _dismissalType = dismissalType;
        
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
    
    self.presentedViewController = toVC;
    
    self.presentationTransition.isPush = YES;
    self.dismissalTransition.isPush = YES;
    if ( operation == UINavigationControllerOperationPop ) {
        return [self setupTransitionIsDismissal:YES];
    } else {
        if ( self.interactive ) {
            UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] init];
            [gesture addTarget:self action:@selector(handleGesture:)];
            [toVC.view addGestureRecognizer:gesture];            
        }
    }
    return [self setupTransitionIsDismissal:NO];

}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                        interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    if ( self.presentationTransition.isInteracting ) {
        return self.presentationTransition.interactiveTransition;
    } else if ( self.dismissalTransition.isInteracting ) {
        return self.dismissalTransition.interactiveTransition;
    }
    return nil;
}


#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                 presentingController:(UIViewController *)presenting
                                                                     sourceController:(UIViewController *)source {
        // Can't dismiss a controller with a gesture if it has no idea which controller it's dismissing.
    
    self.presentedViewController = presented;
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] init];
    [gesture addTarget:self action:@selector(handleGesture:)];
    [presented.view addGestureRecognizer:gesture];
    
    return [self setupTransitionIsDismissal:NO];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [self setupTransitionIsDismissal:YES];
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    
#ifdef DEBUG
#if ATCTransitioningDelegateDebugLog
    NSLog(@"Presentation transition interactive state: %i", self.presentationTransition.isInteracting);
    NSLog(@"Dismissal transition interactive state: %i", self.dismissalTransition.isInteracting);
#endif
#endif
    
    if ( self.presentationTransition.isInteracting ) {
        return self.presentationTransition.interactiveTransition;
    } else if ( self.dismissalTransition.isInteracting ) {
        return self.dismissalTransition.interactiveTransition;
    }
    return nil;
}

#pragma mark - Helper methods

-(id<UIViewControllerAnimatedTransitioning>)setupTransitionIsDismissal:(BOOL)isDismissal {
    
    if ( isDismissal ) {
        self.dismissalTransition.dismissal = isDismissal;
        self.dismissalTransition.direction = self.direction;
        self.dismissalTransition.duration = self.duration;
        return self.dismissalTransition;
        
    } else {
        self.presentationTransition.dismissal = isDismissal;
        self.presentationTransition.direction = self.direction;
        self.presentationTransition.duration = self.duration;
        return self.presentationTransition;
        
    }
    
}

-(void)handleGesture:(UIPanGestureRecognizer *)recognizer {

    [self.dismissalTransition handlePanGesture:recognizer inViewController:self.presentedViewController];
}



@end
