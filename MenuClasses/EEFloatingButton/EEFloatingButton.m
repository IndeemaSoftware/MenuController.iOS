//
//  EEFloatingButton.m
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEFloatingButton.h"

@interface EEFloatingButton() {
    CAShapeLayer *_shapeLayer;
    UIImageView *_menuIconImamgeView;
}

- (CAShapeLayer*)shapeLayer;
- (UIImageView*)menuIconImamgeView;

@end

@implementation EEFloatingButton

#pragma mark - Public methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self setTintColor:[UIColor colorWithRed:147.0f/255.0f green:207.0f/255.0f blue:28.0f/255.0f alpha:1.0f]];
        
        _side = EEMenuFloatingMenuSideLeft;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat lMinSide = MIN(self.frame.size.width, self.frame.size.height);
    CGRect lCircleRect = CGRectMake((self.frame.size.width - lMinSide) / 2.0f, (self.frame.size.height - lMinSide) / 2.0f, lMinSide, lMinSide);
    self.shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:lCircleRect].CGPath;
    [self.menuIconImamgeView setCenter:CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f)];
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    [self.shapeLayer setStrokeColor:tintColor.CGColor];
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

#pragma mark - Private methods
- (CAShapeLayer *)shapeLayer {
    if (_shapeLayer == nil) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        [_shapeLayer setFillColor:[UIColor whiteColor].CGColor];
        [_shapeLayer setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.3f].CGColor];
        [_shapeLayer setShadowOpacity:1.0f];
        [_shapeLayer setShadowRadius:1.0f];
        [_shapeLayer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
        [_shapeLayer setLineWidth:1.5f];
        
        _shapeLayer.contentsScale = [UIScreen mainScreen].scale;
        
        [self.layer insertSublayer:_shapeLayer atIndex:0];
    }
    return _shapeLayer;
}

- (UIImageView*)menuIconImamgeView {
    if (_menuIconImamgeView == nil) {
        _menuIconImamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0, 20.0)];
        [_menuIconImamgeView setImage:[[UIImage imageNamed:@"menu_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [self addSubview:_menuIconImamgeView];
    }
    return _menuIconImamgeView;
}
@end
