//
//  TodayViewControllerLayoutAbstract.m
//  PhotoBar
//
//  Created by Lennart Reiher on 20.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "TodayViewControllerLayoutAbstract.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewControllerLayoutAbstract () <NCWidgetProviding>

@end

@implementation TodayViewControllerLayoutAbstract

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange) name:NSUserDefaultsDidChangeNotification object:nil];
    
    self.sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lennart.reiher.PhotoBar"];
    
    [self setDefaultKeys];
    
    self.storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.lennart.reiher.PhotoBar"];
    
    [self loadImages];
}

-(void)setDefaultKeys {
    
    [self doesNotRecognizeSelector:_cmd];
}

-(void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    if ([self.sharedDefaults boolForKey:self.defaultsKey]) {
        [self loadImages];
        completionHandler(NCUpdateResultNewData);
    } else {
        completionHandler(NCUpdateResultNoData);
    }
}

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    
    CGFloat marginTop = 0;
    CGFloat marginBottom = 0;
    CGFloat marginLeft = 0;
    CGFloat marginRight = 0;
    UIEdgeInsets newInsets = UIEdgeInsetsMake(marginTop, marginLeft, marginBottom, marginRight);
    
    return newInsets;
}

-(void)userDefaultsDidChange {
    
    if ([self.sharedDefaults boolForKey:self.defaultsKey]) {
        [self loadImages];
    }
}

-(void)resetUserDefaults {
    
    [self.sharedDefaults setBool:false forKey:self.defaultsKey];
    [self.sharedDefaults synchronize];
}

-(void)loadImages {
    
    [self doesNotRecognizeSelector:_cmd];
}

-(void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
