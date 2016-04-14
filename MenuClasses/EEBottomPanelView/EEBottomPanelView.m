//
//  EEBottomPanelView.m
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEBottomPanelView.h"
#import "EEBottomPanelTabButton.h"

#import "EEMenuControllerDefines.h"

@interface EEBottomPanelView() {
    //shadow
    UIImageView *_shadowImgView;
    
    //active tab view
    UIView *_activeTabView;
    
    //tab buttons
    NSMutableArray <EEBottomPanelTabButton*> *_tabButtonsArr;
    
    EEBottomPanelTabButton *_selectedTabButton;
}

- (UIImageView*)shadowImageView;

- (UIView*)activeTabView;
- (CGPoint)centerForActiveTabView;
- (void)updateActiveTabViewPositionAnimated:(BOOL)animated;
- (void)tabButtonPressed:(EEBottomPanelTabButton*)tabButton;
@end

@implementation EEBottomPanelView

#pragma mark - Public methods
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
        
        _tabButtonsArr = [NSMutableArray new];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.shadowImageView setFrame:CGRectMake(0.0f, -3.5f, self.frame.size.width, 3.5f)];
    
    NSUInteger lSubviewsCount = _tabButtonsArr.count;
    CGFloat lButtonWidth = self.frame.size.width / (lSubviewsCount + .0f);
    for (NSUInteger index = 0; index < lSubviewsCount; index++) {
        EEBottomPanelTabButton *lTabButton = _tabButtonsArr[index];
        [lTabButton setFrame:CGRectMake(index * lButtonWidth, 0.0f, lButtonWidth, self.frame.size.height)];
    }
    
    // layout activeTabView
    [self.activeTabView setCenter:[self centerForActiveTabView]];
}

- (void)reloadTabs {
    if (self.delegate == nil) {
        return;
    }
    
    NSUInteger lTabsCount = [self.delegate EEMenuPanelTabsCount];
    [_tabButtonsArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_selectedTabButton setSelected:NO];
    _selectedTabButton = nil;
    
    if (lTabsCount == 0) {
        return;
    }
    
    for (NSUInteger i = 0; i < lTabsCount; i++) {
        EEBottomPanelTabButton *lTabButton = [EEBottomPanelTabButton buttonWithMenuTabType:[self.delegate EEMenuPanelMenuTabatIndex:i] tab:i];
        [lTabButton addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_tabButtonsArr addObject:lTabButton];
        [self addSubview:lTabButton];
    }
    
    _selectedTabButton = _tabButtonsArr[0];
    [_selectedTabButton setSelected:YES];
    
    [self setNeedsLayout];
}

- (void)setSelectedTab:(NSUInteger)tabIndex animated:(BOOL)animated {
    [_selectedTabButton setSelected:NO];
    
    _selectedTabButton = _tabButtonsArr[tabIndex];
    [_selectedTabButton setSelected:YES];
    
    [self updateActiveTabViewPositionAnimated:animated];
}

- (void)setShadowHidden:(BOOL)shadowHidden {
    _shadowHidden = shadowHidden;
    [self.shadowImageView setHidden:shadowHidden];
}

#pragma mark - Private methods
- (UIImageView*)shadowImageView {
    if (_shadowImgView == nil) {
        _shadowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_shadow.png"]];
        [self addSubview:_shadowImgView];
    }
    
    return _shadowImgView;
}

- (UIView*)activeTabView {
    if (_activeTabView == nil) {
        _activeTabView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, BOTTOM_PANEL_HEIGHT - 2.0f, 70.0f, 2.0f)];
        [self addSubview:_activeTabView];
    }
    
    return _activeTabView;
}

- (CGPoint)centerForActiveTabView {
    return CGPointMake(_selectedTabButton.center.x, self.activeTabView.center.y);
}

- (void)updateActiveTabViewPositionAnimated:(BOOL)animated {
    void (^animationBlock)(void) = ^{
        [self.activeTabView setCenter:[self centerForActiveTabView]];
    };
    
    if (animated) {
        [UIView animateWithDuration:0.2f delay:0.0f options:(7<<16) animations:animationBlock completion:nil];
    } else {
        animationBlock();
    }
}

- (void)tabButtonPressed:(EEBottomPanelTabButton*)tabButton {
    if (_selectedTabButton.tabIndex == tabButton.tabIndex) {
        return;
    }
    
    [self setSelectedTab:tabButton.tabIndex animated:YES];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(EEMenuPanelSelectedTab:)]) {
        [self.delegate EEMenuPanelSelectedTab:tabButton.tabIndex];
    }
}

@end
