<br>


<a href="http://www.indeema.com">
  <p align="center">
  <img src="http://indeema.com/images/logoIn.png" alt="Indeema Logo"/>
</p>
</a>
<br>
# MenuController.iOS
Floating menu for an iOS application

You can find an article about Floating menu in our [blog](http://indeema.com/blog/how-we-created-a-floating-menu-for-an-ios-application)

<p align="center">
  <img src="/GitHubResources/floating_menu_animation.gif" alt="Floating menu" width="320" height="568" />
</p>

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
[EEMenuConroller.shareInstance setBottomPanelActiveTintColor:[UIColor colorWithRed:64.0f/255.0f green:171.0f/255.0f blue:247.0f/255.0f alpha:1.0f]];

[EEMenuConroller.shareInstance setFloatingPanelColor:[UIColor whiteColor]];
[EEMenuConroller.shareInstance setFloatingPanelTintColor:[UIColor lightGrayColor]];
[EEMenuConroller.shareInstance setFloatingPanelActiveTintColor:[UIColor colorWithRed:64.0f/255.0f green:171.0f/255.0f blue:247.0f/255.0f alpha:1.0f]];
```

