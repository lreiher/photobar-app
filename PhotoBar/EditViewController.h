//
//  EditViewController.h
//  PhotoBar
//
//  Created by Lennart Reiher on 17.11.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZNPhotoPickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface EditViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DZNPhotoPickerControllerDelegate, UIActionSheetDelegate>

-(IBAction)buttonTouched:(id)sender forEvent:(UIEvent *)event;

@property (strong,nonatomic) IBOutlet UITableView* tableV;

@property (nonatomic) NSInteger currentTag;
@property (nonatomic) NSString* pathComponent;
@property (nonatomic) NSURL* storeURL;
@property (nonatomic) CGSize sizeOfReducedImage;
@property (nonatomic) CGSize cropSize;
@property (nonatomic) NSUserDefaults* sharedDefaults;

@end
