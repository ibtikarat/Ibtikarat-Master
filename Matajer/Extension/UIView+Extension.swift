//
//  UIView.swift
//  SmartSafty
//
//  Created by Abdullah Ayyad on 10/18/19.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setRounded() {
        let radius = self.frame.height / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func setRounded(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        var corners = corners
        

         if AppDelegate.shared.language == "ar" {
             if corners == [.topLeft,.bottomLeft] {
             corners = [.topRight,.bottomRight]
             
             }else if corners == [.topRight,.bottomRight]{
             corners = [.topLeft,.bottomLeft]
             }
         }

        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func setBorderGray() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
    
    func setBorder(width:CGFloat,color:UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], gradientOrientation orientation: GradientOrientation) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
        //self.layoutSubviews()
        layoutIfNeeded()

    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    
    // OUTPUT 1
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.layer.shadowOpacity = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 2, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addShadowView(color:UIColor,width:Int,height:Int,Opacity:Float,radius:CGFloat,cornerRadius:CGFloat,alpha:CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowOpacity = Opacity
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius
    }

    
    
    typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)
    
    enum GradientOrientation {
        case topRightBottomLeft
        case topLeftBottomRight
        case horizontal
        case vertical
        
        var startPoint : CGPoint {
            get { return points.startPoint }
        }
        
        var endPoint : CGPoint {
            get { return points.endPoint }
        }
        
        var points : GradientPoints {
            get {
                switch(self) {
                case .topRightBottomLeft:
                    return (CGPoint.init(x: 0.0,y: 1.0), CGPoint.init(x: 1.0,y: 0.0))
                case .topLeftBottomRight:
                    return (CGPoint.init(x: 0.0,y: 0.0), CGPoint.init(x: 1,y: 1))
                case .horizontal:
                    return (CGPoint.init(x: 0.0,y: 0.5), CGPoint.init(x: 1.0,y: 0.5))
                case .vertical:
                    return (CGPoint.init(x: 0.0,y: 0.0), CGPoint.init(x: 0.0,y: 1.0))
                }
            }
        }
    }
    
    
    
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    
    
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    
    
    func flipView(){
        self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    
    
    
    func instanceView<T: UIView>() -> T {
        
        guard let view = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil) as? T else {
            fatalError("Could not locate View with with identifier \(String(describing: T.self)) in Your Project.")
        }
        return view
    }
    
    
    enum Visibility {
            case visible
            case invisible
            case gone
        }

        var visibility: Visibility {
            get {
                let constraint = (self.constraints.filter{$0.firstAttribute == .height && $0.constant == 0}.first)
                if let constraint = constraint, constraint.isActive {
                    return .gone
                } else {
                    return self.isHidden ? .invisible : .visible
                }
            }
            set {
                if self.visibility != newValue {
                    self.setVisibility(newValue)
                }
            }
        }

        private func setVisibility(_ visibility: Visibility) {
            let constraint = (self.constraints.filter{$0.firstAttribute == .height && $0.constant == 0}.first)
            let constraintW = (self.constraints.filter{$0.firstAttribute == .width && $0.constant == 0}.first)

            switch visibility {
            case .visible:
                constraint?.isActive = false
                constraintW?.isActive = false
                self.isHidden = false
                break
            case .invisible:
                constraint?.isActive = false
                constraintW?.isActive = false
                self.isHidden = true
                break
            case .gone:
                if let constraint = constraint {
                    constraint.isActive = true
                    constraintW!.isActive = true
                } else {
                    let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
                    self.addConstraint(constraint)
                    
                    
                    let constraintW = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
                                     self.addConstraint(constraint)
                    
                    
                    self.addConstraint(constraintW)

                    constraint.isActive = true
                    constraintW.isActive = true
                }
            }
        }
    

    
    
    
//    
//    update
//    let layer = self.layer as! CAGradientLayer
//    layer.colors = [firstColor, secondColor].map{$0.cgColor}
//    if (sef.isHorizontal) {
//    layer.startPoint = CGPoint(x: 0, y: 0.5)
//    layer.endPoint = CGPoint (x: 1, y: 0.5)
//    } else {
//    layer.startPoint = CGPoint(x: 0.5, y: 0)
//    layer.endPoint = CGPoint (x: 0.5, y: 1)
//    }
//    
    
}


