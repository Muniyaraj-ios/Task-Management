//
//  PlaceholderTextView.swift
//  Task Management
//
//  Created by MAC on 07/03/25.
//

import UIKit

@IBDesignable class PlaceholderTextView: UITextView {

    @IBInspectable var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    @IBInspectable var returnKeyboardType: UIReturnKeyType = .done {
        didSet {
            placeholderLabel.text = placeholder
            returnKeyType = returnKeyboardType
        }
    }

    var placeholderLabel: CustomLabel = {
        let label = CustomLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureLabel(labeltext: "", color: .quaternaryLight)
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        smartQuotesType = .no
        smartDashesType = .no
        smartDashesType = .no
        returnKeyType = returnKeyboardType
        
        placeholder = "Enter Task Description"
        placeholderLabel.text = "Enter Task Detail"
        
        keyboardType = .default
        
        font = .customFont(style: .regular, size: 16)
        textColor = .TextColor
        backgroundColor = .clear
        
        tintColor = .PrimaryColor

        addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])

        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }

    @objc func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }

}
