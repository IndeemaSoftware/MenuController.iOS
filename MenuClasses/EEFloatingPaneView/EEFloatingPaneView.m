//
//  EEFloatingPaneView.m
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEFloatingPaneView.h"

#import "EEFloatingPaneTabButton.h"

@interface EEFloatingPaneView() {
    //tab buttons
    NSMutableArray <EEFloatingPaneTabButton*> *_tabButtonsArr;

    EEFloatingPaneTabButton *_selectedTabButton;
    
    UIColor *_segmentColor;
}

- (void)tabButtonPressed:(EEFloatingPaneTabButton*)tabButton;

- (CGFloat)segmentAngleForSegmentCount:(NSUInteger)segmentsCount;
- (CGPathRef)buildPathForSegmentWithAngle:(CGFloat)segmentAngle;

@end

@implementation EEFloatingPaneView

#pragma mark - Public methods
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [super setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.0f]];
        
        _side = EEMenuFloatingMenuSideLeft;
        _isVisible = NO;
        
        [self setHidden:YES];
        
        _tabButtonsArr = [NSMutableArray new];
        
        _segmentColor = [UIColor whiteColor];
        _itemsTintColor = [UIColor lightGrayColor];
        _itemsActiveTintColor = [UIColor colorWithRed:147.0f/255.0f green:207.0f/255.0f blue:28.0f/255.0f alpha:1.0f];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL lReturn = NO;
    
    for (EEFloatingPaneTabButton *lTabButton in _tabButtonsArr) {
        if ([lTabButton pointInside:[self convertPoint:point toView:lTabButton] withEvent:event]) {
            lReturn = YES;
            break;
        }
    }
    
    return lReturn;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _segmentColor = backgroundColor;
    [self updatePanelAppearance];
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
    
    CGFloat lSegmentAngle = [self segmentAngleForSegmentCount:lTabsCount];
    CGFloat lStartAngle = -lSegmentAngle * lTabsCount / 2.0f + lSegmentAngle / 2.0f;// - SIDE_BAR_SEGMENT_ANGLE_OFFSET / 2.0f;
    
    CGPathRef lSegmentPath = [self buildPathForSegmentWithAngle:lSegmentAngle];
    
    for (NSUInteger i = 0; i < lTabsCount; i++) {
        EEFloatingPaneTabButton *lTabButton = [EEFloatingPaneTabButton buttonWithMenuTabType:[self.delegate EEMenuPanelMenuTabatIndex:i] tab:i];
        [lTabButton addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [lTabButton setTintColor:self.itemsTintColor];
        [lTabButton setActiveTintColor:self.itemsActiveTintColor];
        [lTabButton setAngle:lStartAngle];
        [lTabButton setBackgroundColor:_segmentColor];
        [lTabButton drawBackgroundWithPath:lSegmentPath];
        
        [_tabButtonsArr addObject:lTabButton];
        [self addSubview:lTabButton];
        
        lStartAngle += lSegmentAngle;
    }
    
    CGPathRelease(lSegmentPath);
    
    
    [self hidePanelAnimated:NO];
    
    _selectedTabButton = _tabButtonsArr[0];
    [_selectedTabButton setSelected:YES];
}

- (void)setSelectedTab:(NSUInteger)tabIndex animated:(BOOL)animated {
    [_selectedTabButton setSelected:NO];
    
    _selectedTabButton = _tabButtonsArr[tabIndex];
    [_selectedTabButton setSelected:YES];
}

