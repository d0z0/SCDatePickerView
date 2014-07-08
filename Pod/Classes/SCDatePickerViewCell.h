//
//  SCDatePickerViewCell.h
//  SCDatePickerDemo
//
//  Created by Schubert Cardozo on 19/06/14.
//  Copyright (c) 2014 Schubert Cardozo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCDatePickerViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UILabel *dateLabel;
@property (nonatomic, strong) UIView *todayBackgroundView;

@end
