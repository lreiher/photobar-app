//
//  SelectionViewController.h
//  PhotoBar
//
//  Created by Lennart Reiher on 23.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SelectionViewController : UIViewController <UINavigationControllerDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *circle1;
@property (strong, nonatomic) IBOutlet UIView *circle2;
@property (strong, nonatomic) IBOutlet UIView *circle3;
@property (strong, nonatomic) IBOutlet UIView *circle4;
@property (strong, nonatomic) IBOutlet UIView *circle5;
@property (strong, nonatomic) IBOutlet UIView *circle6;
@property (strong, nonatomic) IBOutlet UIView *circle7;
@property (strong, nonatomic) IBOutlet UIView *circle8;
@property (strong, nonatomic) IBOutlet UIView *circle9;
@property (strong, nonatomic) IBOutlet UIView *circleA;
@property (strong, nonatomic) IBOutlet UIView *circleB;
@property (strong, nonatomic) IBOutlet UIView *circleC;

@end
