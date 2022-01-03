//
//  ViewController.swift
//  Example
//
//  Created by Mukesh Shakya on 03/01/2022.
//

import UIKit
import ImagePicker

class ViewController: UIViewController {
    
    //MARK: Properties
    private var imagePicker: ImagePicker?
    
    //MARK: Outlets
    @IBOutlet weak var imageView: UIImageView?

    //MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    //MARK: IBActions
    @IBAction func chooseImageTapped(_ sender: UIButton) {
        imagePicker?.present(from: view)
    }
    
    //MARK: Other functions
    private func setup() {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }

}

//MARK: ImagePickerDelegate
extension ViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if let image = image {
            imageView?.image = image
        }
    }
    
}
