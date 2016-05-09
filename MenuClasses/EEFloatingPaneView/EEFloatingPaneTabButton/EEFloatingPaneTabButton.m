//
//  EEFloatingPaneTabButton.m
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEFloatingPaneTabButton.h"
#import "EEMenuTab.h"

#define ICON_IMAGE_SIZE 14.0f

@interface EEFloatingPaneTabButton() {
    CAShapeLayer *_rightSegmentLayer;
    CAShapeLayer *_leftSegmentLayer;
    UIImageView *_imageView;
    UILabel *_titleLabel;
    
    UIColor *_itemTintColor;
}

- (void)updateHighlightedState;
- (CAShapeLayer*)rightSegmentLayer;
- (CAShapeLayer*)leftSegmentLayer;

- (UIImageView*)imageView;
- (UILabel*)titleLabel;

@end

@implementation EEFloatingPaneTabButton

#pragma mark - Public methods
- (id)initWithMenuTabType:(EEMenuTab*)menuTab tab:(NSUInteger)tabIndex {
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, SIDE_BAR_ITEM_WIDTH, SIDE_BAR_WIDTH)];
    if (self) {
        _menuTab = menuTab;
        _tabIndex = tabIndex;
        
        [self.titleLabel setText:_menuTab.title];
        
        [self.imageView setImage:[_menuTab.icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        
        [self setExclusiveTouch:YES];
        
        [super setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

+ (instancetype)buttonWithMenuTabType:(EEMenuTab*)menuTab tab:(NSUInteger)tabIndex {
    return [[EEFloatingPaneTabButton alloc] initWithMenuTabType:menuTab tab:tabIndex];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CAShapeLayer *lLayer = self.leftSegmentLayer;
    if (self.leftSegmentLayer.isHidden) {
        lLayer = self.rightSegmentLayer;
    }
    return CGPathContainsPoint(lLayer.path, 0, point, YES);
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [self.leftSegmentLayer setFillColor:backgroundColor.CGColor];
    [self.rightSegmentLayer setFillColor:backgroundColor.CGColor];
}

- (UIColor *)backgroundColor {
    return [UIColor colorWithCGColor:self.leftSegmentLayer.fillColor];
}

- (void)setTintColor:(UIColor *)tintColor {
    _itemTintColor = tintColor;
    [self updateHighlightedState];
}

- (void)setActiveTintColor:(UIColor *)activeTintColor {
    _activeTintColor = activeTintColor;
    [self updateHighlightedState];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self updateHighlightedState];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateHighlightedState];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateHighlightedState];
}

- (void)updateBackgroundTo:(EEMenuFloatingMenuSide)side {
    [self.leftSegmentLayer setHidden:(side == EEMenuFloatingMenuSideLeft)];
    [self.rightSegmentLayer setHidden:!self.leftSegmentLayer.isHidden];
    
    [self.leftSegmentLayer removeAllAnimations];
    [self.rightSegmentLayer removeAllAnimations];
}

- (void)drawBackgroundWithPath:(CGPathRef)path {
    self.rightSegmentLayer.path = path;
    self.rightSegmentLayer.frame = CGPathGetPathBoundingBox(path);
    self.rightSegmentLayer.bounds = CGPathGetPathBoundingBox(path);
    
    self.leftSegmentLayer.path = path;
    self.leftSegmentLayer.frame = CGPathGetPathBoundingBox(path);
    self.leftSegmentLayer.bounds = CGPathGetPathBoundingBox(path);
}

#pragma mark - Private methods
- (void)updateHighlightedState {
    BOOL lIsHighlighted = self.isSelected || self.isHighlighted;
    
    if (lIsHighlighted) {
        [super setTintColor:self.activeTintColor];
    } else {
        [super setTintColor:_itemTintColor];
    }
     
    [self.titleLabel setTextColor:[super tintColor]];
}

- (CAShapeLayer*)rightSegmentLayer {
    if (_rightSegmentLayer == nil) {
        _rightSegmentLayer = [[CAShapeLayer alloc] init];
        [_rightSegmentLayer setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.3f].CGColor];
        [_rightSegmentLayer setShadowOpacity:1.0f];
        [_rightSegmentLayer setShadowRadius:1.0f];
        [_rightSegmentLayer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
        _rightSegmentLayer.contentsScale = [UIScreen mainScreen].scale;
        
        [self.layer insertSublayer:_rightSegmentLayer atIndex:0];
    }
    return _rightSegmentLayer;
}

- (CAShapeLayer*)leftSegmentLayer {
    if (_leftSegmentLayer == nil) {
        _leftSegmentLayer = [[CAShapeLayer alloc] initWithLayer:self.rightSegmentLayer];
        [_leftSegmentLayer setTransform:CATransform3DScale(CATransform3DMakeRotation(0, 0, 0, 0), -1, 1, 1)];
        
        [self.layer insertSublayer:_leftSegmentLayer atIndex:0];
    }
    return _leftSegmentLayer;
}

- (UIImageView*)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6.0f, (SIDE_BAR_WIDTH - ICON_IMAGE_SIZE) / 2.0f, ICON_IMAGE_SIZE, ICON_IMAGE_SIZE)];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel*)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + 2.0f, (SIDE_BAR_WIDTH - ICON_IMAGE_SIZE) / 2.0f, SIDE_BAR_ITEM_WIDTH - CGRectGetMaxX(self.imageView.frame) - ICON_IMAGE_SIZE, ICON_IMAGE_SIZE)];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_titleLabel setAdjustsFontSizeToFitWidth:YES];
        [_titleLabel setMinimumScaleFactor:0.8f];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
