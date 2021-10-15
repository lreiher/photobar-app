//
//  CustomActivityItems.m
//  Gravitational
//
//  Created by Lennart Reiher on 02.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "CustomActivityItems.h"
#import "iRate.h"

@implementation CustomActivityItems

- (id) activityViewController:(UIActivityViewController *)activityViewController
          itemForActivityType:(NSString *)activityType
{
    NSString* message = NSLocalizedString(@"Check out the PhotoBar widget on the AppStore!", nil);
    NSString* link = @"https://itunes.apple.com/app/id";
    NSUInteger appid = ([iRate sharedInstance].appStoreID != 0) ? [iRate sharedInstance].appStoreID : 925100931;
    return [NSString stringWithFormat:@"%@\n%@%ld",message,link,(long)appid];
}

- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

@end