//
//  GreekGodDetailVC.h
//  Greek-Gods
//
//  Created by Ashley Ng on 6/1/15.
//  Copyright (c) 2015 Ashley Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreekGodDetailVC : UIViewController

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic) NSString *key; // used for editing data

@end