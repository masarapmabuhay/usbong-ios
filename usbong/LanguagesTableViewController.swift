//
//  LanguagesTableViewController.swift
//  usbong
//
//  Created by Joe Amanse on 02/10/2015.
//  Copyright © 2015 Usbong Social Systems, Inc. All rights reserved.
//

import UIKit

class LanguagesTableViewController: UITableViewController {
    var taskNodeGenerator: UsbongTaskNodeGenerator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func didPressCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskNodeGenerator?.availableLanguages.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        let language = taskNodeGenerator?.availableLanguages[indexPath.row]
        cell.textLabel?.text = language
        
        if taskNodeGenerator?.currentLanguage == language {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Set current language to selected language
        if let selectedLanguage = taskNodeGenerator?.availableLanguages[indexPath.row] {
            taskNodeGenerator?.currentLanguage = selectedLanguage
        }
        
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
}
