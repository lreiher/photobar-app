//
//  TodayViewControllerLayout9.m
//  PhotoBar
//
//  Created by Lennart Reiher on 02.10.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "TodayViewControllerLayout9.h"
#import <Photos/Photos.h>

@implementation TodayViewControllerLayout9

-(void)setDefaultKeys {
    
    self.defaultsKey = @"layout9_needsUpdate";
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self setPreferredContentSize:CGSizeMake(0, self.view.frame.size.width / 2)];
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode
                         withMaximumSize:(CGSize)maxSize {

    CGSize preferredSize = CGSizeMake(0, self.view.frame.size.width / 2);
    if ((activeDisplayMode == NCWidgetDisplayModeExpanded) || (preferredSize.height < maxSize.height)) {
        self.preferredContentSize = preferredSize;
    } else if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = maxSize;
    }
}

-(void)loadImages {
    
    NSString* pathComponent = @"layout9_image";
    
    self.imageView1.clipsToBounds = YES;
    self.imageView2.clipsToBounds = YES;
    self.imageView3.clipsToBounds = YES;
    self.imageView4.clipsToBounds = YES;
    self.imageView5.clipsToBounds = YES;
    
    if ([self.sharedDefaults boolForKey:[NSString stringWithFormat:@"%@_usingLastPhotos",pathComponent]]) {
        
        [self loadPhotosFromCameraRollAtScale:2];
    } else {
        
        [self loadPhotosFromDiskWithPathComponent:pathComponent];
    }
    
    [self setPreferredContentSize:CGSizeMake(0, self.view.frame.size.width / 2)];
    
    [self resetUserDefaults];
}

-(void)loadPhotosFromDiskWithPathComponent:(NSString*)pathComponent {
    
    self.imageView1.contentMode = UIViewContentModeScaleToFill;
    self.imageView2.contentMode = UIViewContentModeScaleToFill;
    self.imageView3.contentMode = UIViewContentModeScaleToFill;
    self.imageView4.contentMode = UIViewContentModeScaleToFill;
    self.imageView5.contentMode = UIViewContentModeScaleToFill;
    
    
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
    
    
    
    filesWithSelectedPrefix = [files filteredArrayUsingPredicate:
                               [NSPredicate predicateWithFormat:
                                [NSString stringWithFormat:@"self BEGINSWITH[cd] '%@4'",pathComponent]]];
    
    randomIndex = arc4random_uniform((u_int32_t)filesWithSelectedPrefix.count / 2) + 1;
    
    url = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@4_%ld",pathComponent,(long)randomIndex]];
    
    data = [NSData dataWithContentsOfURL:url];
    
    self.imageView4.image = [UIImage imageWithData:data];
    
    
    
    filesWithSelectedPrefix = [files filteredArrayUsingPredicate:
                               [NSPredicate predicateWithFormat:
                                [NSString stringWithFormat:@"self BEGINSWITH[cd] '%@5'",pathComponent]]];
    
    randomIndex = arc4random_uniform((u_int32_t)filesWithSelectedPrefix.count / 2) + 1;
    
    url = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@5_%ld",pathComponent,(long)randomIndex]];
    
    data = [NSData dataWithContentsOfURL:url];
    
    self.imageView5.image = [UIImage imageWithData:data];
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
                                                   targetSize:CGSizeMake(self.imageView5.frame.size.width*pScale,self.imageView5.frame.size.height*pScale)
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:requestOptions
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        self.imageView5.contentMode = UIViewContentModeScaleAspectFill;
                                                        self.imageView5.image = result;
                                                        
                                                    });
                                                }];
    }
    if (fetchResult.count > 1) {
        PHAsset* asset2 = [fetchResult objectAtIndex:fetchResult.count-2];
        [[PHImageManager defaultManager] requestImageForAsset:asset2
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
    if (fetchResult.count > 2) {
        PHAsset* asset3 = [fetchResult objectAtIndex:fetchResult.count-3];
        [[PHImageManager defaultManager] requestImageForAsset:asset3
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
    if (fetchResult.count > 3) {
        PHAsset* asset4 = [fetchResult objectAtIndex:fetchResult.count-4];
        [[PHImageManager defaultManager] requestImageForAsset:asset4
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
    if (fetchResult.count > 4) {
        PHAsset* asset5 = [fetchResult objectAtIndex:fetchResult.count-5];
        [[PHImageManager defaultManager] requestImageForAsset:asset5
                                                   targetSize:CGSizeMake(self.imageView4.frame.size.width*pScale,self.imageView4.frame.size.height*pScale)
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:requestOptions
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        self.imageView4.contentMode = UIViewContentModeScaleAspectFill;
                                                        self.imageView4.image = result;
                                                        
                                                    });
                                                }];
    }
}

@end
