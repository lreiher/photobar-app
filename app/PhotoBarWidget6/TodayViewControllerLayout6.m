//
//  TodayViewControllerLayout6.m
//  PhotoBar
//
//  Created by Lennart Reiher on 22.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "TodayViewControllerLayout6.h"
#import <Photos/Photos.h>

@implementation TodayViewControllerLayout6

-(void)setDefaultKeys {
    
    self.defaultsKey = @"layout6_needsUpdate";
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self setPreferredContentSize:CGSizeMake(0, self.view.frame.size.width / 9 * 4)];
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode
                         withMaximumSize:(CGSize)maxSize {

    CGSize preferredSize = CGSizeMake(0, self.view.frame.size.width / 9 * 4);
    if ((activeDisplayMode == NCWidgetDisplayModeExpanded) || (preferredSize.height < maxSize.height)) {
        self.preferredContentSize = preferredSize;
    } else if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = maxSize;
    }
}

-(void)loadImages {
    
    NSString* pathComponent = @"layout6_image";
    
    self.imageView1.clipsToBounds = YES;
    self.imageView2.clipsToBounds = YES;
    self.imageView3.clipsToBounds = YES;
    
    if ([self.sharedDefaults boolForKey:[NSString stringWithFormat:@"%@_usingLastPhotos",pathComponent]]) {
        
        [self loadPhotosFromCameraRollAtScale:2];
    } else {
        
        [self loadPhotosFromDiskWithPathComponent:pathComponent];
    }
    
    [self setPreferredContentSize:CGSizeMake(0, self.view.frame.size.width / 9 * 4)];
    
    [self resetUserDefaults];
}

-(void)loadPhotosFromDiskWithPathComponent:(NSString*)pathComponent {
    
    self.imageView1.contentMode = UIViewContentModeScaleToFill;
    self.imageView2.contentMode = UIViewContentModeScaleToFill;
    self.imageView3.contentMode = UIViewContentModeScaleToFill;
    
    
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSArray *files = [fm contentsOfDirectoryAtPath:self.storeURL.path error:nil];
    
    NSArray *filesWithSelectedPrefix = [files filteredArrayUsingPredicate:
                                        [NSPredicate predicateWithFormat:
                                         [NSString stringWithFormat:@"self BEGINSWITH[cd] '%@1'",pathComponent]]];
    
    NSInteger randomIndex = arc4random_uniform((u_int32_t)filesWithSelectedPrefix.count / 2) + 1;
    
    NSURL* url = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@1_%ld",pathComponent,(long)randomIndex]];
    
    NSData* data = [NSData dataWithContentsOfURL:url];
    
    self.imageView1.image = [UIImage imageWithData:data];
    
    
    
    filesWithSelectedPrefix = [files filteredArrayUsingPredicate:
                               [NSPredicate predicateWithFormat:
                                [NSString stringWithFormat:@"self BEGINSWITH[cd] '%@2'",pathComponent]]];
    
    randomIndex = arc4random_uniform((u_int32_t)filesWithSelectedPrefix.count / 2) + 1;
    
    url = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@2_%ld",pathComponent,(long)randomIndex]];
    
    data = [NSData dataWithContentsOfURL:url];
    
    self.imageView2.image = [UIImage imageWithData:data];
    
    
    
    filesWithSelectedPrefix = [files filteredArrayUsingPredicate:
                               [NSPredicate predicateWithFormat:
                                [NSString stringWithFormat:@"self BEGINSWITH[cd] '%@3'",pathComponent]]];
    
    randomIndex = arc4random_uniform((u_int32_t)filesWithSelectedPrefix.count / 2) + 1;
    
    url = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@3_%ld",pathComponent,(long)randomIndex]];
    
    data = [NSData dataWithContentsOfURL:url];
    
    self.imageView3.image = [UIImage imageWithData:data];
}


-(void)loadPhotosFromCameraRollAtScale:(CGFloat)pScale {
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES],];
    PHImageRequestOptions* requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.synchronous = YES;
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    if (fetchResult.count > 0) {
        PHAsset* asset1 = [fetchResult lastObject];
        [[PHImageManager defaultManager] requestImageForAsset:asset1
                                                   targetSize:CGSizeMake(self.imageView3.frame.size.width*pScale,self.imageView3.frame.size.height*pScale)
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:requestOptions
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        self.imageView3.contentMode = UIViewContentModeScaleAspectFill;
                                                        self.imageView3.image = result;
                                                        
                                                    });
                                                }];
    }
    if (fetchResult.count > 1) {
        PHAsset* asset2 = [fetchResult objectAtIndex:fetchResult.count-2];
        [[PHImageManager defaultManager] requestImageForAsset:asset2
                                                   targetSize:CGSizeMake(self.imageView2.frame.size.width*pScale,self.imageView2.frame.size.height*pScale)
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:requestOptions
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        self.imageView2.contentMode = UIViewContentModeScaleAspectFill;
                                                        self.imageView2.image = result;
                                                        
                                                    });
                                                }];
    }
    if (fetchResult.count > 2) {
        PHAsset* asset3 = [fetchResult objectAtIndex:fetchResult.count-3];
        [[PHImageManager defaultManager] requestImageForAsset:asset3
                                                   targetSize:CGSizeMake(self.imageView1.frame.size.width*pScale,self.imageView1.frame.size.height*pScale)
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:requestOptions
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
                                                        self.imageView1.image = result;
                                                        
                                                    });
                                                }];
    }
}

@end
