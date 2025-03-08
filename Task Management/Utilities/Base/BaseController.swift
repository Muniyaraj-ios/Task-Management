//
//  BaseController.swift
//  Task Management
//
//  Created by MAC on 04/03/25.
//

import UIKit

class BaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        hideKeyboardWhenTappedAround()
    }
    
    deinit{
        debugPrint("\(String(describing: Self.self)) has deinitalized")
    }
}

extension BaseController{
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(BaseController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension BaseController{
    
    enum AlerSetup : String{
        case notification
        case location
        
        func title() -> String{
            switch self{
            case .notification:
                return "Notification Alert"
            case .location:
                return "Location Permission"
            }
        }
        
        func message() -> String{
            switch self{
            case .notification:
                return "Are you sure you didn't receive any notification"
            case .location:
                return "We don't have access to location service on Task ManageMent. Please go to settings and enable location services"
            }
        }
        func yestitle() -> String{
            switch self{
            case .notification,.location:
                return "Settings"
            }
        }
        func notitle() -> String{
            switch self{
            case .notification,.location:
                return "Not now"
            }
        }
    }
}
