//
//  SelectionViewController.m
//  PhotoBar
//
//  Created by Lennart Reiher on 23.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "SelectionViewController.h"
#import "OldStyleNavigationControllerAnimatedTransition.h"
#import "iRate.h"
#import "CustomActivityItems.h"
#import <sys/sysctl.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

@implementation SelectionViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    
    [self circlesSetNeedsLayout];
    
    [self circlesLayoutIfNeeded];
    
    [self circlesSetCornerRadius];
    
    [self circlesSetMasksToBounds:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    NSUserDefaults* stdDefaults = [NSUserDefaults standardUserDefaults];
    NSString* currentBundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString* previousBundleVersion = [stdDefaults objectForKey:@"PreviousBundleVersion"];
    
    if (![currentBundleVersion isEqualToString:previousBundleVersion] ) {
        
        if ([currentBundleVersion isEqualToString:@"2.0"]) {
            
            [self performSegueWithIdentifier:@"segueToTutorial" sender:nil];
            [stdDefaults setObject:currentBundleVersion forKey:@"PreviousBundleVersion"];
            [stdDefaults synchronize];
            
        } else if ([currentBundleVersion isEqualToString:@"2.1"] && ![previousBundleVersion isEqualToString:@"2.0"]) {
            
            [self shouldUpdatePhotoPathsTo2_0:YES overwriting:YES];
            
            [self performSegueWithIdentifier:@"segueToTutorial" sender:nil];
            [stdDefaults setObject:currentBundleVersion forKey:@"PreviousBundleVersion"];
            [stdDefaults synchronize];
            
        } else if ([currentBundleVersion isEqualToString:@"2.1"] && [previousBundleVersion isEqualToString:@"2.0"]) {
            
            [stdDefaults setObject:currentBundleVersion forKey:@"PreviousBundleVersion"];
            [stdDefaults synchronize];
            
            NSString* title = NSLocalizedString(@"Restore old photos?", nil);
            NSString* message = NSLocalizedString(@"As you may have noticed, PhotoBar 2.0 ignored all photos you had added using a previous version. You now have the ability to either restore those photos from PhotoBar 1.x and override the new ones or only restore those where new ones are not set yet.", nil);
            
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle: title
                                                                                     message: message
                                                                              preferredStyle: UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Restore without overwriting", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action){
                
                [self shouldUpdatePhotoPathsTo2_0:YES overwriting:NO];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Restore and overwrite", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action){
                
                [self shouldUpdatePhotoPathsTo2_0:YES overwriting:YES];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Do not restore", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action){
                
                [self shouldUpdatePhotoPathsTo2_0:NO overwriting:NO];
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    } else {
        
        [self checkPermissions];
    }
}

-(void)shouldUpdatePhotoPathsTo2_0:(BOOL)shouldUpdate overwriting:(BOOL)shouldOverwrite {
    
    NSLog(@"updatePaths: %d // overwrite: %d", shouldUpdate, shouldOverwrite);
    
    NSURL* storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.lennart.reiher.PhotoBar"];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSArray* files = [fm contentsOfDirectoryAtPath:storeURL.path error:nil];
    
    for (int i = 1; i <= 9; i++) {
        
        NSArray *filesWithSelectedPrefix = [files filteredArrayUsingPredicate:
                                            [NSPredicate predicateWithFormat:
                                             [NSString stringWithFormat:@"self BEGINSWITH[cd] '%@%d_%@'",@"layout",i,@"image"]]];
        
        for (int i = 0; i < filesWithSelectedPrefix.count; i++) {
            
            NSString* fileName = filesWithSelectedPrefix[i];
            
            NSLog(@"%@",fileName);
            
            NSInteger occurencesOf_ = [fileName componentsSeparatedByString:@"_"].count - 1;
            BOOL hasSuffixOrig = [fileName hasSuffix:@"orig"];
            
            NSURL* oldURL;
            NSURL* newURL;
            
            if (hasSuffixOrig && occurencesOf_ == 2) {
                
                oldURL = [storeURL URLByAppendingPathComponent:fileName];
                fileName = [fileName stringByReplacingOccurrencesOfString:@"_orig" withString:@""];
                newURL = [storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@_1_orig",fileName]];
                
            } else if (!hasSuffixOrig && occurencesOf_ == 1) {
                
                oldURL = [storeURL URLByAppendingPathComponent:fileName];
                newURL = [storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@_1",fileName]];
            }
            
            if (shouldUpdate) {
                
                if ([fm fileExistsAtPath:oldURL.path] && [fm fileExistsAtPath:newURL.path] && shouldOverwrite) {
                    
                    [fm removeItemAtPath:newURL.path error:nil];
                    NSLog(@"removed %@",newURL);
                }
                
                if ([fm fileExistsAtPath:oldURL.path] && ![fm fileExistsAtPath:newURL.path]) {
                    
                    [fm moveItemAtPath:oldURL.path toPath:newURL.path error:nil];
                    NSLog(@"has moved %@ to %@",oldURL,newURL);
                    
                } else if ([fm fileExistsAtPath:oldURL.path]) {
                    
                    [fm removeItemAtPath:oldURL.path error:nil];
                    NSLog(@"removed %@",oldURL);
                }
            } else {
                
                if ([fm fileExistsAtPath:oldURL.path]) {
                    
                    [fm removeItemAtPath:oldURL.path error:nil];
                    NSLog(@"removed %@",oldURL);
                }
            }
        }
    }
}



-(void)circlesSetNeedsLayout {
    
    [self.circle1 setNeedsLayout];
    [self.circle2 setNeedsLayout];
    [self.circle3 setNeedsLayout];
    [self.circle4 setNeedsLayout];
    [self.circle5 setNeedsLayout];
    [self.circle6 setNeedsLayout];
    [self.circle7 setNeedsLayout];
    [self.circle8 setNeedsLayout];
    [self.circle9 setNeedsLayout];
    [self.circleA setNeedsLayout];
    [self.circleB setNeedsLayout];
    [self.circleC setNeedsLayout];
}



-(void)circlesLayoutIfNeeded {
    
    [self.circle1 layoutIfNeeded];
    [self.circle2 layoutIfNeeded];
    [self.circle3 layoutIfNeeded];
    [self.circle4 layoutIfNeeded];
    [self.circle5 layoutIfNeeded];
    [self.circle6 layoutIfNeeded];
    [self.circle7 layoutIfNeeded];
    [self.circle8 layoutIfNeeded];
    [self.circle9 layoutIfNeeded];
    [self.circleA layoutIfNeeded];
    [self.circleB layoutIfNeeded];
    [self.circleC layoutIfNeeded];
}



-(void)circlesSetCornerRadius {
    
    self.circle1.layer.cornerRadius = self.circle1.frame.size.width / 2;
    self.circle2.layer.cornerRadius = self.circle2.frame.size.width / 2;
    self.circle3.layer.cornerRadius = self.circle3.frame.size.width / 2;
    self.circle4.layer.cornerRadius = self.circle4.frame.size.width / 2;
    self.circle5.layer.cornerRadius = self.circle5.frame.size.width / 2;
    self.circle6.layer.cornerRadius = self.circle6.frame.size.width / 2;
    self.circle7.layer.cornerRadius = self.circle7.frame.size.width / 2;
    self.circle8.layer.cornerRadius = self.circle8.frame.size.width / 2;
    self.circle9.layer.cornerRadius = self.circle9.frame.size.width / 2;
    self.circleA.layer.cornerRadius = self.circleA.frame.size.width / 5;
    self.circleB.layer.cornerRadius = self.circleB.frame.size.width / 5;
    self.circleC.layer.cornerRadius = self.circleC.frame.size.width / 5;
}



-(void)circlesSetMasksToBounds:(BOOL)b {
    
    self.circle1.layer.masksToBounds = b;
    self.circle2.layer.masksToBounds = b;
    self.circle3.layer.masksToBounds = b;
    self.circle4.layer.masksToBounds = b;
    self.circle5.layer.masksToBounds = b;
    self.circle6.layer.masksToBounds = b;
    self.circle7.layer.masksToBounds = b;
    self.circle8.layer.masksToBounds = b;
    self.circle9.layer.masksToBounds = b;
    self.circleA.layer.masksToBounds = b;
    self.circleB.layer.masksToBounds = b;
    self.circleC.layer.masksToBounds = b;
}



-(void)checkPermissions {
    
    PHAuthorizationStatus authStatusCameraRoll = [PHPhotoLibrary authorizationStatus];
    AVAuthorizationStatus authStatusCamera = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatusCamera == PHAuthorizationStatusNotDetermined && authStatusCameraRoll == AVAuthorizationStatusNotDetermined) {
        
        NSString* title = NSLocalizedString(@"Permission", nil);
        NSString* message = NSLocalizedString(@"In order to fill these beautiful widgets with your own photos, you need to grant access to your photo library and the camera itself.", nil);
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: title
                                                                                 message: message
                                                                          preferredStyle: UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Continue", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){
            [PHPhotoLibrary requestAuthorization:nil];
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:nil];}]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}



