//
//  EEContentVC.h
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EEMenuControllerDefines.h"

@interface EEContentVC : UIViewController

//transition methods
- (void)showViewController:(UIViewController*)viewController transition:(EETransitionType)transitionType;

- (void)removeActiveViewController;

@end
