//
//  TableTableViewController.swift
//  GAP3
//
//  Created by Worship Arts on 5/28/15.
//  Copyright (c) 2015 Shane Hughes. All rights reserved.
//

//

import UIKit
import Parse
import ParseUI

class TableViewController: PFQueryTableViewController {

	// Sign the user out
	@IBAction func signOut(sender: AnyObject) {
		
		PFUser.logOut()
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") as! UIViewController
		self.presentViewController(vc, animated: true, completion: nil)
	}
	
	@IBAction func add(sender: AnyObject) {
		
		dispatch_async(dispatch_get_main_queue()) {
			self.performSegueWithIdentifier("TableViewToDetailView", sender: self)
		}
	}
	
	// Initialise the PFQueryTable tableview
	override init(style: UITableViewStyle, className: String!) {
		super.init(style: style, className: className)
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
  
		// Configure the PFQueryTableView
		self.parseClassName = "PrayerTime"
		self.textKey = "firstName"
		self.pullToRefreshEnabled = true
		self.paginationEnabled = false
	}
	
	// Define the query that will provide the data for the table view
	override func queryForTable() -> PFQuery {
		var query = PFQuery(className: "PrayerTable")
		query.orderByAscending("firstName")
		return query
	}
	
	//override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
		
		var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PFTableViewCell!
		if cell == nil {
			cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
		}
		
		// Extract values from the PFObject to display in the table cell
		if let firstName = object?["firstName"] as? String {
			cell.textLabel?.text = firstName
		}
		if let lastName = object?["lastName"] as? String {
			cell.detailTextLabel?.text = lastName
		}
		
		return cell
	}
	
    
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
		
		// Get the new view controller using [segue destinationViewController].
        if let detailScene = segue.destinationViewController as? DetailViewController {
		
            // Pass the selected object to the destination view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let row = Int(indexPath.row)
                detailScene.currentObject = (objects?[row] as? PFObject)
            }
        }
	}
	
    /*
    
    func newLabelWithTitle(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.backgroundColor = UIColor.clearColor()
        label.sizeToFit()
        return label
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        footerView.backgroundColor = UIColor.blackColor()
        
        return footerView
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }

    */
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
	override func viewDidAppear(animated: Bool) {
        // Refresh the table to ensure any data changes are displayed
        tableView.reloadData()
	}
	
}
