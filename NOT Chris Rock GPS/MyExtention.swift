//
//  MyExtention.swift
//  iParth
//
//  Created by iParth on 9/21/16.
//  Copyright © 2016 iParth. All rights reserved.
//


import Foundation
import UIKit
import CoreLocation


class MyExtention: NSObject {
    //
}

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
extension UIView {
    public func setBorder(width:CGFloat = 1, color: UIColor = UIColor.darkGrayColor())
    {
        self.layer.borderColor = color.CGColor
        self.layer.borderWidth = width
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    public func setCornerRadious(radious:CGFloat = 4)
    {
        self.layer.cornerRadius = radious ?? 4
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    public func animateShakeEffect(radious:CGFloat = 20)
    {
        self.transform = CGAffineTransformMakeTranslation(20, 0);
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0, options:.CurveEaseInOut , animations: {
            self.transform = CGAffineTransformIdentity
            })
        { (complete) in
                //print("Finish shaking..")
        }
    }
}

extension UIView {
    
    func lock() {
        if let _ = viewWithTag(10) {
            //View is already locked
        }
        else {
            let lockView = UIView(frame: bounds)
            lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
            lockView.tag = 10
            lockView.alpha = 0.0
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .White)
            activity.hidesWhenStopped = true
            activity.center = lockView.center
            lockView.addSubview(activity)
            activity.startAnimating()
            addSubview(lockView)
            
            UIView.animateWithDuration(0.2) {
                lockView.alpha = 1.0
            }
        }
    }
    
    func unlock() {
        if let lockView = viewWithTag(10) {
            UIView.animateWithDuration(0.2, animations: {
                lockView.alpha = 0.0
            }) { finished in
                lockView.removeFromSuperview()
            }
        }
    }
    
    func fadeOut(duration: NSTimeInterval) {
        UIView.animateWithDuration(duration) {
            self.alpha = 0.0
        }
    }
    
    func fadeIn(duration: NSTimeInterval) {
        UIView.animateWithDuration(duration) {
            self.alpha = 1.0
        }
    }
    
    class func viewFromNibName(name: String) -> UIView? {
        let views = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
        return views.first as? UIView
    }
}

extension NSObject {
    
