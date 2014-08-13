//
//  SCDatePickerViewCell.m
//  SCDatePicker
//
//  Created by Schubert Cardozo on 19/06/14.
//  Copyright (c) 2014 Schubert Cardozo. All rights reserved.
//

#import "SCDatePickerViewCell.h"

@interface SCDatePickerViewCell ()

@property (nonatomic, strong, readwrite) UILabel *dateLabel;

@end

@implementation SCDatePickerViewCell

@synthesize todayBackgroundView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        // Initialization code
        self.dateLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.dateLabel];

        // today background
        self.todayBackgroundView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        self.todayBackgroundView.hidden = YES;
        self.todayBackgroundView.layer.borderColor = [UIColor blackColor].CGColor;
        self.todayBackgroundView.layer.borderWidth = 1.0f;
        self.todayBackgroundView.layer.cornerRadius = self.contentView.frame.size.width/2;
        [self.contentView addSubview:self.todayBackgroundView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, frame.size.height-0.5f, frame.size.width, 0.5f)];
        lineView.backgroundColor = [UIColor blackColor];
        lineView.alpha = 0.25f;
        [self.contentView addSubview:lineView];
        
        [self.contentView sendSubviewToBack:self.todayBackgroundView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.dateLabel.text = nil;
    self.todayBackgroundView.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
