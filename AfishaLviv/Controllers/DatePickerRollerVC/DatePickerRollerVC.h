//
//  DatePickerRollerVC.h
//  AfishaLviv
//
//  Created by Mac on 22.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerRollerVC;
@protocol DatePickerRollerDelegate <NSObject>
@optional

- (void)datePicker:(DatePickerRollerVC *)datePicker didPickDate:(NSDate *)date;

@end

@interface DatePickerRollerVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) id <DatePickerRollerDelegate> delegate;

@end
