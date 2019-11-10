//
//  TutorialPageContentController.m
//  PhotoBar
//
//  Created by Lennart Reiher on 23.02.15.
//  Copyright (c) 2015 Lennart Reiher. All rights reserved.
//

#import "TutorialPageContentController.h"

@interface TutorialPageContentController ()

@end

@implementation TutorialPageContentController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.label.text = self.text;
    self.image.image = [UIImage imageNamed:self.imageFile];
}

@end
