//
//  UIView+Ext.swift
//  Task Management
//
//  Created by MAC on 04/03/25.
//

import UIKit

extension UIView{
    
    func makeEdgeConstrains(toView parentView: UIView,edge const: UIEdgeInsets = .zero,isSafeArea: Bool = false){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: isSafeArea ? parentView.safeAreaLayoutGuide.topAnchor : parentView.topAnchor, constant: const.top).isActive = true
        leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: const.left).isActive = true
        trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -const.right).isActive = true
        bottomAnchor.constraint(equalTo: isSafeArea ? parentView.safeAreaLayoutGuide.bottomAnchor : parentView.bottomAnchor, constant: -const.bottom).isActive = true
    }
    
    @discardableResult
    func makeConstraints(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, edge: UIEdgeInsets = .zero, width: CGFloat? = nil, height: CGFloat? = nil)-> AnchoredConstaraints{
        translatesAutoresizingMaskIntoConstraints = false
        var anchor = AnchoredConstaraints()
        
        if let top{
            anchor.top = topAnchor.constraint(equalTo: top, constant: edge.top)
        }
        if let leading{
            anchor.leading = leadingAnchor.constraint(equalTo: leading, constant: edge.left)
        }
        if let trailing{
            anchor.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -edge.right)
        }
        if let bottom{
            anchor.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -edge.bottom)
        }
        if let width{
            anchor.width = widthAnchor.constraint(equalToConstant: width)
        }
        if let height{
            anchor.height = heightAnchor.constraint(equalToConstant: height)
        }
        [anchor.top,anchor.leading,anchor.trailing,anchor.bottom,anchor.width,anchor.height].forEach{ $0?.isActive = true }
        return anchor
        
    }
    
    struct AnchoredConstaraints{
        var top,leading,trailing,bottom,width,height: NSLayoutConstraint?
    }
    
    func makeWidthHeightMultiplier(toView view: UIView,width: CGFloat,height: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: width).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: height).isActive = true
    }
    
    func makeViewMultiplierWidth(toView view: UIView,width: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: width).isActive = true
    }
    
    func makeViewMultiplierHeight(toView view: UIView,height: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: height).isActive = true
    }
    
    func makeCenterConstraints(toView view: UIView,xConst: CGFloat = 0,yConst: CGFloat = 0,isCenterX: Bool = true, isCenterY: Bool = true){
        translatesAutoresizingMaskIntoConstraints = false
        if isCenterX{
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: xConst).isActive = true
        }
        if isCenterY{
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConst).isActive = true
        }
    }
    
    func makeCenterContraints(toView view: UIView, centerX: Bool, centerY: Bool){
        translatesAutoresizingMaskIntoConstraints = false
        if centerX{
            //centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        if centerY{
            //centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    func sizeConstraints(width: CGFloat, height: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func equalSizeConstrinats(_ const: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: const).isActive = true
        heightAnchor.constraint(equalToConstant: const).isActive = true
    }
    
    func widthConstraints(_ const: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: const).isActive = true
    }
    
    func heightConstraints(height: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}


extension UITextField {
    func setPlaceholder(text: String, font: UIFont, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: color
            ]
        )
    }
}

class CircleView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeCircle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeCircle()
    }
    
    private func makeCircle(){
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 0.8
        layer.borderColor = UIColor.darkGray.cgColor
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeCircle()
    }
}
