//
//  PaginatedPickerVC.m
//  SCDatePickerViewDemo
//
//  Created by Schubert Cardozo on 06/08/14.
//  Copyright (c) 2014 Schubert. All rights reserved.
//

#import "PaginatedPickerVC.h"

@interface PaginatedPickerVC ()

@end

@implementation PaginatedPickerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SCDatePickerView *datePickerView = [[SCDatePickerView alloc] initWithFrame:self.view.bounds style:SCDatePickerViewStylePaginated];
    datePickerView.delegate = self;
    datePickerView.endDate = [NSDate dateWithTimeInterval:((24 * 60 * 60) * 365) sinceDate:[NSDate date]];
    datePickerView.selectedDate = [NSDate date];
    
    // -- Pre selected dates
    NSDateComponents *comp = [NSDateComponents new];
    comp.month = 1;
    NSDate *preSelectedDate = [[NSCalendar currentCalendar]  dateByAddingComponents:comp toDate:[NSDate date] options:0];
    datePickerView.selectedDate = preSelectedDate;
    [[[self.view subviews] objectAtIndex:0] addSubview:datePickerView];
    // Do any additional setup after loading the view.
}

- (UIImage *)previousMonthImageForDatePickerView:(SCDatePickerView *)datePickerView
{
    return [UIImage imageNamed:@"glyph-left-arrow.png"];
}

- (UIImage *)nextMonthImageForDatePickerView:(SCDatePickerView *)datePickerView
{
    return [UIImage imageNamed:@"glyph-right-arrow.png"];
}

- (CGFloat)heightForMonthHeaderInDatePickerView:(SCDatePickerView *)datePickerView
{
    return 50.0f;
}



@end
