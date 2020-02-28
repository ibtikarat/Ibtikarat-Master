//
//  LayoutButton.swift
//  NGUIButtonInsetsExample
//
//  Created by Abdullah Ayyad on 26/11/2019.
//  Copyright © 2019 Noah Gilmore. All rights reserved.
//

import UIKit

@IBDesignable
class LayoutableButton: UIButton {
    
    var isArabic :Bool {
        get{
            return AppDelegate.shared.language == "ar"
            //return false
        }
    }
    
    
    enum VerticalAlignment : String {
        case center, top, bottom, unset
    }
    
    
    enum HorizontalAlignment : String {
        case center, start, end, unset
    }
    
    
    @IBInspectable
    var imageToTitleSpacing: CGFloat = 8.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    var imageVerticalAlignment: VerticalAlignment = .unset {
        didSet {
            setNeedsLayout()
        }
    }
    
    var imageHorizontalAlignment: HorizontalAlignment = .unset {
        didSet {
            setNeedsLayout()
        }
    }
    
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'imageVerticalAlignment' instead.")
    @IBInspectable
    var imageVerticalAlignmentName: String {
        get {
            return imageVerticalAlignment.rawValue
        }
        set {
            if let value = VerticalAlignment(rawValue: newValue) {
                imageVerticalAlignment = value
            } else {
                imageVerticalAlignment = .unset
            }
        }
    }
    
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'imageHorizontalAlignment' instead.")
    @IBInspectable
    var imageHorizontalAlignmentName: String {
        get {
            return imageHorizontalAlignment.rawValue
        }
        set {
            if let value = HorizontalAlignment(rawValue: newValue) {
                imageHorizontalAlignment = value
            } else {
                imageHorizontalAlignment = .unset
            }
        }
    }
    
    var extraContentEdgeInsets:UIEdgeInsets = UIEdgeInsets.zero
    
    override var contentEdgeInsets: UIEdgeInsets {
        get {
            return super.contentEdgeInsets
        }
        set {
            super.contentEdgeInsets = newValue
            self.extraContentEdgeInsets = newValue
        }
    }
    
    var extraImageEdgeInsets:UIEdgeInsets = UIEdgeInsets.zero
    
    override var imageEdgeInsets: UIEdgeInsets {
        get {
            return super.imageEdgeInsets
        }
        set {
            super.imageEdgeInsets = newValue
            self.extraImageEdgeInsets = newValue
        }
    }
    
    var extraTitleEdgeInsets:UIEdgeInsets = UIEdgeInsets.zero
    
    override var titleEdgeInsets: UIEdgeInsets {
        get {
            return super.titleEdgeInsets
        }
        set {
            super.titleEdgeInsets = newValue
            self.extraTitleEdgeInsets = newValue
        }
    }
    
    //Needed to avoid IB crash during autolayout
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.semanticContentAttribute = .forceLeftToRight
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.semanticContentAttribute = .forceLeftToRight
        
