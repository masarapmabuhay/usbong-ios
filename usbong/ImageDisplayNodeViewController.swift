//
//  ImageDisplayNodeViewController.swift
//  usbong
//
//  Created by Joe Amanse on 16/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import UIKit

class ImageDisplayNodeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(imageView.image?.size)
        print(UIScreen.mainScreen().bounds.size)
        
        imageView.hidden = true
//        // Compute scale
//        if let imageWidth = imageView.image?.size.width {
//            let scale = imageWidth / UIScreen.mainScreen().bounds.width
//            print(scale)
//            if scale > 1 {
//                print("Image has larger width")
//                imageViewHeightConstraint.constant /= scale
//            } else {
//                print("Image has smaller width")
//                imageViewHeightConstraint.constant *= scale
//            }
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        print(imageView.image?.size)
        print(imageView.frame.size)
        
        // Compute scale
        if let imageWidth = imageView.image?.size.width {
            let scale = imageWidth / imageView.frame.width
            print(scale)
            if scale > 1 {
                print("Image has larger width")
                imageViewHeightConstraint.constant /= scale
            } else {
                print("Image has smaller width")
                imageViewHeightConstraint.constant *= scale
            }
        }
        
        imageView.hidden = false
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
