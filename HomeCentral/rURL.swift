//
//  rURL.swift
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 31.05.2018.
//  Copyright © 2018 Ruedi Heimlicher. All rights reserved.
//

import UIKit
import Foundation


class DotColors {
   
   let tsblueColor = UIColor(red:58/255.0, green: 125/255.0, blue: 208/255.0, alpha: 1.0)
   
}

@objc class rURLTask:NSObject
{
   var loadURL:URL?
   var wert:String?
 override init() {}
   
 @objc   public func primer()
   {
      print("primer")
   }
   @objc   public func follower()
   {
      print("follower")
   }

   @objc    public func ladeWert(wert: String?)
   {
      self.wert = wert
      print("ladeWert: (wert)")
   }

   
   
@objc    public func ladeURL(url: URL?){
      self.loadURL = url
   print("loadURL: \(String(describing: loadURL))")}
}
