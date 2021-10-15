//
//  ViewControllerLayout6.h
//  PhotoBar
//
//  Created by Lennart Reiher on 26.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "ViewControllerLayoutAbstract.h"

@interface ViewControllerLayout1 : ViewControllerLayoutAbstract <ViewControllerLayoutProtocol>

@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *editButton1;

@property (strong, nonatomic) IBOutlet UIView *placeholder1;

@end