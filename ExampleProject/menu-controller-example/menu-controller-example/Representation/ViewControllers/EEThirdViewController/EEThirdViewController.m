//
//  EEThirdViewController.m
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 14/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEThirdViewController.h"

@interface EEThirdViewController () {
    IBOutlet UITextView *_textView;
}

@end

@implementation EEThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - EEMenuContent protocol
- (void)EEMenuContentBottomInsetChanged:(CGFloat)bottomInset animated:(BOOL)animated {
    if (self.isViewLoaded) {
        if (animated) {
            [UIView animateWithDuration:0.25f animations:^{
                [_textView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, bottomInset, 0.0f)];
                [_textView setScrollIndicatorInsets:UIEdgeInsetsMake(0.0f, 0.0f, bottomInset, 0.0f)];
            }];
        } else {
            [_textView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, bottomInset, 0.0f)];
            [_textView setScrollIndicatorInsets:UIEdgeInsetsMake(0.0f, 0.0f, bottomInset, 0.0f)];
        }
    }
}

@end
