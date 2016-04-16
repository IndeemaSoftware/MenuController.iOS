//
//  EEMenuConroller.m
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEMenuConroller.h"

#import "EEContentVC.h"

#import "EEMenuControllerDefines.h"
#import "EEMenuPanelDelegate.h"

#import "EEFloatingButton.h"
#import "EEFloatingPaneView.h"
#import "EEBottomPanelView.h"

@interface EEMenuConroller() <EEMenuPanelDelegate> {
    EEContentVC *_contentVC;
    
    EEFloatingButton *_floatingButton;
    EEFloatingPaneView *_floatingPanel;
    EEBottomPanelView *_bottomPanel;
    
    NSMutableArray <EEMenuTab*> *_menuTabsArr;
    
    //
    UIView *_blockView;
    UIImageView *_magnetView;//is using to show for user where he/she can push floating menu
    
    CGSize _floatingTabBarVelocity;
    
    CGFloat _bottomInset;
    
    BOOL _isFloatingTabBarOpened;
    BOOL _needMoveAway;
    BOOL _isMenuVisible;
}

- (EEContentVC*)contentVC;
- (void)navigateToTabIndex:(NSUInteger)tabIndex animated:(BOOL)animated;
- (EETransitionType)transitionTypeFor:(NSUInteger)tabIndex1 tab:(NSUInteger)tabIndex2;

- (EEMenuTab*)menuTabAtIndex:(NSUInteger)tabIndex;

- (EEFloatingButton*)floatingButton;
- (EEFloatingPaneView*)floatingPanel;
- (EEBottomPanelView*)bottomPanel;

- (void)removeFloatingTabBarMenu;

- (void)setFloatingMenuVisible:(BOOL)isVisible animated:(BOOL)animated;
- (void)setBottomTabBarVisible:(BOOL)isVisible animated:(BOOL)animated;

- (void)setBlockViewVisible:(BOOL)visible;

- (void)setMagnetViewVisible:(BOOL)visible;

- (void)setIsFloatingMode:(BOOL)isfloatingMode withTouchPoint:(CGPoint)touchPoint;
- (void)dragTabBarCenter:(CGPoint)newCeneter;
- (void)magnetFloatingTabBar;
- (BOOL)canBecomeBottomTabBarWithLocation:(CGPoint)location;
- (void)setFloatingSidePanelOpen:(BOOL)open;

- (void)updateBottomInset:(CGFloat)bottomInset animated:(BOOL)animated;
- (void)sendBottomInset:(CGFloat)bottomOffset to:(UIViewController <EEMenuContentProtocol> *)contentVC animated:(BOOL)animated;

#pragma mark Gesture handlers
- (void)longPressGestureHandler:(UILongPressGestureRecognizer*)longPressGesture;
- (void)panGestureHandler:(UIPanGestureRecognizer*)panGesture;
- (void)tapGestureHandler:(UITapGestureRecognizer*)tapGesture;
@end

@implementation EEMenuConroller

#pragma mark - Public methods
+ (EEMenuConroller*)shareInstance {
    static EEMenuConroller *sMenuConroller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sMenuConroller = [[EEMenuConroller alloc] init];
    });
    return sMenuConroller;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _menuTabsArr = [NSMutableArray new];
        
        _isFloatingMode = NO;
        _isFloatingTabBarOpened = NO;
        _needMoveAway = NO;
        _isMenuVisible = NO;
        
        [self.contentVC.view addSubview:self.bottomPanel];
        [self.contentVC.view addSubview:self.floatingPanel];
        [self.contentVC.view addSubview:self.floatingButton];
        
        [self.contentVC setFloatingAreaInsets:UIEdgeInsetsMake(FLOATING_TOP_OFFSET, 0.0f, 0.0f, 0.0f)];
    }
    return self;
}

#pragma mark Appearance
- (void)setBottomPanelColor:(UIColor *)bottomPanelColor {
    [self.bottomPanel setBackgroundColor:bottomPanelColor];
}

- (UIColor *)bottomPanelColor {
    return self.bottomPanel.backgroundColor;
}

- (void)setBottomPanelTintColor:(UIColor *)bottomPanelTintColor {
    [self.bottomPanel setItemsTintColor:bottomPanelTintColor];
}

- (UIColor *)bottomPanelTintColor {
    return self.bottomPanel.itemsTintColor;
}

