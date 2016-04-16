//
//  EEMenuContentProtocol.h
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 16/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EEMenuContentProtocol <NSObject>

- (void)EEMenuContentBottomInsetChanged:(CGFloat)bottomInset animated:(BOOL)animated;

@end
