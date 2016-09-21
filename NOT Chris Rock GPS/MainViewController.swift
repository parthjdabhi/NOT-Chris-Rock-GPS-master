//
//  MainViewController.swift
//  NOT Chris Rock GPS
//
//  Created by Dustin Allen on 9/14/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import SDWebImage
//import UIActivityIndicator_for_SDWebImage

class MainViewController: UIViewController, AudioRecorderViewControllerDelegate {
    
    // MARK: -
    // MARK: Vars
    @IBOutlet var googleMaps: UIButton!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    
    // MARK: -
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imgProfile.setCornerRadious(imgProfile.frame.width/2)
        if let user = NSUserDefaults.standardUserDefaults().objectForKey("userDetail") as? NSDictionary {
            print(user)
            lblName.text = "Hello, \(user["name"] as? String ?? "")"
            imgProfile.sd_setImageWithURL(NSURL(string: user["profile_pic"] as? String ?? ""), placeholderImage: UIImage(named: "user.png"))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    @IBAction func googleMapsButton(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func googlePlaces(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("GooglePlacesViewController") as! GooglePlacesViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func yelp(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func weatherButton(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("OpenWeatherViewController") as! OpenWeatherViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func recordAudio(sender: AnyObject) {
    
        let controller = AudioRecorderViewController()
        controller.audioRecorderDelegate = self
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func actionLogout(sender: AnyObject) {
        let actionSheetController = UIAlertController (title: "Message", message: "Are you sure want to logout?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        actionSheetController.addAction(UIAlertAction(title: "Logout", style: UIAlertActionStyle.Destructive, handler: { (actionSheetController) -> Void in
            print("handle Logout action...")
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userDetail")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let navLogin = self.storyboard?.instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
            self.navigationController?.setViewControllers([navLogin], animated: true)
        }))
        
        presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    func audioRecorderViewControllerDismissed(withFileURL fileURL: NSURL?) {
        // do something with fileURL
        dismissViewControllerAnimated(true, completion: nil)
    }
}
