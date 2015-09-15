//
//  CommunityTableViewController.swift
//  usbong
//
//  Created by Joe Amanse on 15/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import UIKit

class CommunityTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let refreshControl = self.refreshControl {
            refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        }
        
        // Register required nibs
        let communityNib = UINib(nibName: "CommunityTableViewCell", bundle: NSBundle.mainBundle())
        
        tableView.registerNib(communityNib, forCellReuseIdentifier: "CommunityCell")
        
        // Self-sizing row height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 102
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    func refresh(sender: AnyObject) {
        print("Start refreshing...")
        if let refreshControl = sender as? UIRefreshControl {
            if refreshControl.refreshing {
                print("Control is refreshing")
                
                // Use these methods for completion of refresh
                tableView.reloadData()
                refreshControl.endRefreshing()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommunityCell", forIndexPath: indexPath) as! CommunityTableViewCell
        
        cell.titleLabel.text = "Community Tree \(indexPath.row)"
        cell.authorLabel.text = "author.user\(indexPath.row)"
        cell.downloadCountLabel.text = "Downloads: \(indexPath.row)"
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