    func callSelectorAsync(selector: Selector, object: AnyObject?, delay: NSTimeInterval) -> NSTimer {
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: selector, userInfo: object, repeats: false)
        return timer
    }
    
    func callSelector(selector: Selector, object: AnyObject?, delay: NSTimeInterval) {
        
        let delay = delay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            NSThread.detachNewThreadSelector(selector, toTarget:self, withObject: object)
        })
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func animateViewMoving (moveValue:CGFloat, up:Bool=true){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        
        self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        UIView.commitAnimations()
    }
    
    func showAlert(title:String,message:String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
        { (result : UIAlertAction) -> Void in
            print("ok")
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension UITextField {
    public func setLeftMargin(marginWidth:CGFloat = 4)
    {
        let paddingLeft = UIView(frame: CGRectMake(0, 0, marginWidth, self.frame.size.height))
        self.leftView = paddingLeft
        self.leftViewMode = UITextFieldViewMode .Always
    }
    public func setRightMargin(marginWidth:CGFloat = 4)
    {
        let paddingRight = UIView(frame: CGRectMake(0, 0, marginWidth, self.frame.size.height))
        self.rightView = paddingRight
        self.rightViewMode = UITextFieldViewMode .Always
    }
    
    public func setLeftImage(padding:CGFloat = 20,imageName:String) {
        
        var envelopeView: UIImageView = UIImageView(frame: CGRectMake(padding, 0, 30, 30))
        envelopeView.image = UIImage(named: "icon_user")
        envelopeView.contentMode = .ScaleAspectFit
        
        var viewLeft: UIView = UIView(frame: CGRectMake(padding, 0, 30, 30))
        viewLeft.addSubview(envelopeView)
        envelopeView.center = viewLeft.center
        
        self.leftView?.frame = envelopeView.frame
        self.leftView = viewLeft
        self.leftViewMode = .Always
        
        //var viewRight: UIView = UIView(frame: CGRectMake(textField.frame.size.width - (textField.frame.size.width + 30 + padding), 0, 30, 30))
        //viewRight.addSubview(envelopeView)
        //textField.rightView.setFrame(envelopeView.frame)
        //textField.rightView = viewRight
    }
    
    func setBottomBorder(borderColor: UIColor = UIColor.whiteColor())
    {
        self.borderStyle = UITextBorderStyle.None
        self.backgroundColor = UIColor.clearColor()
        let width:CGFloat = 1.0
        
        let borderLine = UIView(frame: CGRectMake(0, self.frame.height - width, self.frame.width, width))
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
    public func setPlaceholderColor(textColor:UIColor = UIColor.init(white: 0.8, alpha: 0.8))
    {
        //UIColor.whiteColor()
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder ?? "",attributes:[NSForegroundColorAttributeName: textColor])
        //,NSFontAttributeName:UIFont.fontNamesForFamilyName("Arial")
    }
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}

private var maxLengths = [UITextField: Int]()

extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(
                self,
                action: #selector(limitLength),
                forControlEvents: UIControlEvents.EditingChanged
            )
        }
    }
    
    func limitLength() {
        guard let prospectiveText = self.text
            where prospectiveText.characters.count > maxLength else {
                return
        }
        
        let selection = selectedTextRange
        text = prospectiveText.substringWithRange(
            Range<String.Index>(prospectiveText.startIndex ..< prospectiveText.startIndex.advancedBy(maxLength))
        )
        selectedTextRange = selection
    }
    
}

extension NSData {
    var stringValue: String? {
        return String(data: self, encoding: NSUTF8StringEncoding)
    }
    var base64EncodedString: String? {
        return base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
}

extension String {
    
    var convertToDictionary: [String:AnyObject]? {
        if let data = self.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    var utf8StringEncodedData: NSData? {
        return dataUsingEncoding(NSUTF8StringEncoding)
    }
    var base64DecodedData: NSData? {
        return NSData(base64EncodedString: self, options: .IgnoreUnknownCharacters)
    }
}

extension Dictionary where Value: AnyObject {
    
    var clean: [Key: Value] {
        //let tup = filter { !($0.1 is NSNull) }
        //return tup.reduce([Key: Value]()) { (var r, e) in r[e.0] = e.1; return r }
    
        var dict  = self
        let keysToRemove = dict.keys.filter { isNull(dict[$0]) == true }
        for key in keysToRemove {
            dict.removeValueForKey(key)
        }
        return dict
        
//        self.reduce([String : AnyObject]()) { (var dict, e) in
//            guard let value = e.1 else { return dict }
//            dict[e.0] = value
//            return dict
//        }
    }
}

func isNull(someObject: AnyObject?) -> Bool {
    guard let someObject = someObject else {
        return true
    }
    
    return (someObject is NSNull)
}

extension CLPlacemark {
    func LocationString() -> String? {
        
        // Address dictionary
        print(self.addressDictionary)
        
        // Location name
        let locationName = self.addressDictionary?["Name"] as! String!
        print(locationName)
        
        // Street address
        let street = self.addressDictionary?["Thoroughfare"] as! String!
        
        // City
        let city = self.addressDictionary?["City"] as! String!
        
        // Zip code
        let zip = self.addressDictionary?["ZIP"] as! String!
        
        // Country
        let country = self.addressDictionary?["Country"] as! String!
        print(country)
        
        return "\(street), \(city) \(zip)"
        /*
         print("\(self)")
         var LocArray = [""]
         LocArray.removeAll()
         //        if (self.locality != nil
         //            && self.locality?.characters.count > 1) {
         //            LocArray.append(self.locality!)
         //        }
         //        if self.administrativeArea != nil  && self.administrativeArea?.characters.count > 1 {
         //            LocArray.append((self.administrativeArea)!)
         //        }
         //        if self.country != nil  && self.country?.characters.count > 1 {
         //            LocArray.append(self.country!)
         //        }
         
         // Street address
         if self.thoroughfare != nil  && self.thoroughfare?.characters.count > 1 {
         LocArray.append(self.thoroughfare!)
         }
         
         // City
         if self.administrativeArea != nil  && self.administrativeArea?.characters.count > 1 {
         LocArray.append(self.administrativeArea!)
         }
         
         // Zip code
         if self.postalCode != nil  && self.postalCode?.characters.count > 1 {
         LocArray.append(self.postalCode!)
         }
         
         // Country
         if self.country != nil  && self.country?.characters.count > 1 {
         LocArray.append(self.country!)
         }
         
         let locationString = LocArray.joinWithSeparator(", ")
         print("String : \(locationString)")
         return locationString
         */
    }
    
}


extension NSDateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat =  dateFormat
    }
}


