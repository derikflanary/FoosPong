//
//  SettingsTableViewCell.m
//  FoosPong
//
//  Created by Derik Flanary on 3/24/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "SettingsSegmentedTableViewCell.h"

@interface SettingsSegmentedTableViewCell()

@property (nonatomic, assign) BOOL tenPointGames;

@end

@implementation SettingsSegmentedTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SettingsSegmentedCell"];
    self.textLabel.font = [UIFont fontWithName:@"Thonburi-Light" size:18];
    self.detailTextLabel.font = [UIFont boldSystemFontOfSize:11];

    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"5",@"10"]];
    self.segmentedControl.frame = CGRectMake(250, 11, 100, 31);
    [self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.tintColor = [UIColor darkColor];
    self.segmentedControl.selectedSegmentIndex = 1;
    UIFont *font = [UIFont boldSystemFontOfSize:18.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segmentedControl setTitleTextAttributes:attributes
                                         forState:UIControlStateNormal];
    [self.contentView addSubview:self.segmentedControl];

    self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 240, 100)];
    self.descriptionLabel.text = @"How many points per game to win. Changing this will affect all previous stats.";
    self.descriptionLabel.font = [UIFont fontWithName:[NSString mainFont] size:15];
    self.descriptionLabel.numberOfLines = 0;

    [self.contentView addSubview:self.descriptionLabel];
    
    self.backgroundColor = [UIColor mainWhite];
    
    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_segmentedControl, _descriptionLabel);
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_descriptionLabel]-|" options:0 metrics:nil views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_descriptionLabel(>=250)]-(==16)-[_segmentedControl(==50)]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    

    NSNumber *tenPointGame = [[NSUserDefaults standardUserDefaults]objectForKey:@"tenPointGamesOn"];
    self.tenPointGames = tenPointGame.boolValue;
    if (self.tenPointGames) {
        self.segmentedControl.selectedSegmentIndex = 1;
    }else{
        self.segmentedControl.selectedSegmentIndex = 0;
    }
    
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)segmentedControlValueChanged:(id)sender{
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        self.tenPointGames = YES;
    }else{
        self.tenPointGames = NO;
    }
    NSNumber *tenPointGamesOn = [NSNumber numberWithBool:self.tenPointGames];
    [[NSUserDefaults standardUserDefaults] setBool:self.tenPointGames forKey:@"tenPointGamesOn"];
//    [[NSUserDefaults standardUserDefaults] setObject:tenPointGamesOn forKey:@"tenPointGamesOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
