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

@property (nonatomic, readonly) BOOL isFloatingMode;

@property (nonatomic, readonly) NSUInteger selectedTabIndex;
@property (nonatomic, readonly) EEMenuTab *selectedMenuTab;
@property (nonatomic, readonly) UIViewController *contentViewController;

+ (EEMenuConroller*)shareInstance;

- (void)loadTabs:(NSArray <EEMenuTab*> *)menuTabsArr;

- (void)selectTab:(NSUInteger)tabIndex animated:(BOOL)animated;

//use this methods to show/hide main menu
- (void)setMenuVisible:(BOOL)isVisible animated:(BOOL)animated;

@end
