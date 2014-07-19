//
//  SCDatePickerView.h
//  SCDatePickerView
//
//  Created by Schubert Cardozo on 08/07/14.
//  Copyright (c) 2014 Schubert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCDatePickerViewFlowLayout.h"
#import "SCDatePickerViewHeader.h"
#import "SCDatePickerViewCell.h"

@class SCDatePickerView;

@protocol SCDatePickerViewDelegate <NSObject>

@optional

- (CGFloat)heightForMonthHeaderInDatePickerView:(SCDatePickerView *)datePickerView;

- (UIView *)datePickerView:(SCDatePickerView *)datePickerView selectedBackgroundViewForDate:(NSDate *)date;
- (UIView *)datePickerView:(SCDatePickerView *)datePickerView todayBackgroundViewForDate:(NSDate *)date;

- (UIImage *)previousMonthImageForDatePickerView:(SCDatePickerView *)datePickerView;
- (UIImage *)nextMonthImageForDatePickerView:(SCDatePickerView *)datePickerView;

- (void)datePickerView:(SCDatePickerView *)datePickerView didSelectDate:(NSDate *)date;
- (void)datePickerView:(SCDatePickerView *)datePickerView didSelectDateRangeFrom:(NSDate *)fromDate to:(NSDate *)toDate;

@end

@interface SCDatePickerView : UIView<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet id<SCDatePickerViewDelegate> delegate;

// customization properties
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, readonly) NSDate *selectedDate;
@property (nonatomic, readonly) NSDate *selectedEndDate;
@property (nonatomic, assign) int currentMonthOffset;
@property (nonatomic, assign) BOOL continousCalendar;

// FIXME -- switch to use delegate methods
@property (nonatomic, strong) UIFont *headerFont;
@property (nonatomic, strong) UIFont *dayOfWeekFont;
@property (nonatomic, strong) UIFont *dateFont;
@property (nonatomic, strong) UIColor *dateColor;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *monthYearFormatter;


@property (nonatomic, assign) BOOL rangeSelection;

- (void)selectDate:(NSDate *)date;
- (void)selectDateRangeFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

@end