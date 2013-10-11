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

@interface ATCAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) ATCTransitionAnimationDirection direction;
@property (nonatomic) NSTimeInterval duration;

@property (nonatomic, getter = isDismissal) BOOL dismissal;

@end
