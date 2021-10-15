//
//  TutorialPageViewController.h
//  PhotoBar
//
//  Created by Lennart Reiher on 23.02.15.
//  Copyright (c) 2015 Lennart Reiher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutorialPageContentController.h"

@interface TutorialPageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) NSArray *tutorialTexts;
@property (strong, nonatomic) NSArray *tutorialImages;

@end
