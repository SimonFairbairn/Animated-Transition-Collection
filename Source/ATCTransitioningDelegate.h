//
//  ATCTransitioningDelegate.h
//  Animated Transition Collection
//
//  Created by Simon Fairbairn on 11/10/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATCAnimatedTransitioning.h"

/**
 * @class ATCTransitioningDelegate
 * @brief A pre-configured UIViewController delegate system for
 * making animated and interactive transitions a piece of cake
 */
typedef NS_ENUM(NSInteger, ATCTransitionAnimationType) {
    ATCTransitionAnimationTypeFade,
    ATCTransitionAnimationTypeBounce
};

@interface ATCTransitioningDelegate : NSObject <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

/**
 * @property duration
 * @brief An NSTimeInterval that dictates how long the animation should take
 */
@property (nonatomic) NSTimeInterval duration;

/**
 * @property type
 * @brief An ENUM of allowed ATC Animated Transition types. 
 * Automatically configures an ATCAnimatedTransitioning subclass.
 * Defaults to ATCTransitionAnimationTypeFade
 */
@property (nonatomic) ATCTransitionAnimationType type;

/**
 * @property direction
 * @brief Dictates the direction the animation comes from (only
 * applies to select ATCAnimatedTransitioning subclasses)
 */
@property (nonatomic) ATCTransitionAnimationDirection direction;

/**
 * @property interactive
 * @brief Whether or not the transition should be interactive
 */
@property (nonatomic) BOOL interactive;

/**
 * @property modalView
 * @brief The view being presented (only required for interactive transitions)
 */
@property (nonatomic, strong) UIViewController *modalView;


/**
 * @method initWithTransitionType:direction:duration
 * @brief This class' designated initializer. 
 */
-(instancetype)initWithTransitionType:(ATCTransitionAnimationType)type direction:(ATCTransitionAnimationDirection)direction duration:(NSTimeInterval)duration;

@end
