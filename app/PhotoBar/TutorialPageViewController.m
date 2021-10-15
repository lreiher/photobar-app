//
//  TutorialPageViewController.m
//  PhotoBar
//
//  Created by Lennart Reiher on 23.02.15.
//  Copyright (c) 2015 Lennart Reiher. All rights reserved.
//

#import "TutorialPageViewController.h"

@interface TutorialPageViewController ()

@end

@implementation TutorialPageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.dataSource = self;
    
    [self setData];
    
    TutorialPageContentController* startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

-(void)setData {
    
    NSString* text1 = NSLocalizedString(@"With PhotoBar you can personalize your Today-View with your own photos.",nil);
    NSString* text2 = NSLocalizedString(@"You can choose from 9 predesigned Layouts or simply create up to 3 custom ones. All of them are waiting to be filled with your photos.",nil);
    NSString* text3 = NSLocalizedString(@"You will be able to both change height and number of photos of the custom layouts.",nil);
    NSString* text4 = NSLocalizedString(@"Adding your photos one by one is simple. Alternatively you can activate the switch and always use the last photos from your archive.",nil);
    NSString* text5 = NSLocalizedString(@"You can even put more photos in the exact same slot of the layout. Everytime you pull down the Today-View PhotoBar will then randomly choose one of the available photos for that slot.",nil);
    NSString* text6 = NSLocalizedString(@"Once you are ready to see your PhotoBar in action, simply tap 'Edit' in the Today-View and then add the layout you wish to display.",nil);
    NSString* text7 = NSLocalizedString(@"Have fun using PhotoBar!",nil);
    
    self.tutorialTexts = @[text1,text2,text3,text4,text5,text6,text7];
    self.tutorialImages = @[@"tutorialScreen1",@"tutorialScreen2",@"tutorialScreen3",@"tutorialScreen4",@"tutorialScreen5",@"tutorialScreen6",@"tutorialScreen7"];
    NSAssert(self.tutorialTexts.count == self.tutorialImages.count, @"texts.count =! images.count");
}


-(UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerBeforeViewController:(UIViewController*)viewController
{
    NSUInteger index = ((TutorialPageContentController*)viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

-(UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerAfterViewController:(UIViewController*)viewController
{
    NSUInteger index = ((TutorialPageContentController*)viewController).pageIndex;
    
    if ((index == self.tutorialTexts.count-1) || index == NSNotFound) {
        return nil;
    }
    
    index++;
    return [self viewControllerAtIndex:index];
}

-(TutorialPageContentController*)viewControllerAtIndex:(NSUInteger)index
{
    if ((self.tutorialTexts.count == 0) || (index >= self.tutorialTexts.count)) {
        return nil;
    }
    
    TutorialPageContentController* pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialPageContentController"];
    
    pageContentViewController.imageFile = self.tutorialImages[index];
    pageContentViewController.text = self.tutorialTexts[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.tutorialTexts count];
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
