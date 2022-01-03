//
//  String+Extension.swift
//  
//
//  Created by Mukesh Shakya on 03/01/2022.
//

import Foundation

extension String {

    var localized: String {
        let path = Bundle.module.path(forResource: Locale.current.languageCode, ofType: "lproj")
        print("Current package language: \(Locale.current.languageCode)")
        let bundle = Bundle(path: path!)!
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
    
 }
