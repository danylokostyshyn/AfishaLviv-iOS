//
//  AppDelegate.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 20.03.12.

#import <UIKit/UIKit.h>

#define  ApplicationDelegate    ((ALAppDelegate *)[[UIApplication sharedApplication] delegate])

@interface ALAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
