//
//  ViewControllerLayoutAbstract.m
//  PhotoBar
//
//  Created by Lennart Reiher on 20.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "ViewControllerLayoutAbstract.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewControllerLayoutAbstract ()

@property (nonatomic) UIImage* currentImage;
@property (nonatomic) CGRect currentAlertRect;
@property (nonatomic) UIView* currentButtonView;
@property (nonatomic) NSUserDefaults* sharedDefaults;
@property (nonatomic) UIPopoverController* popOverController;
@property (nonatomic) BOOL isEditMode;

@end

@implementation ViewControllerLayoutAbstract

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lennart.reiher.PhotoBar"];
    
    self.storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.lennart.reiher.PhotoBar"];
    
    self.isEditMode = false;
    
    [self setInitialValues];
    
    [self determinePlaceholderVisibility];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}



-(void)setInitialValues {
    
    [self doesNotRecognizeSelector:_cmd];
}



-(void)buttonTouched:(id)sender forEvent:(UIEvent *)event {
    
    self.currentTag = ((UIButton*)sender).tag;
    
    UIView* buttonTouched = (UIView *)sender;
    UITouch* touch = [[event touchesForView:buttonTouched] anyObject];
    CGPoint location = [touch locationInView:buttonTouched];
    
    self.currentAlertRect = CGRectMake(location.x - 80, location.y - 20, 160, 160);
    self.currentButtonView = buttonTouched;
    
    [self showAlertController];
}

- (IBAction)editNavButtonTouched:(id)sender {
    
    [self toggleEditMode];
}

-(void)switchChangedState:(id)sender {
    
    [self.sharedDefaults setBool:((UISwitch*)sender).isOn forKey:[NSString stringWithFormat:@"%@_usingLastPhotos",self.pathComponent]];
    [self requestReload];
    if (self.isEditMode) {
        [self deactivateEditMode];
        self.isEditMode = false;
        [self.editNavButton setTitle:NSLocalizedString(@"Edit", nil)];
    }
    [self determinePlaceholderVisibility];
}


-(void)storePhoto:(UIImage*)editedImage original:(UIImage*)originalImage {
    
    originalImage = [self fixRotation:originalImage];
    UIImage* reducedImage = [self reduceSizeOfImage:editedImage];
    
    NSInteger imgNo = 1;
    
    NSURL* writeURLReduced = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld",self.pathComponent,(long)self.currentTag,(long)imgNo]];
    NSURL* writeURLOriginal = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld_orig",self.pathComponent,(long)self.currentTag,(long)imgNo]];
    
    NSData* dataOriginal = UIImagePNGRepresentation(originalImage);
    NSData* dataReduced = UIImageJPEGRepresentation(reducedImage, 0.9);
    
    [dataOriginal writeToURL:writeURLOriginal atomically:YES];
    [dataReduced writeToURL:writeURLReduced atomically:YES];
    
    [self determinePlaceholderVisibility];
    
    [self requestReload];
}



-(void)removePhotoAndStoreNew:(BOOL)hasNewPhoto {
    
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSURL* deleteURLOriginal = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_1_orig",self.pathComponent,(long)self.currentTag]];
    NSURL* deleteURLReduced = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_1",self.pathComponent,(long)self.currentTag]];
    
    if ([fm fileExistsAtPath:[deleteURLOriginal path]]) {
        [fm removeItemAtURL:deleteURLOriginal error:nil];
    }
    if ([fm fileExistsAtPath:[deleteURLReduced path]]) {
        [fm removeItemAtURL:deleteURLReduced error:nil];
    }
    
    if (self.isEditMode) {
        [self toggleEditMode];
    }

    if (!hasNewPhoto) {
        [self determinePlaceholderVisibility];
        [self requestReload];
    }
}



