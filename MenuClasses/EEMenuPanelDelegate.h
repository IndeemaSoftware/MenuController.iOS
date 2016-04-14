//
//  EEMenuPanelDelegate.h
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EEMenuTab;
@protocol EEMenuPanelDelegate <NSObject>

- (NSUInteger)EEMenuPanelTabsCount;
- (EEMenuTab*)EEMenuPanelMenuTabatIndex:(NSUInteger)tabIndex;
- (void)EEMenuPanelSelectedTab:(NSUInteger)tabIndex;
@end
