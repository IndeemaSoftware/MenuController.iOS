//
//  EEBottomPanelTabButton.m
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEBottomPanelTabButton.h"
#import "EEMenuTab.h"

#import "EEMenuControllerDefines.h"

@interface EEBottomPanelTabButton() {
    UIImageView *_imageView;
    UILabel *_titleLabel;
    
    UIColor *_itemTintColor;
}

//highliting
- (void)updateHighlightedState;

//image view
- (UIImageView*)imageView;

//title
- (UILabel*)titleLabel;

@end

@implementation EEBottomPanelTabButton

#pragma mark - Public methods
- (id)initWithMenuTabType:(EEMenuTab*)menuTab tab:(NSUInteger)tabIndex {
    self = [super init];
    if (self) {
        _menuTab = menuTab;
        _tabIndex = tabIndex;
        
        [self.titleLabel setText:_menuTab.title];
        
        [self.imageView setImage:[_menuTab.icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        
        [self setExclusiveTouch:YES];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

+ (instancetype)buttonWithMenuTabType:(EEMenuTab*)menuTab tab:(NSUInteger)tabIndex {
    return [[EEBottomPanelTabButton alloc] initWithMenuTabType:menuTab tab:tabIndex];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView setCenter:CGPointMake(roundf(self.frame.size.width / 2.0f), IMAGE_OFFSET + roundf(self.imageView.frame.size.height / 2.0f))];
    [self.titleLabel setFrame:CGRectMake(0.0f, 28.0f, self.frame.size.width, self.titleLabel.frame.size.height)];
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

//image view
- (UIImageView*)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IMAGE_SIZE, IMAGE_SIZE)];
        [self insertSubview:_imageView atIndex:0];
    }
    return _imageView;
}

//title
- (UILabel*)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IMAGE_SIZE, IMAGE_SIZE)];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
@end
