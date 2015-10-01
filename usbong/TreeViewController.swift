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
    
    var treeGenerator: UsbongTaskNodeGenerator?
    
    var taskNodeTableViewController = TaskNodeTableViewController()
    
    lazy var speechSynthezier: AVSpeechSynthesizer = AVSpeechSynthesizer()
    var backgroundAudioPlayer: AVAudioPlayer?
    var audioSpeechPlayer: AVAudioPlayer?
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backNextSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Unpack tree (place this on a background thread if noticeable lag occurs)
        if let zipURL = treeZipURL {
            if let treeRootURL = UsbongFileManager.defaultManager().unpackTreeToTemporaryDirectoryWithTreeURL(zipURL) {
                treeGenerator = UsbongTaskNodeGeneratorXML(treeRootURL: treeRootURL)
                
                navigationItem.title = treeGenerator?.title
            }
        }
        
        if let firstTaskNode = treeGenerator?.currentTaskNode {
            taskNodeTableViewController.taskNode = firstTaskNode
            
            addChildViewController(taskNodeTableViewController)
            containerView.addSubview(taskNodeTableViewController.view)
            
            taskNodeTableViewController.view.frame = containerView.bounds
            taskNodeTableViewController.didMoveToParentViewController(self)
            
            activityIndicatorView.stopAnimating()
            
            // Load background audio at start
            loadBackgroundAudio()
        }
        
        if treeGenerator?.previousTaskNode == nil {
            backNextSegmentedControl.setTitle("Exit", forSegmentAtIndex: 0)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // If no task nodes, show alert
        if treeGenerator?.taskNodesCount ?? 0 == 0 {
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
            if treeGenerator?.previousTaskNode == nil {
                dismissViewControllerAnimated(true, completion: nil)
            } else {
                treeGenerator?.transitionToPreviousTaskNode()
            }
            
        } else {
            // Next transition
            if treeGenerator?.currentTaskNode is EndStateTaskNode {
                dismissViewControllerAnimated(true, completion: nil)
            } else {
                treeGenerator?.transitionToNextTaskNode()
            }
        }
        
        // Load task node it task node table view controller
        if let currentTaskNode = treeGenerator?.currentTaskNode {
            let oldTaskNode = taskNodeTableViewController.taskNode
            taskNodeTableViewController.taskNode = currentTaskNode
            
            // Background audio
            if oldTaskNode.backgroundAudioFilePath != currentTaskNode.backgroundAudioFilePath {
                backgroundAudioPlayer = nil
                loadBackgroundAudio()
            }
        }
        
        // Finished transition
        // Change back button title to exit if there are no previous task nodes
        if treeGenerator?.previousTaskNode == nil {
            sender.setTitle("Exit", forSegmentAtIndex: 0)
        } else {
            sender.setTitle("Back", forSegmentAtIndex: 0)
        }
        
        // Change next button title to exit if transitioned node is end state
        if treeGenerator?.currentTaskNode is EndStateTaskNode {
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
    
    // MARK: Background Audio
    
    func loadBackgroundAudio() {
        if let currentTaskNode = treeGenerator?.currentTaskNode {
            if let backgroundAudopFilePath = currentTaskNode.backgroundAudioFilePath {
                if let audioPlayer = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: backgroundAudopFilePath)) {
                    audioPlayer.numberOfLoops = -1 // Endless loop
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    audioPlayer.volume = 0.8
                    
                    backgroundAudioPlayer = audioPlayer
                }
            }
        }
    }
    
    // MARK: Voice-over
    func startVoiceOver() {
        if let currentTaskNode = treeGenerator?.currentTaskNode {
            // Attempt to play speech from audio file, if failed, resort to text-to-speech
            if !startAudioSpeechInTaskNode(currentTaskNode) {
                print(">>> Text-to-speech")
                startTextToSpeechInTaskNode(currentTaskNode)
            }
        }
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
    
    func startAudioSpeechInTaskNode(taskNode: TaskNode) -> Bool {
        if let audioFilePath = taskNode.audioFilePath {
            do {
                audioSpeechPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioFilePath))
            } catch let error as NSError {
                print("Error loading file: \(error)")
                return false
            }
            
            if let audioPlayer = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioFilePath)) {
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                
                audioSpeechPlayer = audioPlayer
                print(">>> PLAYED!")
                return true
            }
        }
        return false
    }
    
    // MARK: Translation
    
    func showChoosLanguageScreen() {
        print(">>> Show choose language screen")
    }
}