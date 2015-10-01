//
//  UsbongTaskNodeGenerator.swift
//  usbong
//
//  Created by Joe Amanse on 01/10/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

protocol UsbongTaskNodeGenerator {
    var title: String { get }
    var taskNodesCount: Int { get }
    var currentLanguage: String { get set }
    
    var previousTaskNode: TaskNode? { get }
    var currentTaskNode: TaskNode? { get }
    var nextTaskNode: TaskNode? { get }
    
    func transitionToNextTaskNode() -> Bool
    func transitionToPreviousTaskNode() -> Bool
}