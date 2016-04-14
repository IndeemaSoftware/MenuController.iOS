//
//  EEMenuControllerCommon.h
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#ifndef EEMenuControllerCommon_h
#define EEMenuControllerCommon_h

typedef enum {
    EETransitionTypeNone = 0,
    EETransitionTypeFade = 1,
    EETransitionTypeLeft = 2,
    EETransitionTypeRight = 3,
    EETransitionTypeTop = (2 << 10),
    EETransitionTypeBottom = (3 << 10),
} EETransitionType;

//FLOATING MENU PANEL TYPE
typedef enum {
    EEMenuFloatingMenuSideLeft,
    EEMenuFloatingMenuSideRight
} EEMenuFloatingMenuSide;

//DEFINES
#define SIDE_BAR_WIDTH 226.0
#define SIDE_BAR_ITEM_WIDTH 88.0
#define SIDE_BAR_ITEM_SCALE_FACTOR 0.35f
#define SIDE_BAR_SEGMENT_OFFSET 4.0f

#define FLOATING_TOP_OFFSET 110.0f
#define FLOATING_VIEW_SIZE 48.0f

#define BUTTOB_MAGNET_EDGE 40.0f
#define MAGNET_JUMP_INSET 8.0f
#define MIN_TABBAR_SPEED 30.0f
#define BOTTOM_PANEL_BUTTON_WIDTH 106.0f
#define BOTTOM_PANEL_HEIGHT 51.0f

#define STATUS_BAR_HEIGHT 20.0f

#define IMAGE_OFFSET 8.0f
#define IMAGE_SIZE 20.0f

#define STATUS_BAR_HEIGHT 20.0f

#endif /* EEMenuControllerCommon_h */
