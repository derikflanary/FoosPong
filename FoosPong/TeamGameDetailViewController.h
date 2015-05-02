//
//  TeamGameDetailViewController.h
//  FoosPong
//
//  Created by Derik Flanary on 5/1/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "TeamGame.h"
#import "TeamGameDetails.h"

@interface TeamGameDetailViewController : UIViewController

@property (nonatomic, strong) Game *singleGame;
@property (nonatomic, strong) TeamGameDetails *teamGame;

@end
