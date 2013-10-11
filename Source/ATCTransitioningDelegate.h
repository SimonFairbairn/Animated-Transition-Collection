//
//  ATCTransitioningDelegate.h
//  Animated Transition Collection
//
//  Created by Simon Fairbairn on 11/10/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATCAnimatedTransitioning.h"

@class ATCAnimatedTransitioningFade;

typedef NS_ENUM(NSInteger, ATCTransitionAnimationType) {
    ATCTransitionAnimationTypeFade,
    ATCTransitionAnimationTypeBounce
};

@interface ATCTransitioningDelegate : NSObject <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) ATCTransitionAnimationType type;
@property (nonatomic) ATCTransitionAnimationDirection direction;

-(instancetype)initWithTransitionType:(ATCTransitionAnimationType)type direction:(ATCTransitionAnimationDirection)direction duration:(NSTimeInterval)duration;

@end
