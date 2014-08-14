//
//  SCDatePickerViewCell.h
//  SCDatePickerView
//
//  Created by Schubert Cardozo on 19/06/14.
//  Copyright (c) 2014 Schubert Cardozo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SCDatePickerViewCellDateType) {
    SCDatePickerViewCellDateTypeDisabled, // date for cell does not belong to current month
    SCDatePickerViewCellDateTypeInvalid, // date for cell does not fall within allowed limits
    SCDatePickerViewCellDateTypeValid // date for cell belongs to current month and is selectable
};

@interface SCDatePickerViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UILabel *dateLabel;
@property (nonatomic, strong, readonly) UIView *borderView;
@property (nonatomic, assign) SCDatePickerViewCellDateType cellDateType;

@end
