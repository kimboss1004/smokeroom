//
//  Helper.swift
//  smokeroom
//
//  Created by Austin Kim on 7/18/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase


class Helper {
    static var shared = Helper()
    static var currentUser: User = User()
    
    func showOKAlert(title: String, message: String, viewController: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true)
    }
    
    func switchStoryboard(vc: UIViewController){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
    }
    
    func getDate() -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
 
        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        //let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        //formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        //let myStringafd = formatter.string(from: yourDate!)

        return myString
    }
    
    func formatStringToUserTime(stringDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: stringDate){
            dateFormatter.dateFormat = "h:mm a"
            let elapsedTimeInSeconds = Date().timeIntervalSince(date)
            let secondInDays: TimeInterval = 60 * 60 * 24
            if elapsedTimeInSeconds > 7 * secondInDays {
                dateFormatter.dateFormat = "MM/dd/yy"
            } else if elapsedTimeInSeconds > secondInDays {
                dateFormatter.dateFormat = "EEE"
            }
            return dateFormatter.string(from: date)
        }
        return dateFormatter.string(from: Date())
    }
    
    func DateComparisonFormat(stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: stringDate)!
    }
    
    func extract_tags(text: String) -> [String] {
        let string = text as NSString
        if let regex = try? NSRegularExpression(pattern: "@[a-z0-9]+", options: .caseInsensitive) {
            return regex.matches(in: string as String, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range).replacingOccurrences(of: "@", with: "").lowercased()
            }
        }
        return []
    }

    
}
