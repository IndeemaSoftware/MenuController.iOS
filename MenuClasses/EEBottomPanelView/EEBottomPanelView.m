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
- (void)updatePanelAppearance;
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
        
        _itemsTintColor = [UIColor lightGrayColor];
        _itemsActiveTintColor = [UIColor colorWithRed:147.0f/255.0f green:207.0f/255.0f blue:28.0f/255.0f alpha:1.0f];
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
}

- (void)setItemsTintColor:(UIColor *)itemsTintColor {
    _itemsTintColor = itemsTintColor;
    [self updatePanelAppearance];
}

- (void)setItemsActiveTintColor:(UIColor *)itemsActiveTintColor {
    _itemsActiveTintColor = itemsActiveTintColor;
    [self updatePanelAppearance];
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
        [lTabButton setTintColor:self.itemsTintColor];
        [lTabButton setActiveTintColor:self.itemsActiveTintColor];
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

- (void)updatePanelAppearance {
    for (EEBottomPanelTabButton *lTabButton in _tabButtonsArr) {
        [lTabButton setTintColor:self.itemsTintColor];
        [lTabButton setActiveTintColor:self.itemsActiveTintColor];
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
