//
//  EETitleViewController.m
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EETitleViewController.h"

@interface EETitleViewController () {
    IBOutlet UILabel *_titleLblb;
}

- (void)updateTitleLbl;

@end

@implementation EETitleViewController

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    [self updateTitleLbl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // update title label
    [self updateTitleLbl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)updateTitleLbl {
    if (_titleLblb != nil) {
        [_titleLblb setText:self.title];
    }
}

@end
