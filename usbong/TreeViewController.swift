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
    var taskNodes: [TaskNode] = []
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Task Nodes
        // Test task nodes
        let textDisplay = TextDisplayNode(name: "a")
        let imageDisplay = ImageDisplayNode(name: "b")
        let textImageDisplay = TextImageDisplayNode(name: "c")
        
        taskNodes.append(textDisplay)
        taskNodes.append(imageDisplay)
        taskNodes.append(textImageDisplay)
        
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
        guard taskNodes.count != 0 && index < taskNodes.count else {
            return nil
        }
        
        // Assign task node for view controller
        let taskVC = TaskNodeTableViewController()
        taskVC.taskNode = taskNodes[index]
        
        return taskVC
    }
    
    func indexOfViewController(viewController: TaskNodeTableViewController) -> Int {
        return taskNodes.indexOf(viewController.taskNode) ?? NSNotFound
    }
}

extension TreeViewController: UIPageViewControllerDelegate {}

extension TreeViewController: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! TaskNodeTableViewController)
        guard index > 0 && index != NSNotFound else {
            return nil
        }
        
        index--
        return viewControllerAtIndex(index)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! TaskNodeTableViewController)
        guard index < taskNodes.count && index != NSNotFound else {
            return nil
        }
        
        index++
        return viewControllerAtIndex(index)
    }
}