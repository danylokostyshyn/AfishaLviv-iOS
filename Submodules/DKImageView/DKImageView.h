//
//  DKImageView.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 23.03.12.

//

#import <UIKit/UIKit.h>

@interface DKImageView : UIImageView

typedef enum {
    DKImageViewStyleSmall,
    DKImageViewStyleBig
} DKImageViewStyle;

- (id)initWithStyle:(DKImageViewStyle)style;
- (id)initWithImageFromUrl:(NSURL *)imageUrl style:(DKImageViewStyle)style;
+ (DKImageView *)imageViewWithImageFromUrl:(NSURL *)imageUrl style:(DKImageViewStyle)style;

@property (strong, nonatomic) NSURL *imageUrl;

@end
