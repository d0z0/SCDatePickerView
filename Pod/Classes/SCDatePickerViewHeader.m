//
//  SCDatePickerViewHeader.m
//  SCDatePickerDemo
//
//  Created by Schubert Cardozo on 19/06/14.
//  Copyright (c) 2014 Schubert Cardozo. All rights reserved.
//

#import "SCDatePickerViewHeader.h"

@interface SCDatePickerViewHeader ()

@end

@implementation SCDatePickerViewHeader

@synthesize topLineView;
@synthesize bottomLineView;
@synthesize previousMonthBtn;
@synthesize nextMonthBtn;
@synthesize monthYearLabel;
@synthesize daysOfWeekView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        monthYearLabel = [[UILabel alloc] init];
        monthYearLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:monthYearLabel];
        
        previousMonthBtn = [[UIButton alloc] init];
        [previousMonthBtn setTitle:@"<" forState:UIControlStateNormal];
        [previousMonthBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [previousMonthBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        previousMonthBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:previousMonthBtn];

        nextMonthBtn = [[UIButton alloc] init];
        [nextMonthBtn setTitle:@">" forState:UIControlStateNormal];
        [nextMonthBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nextMonthBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        nextMonthBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:nextMonthBtn];

        daysOfWeekView = [[UIView alloc] init];
        for(int i = 0; i < 7; i ++)
        {
            UILabel *dayLabel = [[UILabel alloc] init];
            dayLabel.textAlignment = NSTextAlignmentCenter;
            [daysOfWeekView addSubview:dayLabel];
        }
        [self addSubview:daysOfWeekView];

        topLineView = [[UIView alloc] init];
        [topLineView setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:topLineView];
        
        bottomLineView = [[UIView alloc] init];
        [bottomLineView setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:bottomLineView];
        
        
    }
    return self;
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
