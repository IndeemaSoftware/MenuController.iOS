//
//  EEFloatingPaneTabButton.h
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EEMenuControllerDefines.h"

@class EEMenuTab;
@interface EEFloatingPaneTabButton : UIControl

@property (nonatomic, readonly) EEMenuTab *menuTab;
@property (nonatomic, readonly) NSUInteger tabIndex;
@property (nonatomic, readwrite) CGFloat angle;

@property (nonatomic, strong) UIColor *activeTintColor;

- (instancetype)initWithMenuTabType:(EEMenuTab*)menuTab tab:(NSUInteger)tabIndex;
+ (instancetype)buttonWithMenuTabType:(EEMenuTab*)menuTab tab:(NSUInteger)tabIndex;

- (void)updateBackgroundTo:(EEMenuFloatingMenuSide)side;
- (void)drawBackgroundWithPath:(CGPathRef)path;

@end
