//
//  ImagePicker.swift
//
//
//  Created by Mukesh Shakya on 03/01/2022.
//

import UIKit.UIImagePickerController
import Photos

@available(iOS 10.0, *)
public class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        pickerController = UIImagePickerController()
        super.init()
        self.presentationController = presentationController
        self.delegate = delegate
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
    }
    
    @available(iOS 10.0, *)
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        
        enum PermissionType {
            case camera
            case library
            
            var message: String {
                switch self {
                case .camera:
                    return GlobalConstants.Localization.camera_required
                case .library:
                    return GlobalConstants.Localization.library_required
                }
            }
            
            var allowTitle: String {
                return GlobalConstants.Localization.settings
            }
        }

        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            
            func alertToEncourageAccessInitially(for type: PermissionType) {
                let alert = UIAlertController(
                    title: GlobalConstants.Localization.important,
                    message: type.message,
                    preferredStyle: UIAlertController.Style.alert
                )
                alert.addAction(UIAlertAction(title: GlobalConstants.Localization.cancel, style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: type.allowTitle, style: .default, handler: { (alert) -> Void in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }))
                presentationController?.presentFullScreen(alert, animated: true)
            }
            
            pickerController.sourceType = type
            switch type {
            case .photoLibrary:
                let photoStatus = PHPhotoLibrary.authorizationStatus()
                switch photoStatus {
                case .notDetermined:
                    PHPhotoLibrary.requestAuthorization({ status in
                        switch status {
                        case .denied:
                            alertToEncourageAccessInitially(for: .library)
                        case .authorized:
                            DispatchQueue.main.async { [weak self] in
                                self?.presentationController?.presentFullScreen(pickerController, animated: true)
                            }
                        case .limited,
                             .notDetermined,
                             .restricted:
                            break
                        @unknown default:
                            break
                        }
                    })
                    return
                case .denied:
                    alertToEncourageAccessInitially(for: .library)
                case .limited,
                     .restricted:
                    break
                case .authorized:
                    presentationController?.presentFullScreen(self.pickerController, animated: true)
                @unknown default:
                    break
                }
            case .camera:
                let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                switch authStatus {
                case .authorized: break
                case .denied:
                    alertToEncourageAccessInitially(for: .camera)
                    return
                case .notDetermined: break
                default: break
                }
            case .savedPhotosAlbum: break
            @unknown default:
                break
            }
            presentationController?.presentFullScreen(pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
        if let action = self.action(for: .camera, title: GlobalConstants.Localization.take_photo) {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: GlobalConstants.Localization.camera_roll) {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: GlobalConstants.Localization.photo_library) {
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: GlobalConstants.Localization.cancel, style: .cancel, handler: nil))
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        presentationController?.presentFullScreen(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        delegate?.didSelect(image: image)
    }
    
}

//MARK: UIImagePickerControllerDelegate
@available(iOS 10.0, *)
extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return pickerController(picker, didSelect: nil)
        }
        pickerController(picker, didSelect: image)
    }
    
}

//MARK: UINavigationControllerDelegate
@available(iOS 10.0, *)
extension ImagePicker: UINavigationControllerDelegate { }
