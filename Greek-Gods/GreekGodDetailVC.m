//
//  GreekGodDetailVC.m
//  Greek-Gods
//
//  Created by Ashley Ng on 6/1/15.
//  Copyright (c) 2015 Ashley Ng. All rights reserved.
//

#import "GreekGodDetailVC.h"
#import "FormVC.h"
#import <Firebase/Firebase.h>

@interface GreekGodDetailVC ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *romanLabel;
@property (strong, nonatomic) IBOutlet UITextView *repText;
@property (strong, nonatomic) IBOutlet UITextView *symbolsText;

@end

@implementation GreekGodDetailVC

- (NSString *)formatArrayToString:(NSArray *)array
{
    NSMutableString *return_string = [[NSMutableString alloc] init];
    for (id value in array) {
        if ([value isKindOfClass:[NSString class]])
        {
            [return_string appendFormat:@"%@, ", (NSString *)value];
        }
    }
    return return_string;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://greek-gods.firebaseio.com/"];
    [ref observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"The updated post title is %@", snapshot.value);
        self.godData = snapshot.value;
        [self reloadData];
    }];
    
    [self reloadData];
    
}

- (void)reloadData
{
    self.nameLabel.text = self.name;
    self.romanLabel.text = [self.godData valueForKey:@"roman"];
# warning need to fix font size
    self.repText.text = [self formatArrayToString:[self.godData valueForKey:@"rep"]];
    self.symbolsText.text = [self formatArrayToString:[self.godData valueForKey:@"symbol"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Edit Data"]) {
        if ([segue.destinationViewController isKindOfClass:[FormVC class]]) {
            FormVC *fvc = segue.destinationViewController;
            fvc.data = self.godData;
            fvc.name = self.name;
            fvc.isEditForm = YES;
        }
    }
}

- (IBAction)toDetailVC:(UIStoryboardSegue *)sender
{
    
}



@end