- (void)setBottomPanelActiveTintColor:(UIColor *)bottomPanelActiveTintColor {
    [self.bottomPanel setItemsActiveTintColor:bottomPanelActiveTintColor];
}

- (UIColor *)bottomPanelActiveTintColor {
    return self.bottomPanel.itemsTintColor;
}

- (void)setFloatingPanelColor:(UIColor *)floatingPanelColor {
    [self.floatingPanel setBackgroundColor:floatingPanelColor];
}

- (UIColor *)floatingPanelColor{
    return self.floatingPanel.backgroundColor;
}

- (void)setFloatingPanelTintColor:(UIColor *)floatingPanelTintColor {
    [self.floatingPanel setItemsTintColor:floatingPanelTintColor];
}

- (UIColor *)floatingPanelTintColor {
    return self.floatingPanel.itemsTintColor;
}

- (void)setFloatingPanelActiveTintColor:(UIColor *)floatingPanelActiveTintColor {
    [self.floatingPanel setItemsActiveTintColor:floatingPanelActiveTintColor];
}

- (UIColor *)floatingPanelActiveTintColor {
    return self.floatingPanel.itemsActiveTintColor;
}

- (void)setFloatingAreaInsets:(UIEdgeInsets)floatingAreaInsets {
    [self.contentVC setFloatingAreaInsets:floatingAreaInsets];
}

- (UIEdgeInsets)floatingAreaInsets {
    return self.contentVC.floatingAreaInsets;
}

#pragma mark Navigation
- (EEMenuTab *)selectedMenuTab {
    return [self menuTabAtIndex:_selectedTabIndex];
}

- (UIViewController *)contentViewController {
    return self.contentVC;
}

- (void)loadTabs:(NSArray <EEMenuTab*> *)menuTabsArr {
    [_menuTabsArr removeAllObjects];
    
    _selectedTabIndex = 0;
    
    if (menuTabsArr.count != 0) {
        // reload views
        [_menuTabsArr addObjectsFromArray:menuTabsArr];
        
        [self.contentVC showViewController:self.selectedMenuTab.viewController transition:EETransitionTypeNone];
    } else {
        [self.contentVC removeActiveViewController];
    }
    
    [self.floatingPanel reloadTabs];
    [self.bottomPanel reloadTabs];
}

- (void)selectTab:(NSUInteger)tabIndex animated:(BOOL)animated {
    [self.floatingPanel setSelectedTab:tabIndex animated:animated];
    [self.bottomPanel setSelectedTab:tabIndex animated:animated];

    [self navigateToTabIndex:tabIndex animated:animated];
}

- (void)setMenuVisible:(BOOL)isVisible animated:(BOOL)animated {
    if (_isMenuVisible != isVisible) {
        _isMenuVisible = isVisible;
        
        if (_isFloatingMode) {
            [self setFloatingMenuVisible:isVisible animated:animated];
        } else {
            [self setBottomTabBarVisible:isVisible animated:animated];
        }
    }
}

#pragma mark - Private methods
- (EEContentVC*)contentVC {
    if (_contentVC == nil) {
        _contentVC = [[EEContentVC alloc] init];
    }
    return _contentVC;
}

- (void)navigateToTabIndex:(NSUInteger)tabIndex animated:(BOOL)animated {
    if (_selectedTabIndex != tabIndex) {
        EEMenuTab *lNewMenuTab = [self menuTabAtIndex:tabIndex];
        
        EETransitionType lTransitionType = EETransitionTypeNone;
        if (animated) {
            lTransitionType = [self transitionTypeFor:_selectedTabIndex tab:tabIndex];
        }
        
        [self.contentVC showViewController:lNewMenuTab.viewController transition:lTransitionType];
        
        _selectedTabIndex = tabIndex;
        
        [self sendBottomInset:_bottomInset to:lNewMenuTab.viewController animated:NO];
    }
}

- (EETransitionType)transitionTypeFor:(NSUInteger)tabIndex1 tab:(NSUInteger)tabIndex2 {
    if (tabIndex1 == tabIndex2) {
        return EETransitionTypeNone;
    }
    
    EETransitionType lReturn = EETransitionTypeFade;
    
    if (!self.isFloatingMode) {
        if (tabIndex1 > tabIndex2) {
            lReturn = EETransitionTypeLeft;
        } else if (tabIndex1 < tabIndex2) {
            lReturn = EETransitionTypeRight;
        }
    }
    
    return lReturn;
}

