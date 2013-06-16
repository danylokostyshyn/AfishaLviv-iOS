//
//  ALDatePickerContainerView.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 6/17/13.
//
//

#import <UIKit/UIKit.h>

@class ALDatePickerView;
@protocol ALDatePickerViewDelegate <NSObject>
@optional
- (void)datePickerView:(ALDatePickerView *)datePickerView didFinishWithDateOrNil:(NSDate *)dateOrNil;
@end

@interface ALDatePickerView : UIView
@property (weak, nonatomic) id <ALDatePickerViewDelegate> delegate;
- (id)initWithView:(UIView *)view;
- (void)show;
@end
