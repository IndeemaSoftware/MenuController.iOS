# MenuController.iOS
Floating menu for an iOS application

Made in ![Indeema Logo](http://indeema.com/images/Indeema.png)

You can find an article about Floating menu in our [blog](http://indeema.com/blog/how-we-created-a-floating-menu-for-an-ios-application)

![Floating menu](/GitHubResources/floating_menu_animation_small.gif)

## Requirements
iOS 7.0

##Customization

You are allowed to adjust margins of the fixed floating area:
```objective-c
[EEMenuConroller.shareInstance setFloatingAreaInsets:UIEdgeInsetsMake(100.0f, 0.0f, 0.0f, 0.0f)];
```

Select color patterns for both panels(bottom/foating):
```objective-c
[EEMenuConroller.shareInstance setBottomPanelColor:[UIColor colorWithWhite:0.95f alpha:1.0f]];
[EEMenuConroller.shareInstance setBottomPanelTintColor:[UIColor lightGrayColor]];
[EEMenuConroller.shareInstance setBottomPanelActiveTintColor:[UIColor colorWithRed:147.0f/255.0f green:207.0f/255.0f blue:28.0f/255.0f alpha:1.0f]];
 
[EEMenuConroller.shareInstance setFloatingPanelColor:[UIColor whiteColor]];
[EEMenuConroller.shareInstance setFloatingPanelTintColor:[UIColor lightGrayColor]];
[EEMenuConroller.shareInstance setFloatingPanelActiveTintColor:[UIColor colorWithRed:147.0f/255.0f green:207.0f/255.0f blue:28.0f/255.0f alpha:1.0f]];
```

