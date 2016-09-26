//
//  ViewController1.swift
//  NOT Chris Rock GPS
//
//  Created by iParth on 9/23/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import UIKit


//extension UIViewController
//{
//    func startFiveTapGesture() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.checkFiveTapGesture))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    
//    func checkFiveTapGesture() {
//        print("checkFiveTapGesture")
//        checkThisTap()
//    }
//    
//    // Resent the timer because there was user interaction.
//    func checkThisTap()
//    {
//        tapStack.append(NSDate())
//        print(" Count : ", tapStack.count, "First : ", tapStack.first, "Last : ", tapStack.last)
//        
//        if tapStack.count > 5 {
//            tapStack.removeFirst()
//        }
//        
//        if tapStack.count == 5 {
//            let elapsedTime = tapStack.last!.timeIntervalSinceDate(tapStack.first!)
//            //let duration = Int(elapsedTime)
//            if elapsedTime <= tapInSeconds { //Timeout time to detect taps in 10 seconds
//                tapStack.removeAll()
//                DetectedFiveTaps()
//            }
//        }
//    }
//    
//    // If the timer reaches the limit as defined in timeoutInSeconds, post this notification.
//    func DetectedFiveTaps() {
//        print("DetectedFiveTaps")
//        NSNotificationCenter.defaultCenter().postNotificationName(ApplicationDidFiveTapsNotification, object: nil)
//    }
//
//}


//class MyViewController: UIViewController, AudioRecorderViewControllerDelegate {
//    
//    //MARK : AudioRecorderViewController Delegage Methods
//    
//    func audioRecorderViewControllerDismissed(withFileURL fileURL: NSURL?) {
//        // do something with fileURL
//        dismissViewControllerAnimated(true, completion: nil)
//        print("Audio file URL : \(fileURL)")
//    }
//    
//    //MARK : ShowRecodringScreen
//    
//    func ShowRecodringScreen() {
//        print("ShowRecodringScreen")
//        let controller = AudioRecorderViewController()
//        controller.audioRecorderDelegate = self
//        presentViewController(controller, animated: true, completion: nil)
//    }
//}

extension UIViewController : AudioRecorderViewControllerDelegate
{
    func ShowRecodringScreen() {
        print("ShowRecodringScreen")
        let controller = AudioRecorderViewController()
        controller.audioRecorderDelegate = self
        presentViewController(controller, animated: true, completion: nil)
    }
    
    //MARK : AudioRecorderViewController Delegage Methods
    func audioRecorderViewControllerDismissed(withFileURL fileURL: NSURL?) {
        // do something with fileURL
        dismissViewControllerAnimated(true, completion: nil)
        print("Audio file URL : \(fileURL)")
    }
}


func topViewController(base: UIViewController? = (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
        return topViewController(nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
        if let selected = tab.selectedViewController {
            return topViewController(selected)
        }
    }
    if let presented = base?.presentedViewController {
        return topViewController(presented)
    }
    return base
}
