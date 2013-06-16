//
//  ALDatePickerContainerView.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 6/17/13.
//
//

#import "ALDatePickerView.h"

@implementation UIView (MCAdditional)

- (void)showPickerContainerView:(UIView *)pickerContainerView
{
    __block CGRect newFrame = pickerContainerView.frame;
    newFrame.origin.y = self.frame.size.height + newFrame.size.height;
    pickerContainerView.frame = newFrame;
    
    [self addSubview:pickerContainerView];
    
    [UIView animateWithDuration:.5f animations:^{
        newFrame.origin.y = self.frame.size.height - newFrame.size.height;
        pickerContainerView.frame = newFrame;
    }];
}

- (void)hidePickerContainerView:(UIView *)pickerContainerView
{
    __block CGRect newFrame = pickerContainerView.frame;
    
    [UIView animateWithDuration:.5f animations:^{
        newFrame.origin.y = self.frame.size.height + newFrame.size.height;
        pickerContainerView.frame = newFrame;
    } completion:^(BOOL finished) {
        [pickerContainerView removeFromSuperview];
    }];
}

@end

@interface ALDatePickerView ()
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) UIBarButtonItem *cancelBarButon;
@property (strong, nonatomic) UIBarButtonItem *doneBarButton;
@property (weak, nonatomic) UIView *parentView;
@end

@implementation ALDatePickerView

- (UIToolbar *)toolbar
{
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 44.f)];
    }
    return _toolbar;
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.f, 44.f, 320.f, 216.f)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    return _datePicker;
}

- (UIBarButtonItem *)cancelBarButon
{
    if (!_cancelBarButon) {
        _cancelBarButon = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                        target:self
                                                                        action:@selector(cancelButtonPressed:)];
    }
    return _cancelBarButon;
}

- (UIBarButtonItem *)doneBarButton
{
    if (!_doneBarButton) {
        _doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                       target:self
                                                                       action:@selector(doneButtonPressed:)];
    }
    return _doneBarButton;
}

- (id)initWithView:(UIView *)view
{
    self = [super initWithFrame:CGRectMake(0.f, 0.f, 320.f, 260.f)];
    if (self) {
        _parentView = view;
        
        [self addSubview:self.toolbar];
        [self addSubview:self.datePicker];
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil action:nil];
        
        self.toolbar.items = @[self.cancelBarButon, flexibleSpace, self.doneBarButton];
    }
    return self;
}

#pragma mark - UI Actions

- (void)show
{
    [self.parentView showPickerContainerView:self];
}

- (void)cancelButtonPressed:(id)sender
{
    [self.parentView hidePickerContainerView:self];
    [self.delegate datePickerView:self didFinishWithDateOrNil:nil];
}

- (void)doneButtonPressed:(id)sender
{
    [self.parentView hidePickerContainerView:self];
    [self.delegate datePickerView:self didFinishWithDateOrNil:self.datePicker.date];
}

@end
