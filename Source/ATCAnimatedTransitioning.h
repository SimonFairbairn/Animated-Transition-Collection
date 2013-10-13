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

@property (nonatomic) ATCTransitionAnimationDirection direction;
@property (nonatomic) NSTimeInterval duration;

@property (nonatomic, getter = isDismissal) BOOL dismissal;

@property (nonatomic) BOOL isInteractive;
@property (nonatomic) BOOL isInteracting;

@property (nonatomic, strong) UIViewController *modalView;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;


@end
