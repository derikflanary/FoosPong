//
//  GameViewController.h
//  FoosPong
//
//  Created by Derik Flanary on 2/9/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleGameViewController : UIViewController

@property (nonatomic, strong) NSString *playerOneName;
@property (nonatomic, strong) NSString *playerTwoName;
@property (nonatomic, strong) PFUser *playerOne;
@property (nonatomic, strong) PFUser *playerTwo;
@property (nonatomic, strong) PFObject *playerOneRanking;
@property (nonatomic, strong) PFObject *playerTwoRanking;

@end
