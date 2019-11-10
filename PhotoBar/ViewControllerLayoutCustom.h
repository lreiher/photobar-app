//
//  ViewControllerLayoutCustom.h
//  PhotoBar
//
//  Created by Lennart Reiher on 23.11.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerLayoutAbstract.h"

@interface ViewControllerLayoutCustom : ViewControllerLayoutAbstract

@property (strong, nonatomic) IBOutlet UISlider *heightSlider;
@property (strong, nonatomic) IBOutlet UISlider *imageNoSlider;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UIView *prevContainer;
@property (strong, nonatomic) IBOutlet UIView *prevBContainer;
@property (strong, nonatomic) IBOutlet UIView *imgContainer;

-(void)resetLayout;
-(NSString*)getPathComponent;

@end