- (EEMenuTab*)menuTabAtIndex:(NSUInteger)tabIndex {
    if (_menuTabsArr.count > tabIndex) {
        return _menuTabsArr[tabIndex];
    }
    return nil;
}

#pragma mark Menu Panels
- (EEFloatingButton*)floatingButton {
    if (_floatingButton == nil) {
        _floatingButton = [[EEFloatingButton alloc] initWithFrame:CGRectMake(-FLOATING_VIEW_SIZE, self.contentVC.floatingAreaCenter.y, FLOATING_VIEW_SIZE, FLOATING_VIEW_SIZE)];
        [_floatingButton setSide:EEMenuFloatingMenuSideLeft];
        
        UIPanGestureRecognizer *lPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
        [_floatingButton addGestureRecognizer:lPanGesture];
        
        UITapGestureRecognizer *lTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
        [lTapGesture setNumberOfTapsRequired:1];
        [lTapGesture setNumberOfTouchesRequired:1];
        [_floatingButton addGestureRecognizer:lTapGesture];
    }
    return _floatingButton;
}

- (EEFloatingPaneView*)floatingPanel {
    if (_floatingPanel == nil) {
        _floatingPanel = [[EEFloatingPaneView alloc] initWithFrame:CGRectMake(0.0, SIDE_BAR_WIDTH, SIDE_BAR_WIDTH, SIDE_BAR_WIDTH)];
        [_floatingPanel setDelegate:self];
    }
    return _floatingPanel;
}

- (EEBottomPanelView*)bottomPanel {
    if (_bottomPanel == nil) {
        _bottomPanel = [[EEBottomPanelView alloc] initWithFrame:CGRectMake(0.0, self.contentVC.view.frame.size.height, self.contentVC.view.frame.size.width, BOTTOM_PANEL_HEIGHT)];
        [_bottomPanel setDelegate:self];
        
        UILongPressGestureRecognizer *lLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureHandler:)];
        [lLongGesture setNumberOfTouchesRequired:1];
        [lLongGesture setMinimumPressDuration:0.3];
        [_bottomPanel addGestureRecognizer:lLongGesture];
    }
    return _bottomPanel;
}

- (void)removeFloatingTabBarMenu {
    [_floatingPanel removeFromSuperview];
    _floatingPanel = nil;
}

- (void)setFloatingMenuVisible:(BOOL)isVisible animated:(BOOL)animated {
    CGPoint lNewCenter = CGPointMake(BOTTOM_PANEL_HEIGHT / 2.0, self.contentVC.floatingAreaCenter.y);
    CGPoint lJumpCenter = lNewCenter;
    
    if (isVisible) {
        if (self.floatingButton.center.x < self.contentVC.floatingAreaCenter.x) {
            lNewCenter = CGPointMake(BOTTOM_PANEL_HEIGHT / 2.0, self.floatingButton.center.y);
        } else {
            lNewCenter = CGPointMake(self.contentVC.view.frame.size.width - BOTTOM_PANEL_HEIGHT / 2.0, self.floatingButton.center.y);
        }
    } else {
        if (self.floatingButton.center.x < self.contentVC.floatingAreaCenter.x) {
            lNewCenter = CGPointMake(-BOTTOM_PANEL_HEIGHT, self.floatingButton.center.y);
        } else {
            lNewCenter = CGPointMake(self.contentVC.view.frame.size.width + BOTTOM_PANEL_HEIGHT, self.floatingButton.center.y);
        }
    }
    
    if (lNewCenter.x < self.contentVC.floatingAreaCenter.x) {
        lJumpCenter = CGPointMake(lNewCenter.x + MAGNET_JUMP_INSET, lNewCenter.y);
    } else {
        lJumpCenter = CGPointMake(lNewCenter.x - MAGNET_JUMP_INSET, lNewCenter.y);
    }
    
    void (^animationBlock)(void) = ^{
        [self.floatingButton setCenter:lNewCenter];
        [self.bottomPanel setCenter:lNewCenter];
    };
    
    if (animated) {
        [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.floatingButton setCenter:lJumpCenter];
            [self.bottomPanel setCenter:lJumpCenter];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:animationBlock completion:nil];
        }];
    } else {
        animationBlock();
    }
}

