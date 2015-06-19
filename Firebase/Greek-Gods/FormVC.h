//
//  FormVC.h
//  Greek-Gods
//
//  Created by Ashley Ng on 6/1/15.
//  Copyright (c) 2015 Ashley Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormVC : UIViewController

@property (nonatomic, strong) NSDictionary *data; // only for edit form
@property (nonatomic) NSString *key; // only for edit form
@property BOOL isEditForm;

@end
