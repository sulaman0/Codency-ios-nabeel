//
//  UIViewExtension.swift
//  Codency
//
//  Created by Nabeel Nazir on 21/11/2023.
//

import UIKit

extension UIView {
    public func layoutIfNeededWithAnimation(duration: TimeInterval?){
        UIView.animate(withDuration: duration ?? 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    public func getConstriant(identifier: String) -> NSLayoutConstraint?{
        for constraint in self.constraints {
            if constraint.identifier == identifier{
                return constraint
            }
        }
        return nil
    }
    
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    @IBInspectable public  var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable public var circle: Bool{
        get{
            return false
        }
        set{
            if newValue{
                layer.cornerRadius = frame.width*0.5
                layer.masksToBounds = true
            }
            
        }
    }
    
    // MARK: - Shadow
    @IBInspectable
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    public var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    public func fadeIn(duration: TimeInterval = 0.3, isWithInStackView: Bool = false){
        guard isWithInStackView else {
            UIView.animate(withDuration: duration) {
                self.alpha = 1
            }
            return
        }
        
        UIView.animate(withDuration: duration) {
            self.isHidden = false
        }
    }
    
    public func fadeOut(duration: TimeInterval = 0.3, isWithInStackView: Bool = false){
        
        guard isWithInStackView else {
            UIView.animate(withDuration: duration) {
                self.alpha = 0
            }
            return
        }
        
        UIView.animate(withDuration: duration) {
            self.isHidden = true
        }
    }
    
    /// Adds shadow to view, sets shadowOpacity to 0.16, set shadowOffer to CGSize(width: 0, height: 3) and radius to 3.
    public func dropShadow(scale: Bool = true , color: CGColor? = UIColor(named: "ThemeColor")?.withAlphaComponent(0.7).cgColor , shadowRadius: CGFloat = 10, shadowOffset: CGSize = CGSize(width: 0, height: 3)) {
        layer.masksToBounds = false
        layer.shadowColor = color
        layer.shadowOpacity = 0.9
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
    }
    
    public func dropShadowWithBezierPath(scale: Bool = true , color: CGColor? = UIColor(named: "ThemeColor")!.cgColor , shadowRadius: CGFloat = 5, shadowOffset: CGSize = CGSize(width: 10, height: 10)) {
        let shadowSize: CGFloat = 10
        let shadowDistance: CGFloat = 10
        let contactRect = CGRect(x: shadowSize, y: frame.size.height - (shadowSize * 0.4) + shadowDistance, width: frame.size.width - (shadowSize * 2), height: shadowSize)
        layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowColor = color
    }
    
    //Responsible to load NibFiles
    public class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
