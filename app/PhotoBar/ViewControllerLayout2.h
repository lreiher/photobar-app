//
//  ViewControllerLayout1.h
//  PhotoBar
//
//  Created by Lennart Reiher on 19.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerLayoutAbstract.h"

@interface ViewControllerLayout2 : ViewControllerLayoutAbstract <ViewControllerLayoutProtocol>

@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;
@property (strong, nonatomic) IBOutlet UIButton *button4;
@property (strong, nonatomic) IBOutlet UIButton *editButton1;
@property (strong, nonatomic) IBOutlet UIButton *editButton2;
@property (strong, nonatomic) IBOutlet UIButton *editButton3;
@property (strong, nonatomic) IBOutlet UIButton *editButton4;

@property (strong, nonatomic) IBOutlet UIView *placeholder1;
@property (strong, nonatomic) IBOutlet UIView *placeholder2;
@property (strong, nonatomic) IBOutlet UIView *placeholder3;
@property (strong, nonatomic) IBOutlet UIView *placeholder4;

@end
