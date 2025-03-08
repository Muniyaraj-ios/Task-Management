//
//  SearchView.swift
//  Task Management
//
//  Created by MAC on 07/03/25.
//

import UIKit

final class SearchView: BaseView{
    
    lazy var searchTxt: CustomTextField = {
        let tf = CustomTextField()
        tf.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
        tf.configureTextField(placeholder: "Search", placeholderColor: .darkGray, returnType: .search)
        return tf
    }()
    lazy var cancelBtn: CustomButton = {
        let button = CustomButton()
        button.configureButton(title: "Cancel", titleColor: .TextPlumColor, bgColor: .clear)
        return button
    }()
    
    lazy var SearchBtn: CustomIconButton = {
        let button = CustomIconButton()
        button.configureButton(iconName: "text.magnifyingglass")
        return button
    }()
    
    lazy var horiSearchStack = HorizontalStack(arrangedSubViews: [SearchBtn,searchTxt], spacing: 8, alignment: .center, distribution: .fill)
    
    lazy var searchSectionStack = HorizontalStack(arrangedSubViews: [horiSearchStack,cancelBtn], spacing: 16, alignment: .center, distribution: .fill)
    
    lazy var headerLbl: CustomLabel = {
        let label = CustomLabel()
        label.configureLabel(labeltext: "To-do-Task", color: .TextColor, labelfont: .customFont(style: .semiBold, size: 16))
        return label
    }()
    
    lazy var headerSearchBtn: CustomIconButton = {
        let button = CustomIconButton()
        button.configureButton(iconName: "text.magnifyingglass")
        return button
    }()
    
    lazy var moreOptionBtn: CustomIconButton = {
        let button = CustomIconButton()
        button.configureButton(iconName: "ellipsis.circle")
        return button
    }()
    
    lazy var HeaderStack = HorizontalStack(arrangedSubViews: [headerLbl,headerSearchBtn, moreOptionBtn], spacing: 16, alignment: .center, distribution: .fill)
    
    lazy var headerWholeStack = HorizontalStack(arrangedSubViews: [HeaderStack,searchSectionStack], spacing: 16, alignment: .center, distribution: .fill)
    
    weak var searchDelegate: SearchFieldAction?
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    
    private func setupUI(){
        backgroundColor = .systemBackground
        horiSearchStack.layoutMargins = .init(top: 6, left: 6, bottom: 6, right: 4)
        horiSearchStack.isLayoutMarginsRelativeArrangement = true
        horiSearchStack.clipsToBounds = true
        
        searchSectionStack.isHidden = true
        HeaderStack.isHidden = false
        
        headerWholeStack.layoutMargins = .init(top: 5, left: 15, bottom: 5, right: 5)
        headerWholeStack.isLayoutMarginsRelativeArrangement = true
        headerWholeStack.clipsToBounds = true
        
        addSubview(headerWholeStack)
        headerWholeStack.makeConstraints(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor,edge: .init(top: 0, left: 3, bottom: 0, right: 3),height: 55)
        
        cancelBtn.widthConstraints(60)
        headerSearchBtn.equalSizeConstrinats(45)
        SearchBtn.equalSizeConstrinats(30)
        
        headerSearchBtn.addTarget(self, action: #selector(searchActionTriggered(_:)), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(searchActionTriggered(_:)), for: .touchUpInside)
        
        searchTxt.delegate = self
    }
    
    @objc func searchActionTriggered(_ sender: UIButton){
        defer{
            if sender == headerSearchBtn{
                searchTxt.becomeFirstResponder()
                searchDelegate?.beginSearch()
            }
            if sender == cancelBtn{
                searchTxt.text?.removeAll()
                searchTxt.resignFirstResponder()
                searchDelegate?.closeSearch()
            }
        }
        searchSectionStack.isHidden = sender == cancelBtn
        HeaderStack.isHidden = sender == headerSearchBtn
    }
}

extension SearchView: UITextFieldDelegate{
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchDelegate?.clearSearch()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text
        if let newString = text as? NSString{
            let currentString = newString
            searchDelegate?.searchWith(key: currentString as String)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text
        if let newString = text as? NSString{
            let currentString = newString.replacingCharacters(in: range, with: string) as NSString
            searchDelegate?.searchWith(key: currentString as String)
        }
        return true
    }
}
protocol SearchFieldAction: AnyObject{
    func beginSearch()
    func clearSearch()
    func searchWith(key word: String)
    func closeSearch()
}

extension UIView{
    
    func cornerRadiusWithBorder(corner radius: CGFloat = 8,isRound: Bool = false,isBorder: Bool = true,borWidth borderWidth: CGFloat = 1,borColor borderColor: UIColor = .darkGray){
        layer.cornerRadius = isRound ? (layer.frame.height / 2) : radius
        if isBorder{
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor.cgColor
        }
    }
}
