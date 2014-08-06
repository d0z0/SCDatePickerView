//
//  PickerVC.m
//  SCDatePickerViewDemo
//
//  Created by Schubert Cardozo on 06/08/14.
//  Copyright (c) 2014 Schubert. All rights reserved.
//

#import "PickerVC.h"

@interface PickerVC ()

@end

@implementation PickerVC

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
 // Get the new view controller using [segue destinationPickerVC].
 // Pass the selected object to the new view controller.
 }
 */

@end
