//
//  DetailVC.m
//  greekgods-parse
//
//  Created by Ashley Ng on 6/6/15.
//  Copyright (c) 2015 Ashley Ng. All rights reserved.
//

#import "DetailVC.h"
#import "FormVC.h"
#import "Parse/Parse.h"

@interface DetailVC ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *romanLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *repText;
@property (strong, nonatomic) IBOutlet UILabel *symbolsText;
@property (strong, nonatomic) PFObject *data;

@end

@implementation DetailVC



/*
 format an array into a comma seperated string
 */
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
}

- (void)viewDidAppear:(BOOL)animated {
    PFQuery *query = [PFQuery queryWithClassName:@"GreekGod"];
    assert(self.key); // make sure key is not null
    
    // in didAppear b/c view is already loaded if coming back from edit form, need to refresh with updated data
    [query getObjectInBackgroundWithId:self.key block:^(PFObject *retreivedObject, NSError *error) {
        if (!error) {
            self.data = retreivedObject;
            NSLog(@"Object retreived");
            [self reloadData];
        }
        else {
            NSLog(@"%@", error);
        }
    }];
}

/*
    add the data to the appropriate fields
 */
# warning need to fix vertical spacing within representation and symbols label
- (void)reloadData
{
    self.nameLabel.text = self.name;
    self.romanLabel.text = self.data[@"roman"];
    self.repText.text = [self formatArrayToString:self.data[@"reps"]];
    self.symbolsText.text = [self formatArrayToString:self.data[@"symbol"]];
    if (self.data[@"imageFile"]) {
        PFFile *image = self.data[@"imageFile"];
        NSData *imageData = [image getData];
        self.image.image = [UIImage imageWithData:imageData];
    }
    NSLog(@"Done updating data");
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
            fvc.key = self.key;
            fvc.isEditForm = YES;
        }
    }
}

- (IBAction)toDetailVC:(UIStoryboardSegue *)sender
{
    
}


@end
