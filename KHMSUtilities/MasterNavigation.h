//
//  MasterNavigation.h
//  Bookin'day
//
//  Created by Ahmed Khemiri on 8/13/16.
//  Copyright © 2016 Ahmed Khemiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define YellowColorBID RGB(246,212,30)
@interface MasterNavigation : NSObject
@property (strong, nonatomic) UIWindow *window;

+ (void)setRootViewController:(UIViewController *)rootViewController;
+ (void)presentViewControllerWithIdentifier:(NSString *)identifier rootViewController:(UIViewController *)rootViewController animated:(BOOL)animated storyboard:(UIStoryboard *)storyboard;
@end
