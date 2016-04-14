//
//  EEFloatingButton.m
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEFloatingButton.h"

@interface EEFloatingButton() {
    
}


@end

@implementation EEFloatingButton

#pragma mark - Public methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *lBGImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [lBGImageView setImage:[UIImage imageNamed:@"floating_menu_icon"]];
        [self addSubview:lBGImageView];
        
        UIImageView *lIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 15.0, 20.0, 20.0)];
        [lIconImageView setImage:[UIImage imageNamed:@"menu_icon"]];
        [self addSubview:lIconImageView];
        
        _side = EEMenuFloatingMenuSideLeft;
    }
    return self;
}

- (void)setVisible:(BOOL)visible animated:(BOOL)animated {
    CGPoint lNewCenter = CGPointZero;
    CGPoint lJumpCenter = CGPointZero;
    
    if (visible) {
        if (_side == EEMenuFloatingMenuSideLeft) {
            lNewCenter = CGPointMake(BOTTOM_PANEL_HEIGHT / 2.0, self.center.y);
        } else {
            lNewCenter = CGPointMake(self.superview.frame.size.width - BOTTOM_PANEL_HEIGHT / 2.0, self.center.y);
        }
    } else {
        if (_side == EEMenuFloatingMenuSideLeft) {
            lNewCenter = CGPointMake(SIDE_BAR_WIDTH + BOTTOM_PANEL_HEIGHT/2.0, self.center.y);
        } else {
            lNewCenter = CGPointMake(self.superview.frame.size.width - BOTTOM_PANEL_HEIGHT/2.0 - SIDE_BAR_WIDTH, self.center.y);
        }
    }
    
    if (_side == EEMenuFloatingMenuSideLeft) {
        lJumpCenter = CGPointMake(self.center.x + MAGNET_JUMP_INSET, self.center.y);
    } else {
        lJumpCenter = CGPointMake(self.center.x - MAGNET_JUMP_INSET, self.center.y);
    }
    
    void (^animationBlock)(void) = ^{
        [self setCenter:lNewCenter];
    };
    
    if (animated) {
        [UIView animateWithDuration:0.06f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
            [self setCenter:lJumpCenter];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:animationBlock completion:nil];
        }];
    } else {
        animationBlock();
    }
}

@end
