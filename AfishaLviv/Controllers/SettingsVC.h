//
//  SettingsVC.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 20.03.12.

#import <UIKit/UIKit.h>

@class SettingsVC;
@protocol SettingsDelegate <NSObject>

- (void)settingsViewControllerDidEraseDadabase:(SettingsVC *)settingsVC;

@end

@interface SettingsVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) id <SettingsDelegate> delegate;

@end
