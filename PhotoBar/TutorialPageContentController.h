//
//  TutorialPageContentController.h
//  PhotoBar
//
//  Created by Lennart Reiher on 23.02.15.
//  Copyright (c) 2015 Lennart Reiher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialPageContentController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@property NSUInteger pageIndex;
@property NSString *text;
@property NSString *imageFile;

@end
