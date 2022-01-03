//
//  String+Extension.swift
//  
//
//  Created by Mukesh Shakya on 03/01/2022.
//

import Foundation

extension String {

    var localized: String {
        let path = Bundle.module.path(forResource: "ja", ofType: "lproj")
        print("Current package language: \(Locale.current.languageCode)")
        print("Current device language in package: \(UserDefaults.standard.string(forKey: "LCLCurrentLanguageKey"))")
        let bundle = Bundle(path: path!)!
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
    
 }
