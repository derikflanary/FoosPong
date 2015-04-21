//
//  SettingsVoiceTableViewCell.m
//  FoosPong
//
//  Created by Derik Flanary on 4/14/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "SettingsVoiceTableViewCell.h"

@interface SettingsVoiceTableViewCell()

@property (nonatomic, assign) BOOL microphoneOff;

@end

@implementation SettingsVoiceTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NewGameCell"];
    self.mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(250, 50, 50, 50)];
    self.mySwitch.onTintColor = [UIColor darkColor];
    [self.mySwitch addTarget:self action:@selector(switchSwitched:) forControlEvents:UIControlEventValueChanged];
    
    NSNumber *micOff = [[NSUserDefaults standardUserDefaults]objectForKey:@"micOff"];
    BOOL microphoneOff = micOff.boolValue;
    if (!microphoneOff) {
        self.mySwitch.on = NO;
    }else{
        self.mySwitch.on = YES;
    }
    self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 240, 150)];
    self.descriptionLabel.text = @"To use voice scoring say 'One Goal', or 'Two Goal' to add a point for either player or team.";
    self.descriptionLabel.font = [UIFont fontWithName:[NSString mainFont] size:15];
    self.descriptionLabel.numberOfLines = 0;
    
    [self.contentView addSubview:self.mySwitch];
    [self.contentView addSubview:self.descriptionLabel];
    
    self.backgroundColor = [UIColor mainWhite];
    
    self.mySwitch.translatesAutoresizingMaskIntoConstraints = NO;
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_mySwitch, _descriptionLabel);
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_descriptionLabel]-|" options:0 metrics:nil views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_descriptionLabel(>=250)]-(==16)-[_mySwitch(==50)]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    
    return self;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)switchSwitched:(id)sender{
    if (self.mySwitch.on) {
        self.microphoneOff = YES;
    }else{
        self.microphoneOff = NO;
    }
    NSNumber *micOff = [NSNumber numberWithBool:self.microphoneOff];
    [[NSUserDefaults standardUserDefaults] setObject:micOff forKey:@"micOff"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[self.tableView reloadData];
}


@end

