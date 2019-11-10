//
//  TodayViewControllerLayoutCustom3.m
//  PhotoBar
//
//  Created by Lennart Reiher on 19.02.15.
//  Copyright (c) 2015 Lennart Reiher. All rights reserved.
//

#import "TodayViewControllerLayoutCustom3.h"
#import "UIView+AutoLayout.h"
#import <Photos/Photos.h>

@interface TodayViewControllerLayoutCustom3 ()

@property CGFloat imgRatio;
@property NSInteger imgCount;

@end

@implementation TodayViewControllerLayoutCustom3

-(void)viewDidLoad {
    
    self.sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lennart.reiher.PhotoBar"];
    
    self.imgRatio = [self.sharedDefaults floatForKey:@"layoutC_ratio"];
    self.imgCount = [self.sharedDefaults integerForKey:@"layoutC_count"];
    
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, [self getPreferredHeight])];
    
    [self setupSubviews];
    
    [self.view layoutIfNeeded];
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self setPreferredContentSize:CGSizeMake(0, [self getPreferredHeight])];
}


-(void)setupSubviews {
    
    UIView* distanceHolder = [[UIView newAutoLayoutView] initForAutoLayout];
    [self.view addSubview:distanceHolder];
    
    UIView* distanceHolder2 = [[UIView newAutoLayoutView] initForAutoLayout];
    [self.view addSubview:distanceHolder2];
    
    [distanceHolder autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:distanceHolder.superview];
    [distanceHolder autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:distanceHolder.superview];
    [distanceHolder autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:distanceHolder.superview];
    
    [distanceHolder2 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:distanceHolder2.superview];
    [distanceHolder2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:distanceHolder2.superview];
    [distanceHolder2 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:distanceHolder2.superview];
    
    distanceHolder.backgroundColor = [UIColor grayColor];
    distanceHolder2.backgroundColor = [UIColor orangeColor];
    distanceHolder.alpha = 0.0;
    distanceHolder2.alpha = 0.0;
    
    [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{[distanceHolder autoSetDimension:ALDimensionWidth toSize:0.0];}];
    [distanceHolder2 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:distanceHolder];
    [distanceHolder2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:distanceHolder];
    
    if ([self.sharedDefaults boolForKey:@"layoutC_isHorizontal"]) {
        
        [distanceHolder autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:[self createNextViewPinningHorizontally:distanceHolder2 :self.imgCount]];
    } else {
        
        UIImageView* imageView = [[UIImageView newAutoLayoutView] initForAutoLayout];
        [self.view addSubview:imageView];
        imageView.backgroundColor = [UIColor clearColor];
        UIImageView* nextView = (UIImageView*)[self createNextViewPinningVertically:distanceHolder :distanceHolder2 :self.imgCount-1];
        
        [imageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:imageView.superview];
        [imageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:distanceHolder];
        [imageView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:distanceHolder2];
        [imageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:nextView];
        
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{[imageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:imageView withMultiplier:self.imgRatio];}];
        [imageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:nextView];
        [imageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:nextView];
    }
}

-(UIView*)createNextViewPinningHorizontally:(UIView*)distanceHolder2 :(NSInteger)pImgCount {
    
    UIImageView* imageView;
    
    imageView = [[UIImageView newAutoLayoutView] initForAutoLayout];
    [self.view addSubview:imageView];
    
    imageView.backgroundColor = [UIColor clearColor];
    
    [imageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:imageView.superview];
    [imageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:imageView.superview];
    
    if (pImgCount > 1) {
        UIImageView* nextView = (UIImageView*)[self createNextViewPinningHorizontally:distanceHolder2 :pImgCount-1];
        [imageView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:nextView];
        [imageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:nextView];
        [imageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:nextView];
    } else {
        CGFloat imgRatio = [self.sharedDefaults floatForKey:@"layoutC_ratio"];
        [imageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:imageView withMultiplier:imgRatio];
        [imageView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:distanceHolder2];
    }
    return imageView;
}

