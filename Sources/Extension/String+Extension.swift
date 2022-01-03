//
//  String+Extension.swift
//  
//
//  Created by Mukesh Shakya on 03/01/2022.
//

import Foundation

extension String {

    var localized: String {
        return NSLocalizedString(self, bundle: .main, comment: "")
    }
    
 }
