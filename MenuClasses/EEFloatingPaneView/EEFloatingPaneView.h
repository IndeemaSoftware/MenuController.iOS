//
//  EEFloatingPaneView.h
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EEMenuPanelDelegate.h"
#import "EEMenuControllerDefines.h"

@interface EEFloatingPaneView : UIView

@property (nonatomic, weak) id <EEMenuPanelDelegate> delegate;
@property (nonatomic, readonly) EEMenuFloatingMenuSide side;
@property (nonatomic, readonly) BOOL isVisible;

- (void)reloadTabs;
- (void)setSelectedTab:(NSUInteger)tabIndex animated:(BOOL)animated;

- (void)showPanelFromSide:(EEMenuFloatingMenuSide)side animated:(BOOL)animated;
- (void)hidePanelAnimated:(BOOL)animated;

@end
