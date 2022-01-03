//
//  UIViewController+Extension.swift
//  
//
//  Created by Mukesh Shakya on 03/01/2022.
//

import UIKit.UIViewController

//MARK: iOS 13
extension UIViewController {
    
    func presentFullScreen(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        if #available(iOS 13.0, *) {
            viewController.modalPresentationStyle = .fullScreen
        }
        present(viewController, animated: animated, completion: completion)
    }
    
}
