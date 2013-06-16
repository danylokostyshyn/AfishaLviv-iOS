//
//  DatePickerVC.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 20.03.12.

#import "ALViewController.h"

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

@interface DatePickerVC : ALViewController <UITableViewDelegate, UITableViewDataSource,
    DatePickerRollerDelegate, UINavigationControllerDelegate>
@property (assign, nonatomic) id <DatePickerDelegate> delegate;
@property (assign, nonatomic) id <DatePickerDatasource> datasource;
@end
