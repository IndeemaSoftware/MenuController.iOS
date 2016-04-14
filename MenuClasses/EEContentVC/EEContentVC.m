//
//  EEContentVC.m
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEContentVC.h"

@interface EEContentVC () {
    //transition
    UIViewController *_currentViewController;
}

@end

@implementation EEContentVC

- (id)init {
    self = [super init];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationAppearanceHasChanged:) name:APPLICATION_APPEARANCE_CHANGED object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.definesPresentationContext = YES;
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:1.0f]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (_currentViewController != nil) {
        [_currentViewController.view setFrame:self.view.bounds];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _currentViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return _currentViewController.prefersStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return _currentViewController.preferredStatusBarUpdateAnimation;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return _currentViewController.preferredInterfaceOrientationForPresentation;
}

- (void)showViewController:(UIViewController*)viewController transition:(EETransitionType)transitionType {
    if ([_currentViewController isEqual:viewController]) {
        return;
    }
    
    __block UIViewController *lCurrentViewController__ = _currentViewController;
    __block UIViewController *lNewViewController__ = viewController;
    
    CGRect lNewVCStartFrame = self.view.bounds;
    CGRect lNewVCEndFrame = self.view.bounds;
    CGRect lOldVCEndFrame = self.view.bounds;
    
    CGAffineTransform lNewVCEndTransform = CGAffineTransformMakeScale(0.8f, 0.8f);
    CGAffineTransform lOldVCEndransform = CGAffineTransformMakeScale(0.8f, 0.8f);
    
    if (transitionType == EETransitionTypeRight) {
        lNewVCStartFrame = CGRectMake(self.view.frame.size.width, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        lOldVCEndFrame = CGRectMake(-self.view.frame.size.width, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    } else if (transitionType == EETransitionTypeLeft) {
        lNewVCStartFrame = CGRectMake(-self.view.frame.size.width, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        lOldVCEndFrame = CGRectMake(self.view.frame.size.width, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    } else if (transitionType == EETransitionTypeTop) {
        lNewVCStartFrame = CGRectMake(100.0f, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        lOldVCEndFrame = CGRectMake(0.0f, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        
        lNewVCEndTransform = CGAffineTransformRotate(lNewVCEndTransform, M_PI_4 / 2.0f);
        lOldVCEndransform = CGAffineTransformRotate(lNewVCEndTransform, -M_PI_4 / 2.0f);
    } else if (transitionType == EETransitionTypeBottom) {
        lNewVCStartFrame = CGRectMake(0.0f, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        lOldVCEndFrame = CGRectMake(0.0f, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        
        lNewVCEndTransform = CGAffineTransformRotate(lNewVCEndTransform, -M_PI_4 / 2.0f);
        lOldVCEndransform = CGAffineTransformRotate(lNewVCEndTransform, M_PI_4 / 2.0f);
    } else if (transitionType == EETransitionTypeFade) {
        lNewVCStartFrame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        lOldVCEndFrame = CGRectMake(0.0f, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [viewController.view setTransform:CGAffineTransformIdentity];
    [viewController.view setFrame:lNewVCStartFrame];
    
    [self addChildViewController:viewController];
    
    if (_currentViewController == nil) {
        [self.view insertSubview:viewController.view atIndex:0];
    } else {
        [_currentViewController willMoveToParentViewController:nil];
        [_currentViewController removeFromParentViewController];
        [_currentViewController didMoveToParentViewController:nil];
        
        [self.view insertSubview:viewController.view aboveSubview:_currentViewController.view];
    }
    
    [viewController didMoveToParentViewController:self];
    
    _currentViewController = viewController;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [viewController.view setTransform:lNewVCEndTransform];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:(7 << 16) animations:^{
        [lNewViewController__.view setTransform:CGAffineTransformIdentity];
        [lNewViewController__.view setFrame:lNewVCEndFrame];
        
        [lCurrentViewController__.view setFrame:lOldVCEndFrame];
        [lCurrentViewController__.view setTransform:lOldVCEndransform];
    } completion:^(BOOL finished) {
        if (![lCurrentViewController__ isEqual:_currentViewController]) {
            [lCurrentViewController__.view removeFromSuperview];
        }
    }];
}

- (void)removeActiveViewController {
    [_currentViewController willMoveToParentViewController:nil];
    [_currentViewController.view removeFromSuperview];
    [_currentViewController removeFromParentViewController];
    [_currentViewController didMoveToParentViewController:nil];
    _currentViewController = nil;
}
@end
