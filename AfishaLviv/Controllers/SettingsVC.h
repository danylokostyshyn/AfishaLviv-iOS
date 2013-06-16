//
//  SettingsVC.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 20.03.12.

#import "ALViewController.h"

@class SettingsVC;
@protocol SettingsDelegate <NSObject>
- (void)settingsViewControllerDidEraseDadabase:(SettingsVC *)settingsVC;
@end

@interface SettingsVC : ALViewController <UITableViewDataSource, UITableViewDelegate>
@property (assign, nonatomic) id <SettingsDelegate> delegate;
@end
