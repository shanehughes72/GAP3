//
//  DetailViewController.swift
//  GAP3
//
//  Created by Worship Arts on 5/28/15.
//  Copyright (c) 2015 Shane Hughes. All rights reserved.
//

//

import UIKit
import Parse

class DetailViewController: UIViewController {
	
	// Container to store the view table selected object
	var currentObject : PFObject?
	
	// Some text fields
	@IBOutlet weak var firstName: UITextField!
	@IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var prayerTitle: UITextField!
    @IBOutlet weak var prayer: UITextView!

	
	
	// The save button
	@IBAction func saveButton(sender: AnyObject) {
		
		if let updateObject = currentObject as PFObject? {
			
			// Update the existing parse object
			updateObject["firstName"] = firstName.text
			updateObject["lastName"] = lastName.text
			updateObject["prayerTitle"] = prayerTitle.text
			updateObject["prayer"] = prayer.text
			
			// Save the data back to the server in a background task
			updateObject.saveEventually()
			
		} else {
			
			// Create a new parse object
			var updateObject = PFObject(className:"PrayerTable")
			
			updateObject["firstName"] = firstName.text
			updateObject["lastName"] = lastName.text
			updateObject["prayerTitle"] = prayerTitle.text
            updateObject["prayer"] = prayer.text
			updateObject.ACL = PFACL(user: PFUser.currentUser()!)
			
			// Save the data back to the server in a background task
			updateObject.saveEventually()
			
		}
		
		// Return to table view
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Unwrap the current object object
        //#### - Not unwrapping here.
        if let object = currentObject {
			firstName.text = object["firstName"] as? String
			lastName.text = object["lastName"] as? String
			prayerTitle.text = object["prayerTitle"] as? String
			prayer.text = object["prayer"] as? String
		}
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
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
