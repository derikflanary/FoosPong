//
//  FindGroupViewController.h
//  FoosPong
//
//  Created by Derik Flanary on 2/25/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FindGroupViewControllerDelegate;


@interface FindGroupViewController : UIViewController

@property (nonatomic, weak) id <FindGroupViewControllerDelegate> delegate;

@end

@protocol FindGroupViewControllerDelegate <NSObject>

-(void)groupSelected;

@end