- (void)setBottomTabBarVisible:(BOOL)isVisible animated:(BOOL)animated {
    CGPoint lNewCenter = self.bottomPanel.center;
    CGPoint lJumpCenter = lNewCenter;
    CGFloat lBottomInsets = BOTTOM_PANEL_HEIGHT;
    
    if (isVisible) {
        lNewCenter = CGPointMake(self.bottomPanel.center.x, self.contentVC.view.frame.size.height - BOTTOM_PANEL_HEIGHT / 2.0);
        lJumpCenter = lNewCenter;
        lBottomInsets = BOTTOM_PANEL_HEIGHT;
    } else {
        lNewCenter = CGPointMake(self.bottomPanel.center.x, self.contentVC.view.frame.size.height + BOTTOM_PANEL_HEIGHT / 2.0);
        lBottomInsets = 0.0f;
        lJumpCenter = self.bottomPanel.center;
    }
    
    if (animated) {
        [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.bottomPanel setCenter:lJumpCenter];
            [self.bottomPanel setTransform:CGAffineTransformMakeScale(1.1f, 1.1f)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.bottomPanel setCenter:lNewCenter];
                [self.bottomPanel setTransform:CGAffineTransformIdentity];
            } completion:nil];
        }];
    } else {
        [self.bottomPanel setCenter:lNewCenter];
    }
    
    //send to VC
    [self updateBottomInset:lBottomInsets animated:animated];
}

- (void)setBlockViewVisible:(BOOL)visible {
    if (visible) {
        if (_blockView == nil) {
            _blockView = [[UIView alloc] initWithFrame:self.contentVC.view.bounds];
            [_blockView setBackgroundColor:[UIColor clearColor]];
            
            UITapGestureRecognizer *lTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
            [lTapGesture setNumberOfTapsRequired:1];
            [lTapGesture setNumberOfTouchesRequired:1];
            [_blockView addGestureRecognizer:lTapGesture];
        }
        [self.contentVC.view insertSubview:_blockView belowSubview:self.bottomPanel];
        
        [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            [_blockView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.2f]];
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            [_blockView setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
            if (finished && !self.floatingPanel.isVisible) {
                [_blockView removeFromSuperview];
                _blockView = nil;
            }
        }];
    }
}

- (void)setMagnetViewVisible:(BOOL)visible {
    if (visible) {
        if (_magnetView == nil) {
            _magnetView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.contentVC.view.frame.size.height - 5.0, self.contentVC.view.frame.size.width, 5.0)];
            [_magnetView setUserInteractionEnabled:NO];
            [_magnetView setAnimationImages:@[[UIImage imageNamed:@"menu_placeholder_image"], [UIImage imageNamed:@"empty.png"]]];
            [_magnetView setAnimationRepeatCount:10000];
            [_magnetView setAnimationDuration:0.5];
            [_magnetView setAlpha:0.0];
            [_magnetView startAnimating];
            [self.contentVC.view addSubview:_magnetView];
        }
        [UIView animateWithDuration:0.2 animations:^{
            [_magnetView setAlpha:1.0];
        }];
    } else {
        if (_magnetView != nil) {
            __block UIImageView *lMagnetView = _magnetView;
            _magnetView = nil;
            [UIView animateWithDuration:0.2 animations:^{
                [lMagnetView setAlpha:0.0];
            } completion:^(BOOL finished) {
                [lMagnetView stopAnimating];
                [lMagnetView removeFromSuperview];
                lMagnetView = nil;
            }];
        }
    }
}

- (void)setIsFloatingMode:(BOOL)isfloatingMode withTouchPoint:(CGPoint)touchPoint {
    if (_isFloatingMode != isfloatingMode) {
        if (isfloatingMode) {
            [self.floatingButton setCenter:touchPoint];
            [self.floatingButton setHidden:NO];
            
            [self setMagnetViewVisible:YES];
            
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.floatingButton setAlpha:1.0f];
                [self.floatingButton setTransform:CGAffineTransformIdentity];
                
                [self.bottomPanel setCenter:touchPoint];
                [self.bottomPanel setTransform:CGAffineTransformMakeScale(0.05f, 0.05f)];
            } completion:^(BOOL finished) {
                
            }];
            
            //send to VC
            [self updateBottomInset:0.0f animated:YES];
        } else {
            [self.bottomPanel setCenter:touchPoint];
            [self.floatingButton setCenter:touchPoint];
            
            [self setMagnetViewVisible:NO];
            
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.bottomPanel setTransform:CGAffineTransformIdentity];
                [self.bottomPanel setCenter:CGPointMake(self.contentVC.view.frame.size.width / 2.0, self.contentVC.view.frame.size.height - BOTTOM_PANEL_HEIGHT / 2.0)];
                
                [self.floatingButton setTransform:CGAffineTransformMakeScale(0.5f, 0.5f)];
                [self.floatingButton setAlpha:0.0];
            } completion:^(BOOL finished) {
                
            }];
            
            //send to VC
            [self updateBottomInset:BOTTOM_PANEL_HEIGHT animated:YES];
        }
        _isFloatingMode = isfloatingMode;
    }
}

