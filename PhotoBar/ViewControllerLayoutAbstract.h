//
//  ViewControllerLayoutAbstract.h
//  PhotoBar
//
//  Created by Lennart Reiher on 20.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZNPhotoPickerController.h"
#import "EditViewController.h"

@protocol ViewControllerLayoutProtocol <NSObject>

-(IBAction)buttonTouched:(id)sender forEvent:(UIEvent *)event;
-(void)setInitialValues;
-(CGSize)getSizeOfReducedImage;
-(void)activateEditMode;
-(void)deactivateEditMode;
-(void)placeholderForTag:(NSInteger)tag hidden:(BOOL)hidden;

@end

@interface ViewControllerLayoutAbstract : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, DZNPhotoPickerControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editNavButton;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (nonatomic) NSInteger currentTag;

@property (nonatomic) NSString* screenName;

@property (nonatomic) NSInteger numberOfImages;
@property (nonatomic) NSString* pathComponent;
@property (nonatomic) NSString* defaultsKey;
@property (nonatomic) CGSize cropSize;

@property (nonatomic) NSURL* storeURL;

-(void)buttonTouched:(id)sender forEvent:(UIEvent *)event;
-(void)switchChangedState:(id)sender;
-(void)removeAllPhotos:(NSInteger)imgNo;
-(void)determinePlaceholderVisibility;

@end