extension NSDate {
    struct Formatter {
        //user_upload_time : Format (YYYY-MM-DD HH:MM:SS) 2016-08-02 11:22:11 (24 hours)
        static let custom = NSDateFormatter(dateFormat: "yyyy-MM-dd, HH:mm:ss")
        static let customUTC = NSDateFormatter(dateFormat: "yyyy-MM-dd, HH:mm:ss")
    }
    var strDateInLocal: String {
        //formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)  // you can set GMT time
        //formatter.timeZone = NSTimeZone.localTimeZone()        // or as local time
        return Formatter.custom.stringFromDate(self)
    }
    var strDateInUTC: String {
        Formatter.customUTC.timeZone = NSTimeZone(name: "UTC")
        return Formatter.customUTC.stringFromDate(self)
    }
}

extension String {
    var asDateLocal: NSDate? {
        return NSDate.Formatter.custom.dateFromString(self)
    }
    var asDateUTC: NSDate? {
        NSDate.Formatter.customUTC.timeZone = NSTimeZone(name: "UTC")
        return NSDate.Formatter.customUTC.dateFromString(self)
    }
    func asDateFormatted(with dateFormat: String) -> NSDate? {
        return NSDateFormatter(dateFormat: dateFormat).dateFromString(self)
    }
}

extension NSDate {
    
    func getElapsedInterval() -> String {
        
        var interval = NSCalendar.currentCalendar().components(.Year, fromDate: self, toDate: NSDate(), options: []).year
        
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "year ago" :
                "\(interval)" + " " + "years ago"
        }
        
        interval = NSCalendar.currentCalendar().components(.Month, fromDate: self, toDate: NSDate(), options: []).month
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "month ago" :
                "\(interval)" + " " + "months ago"
        }
        
        interval = NSCalendar.currentCalendar().components(.Day, fromDate: self, toDate: NSDate(), options: []).day
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "day ago" :
                "\(interval)" + " " + "days ago"
        }
        
        interval = NSCalendar.currentCalendar().components(.Hour, fromDate: self, toDate: NSDate(), options: []).hour
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "hour ago" :
                "\(interval)" + " " + "hours ago"
        }
        
        interval = NSCalendar.currentCalendar().components(.Minute, fromDate: self, toDate: NSDate(), options: []).minute
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "minute ago" :
                "\(interval)" + " " + "minutes ago"
        }
        
        return "a moment ago"
    }
}

extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}

extension NSDate {
    static func changeDaysBy(days : Int) -> NSDate {
        let currentDate = NSDate()
        let dateComponents = NSDateComponents()
        dateComponents.day = days
        return NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
    }
    
    static func changeYearsBy(years : Int) -> NSDate {
        let currentDate = NSDate()
        let dateComponents = NSDateComponents()
        dateComponents.year = years
        return NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
    }
}
