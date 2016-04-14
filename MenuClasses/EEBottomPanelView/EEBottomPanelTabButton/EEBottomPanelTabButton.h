//
//  EEBottomPanelTabButton.h
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EEMenuTab;
@interface EEBottomPanelTabButton : UIControl

@property (nonatomic, readonly) EEMenuTab *menuTab;
@property (nonatomic, readonly) NSUInteger tabIndex;

- (instancetype)initWithMenuTabType:(EEMenuTab*)menuTab tab:(NSUInteger)tabIndex;
+ (instancetype)buttonWithMenuTabType:(EEMenuTab*)menuTab tab:(NSUInteger)tabIndex;

@end
