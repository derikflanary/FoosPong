//
//  GameDetailViewController.h
//  FoosPong
//
//  Created by Derik Flanary on 3/21/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "TeamGame.h"

@interface GameDetailViewController : UIViewController

@property (nonatomic, strong) Game *singleGame;
@property (nonatomic, strong) TeamGame *teamGame;

@end
