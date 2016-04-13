//
//  UIViewController+Initializing.m
//
//
//  Created by  Sergiy Londar on 6/8/15.
//  Copyright (c) 2015 Indeema. All rights reserved.
//

#import "UIViewController+Initializing.h"

@implementation UIViewController (Initializing)

- (instancetype)initWithNimbAsClassName {
    return [self initWithNibName:NSStringFromClass(self.class) bundle:nil];
}

+ (instancetype)newWithNimbAsClassName {
    return [[self alloc] initWithNimbAsClassName];
}

@end
