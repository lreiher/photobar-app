//
//  HeaderViewController.h
//  PhotoBar
//
//  Created by Lennart Reiher on 28.11.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISwitch *hSwitch;
@property (strong, nonatomic) IBOutlet UILabel *label;

-(void)activateHeightMode;
-(void)activateImgNoMode;
-(void)activateSwitchMode;

@end