-(id<UIViewControllerAnimatedTransitioning>)navigationController:
(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    OldStyleNavigationControllerAnimatedTransition * animation = [[OldStyleNavigationControllerAnimatedTransition alloc] init];
    animation.operation = operation;
    return animation;
}


- (IBAction)infoButtonTouched:(id)sender {
    
    NSString* version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString* year = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString* title = [NSString stringWithFormat:@"PhotoBar %@",version];
    NSString* message = [NSString stringWithFormat:@"\u00A9 %@ Lennart Reiher \n www.gravitational-app.com/photobar",year];
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle: title
                                                                             message: message
                                                                      preferredStyle: UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Gravitational – my iOS-game" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action) {
        NSString* linkToGravitational = @"https://itunes.apple.com/de/app/gravitational/id911742107?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkToGravitational]];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Contact", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
        [self sendMail];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Share", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
        [self showShareViewController];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Rate PhotoBar", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
        [[iRate sharedInstance] openRatingsPageInAppStore];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", nil) style:UIAlertActionStyleCancel handler:nil]];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}



#pragma mark Share View Controller

-(void)showShareViewController {
//    CustomActivityItems* customItems = [[CustomActivityItems alloc] init];
//
//    UIActivityViewController* share = [[UIActivityViewController alloc] initWithActivityItems:@[customItems] applicationActivities:nil];
//
//    share.excludedActivityTypes = @[UIActivityTypeAirDrop,UIActivityTypePostToWeibo,UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
//
//    [self presentViewController:share animated:YES completion:nil];
}



#pragma mark Send Mail
     
-(void)sendMail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                    message:NSLocalizedString(@"I would really like any kind of feedback from you! Do not hesitate to contact me in order to report bugs, give me suggestions on improving PhotoBar or just say 'hi'!",nil)
                                                    delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [alert show];
         
    [self showMailInterface];
}
     
