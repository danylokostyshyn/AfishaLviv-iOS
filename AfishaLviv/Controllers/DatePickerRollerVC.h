//
//  DatePickerRollerVC.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 22.03.12.

#import <UIKit/UIKit.h>

@class DatePickerRollerVC;
@protocol DatePickerRollerDelegate <NSObject>
@optional

- (void)datePicker:(DatePickerRollerVC *)datePicker didPickDate:(NSDate *)date;

@end

@interface DatePickerRollerVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) id <DatePickerRollerDelegate> delegate;

@end
