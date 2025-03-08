//
//  AlertHelper.swift
//  Task Management
//
//  Created by MAC on 08/03/25.
//


import UIKit

class AlertHelper {
    static func showCustomAlert(
        on viewController: UIViewController,
        title: String,
        message: String,
        okTitle: String = "OK",
        cancelTitle: String = "Cancel",
        onOk: (() -> Void)? = nil
        //,onCancel: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            onOk?()
        }
        
//        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
//            onCancel?()
//        }
        
        alertController.addAction(okAction)
        //alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