-(void)showMailInterface {
         
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    NSString* appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString* iOSversion = [[UIDevice currentDevice] systemVersion];
    NSString* modelRaw = [self platformRawString];
    NSString* model = [NSString stringWithFormat:@"(%@)",[self platformNiceString]];
    NSString* message = [NSString stringWithFormat:@"\n\n______________\nPhotoBar %@\niOS %@\n%@ %@",appVersion,iOSversion,modelRaw,model];
    [mc setSubject:NSLocalizedString(@"Contact Inquiry PhotoBar", nil)];
    [mc setMessageBody:message isHTML:NO];
    [mc setToRecipients:[NSArray arrayWithObject:@"contact@gravitational-app.com"]];
    
    [self presentViewController:mc animated:YES completion:NULL];
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:{
            NSLog(@"Mail cancelled");
            break;}
        case MFMailComposeResultSaved:{
            NSLog(@"Mail saved");
            break;}
        case MFMailComposeResultSent:{
            NSLog(@"Mail sent");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Mail sent", nil)
                                                            message:NSLocalizedString(@"Thank you for contacting me.", nil)
                                                            delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [alert show];
            break;}
        case MFMailComposeResultFailed:{
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                            message:NSLocalizedString(@"Your mail did not send properly.",nil)
                                                            delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [alert show];
            break;}
        default:{
            break;}
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(NSString*)platformRawString {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char* machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString* platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

-(NSString*)platformNiceString {
    NSString* platform = [self platformRawString];
    if ([platform isEqualToString:@"iPhone1,1"])         return @"iPhone 1st Gen";
    else if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    else if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    else if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 CDMA";
    else if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    else if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    else if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    else if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    else if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    else if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    else if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6+";
    else if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    else if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1st Gen";
    else if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2nd Gen";
    else if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3rd Gen";
    else if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4th Gen";
    else if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5th Gen";
    else if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1";
    else if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2";
    else if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    else if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    else if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2";
    else if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3rd Gen";
    else if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3rd Gen";
    else if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3rd Gen";
    else if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4th Gen";
    else if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4th Gen";
    else if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4th Gen";
    else if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air";
    else if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air";
    else if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    else if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    else if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    else if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini";
    else if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2nd Gen";
    else if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2nd Gen";
    else if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    else if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    else if ([platform isEqualToString:@"i386"])         return @"Simulator";
    else if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    else return @"-";
}

@end
