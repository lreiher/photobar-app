//
//  TodayViewControllerLayoutAbstract.h
//  PhotoBar
//
//  Created by Lennart Reiher on 20.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NotificationCenter/NotificationCenter.h>

@protocol TodayViewControllerLayoutProtocol <NSObject>

-(void)loadImages;
-(void)setDefaultKeys;

@end

@interface TodayViewControllerLayoutAbstract : UIViewController <NCWidgetProviding>

@property (nonatomic) NSUserDefaults* sharedDefaults;
@property (nonatomic) NSURL* storeURL;
@property (nonatomic) NSString* defaultsKey;

-(void)resetUserDefaults;
-(void)userDefaultsDidChange;

@end
