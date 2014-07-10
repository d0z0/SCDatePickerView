//
//  SCDatePickerViewHeader.h
//  SCDatePickerDemo
//
//  Created by Schubert Cardozo on 19/06/14.
//  Copyright (c) 2014 Schubert Cardozo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCDatePickerViewHeader : UICollectionReusableView

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) UILabel *monthYearLabel;
@property (nonatomic, strong) UIButton *previousMonthBtn;
@property (nonatomic, strong) UIButton *nextMonthBtn;
@property (nonatomic, strong) UIImageView *previousMonthImage;
@property (nonatomic, strong) UIImageView *nextMonthImage;
@property (nonatomic, strong) UIView *daysOfWeekView;

@end
