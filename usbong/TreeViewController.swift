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
    
    var pageViewController: UIPageViewController?
//    var taskNodes: [TaskNode] = []
    var treeZipURL: NSURL?
    var tree: UsbongTree?
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var containerView: UIView!
    
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
        
        // TODO: Show alert
        if tree?.taskNodes.count ?? 0 == 0 {
            navigationController?.popViewControllerAnimated(true)
        }
        
        // Task Nodes
        // Test task nodes
//        let textDisplay = TextDisplayTaskNode(text: "Some Text.")
//        let imageDisplay = ImageDisplayTaskNode(imageFilePath: "someFile")
//        let textImageDisplay = TextImageDisplayTaskNode(text: "Some Text.", imageFilePath: "someFilePath")
//        let imageTextDisplay = ImageTextDisplayTaskNode(imageFilePath: "someFilePath", text: "Some Text.")
//        
//        taskNodes.append(textDisplay)
//        taskNodes.append(imageDisplay)
//        taskNodes.append(textImageDisplay)
//        taskNodes.append(imageTextDisplay)
        
        // Page view controller
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        
        if let pageVC = pageViewController {
            pageVC.delegate = self
            
            if let startingViewController = viewControllerAtIndex(0) {
                pageVC.setViewControllers([startingViewController], direction: .Forward, animated: false, completion: nil)
            }
            pageVC.dataSource = self
            
            addChildViewController(pageVC)
            containerView.addSubview(pageVC.view)
            
            pageVC.view.frame = containerView.bounds
            pageVC.didMoveToParentViewController(self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom
    
    func viewControllerAtIndex(index: Int) -> TaskNodeTableViewController? {
        guard tree?.taskNodes.count != 0 && index < tree?.taskNodes.count else {
            return nil
        }
        
        // Assign task node for view controller
        let taskVC = TaskNodeTableViewController()
        if let taskNode = tree?.taskNodes[index] {
            print("TaskNode found: \(taskNode)")
            taskVC.taskNode = taskNode
        }
        
        return taskVC
    }
    
    func indexOfViewController(viewController: TaskNodeTableViewController) -> Int {
        return tree?.taskNodes.indexOf(viewController.taskNode) ?? NSNotFound
    }
}

extension TreeViewController: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("Index of previous: \(indexOfViewController(previousViewControllers[0] as! TaskNodeTableViewController))")
        print("Index of now: \(indexOfViewController(pageViewController.viewControllers?[0] as! TaskNodeTableViewController))")
        print("Undo transition: \(!completed)")
//        weak var myself = self
//        pageViewController.setViewControllers(pageViewController.viewControllers, direction: .Forward, animated: true) { (finished) -> Void in
//            if finished {
//                dispatch_async(dispatch_get_main_queue()) {
//                    myself?.pageViewController?.setViewControllers(pageViewController.viewControllers, direction: .Forward, animated: false, completion: nil)
//                }
//            }
//        }
        pageViewController.setViewControllers(pageViewController.viewControllers, direction: .Forward, animated: false, completion: nil)
        
        // Revert transition if applicable.
        // TODO: transition previous
        if !completed {
            let currentIndex = indexOfViewController(pageViewController.viewControllers?.first as! TaskNodeTableViewController)
            print("current = \(currentIndex); count = \(tree?.taskNodes.count)")
            if currentIndex + 1 < tree?.taskNodes.count {
                print("*** Removing task node ***")
                tree?.transitionToPreviousTaskNode()
//                pageViewController.setViewControllers(pageViewController.viewControllers, direction: .Forward, animated: false, completion: nil)
                print(tree?.taskNodes.count)
                print("VCs.count: \(pageViewController.childViewControllers.count)")
            } else {
                tree?.transitionToNextTaskNode()
//                pageViewController.setViewControllers(pageViewController.viewControllers, direction: .Forward, animated: false, completion: nil)
                print(tree?.taskNodes.count)
                print("VCs.count: \(pageViewController.childViewControllers.count)")
            }
        }
    }
}

extension TreeViewController: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard viewController is TaskNodeTableViewController else {
            return nil
        }
        var index = indexOfViewController(viewController as! TaskNodeTableViewController)
        guard index > 0 && index != NSNotFound else {
            return nil
        }
        
        // Transition to previous task node
        tree?.transitionToPreviousTaskNode()
        
        index--
        return viewControllerAtIndex(index)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard viewController is TaskNodeTableViewController else {
            return nil
        }
        var index = indexOfViewController(viewController as! TaskNodeTableViewController)
        guard index < tree?.taskNodes.count && index != NSNotFound else {
            print("Index at end or index not found.")
            return nil
        }
        
        print("*** Appending task node ***")
        // Transition to next task node here
        // TODO: transition next
        tree?.transitionToNextTaskNode()
        
        index++
        return viewControllerAtIndex(index)
    }
}