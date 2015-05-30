//
//  SignUpInViewController.swift
//  GAP3
//
//  Created by Worship Arts on 5/28/15.
//  Copyright (c) 2015 Shane Hughes. All rights reserved.
//

//

import UIKit
import Parse

class SignUpInViewController: UIViewController {
	
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var message: UILabel!
	@IBOutlet weak var emailAddress: UITextField!
	@IBOutlet weak var password: UITextField!
    
    
    
    var popViewController : PopUpViewControllerSwift!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
	
	@IBAction func signUp(sender: AnyObject) {
		
		// Build the terms and conditions alert
		let alertController = UIAlertController(title: "Agree to terms and conditions",
			message: "Click I AGREE to signal that you agree to the End User Licence Agreement.",
			preferredStyle: UIAlertControllerStyle.Alert
		)
		alertController.addAction(UIAlertAction(title: "I AGREE",
			style: UIAlertActionStyle.Default,
			handler: { alertController in self.processSignUp()})
		)
		alertController.addAction(UIAlertAction(title: "I do NOT agree",
			style: UIAlertActionStyle.Default,
			handler: nil)
		)
		
		// Display alert
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	@IBAction func signIn(sender: AnyObject) {
		
		activityIndicator.hidden = false
		activityIndicator.startAnimating()
		
		var userEmailAddress = emailAddress.text
		userEmailAddress = userEmailAddress.lowercaseString
		
		var userPassword = password.text
		
		PFUser.logInWithUsernameInBackground(userEmailAddress, password:userPassword) {
			(user: PFUser?, error: NSError?) -> Void in
			if user != nil {
				dispatch_async(dispatch_get_main_queue()) {
					self.performSegueWithIdentifier("signInToNavigation", sender: self)
				}
			} else {
				self.activityIndicator.stopAnimating()
				
				if let message: AnyObject = error!.userInfo!["error"] {
					self.message.text = "\(message)"
				}
			}
		}
	}
    @IBOutlet weak var showPopUpBtn: UIButton!
    
     //@IBOutlet weak var showPopupBtn: UIButton!
    
    @IBAction func showPopUp(sender: AnyObject) {
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        {
            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPad", bundle: nil)
            self.popViewController.title = "This is a popup view"
            self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "This is where setting icons will go", animated: true)
        } else
        {
            if UIScreen.mainScreen().bounds.size.width > 320 {
                if UIScreen.mainScreen().scale == 3 {
                    self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                    self.popViewController.title = "This is a popup view"
                    self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "This is where setting icons will go", animated: true)
                } else {
                    self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6", bundle: nil)
                    self.popViewController.title = "This is a popup view"
                    self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "This is where setting icons will go", animated: true)
                }
            } else {
                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
                self.popViewController.title = "This is a popup view"
                self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "This is where setting icons will go", animated: true)
            }
        }
    }

 
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		activityIndicator.hidden = true
		activityIndicator.hidesWhenStopped = true
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	

	func processSignUp() {
		
		var userEmailAddress = emailAddress.text
		var userPassword = password.text
		
		// Ensure username is lowercase
		userEmailAddress = userEmailAddress.lowercaseString
		
		// Add email address validation
		
		// Start activity indicator
		activityIndicator.hidden = false
		activityIndicator.startAnimating()
		
		// Create the user
		var user = PFUser()
		user.username = userEmailAddress
		user.password = userPassword
		user.email = userEmailAddress
		
		user.signUpInBackgroundWithBlock {
			(succeeded: Bool, error: NSError?) -> Void in
			if error == nil {
				
				dispatch_async(dispatch_get_main_queue()) {
					self.performSegueWithIdentifier("signInToNavigation", sender: self)
				}
				
			} else {
				
				self.activityIndicator.stopAnimating()
			 
				if let message: AnyObject = error!.userInfo!["error"] {
					self.message.text = "\(message)"
				}				
			}
		}
	}

	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
