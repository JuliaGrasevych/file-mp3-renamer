//
//  AppDelegate.m
//  FileRenamer
//
//  Created by Yuliya Grasevych on 27.02.14.
//  Copyright (c) 2014 Yuliya Grasevych. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()
@property (nonatomic) MainViewController *mainVC;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.mainVC = [[MainViewController alloc] initWithNibName:NSStringFromClass([MainViewController class]) bundle:nil];
    self.mainVC.view.frame = ((NSView*)self.window.contentView).bounds;
    [self.window.contentView addSubview:self.mainVC.view];

}
@end
