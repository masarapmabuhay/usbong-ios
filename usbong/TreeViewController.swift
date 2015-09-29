//
//  TreeViewController.swift
//  usbong
//
//  Created by Chris Amanse on 9/15/15.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import UIKit
import AVFoundation

// Root view controller for Tree (Page-based)
// TODO: Place string literals as constants in a class (Global if it will be used throughout the project, or local if used only here). Do this after finalizing UI of app
class TreeViewController: UIViewController {
    var treeZipURL: NSURL?
    var treeEngine: UsbongTreeEngine?
    var tree: UsbongTree?
    
    var taskNodeTableViewController = TaskNodeTableViewController()
    
    lazy var speechSynthezier: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backNextSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Unpack tree (place this on a background thread if noticeable lag occurs)
        if let zipURL = treeZipURL {
            if let treeRootURL = UsbongFileManager.defaultManager().unpackTreeToTemporaryDirectoryWithTreeURL(zipURL) {
                treeEngine = UsbongTreeXMLEngine(treeRootURL: treeRootURL)
                tree = treeEngine?.tree
                
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
    
    deinit {
        stopTextToSpeech()
    }
    
    // MARK: - Actions
    
    @IBAction func didPressPreviousOrNext(sender: UISegmentedControl) {
        stopTextToSpeech()
        
        // Before transition
        if sender.selectedSegmentIndex == 0 {
            // Previous
            if tree?.previousTaskNode == nil {
                dismissViewControllerAnimated(true, completion: nil)
            } else {
                tree?.transitionToPreviousTaskNode()
            }
            
        } else {
            // Next transition
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
    
    @IBAction func didPressExit(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressMore(sender: AnyObject) {
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let speechAction = UIAlertAction(title: "Speech", style: .Default) { (action) -> Void in
            self.startVoiceOver()
        }
        let setLanguageAction = UIAlertAction(title: "Set Language", style: .Default) { (action) -> Void in
            self.showChoosLanguageScreen()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        actionController.addAction(speechAction)
        actionController.addAction(setLanguageAction)
        actionController.addAction(cancelAction)
        
        presentViewController(actionController, animated: true, completion: nil)
    }
    
    // MARK: - Custom
    
    // MARK: Voice-over
    func startVoiceOver() {
        if let currentTaskNode = tree?.currentTaskNode {
            if currentTaskNode.audioFilePath != nil {
                print(">>> Audio: \(currentTaskNode.audioFilePath!)")
                startAudioSpeechInTaskNode(currentTaskNode)
            } else {
                print(">>> Text-to-speech")
                startTextToSpeechInTaskNode(currentTaskNode)
            }
        }
        
//        if let audioFilePath = self.tree?.currentTaskNode?.audioFilePath {
//            print(">>> Audio: \(audioFilePath)")
//            startAudioSpeechInTaskNode(taskNode: TaskNode)
//        } else {
//            print(">>> Text-to-speech")
//            if let currentTaskNode = tree?.currentTaskNode {
//                startTextToSpeechInTaskNode(currentTaskNode)
//            }
//        }
    }
    
    func startTextToSpeechInTaskNode(taskNode: TaskNode) {
        let modules = taskNode.modules
        for module in modules {
            if let textModule = module as? TextTaskNodeModule {
                print("\(textModule.text)")
                let utterance = AVSpeechUtterance(string: textModule.text)
                
                // TODO: Set voice with language
                utterance.voice = AVSpeechSynthesisVoice(language: "en-EN")
                
                // Speak
                speechSynthezier.speakUtterance(utterance)
            }
        }
    }
    func stopTextToSpeech() {
        if speechSynthezier.speaking {
            speechSynthezier.stopSpeakingAtBoundary(.Immediate)
        }
    }
    
    var audioSpeechPlayer: AVAudioPlayer?
    func startAudioSpeechInTaskNode(taskNode: TaskNode) {
        if let audioFilePath = taskNode.audioFilePath {
            do {
                audioSpeechPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioFilePath))
            } catch let error as NSError {
                print("Error loading file: \(error)")
            }
            audioSpeechPlayer = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioFilePath))
            audioSpeechPlayer?.prepareToPlay()
            if audioSpeechPlayer?.play() ?? false {
                print(">>> PLAYED!")
            }
        }
    }
    
//    func startAudioSpeech
    
    // MARK: Translation
    
    func showChoosLanguageScreen() {
        print(">>> Show choose language screen")
    }
}