-(void)removeAllPhotos:(NSInteger)imgNo {
    
    NSFileManager* fm = [NSFileManager defaultManager];
    
    for (int i = 1; i <= imgNo; i++) {
        
        NSArray *files = [fm contentsOfDirectoryAtPath:self.storeURL.path error:nil];
        NSArray *filesWithSelectedPrefix = [files filteredArrayUsingPredicate:
                                            [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self BEGINSWITH[cd] '%@%d'",self.pathComponent,i]]];
        
        for (int j = 0; j < filesWithSelectedPrefix.count; j++) {
            
            NSURL* deleteURL = [self.storeURL URLByAppendingPathComponent:filesWithSelectedPrefix[j]];
            if ([fm fileExistsAtPath:deleteURL.path]) {
                [fm removeItemAtURL:deleteURL error:nil];
            }
        }
    }
}



-(void)editExistingPhoto {
    
    NSData* data = [NSData dataWithContentsOfURL:[self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_1_orig",self.pathComponent,(long)self.currentTag]]];
    
    self.currentImage = [UIImage imageWithData:data];
    
    [self showEditingControlsWithImage:self.currentImage];
}



-(UIImage*)reduceSizeOfImage:(UIImage*)origImage {
    
    CGSize destinationSize = [self getSizeOfReducedImage];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        destinationSize = CGSizeMake(destinationSize.width / 2, destinationSize.height / 2);
    }
    UIGraphicsBeginImageContext(destinationSize);
    [origImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage* reducedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reducedImage;
}



-(CGSize)getSizeOfReducedImage {
    
    [self doesNotRecognizeSelector:_cmd];
    return CGSizeZero;
}



-(void)toggleEditMode {
    
    if (self.isEditMode) {
        self.isEditMode = false;
        [self.editNavButton setTitle:NSLocalizedString(@"Edit", nil)];
        [self determinePlaceholderVisibility];
        [self deactivateEditMode];
    } else {
        self.isEditMode = true;
        [self.editNavButton setTitle:NSLocalizedString(@"Done", nil)];
        [self activateEditMode];
    }
}



-(void)activateEditMode {
    
    [self doesNotRecognizeSelector:_cmd];
}



-(void)deactivateEditMode {
    
    [self doesNotRecognizeSelector:_cmd];
}



-(void)placeholderForTag:(NSInteger)tag hidden:(BOOL)hidden {
    
    [self doesNotRecognizeSelector:_cmd];
}



-(void)determinePlaceholderVisibility {
    
    if ([self.sharedDefaults boolForKey:[NSString stringWithFormat:@"%@_usingLastPhotos",self.pathComponent]]) {
        for (int i = 1; i <= self.numberOfImages; i++) {
            [self placeholderForTag:i hidden:true];
        }
        self.editNavButton.enabled = false;
    } else {
        NSFileManager* fm = [NSFileManager defaultManager];
        NSInteger numberFilledPlaceholders = 0;
        
        for (int i = 1; i <= self.numberOfImages; i++) {
            
            NSURL* dataURL = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%d_1",self.pathComponent, i]];
            
            if ([fm fileExistsAtPath:[dataURL path]]) {
                [self placeholderForTag:i hidden:true];
                numberFilledPlaceholders++;
            } else {
                [self placeholderForTag:i hidden:false];
            }
        }
        
        if (numberFilledPlaceholders == 0) {
            self.editNavButton.enabled = false;
        } else {
            self.editNavButton.enabled = true;
        }
    }
}



-(void)requestReload {
    
    [self.sharedDefaults setBool:true forKey:self.defaultsKey];
    [self.sharedDefaults synchronize];
    [self.container setNeedsDisplay];
}



-(void)showAlertController {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil
                                                                              message: nil
                                                                       preferredStyle: UIAlertControllerStyleActionSheet];
    
    if ([self.sharedDefaults boolForKey:[NSString stringWithFormat:@"%@%ld_hasMoreImages",self.pathComponent,(long)self.currentTag]]) {
        [alertController addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"Manage Photos in Frame", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self performSegueWithIdentifier:@"segueToEditView" sender:self];
        }]];
    } else {
        if (self.isEditMode) {
            [alertController addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"Add more Photos", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self performSegueWithIdentifier:@"segueToEditView" sender:self];
            }]];
            [alertController addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"Remove Photo", nil) style: UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [self removePhotoAndStoreNew:NO];
            }]];
            [alertController addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"Edit Existing Photo", nil) style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self editExistingPhoto];
            }]];
        }
        [alertController addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"Take Photo", nil) style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showCamera];
        }]];
        [alertController addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"Choose Existing Photo", nil) style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showImagePicker];
        }]];
    }
    [alertController addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.popOverController = [[UIPopoverController alloc] initWithContentViewController:alertController];
        [self.popOverController presentPopoverFromRect:self.currentAlertRect inView:self.currentButtonView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    } else {
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


-(void)showImagePicker {

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(id)kUTTypeImage]) {
            picker.mediaTypes = [[NSArray alloc] initWithObjects:(id)kUTTypeImage, nil];
        }
        picker.allowsEditing = NO;
        picker.delegate = self;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.popOverController = [[UIPopoverController alloc] initWithContentViewController:picker];
            [self.popOverController presentPopoverFromRect:self.currentAlertRect inView:self.currentButtonView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        } else {
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}



-(void)showCamera {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera] containsObject:(id)kUTTypeImage]) {
            picker.mediaTypes = [[NSArray alloc] initWithObjects:(id)kUTTypeImage, nil];
        }
        picker.allowsEditing = NO;
        picker.delegate = self;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.popOverController = [[UIPopoverController alloc] initWithContentViewController:picker];
            [self.popOverController presentPopoverFromRect:self.currentAlertRect inView:self.currentButtonView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        } else {
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}



-(void)showEditingControlsWithImage:(UIImage*)img {
    
    DZNPhotoPickerController* picker = [[DZNPhotoPickerController alloc] initWithEditableImage:img cropSize:self.cropSize];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}



#pragma mark UIImagePickerViewController Delegate Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.currentImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self showEditingControlsWithImage:self.currentImage];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark DZNPhotoPickerController Delegate Methods

-(void)photoPickerController:(DZNPhotoPickerController *)picker didFinishPickingPhotoWithInfo:(NSDictionary *)userInfo {
    
    self.currentImage = nil;
    
    [self removePhotoAndStoreNew:YES];
    
    [self storePhoto:(UIImage*)[userInfo valueForKey:UIImagePickerControllerEditedImage] original:(UIImage*)[userInfo valueForKey:UIImagePickerControllerOriginalImage]];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)photoPickerControllerDidCancel:(DZNPhotoPickerController *)picker {
    
    self.currentImage = nil;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)photoPickerController:(DZNPhotoPickerController *)picker didFailedPickingPhotoWithError:(NSError *)error {
    
    NSLog(@"%@",error.localizedDescription);
}



#pragma mark Segue To Edit Preparation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToEditView"]) {
        EditViewController* editVC = [segue destinationViewController];
        editVC.currentTag = self.currentTag;
        editVC.pathComponent = self.pathComponent;
        editVC.storeURL = self.storeURL;
        editVC.sizeOfReducedImage = [self getSizeOfReducedImage];
        editVC.cropSize = self.cropSize;
        editVC.sharedDefaults = self.sharedDefaults;
    }
}



#pragma mark Status Bar Image Picker Fixer

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}



#pragma mark Rotation Fixer

-(UIImage*)fixRotation:(UIImage *)image{
    
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
    
}

@end
