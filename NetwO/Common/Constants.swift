//
//  Constants.swift
//  NetwO
//
//  Created by Alain Grange on 07/05/2021.
//

import UIKit

let GetAppDelegate = UIApplication.shared.delegate as? AppDelegate

// colors
let ColorPrimary: UIColor               = UIColor(red:245.0/255.0, green:130.0/255.0, blue:17.0/255.0, alpha:1.0)
let ColorBlueLight: UIColor             = UIColor(red:130.0/255.0, green:202.0/255.0, blue:255.0/255.0, alpha:1.0)
let ColorGrey: UIColor                  = UIColor(red:48.0/255.0, green:48.0/255.0, blue:48.0/255.0, alpha:1.0)
let ColorGreyMedium: UIColor            = UIColor(red:73.0/255.0, green:73.0/255.0, blue:73.0/255.0, alpha:1.0)
let ColorGreyLight: UIColor             = UIColor(red:90.0/255.0, green:90.0/255.0, blue:90.0/255.0, alpha:1.0)
let ColorYellow: UIColor                = UIColor(red:255.0/255.0, green:219.0/255.0, blue:88.0/255.0, alpha:1.0)

let ColorTextGreyLight: UIColor         = UIColor(red:201.0/255.0, green:201.0/255.0, blue:201.0/255.0, alpha:1.0)
let ColorTextGreyLight50: UIColor       = UIColor(red:201.0/255.0, green:201.0/255.0, blue:201.0/255.0, alpha:0.5)
let ColorTextGreyMedium: UIColor        = UIColor(red:136.0/255.0, green:136.0/255.0, blue:136.0/255.0, alpha:1.0)
let ColorTextBlack: UIColor             = UIColor(red:1, green:1, blue:1, alpha:1.0)

struct DefaultsKeys {
    static let marginPerfect = "marginPerfect"
    static let marginGood = "marginGood"
    static let marginBad = "marginBad"
    static let rssiPerfect = "rssiPerfect"
    static let rssiBad = "rssiBad"
    static let snrPerfect = "snrPerfect"
    static let snrBad = "snrBad"
    static let sfNumber = "sfNumber"
    static let frameNumber = "frameNumber"
    static let adr = "adr"
}
