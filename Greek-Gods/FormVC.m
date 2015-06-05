//
//  FormVC.m
//  Greek-Gods
//
//  Created by Ashley Ng on 6/1/15.
//  Copyright (c) 2015 Ashley Ng. All rights reserved.
//

#import "FormVC.h"
#import <Firebase/Firebase.h>
#import "GreekGodDetailVC.h"
#import <Foundation/Foundation.h>
//#import "NSStrinAdditions.h"

@interface FormVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *romanField;
@property (strong, nonatomic) IBOutlet UITextView *repField;
@property (strong, nonatomic) IBOutlet UITextView *symbolField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@end

@implementation FormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // on edit form
    if (self.isEditForm) {
        [self editFormSetup];
    }
    else
        self.submitButton.title = @"Sumbit";
}

- (void)editFormSetup
{
    self.submitButton.title = @"Done";
    self.nameField.text = self.name;
    self.romanField.text = [self.data valueForKey:@"roman"];
    self.repField.text = [[self.data valueForKey:@"rep"] componentsJoinedByString:@","];
    self.symbolField.text = [[self.data valueForKey:@"symbol"] componentsJoinedByString:@","];
    if (![[self.data valueForKey:@"image"] isEqualToString:@""]) {
        self.image.image = [self decodeImage:[self.data valueForKey:@"image"]];
    }
}

- (IBAction)submitForm:(id)sender
{
    //get values from fields
    NSArray *symbols = [self.symbolField.text componentsSeparatedByString:@","];
    NSArray *reps = [self.repField.text componentsSeparatedByString:@","];
    symbols = [self formatArray:symbols];
    reps = [self formatArray:reps];
//    NSLog(@"%@", [self encodeImage:self.image.image]);
    NSDictionary *data = @{
                           @"roman" : self.romanField.text,
                           @"symbol" : symbols,
                           @"rep" : reps,
                           @"image" : [self encodeImage:self.image.image]
                           };
    
    // firebase set up and add new data
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://greek-gods.firebaseio.com/"];
    Firebase *godRef = [ref childByAppendingPath: self.nameField.text];
    if (self.isEditForm) {
# warning May not be able to handle if name changes
        [godRef updateChildValues: data];
        [self performSegueWithIdentifier:@"toDetailVC" sender:self];
    }
    else {
        [godRef setValue: data];
        [self performSegueWithIdentifier:@"toTableVC" sender:self];
    }
}

- (NSString *)encodeImage:(UIImage *)image {
    NSLog(@"IN ENCODED IMAGE");
    NSData *dataImage = UIImagePNGRepresentation(image);
    NSLog(@"HERE");
    NSString *encodedImage = [dataImage base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"HERE2");
    NSLog(@"Encoded: %@", encodedImage);
    return encodedImage;
}

- (UIImage *)decodeImage:(NSString *)encodedImage {
    NSData *decodedData = [[NSData alloc]
                           initWithBase64EncodedString:encodedImage
                           options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [UIImage imageWithData:decodedData];
    return image;
}

- (NSArray *)formatArray: (NSArray *)unformatedArray {
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    for (id value in unformatedArray) {
        if ([value isKindOfClass:[NSString class]]) {
            NSString *formatedString = [(NSString *)value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [returnArray addObject:formatedString];
        }
    }
    return returnArray;
}

- (IBAction)goBackButton:(id)sender {
    if (self.isEditForm) {
        [self performSegueWithIdentifier:@"toDetailVC" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"toTableVC" sender:self];
    }

}

# pragma mark Image Uploading

# warning need to support take image
- (IBAction)addImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.image.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (IBAction)toTableVC:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)toDetailVC:(UIStoryboardSegue *)segue
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
