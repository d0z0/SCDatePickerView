//
//  ViewController.m
//  SCDatePickerViewDemo
//
//  Created by Schubert Cardozo on 18/07/14.
//  Copyright (c) 2014 Schubert. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // -- Date range which the selection must be restricted to
    self.datePickerView.startDate = [NSDate date];
    self.datePickerView.endDate = [NSDate dateWithTimeInterval:((24 * 60 * 60) * 152) sinceDate:[NSDate date]];


    // -- Continous calendar (show all months, scrolling vertically)
    // self.datePickerView.continousCalendar = NO;

    // -- Current month offset from startDate (only applies if continousCalendar is NO)
    // self.datePickerView.currentMonthOffset = 0;

    // -- Allows a range of dates to be selected (only works accross months if continousCalendar is YES)
    self.datePickerView.rangeSelection = YES;

    // Do any additional setup after loading the view.
    // -- Pre selected dates
    NSDateComponents *comp = [NSDateComponents new];
    comp.month = 1;
    NSDate *preSelectedDate = [[NSCalendar currentCalendar]  dateByAddingComponents:comp toDate:[NSDate date] options:0];
    [self.datePickerView selectDate:preSelectedDate];
}

- (CGFloat)heightForMonthHeaderInDatePickerView:(SCDatePickerView *)datePickerView
{
    return 30.0f;
}

- (UIImage *)previousMonthImageForDatePickerView:(SCDatePickerView *)datePickerView
{
    return [UIImage imageNamed:@"glyph-left-arrow.png"];
}

- (UIImage *)nextMonthImageForDatePickerView:(SCDatePickerView *)datePickerView
{
    return [UIImage imageNamed:@"glyph-right-arrow.png"];
}

- (void)datePickerView:(SCDatePickerView *)datePickerView didSelectDate:(NSDate *)date
{
    NSLog(@"Date selected: %@", date);
}

- (void)datePickerView:(SCDatePickerView *)datePickerView didSelectDateRangeFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    NSLog(@"Date range selected: %@ - %@", fromDate, toDate);
}

- (UIView *)datePickerView:(SCDatePickerView *)datePickerView todayBackgroundViewForDate:(NSDate *)date
{
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
