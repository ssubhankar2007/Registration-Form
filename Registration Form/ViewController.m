//
//  ViewController.m
//  Registration Form
//
//  Created by test on 5/30/16.
//  Copyright © 2016 GlobalServices. All rights reserved.
//


#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz."

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) CGFloat screenHeight, screenWidth;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    _passwordTextField.delegate = self;
    _nameTextField.delegate = self;
    _emailTextField.delegate = self;
    _cityTextField.delegate = self;
    
    
    [_emailTextField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
     [_emailTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(hideKeyboard:)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_passwordTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_cityTextField resignFirstResponder];
    return  YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)hideKeyboard:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"vc" bundle:nil];
//    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"vc"];

    
    if (textField == _mobileNumberTextField && range.location == 0) {
        if ([string hasPrefix:@"0"]) {
            return NO;
        }
    }
    else if (textField == _mobileNumberTextField && _mobileNumberTextField.text.length>9) {
        return NO;
    }
    
    if (textField == _passwordTextField) {
        if (textField.text.length <7) {
            UIAlertController *passwordAlertController = [UIAlertController alertControllerWithTitle:nil message:@"Minimum 8 characters" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [passwordAlertController addAction:ok];
            
//            [self presentViewController:passwordAlertController animated:YES completion:nil];
        }
    }
    
    if (textField == _nameTextField) {
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    
//    if (textField == _emailTextField && _emailTextField.text.length>0) {
//        
//    }
    
    if (textField == _cityTextField) {
        
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([textField.text length]==0 || [self validateEmailWithString:textField.text]) {
        [textField resignFirstResponder];
        
    }else{
//        [[[UIAlertView alloc] initWithTitle:@"OTS" message:@"Please enter valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        
//        [textField becomeFirstResponder];
        return YES;
    }
    return YES;
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self dismissKeyboard:nil];
    
    // unregister for keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat keyboardHeight = (_screenWidth * 216)/320;
    
    if (textField.frame.origin.y + textField.frame.size.height > (_screenHeight - keyboardHeight)) {
    
        // save the text field that is being edited
        self.activeTextField = textField;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // release the selected text view as we don't need it anymore
    self.activeTextField = nil;
}

// Called when the UIKeyboardDidShowNotification is received
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.25 animations:^{
        
        // keyboard frame is in window coordinates
        NSDictionary *userInfo = [aNotification userInfo];
        CGRect keyboardInfoFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        // get the height of the keyboard by taking into account the orientation of the device too
        CGRect windowFrame = [self.view.window convertRect:self.view.frame fromView:self.view];
        CGRect keyboardFrame = CGRectIntersection (windowFrame, keyboardInfoFrame);
        CGRect coveredFrame = [self.view.window convertRect:keyboardFrame toView:self.view];
        
        // add the keyboard height to the content insets so that the scrollview can be scrolled
        UIEdgeInsets contentInsets = UIEdgeInsetsMake (0.0, 0.0, coveredFrame.size.height, 0.0);
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        // make sure the scrollview content size width and height are greater than 0
        [self.scrollView setContentSize:CGSizeMake (self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
        
        // scroll to the text field
        [self.scrollView scrollRectToVisible:self.activeTextField.superview.frame animated:YES];
    }];
}

// Called when the UIKeyboardWillHideNotification is received
- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.25 animations:^{
        // scroll back..
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }];
}

- (void)dismissKeyboard:(id)sender
{
    [self.scrollView endEditing:YES];
    [self.contentView endEditing:YES];
}
@end
