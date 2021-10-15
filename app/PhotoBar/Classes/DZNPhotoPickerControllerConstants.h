//
//  DZNPhotoPickerControllerConstants.h
//  DZNPhotoPickerController
//  https://github.com/dzenbot/DZNPhotoPickerController
//
//  Created by Ignacio Romero Zurbuchen on 10/5/13.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <Foundation/Foundation.h>

extern NSString *const DZNPhotoPickerControllerCropMode;              // An NSString (i.e. square, circular)
extern NSString *const DZNPhotoPickerControllerCropZoomScale;         // An NSString (from 1.0 to maximum zoom scale, 2.0f)
extern NSString *const DZNPhotoPickerControllerPhotoMetadata;         // An NSDictionary containing metadata from a captured photo

extern NSString *const DZNPhotoPickerDidFinishPickingNotification;    // The notification key used when photo picked.
extern NSString *const DZNPhotoPickerDidCancelPickingNotification;
extern NSString *const DZNPhotoPickerDidFailPickingNotification;      // The notification key used when photo picked.

/**
 Types of supported crop modes.
 */
typedef NS_ENUM(NSInteger, DZNPhotoEditorViewControllerCropMode) {
    DZNPhotoEditorViewControllerCropModeNone = -1,
    DZNPhotoEditorViewControllerCropModeSquare = 0,
    DZNPhotoEditorViewControllerCropModeCircular,
    DZNPhotoEditorViewControllerCropModeCustom
};