//
//  CustomTextField.swift
//  Task Management
//
//  Created by MAC on 06/03/25.
//


import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureTextField(placeholder: String, placeholderColor: UIColor = .quaternaryLight, returnType: UIReturnKeyType = .done) {
        
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        smartQuotesType = .no
        smartDashesType = .no
        returnKeyType = returnType
        keyboardType = .default
        clearButtonMode = .whileEditing
        
        font = .customFont(style: .regular, size: 16)
        textColor = .TextColor
        tintColor = .PrimaryColor
        
        setPlaceholder(text: placeholder, font: .customFont(style: .regular, size: 16), color: placeholderColor)
    }
}