- (void)showPanelFromSide:(EEMenuFloatingMenuSide)side animated:(BOOL)animated {
    _isVisible = YES;
    [self setHidden:NO];
    
    _side = side;
    
    CGFloat lDelay = 0.0;
    CGPoint lCenter = CGPointZero;
    
    CGFloat lRadius = (SIDE_BAR_WIDTH - SIDE_BAR_ITEM_WIDTH) / 2.0f;
    CGPoint lStartCenter = CGPointMake(SIDE_BAR_WIDTH / 2.0f, SIDE_BAR_WIDTH / 2.0f);
    
    if (_side == EEMenuFloatingMenuSideRight) {
        lRadius = -lRadius+2;
    }
    
    for (EEFloatingPaneTabButton *tabButton in _tabButtonsArr) {
        [tabButton updateBackgroundTo:side];
        
        CGFloat lAngle = tabButton.angle;
        if (_side == EEMenuFloatingMenuSideRight) {
            lAngle = -lAngle;
        }
        
        lCenter = findPointOnCirle(lStartCenter, lAngle, lRadius);
        
        CGAffineTransform lTransform = CGAffineTransformMakeRotation(lAngle);
        
        [tabButton setCenter:lStartCenter];
        [tabButton setTransform:CGAffineTransformScale(lTransform, SIDE_BAR_ITEM_SCALE_FACTOR, SIDE_BAR_ITEM_SCALE_FACTOR)];
        [tabButton setAlpha:0.0f];
        
        [UIView animateWithDuration:0.15f delay:lDelay options:(7 << 16) | UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            [tabButton setTransform:CGAffineTransformScale(lTransform, 1.0f, 1.0f)];
            [tabButton setCenter:lCenter];
            [tabButton setAlpha:1.0f];
        } completion:nil];
        
        lDelay += 0.05;
    }
}

- (void)hidePanelAnimated:(BOOL)animated {
    _isVisible = NO;
    
    CGFloat lDelay = 0.0;
    CGPoint lCenter = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0f);
    
    for (EEFloatingPaneTabButton *tabButton in _tabButtonsArr) {
        CGFloat lAngle = tabButton.angle;
        
        if (_side == EEMenuFloatingMenuSideRight) {
            lAngle = -lAngle;
        }
        
        CGAffineTransform lTransform = CGAffineTransformMakeRotation(lAngle);
        
        [UIView animateWithDuration:0.15f delay:lDelay options:(7 << 16) animations:^{
            [tabButton setCenter:lCenter];
            [tabButton setTransform:CGAffineTransformScale(lTransform, SIDE_BAR_ITEM_SCALE_FACTOR, SIDE_BAR_ITEM_SCALE_FACTOR)];
            [tabButton setAlpha:0.0];
        } completion:^(BOOL finished) {
            if (finished && !_isVisible) {
                [self setHidden:YES];
            }
            
        }];
        lDelay +=0.05;
    }
}

#pragma mark - Private methods
- (void)updatePanelAppearance {
    for (EEFloatingPaneTabButton *lTabButton in _tabButtonsArr) {
        [lTabButton setTintColor:self.itemsTintColor];
        [lTabButton setActiveTintColor:self.itemsActiveTintColor];
        [lTabButton setBackgroundColor:_segmentColor];
    }
}

- (void)tabButtonPressed:(EEFloatingPaneTabButton*)tabButton {
    if (_selectedTabButton.tabIndex == tabButton.tabIndex) {
        return;
    }
    
    [self setSelectedTab:tabButton.tabIndex animated:YES];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(EEMenuPanelSelectedTab:)]) {
        [self.delegate EEMenuPanelSelectedTab:tabButton.tabIndex];
    }
}

- (CGFloat)segmentAngleForSegmentCount:(NSUInteger)segmentsCount {
    if (segmentsCount < 3) {
        return M_PI_4 * 1.5f;
    }
    
    return M_PI / (segmentsCount + 0.0f);
}

