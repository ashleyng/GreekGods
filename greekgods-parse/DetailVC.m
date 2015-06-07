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
    [query getObjectInBackgroundWithId:self.key block:^(PFObject *retreivedObject, NSError *error) {
        self.data = retreivedObject;
        NSLog(@"KEY: %@", self.key);
        NSLog(@"%@", self.data);
        NSLog(@"Object retreived");
        [self reloadData];
    }];
}

# warning need to fix  vertical spacing within representation and symbols label
- (void)reloadData
{
    self.nameLabel.text = self.name;
    self.romanLabel.text = self.data[@"roman"];
    self.repText.text = [self formatArrayToString:self.data[@"reps"]];
    self.symbolsText.text = [self formatArrayToString:self.data[@"symbol"]];
//    if (![[self.godData valueForKey:@"image"] isEqualToString:@""]) {
//        self.image.image = [self decodeImage: [self.godData valueForKey:@"image"]];
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSLog(@"SEGUE TO EDIT");
    if ([segue.identifier isEqualToString:@"Edit Data"]) {
        if ([segue.destinationViewController isKindOfClass:[FormVC class]]) {
//            NSLog(@"SET UP FORM DATA");
            FormVC *fvc = segue.destinationViewController;
//            fvc.data = self.data;
            fvc.key = self.key;
            fvc.isEditForm = YES;
        }
    }
}

- (UIImage *)decodeImage:(NSString *)encodedImage {
    NSData *decodedData = [[NSData alloc]
                           initWithBase64EncodedString:encodedImage
                           options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [UIImage imageWithData:decodedData];
    return image;
}

- (IBAction)toDetailVC:(UIStoryboardSegue *)sender
{
    
}


@end
