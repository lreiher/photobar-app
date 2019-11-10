//
//  ViewControllerLayout3.h
//  PhotoBar
//
//  Created by Lennart Reiher on 21.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "ViewControllerLayoutAbstract.h"

@interface ViewControllerLayout5 : ViewControllerLayoutAbstract <ViewControllerLayoutProtocol>

@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *editButton1;
@property (strong, nonatomic) IBOutlet UIButton *editButton2;

@property (strong, nonatomic) IBOutlet UIView *placeholder1;
@property (strong, nonatomic) IBOutlet UIView *placeholder2;

@end
