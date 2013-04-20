//
//  DatePickerVC.h
//  AfishaLviv
//
//  Created by Mac on 20.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DatePickerRollerVC.h"

@class DatePickerVC;

@protocol DatePickerDatasource <NSObject>
@optional

- (NSDate *)checkedDate;

@end

@protocol DatePickerDelegate <NSObject>
@optional

- (void)datePicker:(DatePickerVC *)datePicker didSelectedDate:(NSDate *)date;

@end

@interface DatePickerVC : UIViewController <UITableViewDelegate, UITableViewDataSource, DatePickerRollerDelegate, UINavigationControllerDelegate>
{
    id <DatePickerDelegate> delegate;
    id <DatePickerDatasource> datasource;
}

@property (assign, nonatomic) id <DatePickerDelegate> delegate;
@property (assign, nonatomic) id <DatePickerDatasource> datasource;

@end
