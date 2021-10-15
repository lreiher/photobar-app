//
//  TodayViewControllerLayout1.h
//  PhotoBar
//
//  Created by Lennart Reiher on 19.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "TodayViewControllerLayoutAbstract.h"

@interface TodayViewControllerLayout2 : TodayViewControllerLayoutAbstract <TodayViewControllerLayoutProtocol>

@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;
@property (strong, nonatomic) IBOutlet UIImageView *imageView3;
@property (strong, nonatomic) IBOutlet UIImageView *imageView4;

@end
