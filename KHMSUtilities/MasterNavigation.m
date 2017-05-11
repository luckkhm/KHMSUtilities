//
//  MasterNavigation.m
//  Bookin'day
//
//  Created by Ahmed Khemiri on 8/13/16.
//  Copyright © 2016 Ahmed Khemiri. All rights reserved.
//

#import "MasterNavigation.h"
#import "AppDelegate.h"

@implementation MasterNavigation

+ (void)presentViewControllerWithIdentifier:(NSString *)identifier rootViewController:(UIViewController *)rootViewController animated:(BOOL)animated storyboard:(UIStoryboard *)storyboard {

    
    [rootViewController presentViewController:[storyboard instantiateViewControllerWithIdentifier:identifier] animated:animated completion:nil];
}



+ (void)setRootViewController:(UIViewController *)rootViewController {
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    // dismiss presented view controllers before switch rootViewController to avoid messed up view hierarchy, or even crash
    UIViewController *presentedViewController = [self findPresentedViewControllerStartingFrom:appDel.window.rootViewController];
    [self dismissPresentedViewController:presentedViewController completionBlock:^{
        [appDel.window setRootViewController:rootViewController];
    }];
}
+ (void)dismissPresentedViewController:(UIViewController *)vc completionBlock:(void(^)())completionBlock {
    // if vc is presented by other view controller, dismiss it.
    if ([vc presentingViewController]) {
        __block UIViewController* nextVC = vc.presentingViewController;
        [vc dismissViewControllerAnimated:NO completion:^ {
            // if the view controller which is presenting vc is also presented by other view controller, dismiss it
            if ([nextVC presentingViewController]) {
                [self dismissPresentedViewController:nextVC completionBlock:completionBlock];
            } else {
                if (completionBlock != nil) {
                    completionBlock();
                }
            }
        }];
    } else {
        if (completionBlock != nil) {
            completionBlock();
        }
    }
}
+ (UIViewController *)findPresentedViewControllerStartingFrom:(UIViewController *)start {
    if ([start isKindOfClass:[UINavigationController class]]) {
        return [self findPresentedViewControllerStartingFrom:[(UINavigationController *)start topViewController]];
    }
    
    if ([start isKindOfClass:[UITabBarController class]]) {
        return [self findPresentedViewControllerStartingFrom:[(UITabBarController *)start selectedViewController]];
    }
    
    if (start.presentedViewController == nil || start.presentedViewController.isBeingDismissed) {
        return start;
    }
    
    return [self findPresentedViewControllerStartingFrom:start.presentedViewController];
}

@end
