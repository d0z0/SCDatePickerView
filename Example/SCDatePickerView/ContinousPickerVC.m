//
//  ContinousPickerVC.m
//  SCDatePickerViewDemo
//
//  Created by Schubert Cardozo on 18/07/14.
//  Copyright (c) 2014 Schubert. All rights reserved.
//

#import "ContinousPickerVC.h"

@interface ContinousPickerVC ()

@end

@implementation ContinousPickerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    SCDatePickerView *datePickerView = [[SCDatePickerView alloc] initWithFrame:self.view.bounds style:SCDatePickerViewStyleContinous];
    datePickerView.delegate = self;
    datePickerView.endDate = [NSDate dateWithTimeInterval:((24 * 60 * 60) * 365) sinceDate:[NSDate date]];
    
    // -- Pre selected date range
    datePickerView.selectedDate = [NSDate date];
    NSDateComponents *comp = [NSDateComponents new];
    comp.month = 1;
    NSDate *preSelectedDate = [[NSCalendar currentCalendar]  dateByAddingComponents:comp toDate:[NSDate date] options:0];
    datePickerView.selectedEndDate = preSelectedDate;
    [[[self.view subviews] objectAtIndex:0] addSubview:datePickerView];
}

- (void)datePickerView:(SCDatePickerView *)datePickerView didSelectDateRangeFrom:(NSDate *)fromDate to:(NSDate *)toDate {
    datePickerView.style = SCDatePickerViewStyleContinous;
}

- (void)datePickerView:(SCDatePickerView *)datePickerView didSelectDate:(NSDate *)date {
    datePickerView.style = SCDatePickerViewStyleContinousWithRangeSelection;
}

@end
