//
//  EEFloatingButton.h
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EEMenuControllerDefines.h"

@interface EEFloatingButton : UIControl

@property (nonatomic, readwrite) EEMenuFloatingMenuSide side;

- (void)setVisible:(BOOL)visible animated:(BOOL)animated;

@end
