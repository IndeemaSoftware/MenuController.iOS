//
//  EEBottomPanelView.h
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EEMenuPanelDelegate.h"

@interface EEBottomPanelView : UIView

@property (nonatomic, assign, getter=isShadowHidden) BOOL shadowHidden;
@property (nonatomic, strong) UIColor *itemsTintColor;
@property (nonatomic, strong) UIColor *itemsActiveTintColor;

@property (nonatomic, weak) id <EEMenuPanelDelegate> delegate;

- (void)reloadTabs;
- (void)setSelectedTab:(NSUInteger)tabIndex animated:(BOOL)animated;

@end
