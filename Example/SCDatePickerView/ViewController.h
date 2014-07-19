//
//  ViewController.h
//  SCDatePickerViewDemo
//
//  Created by Schubert Cardozo on 18/07/14.
//  Copyright (c) 2014 Schubert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCDatePickerView.h"

@interface ViewController : UIViewController<SCDatePickerViewDelegate>

@property (nonatomic, strong) IBOutlet SCDatePickerView *datePickerView;

@end