        self.imageEdgeInsets = super.imageEdgeInsets
        self.titleEdgeInsets = super.titleEdgeInsets
        self.contentEdgeInsets = super.contentEdgeInsets
    }
    
    override func layoutSubviews() {
//        self.semanticContentAttribute = .forceLeftToRight
        if let imageSize = self.imageView?.image?.size,
            let font = self.titleLabel?.font,
            let textSize = self.titleLabel?.attributedText?.size() ?? self.titleLabel?.text?.size(withAttributes: [NSAttributedString.Key.font: font]) {
            
            var _imageEdgeInsets = UIEdgeInsets.zero
            var _titleEdgeInsets = UIEdgeInsets.zero
            var _contentEdgeInsets = UIEdgeInsets.zero
            
            let halfImageToTitleSpacing = imageToTitleSpacing / 2.0
            
            switch imageVerticalAlignment {
            case .bottom:
                _imageEdgeInsets.top = (textSize.height + imageToTitleSpacing) / 2.0
                _imageEdgeInsets.bottom = (-textSize.height - imageToTitleSpacing) / 2.0
                _titleEdgeInsets.top = (-imageSize.height - imageToTitleSpacing) / 2.0
                _titleEdgeInsets.bottom = (imageSize.height + imageToTitleSpacing) / 2.0
                _contentEdgeInsets.top = (min (imageSize.height, textSize.height) + imageToTitleSpacing) / 2.0
                _contentEdgeInsets.bottom = (min (imageSize.height, textSize.height) + imageToTitleSpacing) / 2.0
                //only works with contentVerticalAlignment = .center
                contentVerticalAlignment = .center
            case .top:
                _imageEdgeInsets.top = (-textSize.height - imageToTitleSpacing) / 2.0
                _imageEdgeInsets.bottom = (textSize.height + imageToTitleSpacing) / 2.0
                _titleEdgeInsets.top = (imageSize.height + imageToTitleSpacing) / 2.0
                _titleEdgeInsets.bottom = (-imageSize.height - imageToTitleSpacing) / 2.0
                _contentEdgeInsets.top = (min (imageSize.height, textSize.height) + imageToTitleSpacing) / 2.0
                _contentEdgeInsets.bottom = (min (imageSize.height, textSize.height) + imageToTitleSpacing) / 2.0
                //only works with contentVerticalAlignment = .center
                contentVerticalAlignment = .center
            case .center:
                //only works with contentVerticalAlignment = .center
                contentVerticalAlignment = .center
                break
            case .unset:
                break
            }
            
            switch imageHorizontalAlignment {
            case .start:
                if !isArabic {
                    _imageEdgeInsets.left = -halfImageToTitleSpacing
                    _imageEdgeInsets.right = halfImageToTitleSpacing
                    _titleEdgeInsets.left = halfImageToTitleSpacing
                    _titleEdgeInsets.right = -halfImageToTitleSpacing
                    _contentEdgeInsets.left = halfImageToTitleSpacing
                    _contentEdgeInsets.right = halfImageToTitleSpacing
                }else{
                    _imageEdgeInsets.right = -halfImageToTitleSpacing
                    _imageEdgeInsets.left = halfImageToTitleSpacing
                    _titleEdgeInsets.right = halfImageToTitleSpacing
                    _titleEdgeInsets.left = -halfImageToTitleSpacing
                    _contentEdgeInsets.right = halfImageToTitleSpacing
                    _contentEdgeInsets.left = halfImageToTitleSpacing
//
//                    _imageEdgeInsets.left = textSize.width + halfImageToTitleSpacing
//                    _imageEdgeInsets.right = -textSize.width - halfImageToTitleSpacing
//                    _titleEdgeInsets.left = -imageSize.width - halfImageToTitleSpacing
//                    _titleEdgeInsets.right = imageSize.width + halfImageToTitleSpacing
//                    _contentEdgeInsets.left = halfImageToTitleSpacing
//                    _contentEdgeInsets.right = halfImageToTitleSpacing
                }
            case .end:
                if !isArabic {
                    _imageEdgeInsets.left = textSize.width + halfImageToTitleSpacing
                    _imageEdgeInsets.right = -textSize.width - halfImageToTitleSpacing
                    _titleEdgeInsets.left = -imageSize.width - halfImageToTitleSpacing
                    _titleEdgeInsets.right = imageSize.width + halfImageToTitleSpacing
                    _contentEdgeInsets.left = halfImageToTitleSpacing
                    _contentEdgeInsets.right = halfImageToTitleSpacing
                }else{
                  _imageEdgeInsets.right = textSize.width + halfImageToTitleSpacing
                  _imageEdgeInsets.left = -textSize.width - halfImageToTitleSpacing
                  _titleEdgeInsets.right = -imageSize.width - halfImageToTitleSpacing
                  _titleEdgeInsets.left = imageSize.width + halfImageToTitleSpacing
                  _contentEdgeInsets.right = halfImageToTitleSpacing
                  _contentEdgeInsets.left = halfImageToTitleSpacing
                    
//                    _imageEdgeInsets.left = -halfImageToTitleSpacing
//                    _imageEdgeInsets.right = halfImageToTitleSpacing
//                    _titleEdgeInsets.left = halfImageToTitleSpacing
//                    _titleEdgeInsets.right = -halfImageToTitleSpacing
//                    _contentEdgeInsets.left = halfImageToTitleSpacing
//                    _contentEdgeInsets.right = halfImageToTitleSpacing
                }
            case .center:
                if !isArabic {

                _imageEdgeInsets.left = textSize.width / 2.0
                _imageEdgeInsets.right = -textSize.width / 2.0
                _titleEdgeInsets.left = -imageSize.width / 2.0
                _titleEdgeInsets.right = imageSize.width / 2.0
                _contentEdgeInsets.left = -((imageSize.width + textSize.width) - max (imageSize.width, textSize.width)) / 2.0
                _contentEdgeInsets.right = -((imageSize.width + textSize.width) - max (imageSize.width, textSize.width)) / 2.0
                }else{
                    _imageEdgeInsets.right = textSize.width / 2.0
                    _imageEdgeInsets.left = -textSize.width / 2.0
                    _titleEdgeInsets.right = -imageSize.width / 2.0
                    _titleEdgeInsets.left = imageSize.width / 2.0
                    _contentEdgeInsets.right = -((imageSize.width + textSize.width) - max (imageSize.width, textSize.width)) / 2.0
                    _contentEdgeInsets.left = -((imageSize.width + textSize.width) - max (imageSize.width, textSize.width)) / 2.0
                }
            case .unset:
                break
            }
            
            _contentEdgeInsets.top += extraContentEdgeInsets.top
            _contentEdgeInsets.bottom += extraContentEdgeInsets.bottom
            _contentEdgeInsets.left += extraContentEdgeInsets.left
            _contentEdgeInsets.right += extraContentEdgeInsets.right
            
            _imageEdgeInsets.top += extraImageEdgeInsets.top
            _imageEdgeInsets.bottom += extraImageEdgeInsets.bottom
            _imageEdgeInsets.left += extraImageEdgeInsets.left
            _imageEdgeInsets.right += extraImageEdgeInsets.right
            
            _titleEdgeInsets.top += extraTitleEdgeInsets.top
            _titleEdgeInsets.bottom += extraTitleEdgeInsets.bottom
            _titleEdgeInsets.left += extraTitleEdgeInsets.left
            _titleEdgeInsets.right += extraTitleEdgeInsets.right
            
            super.imageEdgeInsets = _imageEdgeInsets
            super.titleEdgeInsets = _titleEdgeInsets
            super.contentEdgeInsets = _contentEdgeInsets
            
        } else {
            super.imageEdgeInsets = extraImageEdgeInsets
            super.titleEdgeInsets = extraTitleEdgeInsets
            super.contentEdgeInsets = extraContentEdgeInsets
        }
        
        super.layoutSubviews()
    }
}
