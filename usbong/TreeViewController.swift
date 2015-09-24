//
//  TreeViewController.swift
//  usbong
//
//  Created by Chris Amanse on 9/15/15.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import UIKit

// Root view controller for Tree (Page-based)
class TreeViewController: UIViewController {
    var treeZipURL: NSURL?
    var tree: UsbongTree?
    var taskNodeTableViewController = TaskNodeTableViewController()
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backNextSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Unpack tree (place this on a background thread if noticeable lag occurs)
        if let zipURL = treeZipURL {
            if let url = UsbongFileManager.defaultManager().unpackTreeToTemporaryDirectoryWithTreeURL(zipURL) {
                tree = UsbongTree(treeDirectoryURL: url)
                
                // Set navigation bar title to tree name
                navigationItem.title = tree?.name
            }
        }
        
        if let firstTaskNode = tree?.taskNodes.first {
            taskNodeTableViewController.taskNode = firstTaskNode
            
            addChildViewController(taskNodeTableViewController)
            containerView.addSubview(taskNodeTableViewController.view)
            
            taskNodeTableViewController.view.frame = containerView.bounds
            taskNodeTableViewController.didMoveToParentViewController(self)
            
            activityIndicatorView.stopAnimating()
        }
        
        if tree?.previousTaskNode == nil {
            backNextSegmentedControl.setTitle("Exit", forSegmentAtIndex: 0)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // If no task nodes, show alert
        if tree?.taskNodes.count ?? 0 == 0 {
            print("No task nodes found!")
            
            let alertController = UIAlertController(title: "Invalid Tree", message: "This tree can't be opened by the app.", preferredStyle: .Alert)
            
            let closeAction = UIAlertAction(title: "Close", style: .Destructive, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            alertController.addAction(closeAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func didPressPreviousOrNext(sender: UISegmentedControl) {
        // Before transition
        if sender.selectedSegmentIndex == 0 {
            // Previous
            if tree?.previousTaskNode == nil {
                dismissViewControllerAnimated(true, completion: nil)
            } else {
                tree?.transitionToPreviousTaskNode()
            }
            
        } else {
            // Next
            if tree?.currentTaskNode is EndStateTaskNode {
                dismissViewControllerAnimated(true, completion: nil)
            } else {
                tree?.transitionToNextTaskNode()
            }
        }
        
        if let currentTaskNode = tree?.currentTaskNode {
            taskNodeTableViewController.taskNode = currentTaskNode
        }
        
        // Finished transition
        // Change back button title to exit if there are no previous task nodes
        if tree?.previousTaskNode == nil {
            sender.setTitle("Exit", forSegmentAtIndex: 0)
        } else {
            sender.setTitle("Back", forSegmentAtIndex: 0)
        }
        // Change next button title to exit if transitioned node is end state
        if tree?.currentTaskNode is EndStateTaskNode {
            sender.setTitle("Exit", forSegmentAtIndex: 1)
        } else {
            sender.setTitle("Next", forSegmentAtIndex: 1)
        }
    }
    
    // MARK: - Custom
    
}