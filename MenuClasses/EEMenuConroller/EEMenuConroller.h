//
//  EEMenuConroller.h
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "EEMenuTab.h"

@interface EEMenuConroller : NSObject

// - - - - - - - - - - - - - - - - - - - - - - - - - Appearance
@property (nonatomic, readonly) BOOL isFloatingMode;

@property (nonatomic, strong) UIColor *bottomPanelColor;
@property (nonatomic, strong) UIColor *bottomPanelTintColor;
@property (nonatomic, strong) UIColor *bottomPanelActiveTintColor;

@property (nonatomic, strong) UIColor *floatingPanelColor;
@property (nonatomic, strong) UIColor *floatingPanelTintColor;
@property (nonatomic, strong) UIColor *floatingPanelActiveTintColor;

// - - - - - - - - - - - - - - - - - - - - - - - - - Navigation
@property (nonatomic, readonly) NSUInteger selectedTabIndex;
@property (nonatomic, readonly) EEMenuTab *selectedMenuTab;
@property (nonatomic, readonly) UIViewController *contentViewController;

+ (EEMenuConroller*)shareInstance;

- (void)loadTabs:(NSArray <EEMenuTab*> *)menuTabsArr;

- (void)selectTab:(NSUInteger)tabIndex animated:(BOOL)animated;

//use this methods to show/hide main menu
- (void)setMenuVisible:(BOOL)isVisible animated:(BOOL)animated;

@end
