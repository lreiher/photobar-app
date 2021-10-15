//
//  EditViewController.m
//  PhotoBar
//
//  Created by Lennart Reiher on 17.11.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@property (nonatomic) NSString* cellIdentifier;
@property (nonatomic) NSMutableArray* pictures;
@property (nonatomic) UIImage* currentImage;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableV setEditing:true];
    
    self.cellIdentifier = @"reusableIdentifier";
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.pictures = nil;
    
    self.pictures = [NSMutableArray array];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSInteger imgNo = 1;
    
    NSURL* dataURL = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld",self.pathComponent,(long)self.currentTag,(long)imgNo]];
    
    while ([fm fileExistsAtPath:[dataURL path]]) {
        NSData* data = [NSData dataWithContentsOfURL:dataURL];
        [self.pictures addObject:[UIImage imageWithData:data]];
        imgNo++;
        dataURL = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld",self.pathComponent,(long)self.currentTag,(long)imgNo]];
    }
    
        
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.pictures.count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pictures.count != 0) {
        CGFloat height = self.view.frame.size.width / 2 * ((UIImage*)self.pictures[0]).size.height / ((UIImage*)self.pictures[0]).size.width;
        return (height <= self.view.frame.size.width / 2) ? height : (self.view.frame.size.width / 2);
    } else {
        return 0;
    }
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    
    if(self.pictures.count != 0) cell.imageView.image = (UIImage*)self.pictures[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.showsReorderControl = false;
    
    return cell;
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self removePhotoAtIndex:[indexPath row]];
}



-(void)buttonTouched:(id)sender forEvent:(UIEvent *)event {
    
    [self showAlertControllerAt:sender];
}



-(void)showAlertControllerAt:(id)sender {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil
                                                                             message: nil
                                                                      preferredStyle: UIAlertControllerStyleActionSheet];
    
    [alertController addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"Take Photo", nil) style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self showCameraAt:sender];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"Choose Existing Photo", nil) style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self showImagePickerAt:sender];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:alertController];
        [pop presentPopoverFromBarButtonItem:(UIBarButtonItem*)sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        [self presentViewController:alertController animated:YES completion:nil];
    }
}



-(void)showCameraAt:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera] containsObject:(id)kUTTypeImage]) {
            picker.mediaTypes = [[NSArray alloc] initWithObjects:(id)kUTTypeImage, nil];
        }
        picker.allowsEditing = NO;
        picker.delegate = self;

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:picker];
            [pop presentPopoverFromBarButtonItem:(UIBarButtonItem*)sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        } else {
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}



-(void)showImagePickerAt:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(id)kUTTypeImage]) {
            picker.mediaTypes = [[NSArray alloc] initWithObjects:(id)kUTTypeImage, nil];
        }
        picker.allowsEditing = NO;
        picker.delegate = self;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:picker];
            [pop presentPopoverFromBarButtonItem:(UIBarButtonItem*)sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        } else {
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}



-(void)storePhoto:(UIImage*)editedImage original:(UIImage*)originalImage {
    
    originalImage = [self fixRotation:originalImage];
    UIImage* reducedImage = [self reduceSizeOfImage:editedImage];
    
    
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSInteger imgNo = 1;
    
    NSURL* writeURLReduced = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld",self.pathComponent,(long)self.currentTag,(long)imgNo]];
    
    while ([fm fileExistsAtPath:[writeURLReduced path]]) {
        imgNo++;
        writeURLReduced = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld",self.pathComponent,(long)self.currentTag,(long)imgNo]];
    }
    NSURL* writeURLOriginal = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld_orig",self.pathComponent,(long)self.currentTag,(long)imgNo]];
    
    NSData* dataOriginal = UIImagePNGRepresentation(originalImage);
    NSData* dataReduced = UIImageJPEGRepresentation(reducedImage, 0.9);
    
    [dataOriginal writeToURL:writeURLOriginal atomically:YES];
    [dataReduced writeToURL:writeURLReduced atomically:YES];
    
    if (imgNo > 1) {
        [self.sharedDefaults setBool:true forKey:[NSString stringWithFormat:@"%@%ld_hasMoreImages",self.pathComponent,(long)self.currentTag]];
    } else {
        [self.sharedDefaults setBool:false forKey:[NSString stringWithFormat:@"%@%ld_hasMoreImages",self.pathComponent,(long)self.currentTag]];
    }
    [self.sharedDefaults synchronize];
    
    [self.tableV reloadData];
}





-(void)removePhotoAtIndex:(NSInteger)index {
    
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSURL* deleteURLOriginal = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld_orig",self.pathComponent,(long)self.currentTag,(long)index+1]];
    NSURL* deleteURLReduced = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld",self.pathComponent,(long)self.currentTag,(long)index+1]];
    
    if ([fm fileExistsAtPath:[deleteURLOriginal path]]) {
        [fm removeItemAtURL:deleteURLOriginal error:nil];
    }
    if ([fm fileExistsAtPath:[deleteURLReduced path]]) {
        [fm removeItemAtURL:deleteURLReduced error:nil];
    }
    
    NSInteger imgNo = 1;
    NSURL* dataURL = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld",self.pathComponent,(long)self.currentTag,(long)imgNo]];
    while ([fm fileExistsAtPath:[dataURL path]]) {
        imgNo++;
        dataURL = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld",self.pathComponent,(long)self.currentTag,(long)imgNo]];
    }
    NSInteger missingIndex = imgNo;
    if (imgNo < self.pictures.count) {
        imgNo++;
        dataURL = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld",self.pathComponent,(long)self.currentTag,(long)imgNo]];
        while ([fm fileExistsAtPath:[dataURL path]]) {
            imgNo++;
            dataURL = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld",self.pathComponent,(long)self.currentTag,(long)imgNo]];
        }
        imgNo--;
        dataURL = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld",self.pathComponent,(long)self.currentTag,(long)imgNo]];
        NSURL* dataURLOrig = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld_orig",self.pathComponent,(long)self.currentTag,(long)imgNo]];
        NSString *newPath = [[[dataURL path] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld",self.pathComponent,(long)self.currentTag,(long)missingIndex]];
        NSString *newPathOrig = [[[dataURLOrig path] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld_orig",self.pathComponent,(long)self.currentTag,(long)missingIndex]];
        [fm moveItemAtPath:[dataURL path] toPath:newPath error:nil];
        [fm moveItemAtPath:[dataURLOrig path] toPath:newPathOrig error:nil];
    }
    
    imgNo = 1;
    dataURL = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld",self.pathComponent,(long)self.currentTag,(long)imgNo]];
    while ([fm fileExistsAtPath:[dataURL path]]) {
        imgNo++;
        dataURL = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld",self.pathComponent,(long)self.currentTag,(long)imgNo]];
    }
    imgNo--;
    if (imgNo > 1) {
        [self.sharedDefaults setBool:true forKey:[NSString stringWithFormat:@"%@%ld_hasMoreImages",self.pathComponent,(long)self.currentTag]];
    } else {
        [self.sharedDefaults setBool:false forKey:[NSString stringWithFormat:@"%@%ld_hasMoreImages",self.pathComponent,(long)self.currentTag]];
    }
    [self.sharedDefaults synchronize];
    
    [self viewWillAppear:true];
    [self.tableV reloadData];
}



-(UIImage*)reduceSizeOfImage:(UIImage*)origImage {
    
    CGSize destinationSize = self.sizeOfReducedImage;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        destinationSize = CGSizeMake(destinationSize.width / 2, destinationSize.height / 2);
    }
    UIGraphicsBeginImageContext(destinationSize);
    [origImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage* reducedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reducedImage;
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
