//
//  UIViewController+Initializing.h
//
//
//  Created by  Sergiy Londar on 6/8/15.
//  Copyright (c) 2015 Indeema. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @header UIViewController+Initializing.h
 
 @brief  Common UIViewController category.
 
 UIViewController+Initializing category contains common methods which helps deloper to manage subclasses of UIViewController
 
 @author Volodymyr Shevchyk Jr.
 @copyright  2015 Mobile Sensor Labs LLC
 @version    1.0
 */

@interface UIViewController (Initializing)

/*!
 @brief This method is made to simplify initializing instance of view controller with nib file.
 
 NOTICE! This methods works only if xib file has the same name as class of instance.
 
 @param  none.
 
 @return UIViewController or any other object of the class that is inheried from UIViewController class
 
 @code
 EEViewController *lViewController = [[EEViewController alloc] initWithNimbAsClassName];
 @endcode
 */

- (instancetype)initWithNimbAsClassName;

/*!
 @brief This method is made to simplify creating instance of view controller with nib file.
 
 NOTICE! This methods works only if xib file has the same name as class of instance.
 
 @param  none.
 
 @return UIViewController or any other object of the class that is inheried from UIViewController class
 
 @code
 EEViewController *lViewController = [EEViewController newWithNimbAsClassName];
 @endcode
 */
+ (instancetype)newWithNimbAsClassName;

@end