- (CGPathRef)buildPathForSegmentWithAngle:(CGFloat)segmentAngle {
//    // find center
//    CGPoint lCenter = CGPointMake(SIDE_BAR_ITEM_WIDTH / 2.0f, SIDE_BAR_WIDTH / 2.0f);
//    
//    // create Arc path
//    CGMutablePathRef lArcPath = CGPathCreateMutable();
//    
//    CGFloat lRadius = SIDE_BAR_ITEM_WIDTH / 2.0f;
//
//    CGPoint lStartPoint = findPointOnCirle(lCenter, 0, lRadius);
//    // move to start point
//    CGPathMoveToPoint(lArcPath, NULL, lStartPoint.x, lStartPoint.y);
//    // add external arc to the path
//    CGPathAddArc(lArcPath, NULL, lCenter.x, lCenter.y, lRadius, 0.0f, 2 * M_PI, NO);
//    
//    // 4. Close path  --------------
//    CGPathCloseSubpath(lArcPath);
//    
//    return lArcPath;
    
    // find center
    CGPoint lCenter = CGPointMake(SIDE_BAR_ITEM_WIDTH - SIDE_BAR_WIDTH / 2.0f, SIDE_BAR_WIDTH / 2.0f);
    
    // create Arc path
    CGMutablePathRef lArcPath = CGPathCreateMutable();
    
    // 1.  Add external arc --------------
    // find external radius
    CGFloat lRadius = SIDE_BAR_WIDTH / 2.0f;
    // culculate new external arc Angle / 2
    CGFloat lHalfOfSegmentAngle = (segmentAngle * lRadius - SIDE_BAR_SEGMENT_OFFSET) / lRadius / 2.0f;
    // find start point of external arc
    CGPoint lStartPoint = findPointOnCirle(lCenter, -lHalfOfSegmentAngle, lRadius);
    // move to start point
    CGPathMoveToPoint(lArcPath, NULL, lStartPoint.x, lStartPoint.y);
    // add external arc to the path
    CGPathAddArc(lArcPath, NULL, lCenter.x, lCenter.y, lRadius, -lHalfOfSegmentAngle, lHalfOfSegmentAngle, NO);
    
    
    // 2. Add connection line from external arc to internal  --------------
    // find internal radius
    lRadius = SIDE_BAR_WIDTH / 2.0f - SIDE_BAR_ITEM_WIDTH;
    lHalfOfSegmentAngle = (segmentAngle * lRadius - SIDE_BAR_SEGMENT_OFFSET) / lRadius  / 2.0f;
    // find end point of internal arc
    lStartPoint = findPointOnCirle(lCenter, lHalfOfSegmentAngle, lRadius);
    // connection line to the path
    CGPathAddLineToPoint(lArcPath, NULL, lStartPoint.x, lStartPoint.y);

    // 3. Add internal arc to the path  --------------
    CGPathAddArc(lArcPath, NULL, lCenter.x, lCenter.y, lRadius, lHalfOfSegmentAngle, -lHalfOfSegmentAngle, YES);

    // 4. Close path  --------------
    CGPathCloseSubpath(lArcPath);
    
    return lArcPath;
    
//    CGFloat lRadius = (SIDE_BAR_WIDTH - SIDE_BAR_ITEM_WIDTH) / 2.0f;
//    CGFloat lHalfOfSegmentAngle = segmentAngle / 2.0f;
//    CGPoint lCenter = CGPointMake(SIDE_BAR_ITEM_WIDTH - SIDE_BAR_WIDTH / 2.0f, SIDE_BAR_WIDTH / 2.0f);
//    CGPoint lStartPoint = CGPointMake(cosf(-lHalfOfSegmentAngle) * lRadius + lCenter.x, sinf(-lHalfOfSegmentAngle) * lRadius + lCenter.y);
//    
//    CGMutablePathRef lArcPath = CGPathCreateMutable();
//    CGPathMoveToPoint(lArcPath, NULL, lStartPoint.x, lStartPoint.y);
//    CGPathAddArc(lArcPath, NULL, lCenter.x, lCenter.y, lRadius, -lHalfOfSegmentAngle, lHalfOfSegmentAngle, NO);
//    CGPathRef lResultPath = CGPathCreateCopyByStrokingPath(lArcPath, NULL, SIDE_BAR_ITEM_WIDTH, kCGLineCapButt, kCGLineJoinMiter, 10);
//    CGPathRelease(lArcPath);
//    
//    return lResultPath;
}

static inline  CGPoint findPointOnCirle(CGPoint center, CGFloat angle, CGFloat radius) {
    return CGPointMake(cosf(angle) * radius + center.x, sinf(angle) * radius + center.y);;
}

@end
