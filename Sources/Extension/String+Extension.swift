//
//  String+Extension.swift
//  
//
//  Created by Mukesh Shakya on 03/01/2022.
//

import Foundation

extension String {

    var localized: String {
        guard let path = Bundle.module.path(forResource: UserDefaults.standard.string(forKey: "LCLCurrentLanguageKey") ?? Locale.current.languageCode, ofType: "lproj") else { return ""}
        guard let bundle = Bundle(path: path) else { return "" }
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
    
 }