-(UIView*)createNextViewPinningVertically:(UIView*)distanceHolder1 :(UIView*)distanceHolder2 :(NSInteger)pImgCount {
    
    UIImageView* imageView;
    
    if (pImgCount > 0) {
        imageView = [[UIImageView newAutoLayoutView] initForAutoLayout];
        [self.view addSubview:imageView];
        
        imageView.backgroundColor = [UIColor clearColor];
        
        [imageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:distanceHolder1];
        [imageView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:distanceHolder2];
        
        if (pImgCount > 1) {
            UIImageView* nextView = (UIImageView*)[self createNextViewPinningVertically:distanceHolder1 :distanceHolder2 :pImgCount-1];
            [imageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:nextView];
            [imageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:nextView];
            [imageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:nextView];
        } else {
            [imageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:imageView.superview];
        }
        return imageView;
    } else {
        return nil;
    }
}



-(void)setDefaultKeys {
    
    self.defaultsKey = @"layoutC_needsUpdate";
}




-(void)loadImages {
    
    NSString* pathComponent = @"layoutC_image";
    
    for (int i = 2; i < self.view.subviews.count; i++) {
        
        ((UIImageView*)self.view.subviews[i]).clipsToBounds = YES;
    }
    
    if ([self.sharedDefaults boolForKey:[NSString stringWithFormat:@"%@_usingLastPhotos",pathComponent]]) {
        
        CGFloat scale = 1.5;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) scale = 1.0;
        [self loadPhotosFromCameraRollAtScale:scale];
    } else {
        
        NSFileManager* fm = [NSFileManager defaultManager];
        
        NSArray *files = [fm contentsOfDirectoryAtPath:self.storeURL.path error:nil];
        
        for (int i = 2; i < self.view.subviews.count; i++) {
            
            ((UIImageView*)self.view.subviews[i]).contentMode = UIViewContentModeScaleToFill;
            
            NSArray *filesWithSelectedPrefix = [files filteredArrayUsingPredicate:
                                                [NSPredicate predicateWithFormat:
                                                 [NSString stringWithFormat:@"self BEGINSWITH[cd] '%@%ld'",pathComponent,(long)(i-1)]]];
            
            NSInteger randomIndex = arc4random_uniform((u_int32_t)filesWithSelectedPrefix.count / 2) + 1;
            
            NSURL* url = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld_%ld",pathComponent,(long)(i-1),(long)randomIndex]];
            
            NSData* data = [NSData dataWithContentsOfURL:url];
            
            ((UIImageView*)self.view.subviews[i]).image = [UIImage imageWithData:data];
        }
    }
    
    [self setPreferredContentSize:CGSizeMake(0, [self getPreferredHeight])];
    
    [self resetUserDefaults];
}

-(void)loadPhotosFromCameraRollAtScale:(CGFloat)pScale {
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES],];
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.synchronous = YES;
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    for (int i = 0; i < self.view.subviews.count-2; i++) {
        if (fetchResult.count > i) {
            PHAsset* asset = [fetchResult objectAtIndex:fetchResult.count-i-1];
            UIView* target = self.view.subviews[self.view.subviews.count-i-1];
            CGSize tarSize = CGSizeMake(target.frame.size.width*pScale, target.frame.size.height*pScale);
            [[PHImageManager defaultManager] requestImageForAsset:asset
                                                       targetSize:tarSize
                                                      contentMode:PHImageContentModeAspectFill
                                                          options:requestOptions
                                                    resultHandler:^(UIImage *result, NSDictionary* info) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            target.contentMode = UIViewContentModeScaleAspectFill;
                                                            ((UIImageView*)target).image = result;
                                                            
                                                        });
                                                    }];
        }
    }
}

-(CGFloat)getPreferredHeight {
    
    if ([self.sharedDefaults boolForKey:@"layoutC_isHorizontal"]) return self.view.frame.size.width / self.imgCount / self.imgRatio;
    else return self.view.frame.size.width * self.imgCount / self.imgRatio;
}

@end