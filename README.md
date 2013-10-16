Animated-Transition-Collection
==============================

A collection of easy-to-use UIViewController animated transitions. Includes triggered and interactive versions.

### Usage

1. Copy the `Source` folder into your project
1. Add `#import "ATCTransitioningDelegate.h"` to the top of your view controller;
1. Add a property to hold on to the transitioning delegate:  

e.g.

    @property (nonatomic,strong) ATCTransitioningDelegate *atcTD;

**Modal Transitions**

Fire when you're ready to present:

    // Set up the ATC Transitioning Delegate
    self.atcTD = [[ATCTransitioningDelegate alloc] 
        initWithTransitionType:ATCTransitionAnimationTypeBounce 
                     direction:ATCTransitionAnimationDirectionLeft 
                      duration:1.0f];
    
    // Apply it to the modal presentation
    UIViewController *yourVC = [[UIViewController alloc] init];
    yourVC.modalPresentationStyle = UIModalPresentationCustom;
    yourVC.transitioningDelegate = self.atcTD;
      
    // Interactive ?
    self.atcTransitioningDelegate.interactive = YES;  
    
    [self presentViewController:detailVC animated:YES completion:nil];
    
The modal ones will automatically take into account whether or not it's a presentation or a dismissal.
    
**Push Transitions**

Set as the navigationController delegate (in `-(void)viewDidLoad;` works). The navigationController will call it when it's time (works with segues too).

    self.atcTD = [[ATCTransitioningDelegate alloc] 
        initWithTransitionType:ATCTransitionAnimationTypeBounce 
                     direction:ATCTransitionAnimationDirectionNone 
                      duration:1.0f];

    // Interactive ?
    self.atcTransitioningDelegate.interactive = YES;  
                  
    self.navigationController.delegate = self.atcTD;
    
Enjoy custom interactive transitions!

Currently the two available transition types are:

1. `ATCTransitionAnimationTypeFade`
1. `ATCTransitionAnimationTypeBounce`

The direction option won't be applied to the Fade transition, but it will to the bounce. To dismiss interactively, drag in the opposite direction it came in.

### Demo

![Screenshot of the Select Transition screen][1]

[1]: http://simonfairbairn.github.io/images/animated-transitions.png

### Coming Soon

More transitions.
