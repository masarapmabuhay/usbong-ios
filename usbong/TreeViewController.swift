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

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Test TextDisplayViewController
        // TODO: Use table view controllers instead. For modularity of components such as text, image, etc.
//        let viewController = TextDisplayNodeViewController(nibName: "TextDisplayNodeViewController", bundle: NSBundle.mainBundle())
        
        // Test TextDisplayViewController
//        let viewController = ImageDisplayNodeViewController(nibName: "ImageDisplayNodeViewController", bundle: NSBundle.mainBundle())
//        let viewController = TaskNodeTableViewController()
//        
//        addChildViewController(viewController)
//        containerView.addSubview(viewController.view)
//        
//        viewController.view.frame = containerView.bounds
        
        // Page view controller
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        
        if let pageVC = pageViewController {
            pageVC.delegate = self
            
            pageVC.setViewControllers([TaskNodeTableViewController()], direction: .Forward, animated: false, completion: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TreeViewController: UIPageViewControllerDelegate {}

extension TreeViewController: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return TaskNodeTableViewController()
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return TaskNodeTableViewController()
    }
}