//
//  SCDatePickerViewFlowLayout.m
//  SCDatePickerView
//
//  Created by Schubert Cardozo on 19/06/14.
//  Copyright (c) 2014 Schubert Cardozo. All rights reserved.
//

#import "SCDatePickerViewFlowLayout.h"

@implementation SCDatePickerViewFlowLayout

- (id)init
{
    self = [super init];
    if(self)
    {

    }
    return self;
}

// -- REF -- http://stackoverflow.com/questions/17229350/cell-spacing-in-uicollectionview
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
