//
//  TaskNodeTableViewController.swift
//  usbong
//
//  Created by Joe Amanse on 17/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import UIKit

class TaskNodeTableViewController: UITableViewController {
    var taskNode: TaskNode = TaskNode(modules: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Register nibs
        let modules = taskNode.modules
        for module in modules {
            switch module {
            case _ as TextTaskNodeModule:
                tableView.registerNib(UINib(nibName: "TextTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "Text")
            case _ as ImageTaskNodeModule:
                tableView.registerNib(UINib(nibName: "ImageTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "Image")
            default:
                break
            }
        }
        
        // Table view properties
        tableView.separatorStyle = .None
        
        // Table view self-sizing height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskNode.modules.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        let module = taskNode.modules[indexPath.row]
        switch module {
        case let textModule as TextTaskNodeModule:
            cell = tableView.dequeueReusableCellWithIdentifier("Text", forIndexPath: indexPath) as! TextTableViewCell
            print("Text: \(textModule.text)")
            
        case let imageModule as ImageTaskNodeModule:
            cell = tableView.dequeueReusableCellWithIdentifier("Image", forIndexPath: indexPath) as! ImageTableViewCell
            print("Image: \(imageModule.imageFilePath)")
        default:
            cell = UITableViewCell(style: .Default, reuseIdentifier: "unknownModule")
            cell.textLabel?.text = "Unkown"
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        print(indexPathsAndHeights[indexPath])
//        return indexPathsAndHeights[indexPath] ?? UITableViewAutomaticDimension
////        return
//    }
//    
//    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 100
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
