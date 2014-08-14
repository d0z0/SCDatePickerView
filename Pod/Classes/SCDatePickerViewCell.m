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
@property (nonatomic, strong, readwrite) UIView *borderView;

@end

@implementation SCDatePickerViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        // Initialization code
        self.dateLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.dateLabel];

        self.borderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, frame.size.height-0.5f, frame.size.width, 0.5f)];
        self.borderView.backgroundColor = [UIColor blackColor];
        self.borderView.alpha = 0.25f;
        [self.contentView addSubview:self.borderView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.dateLabel.text = nil;
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
