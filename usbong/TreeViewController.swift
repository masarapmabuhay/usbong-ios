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

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Test TextDisplayViewController
        // TODO: Use table view controllers instead. For modularity of components such as text, image, etc.
        let viewController = TextDisplayNodeViewController(nibName: "TextDisplayNodeViewController", bundle: NSBundle.mainBundle())
        
        // Test TextDisplayViewController
//        let viewController = ImageDisplayNodeViewController(nibName: "ImageDisplayNodeViewController", bundle: NSBundle.mainBundle())
        
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        
        viewController.view.frame = containerView.bounds
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
