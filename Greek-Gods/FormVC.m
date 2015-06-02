//
//  FormVC.m
//  Greek-Gods
//
//  Created by Ashley Ng on 6/1/15.
//  Copyright (c) 2015 Ashley Ng. All rights reserved.
//

#import "FormVC.h"
#import <Firebase/Firebase.h>

@interface FormVC ()
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *romanField;
@property (strong, nonatomic) IBOutlet UITextView *repField;
@property (strong, nonatomic) IBOutlet UITextView *symbolField;

@end

@implementation FormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitForm:(id)sender
{
    //get values from fields
    NSDictionary *data = @{
                           @"roman" : self.romanField.text,
                           @"symbol" : [self.symbolField.text componentsSeparatedByString:@","],
                           @"rep" : [self.repField.text componentsSeparatedByString:@","]
                           };
    
    // firebase set up and add new data
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://greek-gods.firebaseio.com/"];
    Firebase *godRef = [ref childByAppendingPath: self.nameField.text];
    [godRef setValue: data];
    [self performSegueWithIdentifier:@"submitForm" sender:self];

    
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)sender
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