- (void)dragTabBarCenter:(CGPoint)newCeneter {
    BOOL lCanBecomeBottom = [self canBecomeBottomTabBarWithLocation:newCeneter];
    
    if (lCanBecomeBottom && _isFloatingMode) {
        [self setIsFloatingMode:NO withTouchPoint:newCeneter];
    } else if (!lCanBecomeBottom && !_isFloatingMode) {
        [self setIsFloatingMode:YES withTouchPoint:newCeneter];
    } else if (!lCanBecomeBottom && _isFloatingMode) {
        [UIView animateWithDuration:0.05f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.floatingButton setCenter:newCeneter];
            [self.bottomPanel setCenter:newCeneter];
        } completion:nil];
    }
}

- (void)magnetFloatingTabBar {
    if (_isFloatingMode) {
        CGRect lFloatingArea = self.contentVC.floatingAreaBounds;
        
        CGPoint lMinLocation = CGPointMake(lFloatingArea.origin.x, lFloatingArea.origin.y);
        CGPoint lMaxLocation = CGPointMake(lFloatingArea.size.width, lFloatingArea.size.height);
        
        CGPoint lCurrentCenter = self.floatingButton.center;
        CGPoint lNewCenter = lCurrentCenter;
        CGPoint lInsetCenter = lCurrentCenter;
        
        CGPoint lEndPoint = lCurrentCenter;
        
        CGFloat lSpeedX = _floatingTabBarVelocity.width * 5.0;
        
        CGFloat lEndX = lCurrentCenter.x + lSpeedX;
        CGFloat lEndY = lCurrentCenter.y + _floatingTabBarVelocity.height * 5.0;
        CGFloat lNewX = lMinLocation.x;
        CGFloat lNewY = lCurrentCenter.y + _floatingTabBarVelocity.height * 10.0;
        
        if (lNewY < lMinLocation.y) {
            lNewY = lMinLocation.y;
        } else if (lNewY > lMaxLocation.y) {
            lNewY = lMaxLocation.y;
        }
        
        lEndPoint = CGPointMake(lEndX, lEndY);
        
        if (lSpeedX < -MIN_TABBAR_SPEED) {
            lNewX = lMinLocation.x;
        } else if (lSpeedX > MIN_TABBAR_SPEED) {
            lNewX = lMaxLocation.x;
        } else {
            if (lEndX < self.contentVC.floatingAreaCenter.x) {
                lNewX = lMinLocation.x;
            } else {
                lNewX = lMaxLocation.x;
            }
        }
        
        lNewCenter = CGPointMake(lNewX, lNewY);
        
        if (lNewCenter.x > self.contentVC.floatingAreaCenter.x) {
            lInsetCenter = CGPointMake(lNewCenter.x + MAGNET_JUMP_INSET, lNewCenter.y);
            self.floatingButton.side = EEMenuFloatingMenuSideRight;
        } else {
            lInsetCenter = CGPointMake(lNewCenter.x - MAGNET_JUMP_INSET, lNewCenter.y);
            self.floatingButton.side = EEMenuFloatingMenuSideLeft;
        }
        
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.floatingButton setCenter:lEndPoint];
            [self.bottomPanel setCenter:lEndPoint];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.18 delay:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.floatingButton setCenter:lInsetCenter];
                [self.bottomPanel setCenter:lInsetCenter];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    [self.floatingButton setCenter:lNewCenter];
                    [self.bottomPanel setCenter:lNewCenter];
                } completion:^(BOOL finished) {
                    BOOL lCanBecomeBottom = [self canBecomeBottomTabBarWithLocation:lNewCenter];
                    if (lCanBecomeBottom && _isFloatingMode) {
                        [self setIsFloatingMode:NO withTouchPoint:lNewCenter];
                    }
                }];
            }];
        }];
    } else {
        [self.floatingButton setHidden:YES];
    }
}

