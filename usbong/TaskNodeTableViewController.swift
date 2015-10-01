//
//  TaskNodeTableViewController.swift
//  usbong
//
//  Created by Chris Amanse on 17/09/2015.
//  Copyright 2015 Usbong Social Systems, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import AVFoundation

class TaskNodeTableViewController: UITableViewController {
    var taskNode: TaskNode = TaskNode(modules: []) {
        didSet {
            registerNibs()
            tableView.reloadData()
        }
    }
    
    var backgroundAudioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Register nibs
        registerNibs()
        
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
    
    // MARK: - Custom
    
    func registerNibs() {
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
        
        // Figures out what type of TaskNodeModule, and loads the appropriate cell (text = text cell, image = image cell, etc.)
        let module = taskNode.modules[indexPath.row]
        switch module {
        case let textModule as TextTaskNodeModule:
            let textCell = tableView.dequeueReusableCellWithIdentifier("Text", forIndexPath: indexPath) as! TextTableViewCell
            print("Text: \(textModule.text)")
            textCell.titleLabel.text = textModule.text
            
            cell = textCell
        case let imageModule as ImageTaskNodeModule:
            let imageCell = tableView.dequeueReusableCellWithIdentifier("Image", forIndexPath: indexPath) as! ImageTableViewCell
            print("Image: \(imageModule.imageFilePath)")
            imageCell.customImageView.image = UIImage(contentsOfFile: imageModule.imageFilePath)
            
            cell = imageCell
        default:
            cell = UITableViewCell(style: .Default, reuseIdentifier: "unknownModule")
            cell.textLabel?.text = "Unkown"
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
