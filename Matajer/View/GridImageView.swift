//
//  GridImageView.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 27/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class GridImageView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
    var images :[String] = [] {
        didSet{
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    
    
    func updateView(){
        
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        let verticalStackView = UIStackView()
        verticalStackView.distribution = .fillEqually
        verticalStackView.alignment = .fill
        verticalStackView.axis = .vertical
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        
        
        let firstHorizontalStackView = UIStackView()
        firstHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false

        firstHorizontalStackView.axis = .horizontal
        firstHorizontalStackView.alignment = .fill
        firstHorizontalStackView.distribution = .fillEqually
 
        verticalStackView.addArrangedSubview(firstHorizontalStackView)
        
        let secondHorizontalStackView = UIStackView()
        secondHorizontalStackView.clipsToBounds = true
        secondHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        secondHorizontalStackView.axis = .horizontal
        secondHorizontalStackView.distribution = .fillEqually
        secondHorizontalStackView.alignment = .fill
 
        for (index,image) in images.enumerated(){
            if index <= 1 {
                let uiImageView = UIImageView()
                uiImageView.clipsToBounds = true

                uiImageView.sd_setImage(with: URL(string: image)!, completed: nil)
                uiImageView.contentMode = .scaleAspectFit
                firstHorizontalStackView.addArrangedSubview(uiImageView)
            }else if index == 2{
                
                let uiImageView = UIImageView()
                uiImageView.clipsToBounds = true
                uiImageView.contentMode = .scaleAspectFit

                uiImageView.sd_setImage(with: URL(string: image)!, completed: nil)
                verticalStackView.addArrangedSubview(secondHorizontalStackView)
                secondHorizontalStackView.addArrangedSubview(uiImageView)
                if images.count == 3{
                    secondHorizontalStackView.addArrangedSubview(UIView())
                }
            }else if images.count == 4{
                let uiImageView = UIImageView()
                uiImageView.clipsToBounds = true

                uiImageView.contentMode = .scaleAspectFit
                uiImageView.sd_setImage(with: URL(string: image)!, completed: nil)
                secondHorizontalStackView.addArrangedSubview(uiImageView)
                
            }else {
                let darkView = UIView()
                darkView.translatesAutoresizingMaskIntoConstraints = false
                secondHorizontalStackView.addArrangedSubview(darkView)
                
                
                

                let uiImageView = UIImageView()
                uiImageView.clipsToBounds = true

                uiImageView.contentMode = .scaleAspectFit
                uiImageView.sd_setImage(with: URL(string: image)!, completed: nil)
                uiImageView.translatesAutoresizingMaskIntoConstraints = false
                darkView.addSubview(uiImageView)

                NSLayoutConstraint.activate([
                    uiImageView.topAnchor.constraint(equalTo: darkView.topAnchor),
                    uiImageView.bottomAnchor.constraint(equalTo: darkView.bottomAnchor),
                    uiImageView.leadingAnchor.constraint(equalTo: darkView.leadingAnchor),
                    uiImageView.trailingAnchor.constraint(equalTo: darkView.trailingAnchor)
                ])


                
                
                let layerView = UIView()
                layerView.translatesAutoresizingMaskIntoConstraints = false
                layerView.backgroundColor = UIColor.black
                layerView.alpha = 0.5
                
                darkView.addSubview(layerView)

                NSLayoutConstraint.activate([
                    layerView.centerXAnchor.constraint(equalTo: darkView.centerXAnchor),
                    layerView.centerYAnchor.constraint(equalTo: darkView.centerYAnchor),
                                  
                    layerView.widthAnchor.constraint(equalTo: darkView.widthAnchor),
                    layerView.heightAnchor.constraint(equalTo: darkView.heightAnchor)

                ])
                
                
                
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.numberOfLines = 0
                label.textAlignment = .center
                label.textColor = UIColor.white
                label.font = UIFont(name: "BahijTheSansArabic-Plain", size: 11)
                label.text = "+ \(images.count - 3)\n" + "more".localized
                
                darkView.addSubview(label)
                
                
                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: darkView.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: darkView.centerYAnchor),
                    ])

                
              
                
                
                
                break
            }
            
        }
        
        
        self.layoutIfNeeded()
    }
    
}