//returns YES if floating bar can become bottom bar
- (BOOL)canBecomeBottomTabBarWithLocation:(CGPoint)location {
    BOOL lReturn = CGRectContainsPoint(CGRectMake(0.0, self.contentVC.view.frame.size.height - BUTTOB_MAGNET_EDGE, self.contentVC.view.frame.size.width, BUTTOB_MAGNET_EDGE), location) && (!_needMoveAway);
    return lReturn;
}

- (void)setFloatingSidePanelOpen:(BOOL)open {
    if (_isFloatingTabBarOpened != open) {
        _isFloatingTabBarOpened = open;
        
        if (open) {
            [self.floatingPanel setCenter:self.floatingButton.center];
            
            [self setBlockViewVisible:YES];
            [self.floatingPanel showPanelFromSide:self.floatingButton.side animated:YES];
        } else {
            [self setBlockViewVisible:NO];
            [self.floatingPanel hidePanelAnimated:YES];
        }
    }
}

- (void)updateBottomInset:(CGFloat)bottomInset animated:(BOOL)animated {
    _bottomInset = bottomInset;
    [self sendBottomInset:bottomInset to:self.selectedMenuTab.viewController animated:animated];
}

- (void)sendBottomInset:(CGFloat)bottomInset to:(UIViewController <EEMenuContentProtocol> *)contentVC animated:(BOOL)animated {
    if ([contentVC conformsToProtocol:@protocol(EEMenuContentProtocol)]) {
        [contentVC EEMenuContentBottomInsetChanged:bottomInset animated:animated];
    }
}

#pragma mark - Gesture handlers
- (void)longPressGestureHandler:(UILongPressGestureRecognizer*)longPressGesture {
    CGPoint lLocation = [longPressGesture locationInView:self.contentVC.view];
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        [self setIsFloatingMode:YES withTouchPoint:lLocation];
        _needMoveAway = YES;
    } else if (longPressGesture.state == UIGestureRecognizerStateChanged) {
        if (_needMoveAway) {
            if (!CGRectContainsPoint(self.contentVC.bottomTabBarFrame, lLocation)) {
                _needMoveAway = NO;
            }
        }
        
        CGPoint lCurrentCenter = self.floatingButton.center;
        _floatingTabBarVelocity = CGSizeMake((lLocation.x - lCurrentCenter.x), (lLocation.y - lCurrentCenter.y));
        
        [self dragTabBarCenter:lLocation];
    } else if (longPressGesture.state == UIGestureRecognizerStateEnded) {
        if (_needMoveAway) {
            [self setIsFloatingMode:NO withTouchPoint:lLocation];
        } else {
            [self magnetFloatingTabBar];
            [self setMagnetViewVisible:NO];
        }
    }
}

- (void)panGestureHandler:(UIPanGestureRecognizer*)panGesture {
    CGPoint lLocation = [panGesture locationInView:self.contentVC.view];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        [self setMagnetViewVisible:YES];
        [self setFloatingSidePanelOpen:NO];
        [self dragTabBarCenter:lLocation];
    } else if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint lCurrentCenter = self.floatingButton.center;
        _floatingTabBarVelocity = CGSizeMake((lLocation.x - lCurrentCenter.x), (lLocation.y - lCurrentCenter.y));
        [self dragTabBarCenter:lLocation];
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        [self magnetFloatingTabBar];
        [self setMagnetViewVisible:NO];
    }
}

- (void)tapGestureHandler:(UITapGestureRecognizer*)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        [self setFloatingSidePanelOpen:!_isFloatingTabBarOpened];
    }
}

#pragma mark - EEMenuPanelDelegate methods
- (NSUInteger)EEMenuPanelTabsCount {
    return _menuTabsArr.count;
}

- (EEMenuTab *)EEMenuPanelMenuTabatIndex:(NSUInteger)tabIndex {
    return [self menuTabAtIndex:tabIndex];
}

- (void)EEMenuPanelSelectedTab:(NSUInteger)tabIndex {
    if (_isFloatingMode) {
        [self setFloatingSidePanelOpen:NO];
        
        [self.bottomPanel setSelectedTab:tabIndex animated:NO];
    } else {
        [self.floatingPanel setSelectedTab:tabIndex animated:NO];
    }
    
    [self navigateToTabIndex:tabIndex animated:YES];
}

@end
