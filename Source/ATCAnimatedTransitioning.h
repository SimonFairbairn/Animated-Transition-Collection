//
//  ATCAnimatedTransitioning.h
//  Animated Transition Collection
//
//  Created by Simon Fairbairn on 11/10/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ATCTransitionAnimationDirection) {
    ATCTransitionAnimationDirectionNone,
    ATCTransitionAnimationDirectionLeft,
    ATCTransitionAnimationDirectionTop,
    ATCTransitionAnimationDirectionRight,
    ATCTransitionAnimationDirectionBottom
};

/**
 * @class ATCAnimatedTransitioning
 * @brief The base class for all of the animated transitioning
 * subclass this and you only have to fill out the `-animatedTransition`
 * method. Spend your time animating VCs instead of setting the damn things
 * up...
 */
@interface ATCAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

/**
 * @class ATCTransitionAnimationDirection
 * @brief Some of our subclasses are going to be able to dictate
 * which direction the transition appears from
 */
@property (nonatomic) ATCTransitionAnimationDirection direction;

/**
 * @class duration
 * @brief Surely no explanation required. Surely.
 * 
 * Oh, alright. The duration of the animation.
 */
@property (nonatomic) NSTimeInterval duration;

/**
 * @class dismissal
 * @brief Are we in the throws of a passionate dismissal?
 */
@property (nonatomic, getter = isDismissal) BOOL dismissal;

/**
 * @class interactive
 * @brief Should this thing be interactive?
 */
@property (nonatomic, getter = isInteractive) BOOL interactive;

/**
 * @class interacting
 * @brief Are we currently seeing user interaction
 */
@property (nonatomic, getter = isInteracting) BOOL interacting;

/**
 * @class destinationViewController
 * @brief In order for interactions to work, we need a reference
 * to the presented view controller.
 */
@property (nonatomic, strong) UIViewController *destinationViewController;

/**
 * @class isPush
 * @brief Did this transition come from a navigation controller?
 */
@property (nonatomic) BOOL isPush;

/**
 * @class interactiveTransition
 */
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;

@end
