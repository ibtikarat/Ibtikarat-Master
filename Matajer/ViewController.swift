//
//  ViewController.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 06/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gridImageView :GridImageView!
     
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let images = ["https://premiumaddons.b-cdn.net/wp-content/uploads/2018/01/beautiful-woman-smiles.jpg",
        "https://premiumaddons.b-cdn.net/wp-content/uploads/2018/01/beautiful-woman-smiles.jpg"
        ,"https://premiumaddons.b-cdn.net/wp-content/uploads/2018/01/beautiful-woman-smiles.jpg"
        ,"https://premiumaddons.b-cdn.net/wp-content/uploads/2018/01/beautiful-woman-smiles.jpg"
       ,"https://premiumaddons.b-cdn.net/wp-content/uploads/2018/01/beautiful-woman-smiles.jpg"
             
        ]
        
        
        
        
        gridImageView.images = images
        
  
        
        
        
//        let label = UILabel()
//       // label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = UIColor.red
//        label.text = "hi"
//        
//        
//        let verticalStackView = UIStackView()
//        verticalStackView.distribution = .fillEqually
//        verticalStackView.alignment = .fill
//        verticalStackView.axis = .vertical
//        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        verticalStackView.addArrangedSubview(label)
//        
//        gridImageView.addSubview(verticalStackView)
//        NSLayoutConstraint.activate([
//            verticalStackView.widthAnchor.constraint(equalTo:  gridImageView.widthAnchor),
//            verticalStackView.heightAnchor.constraint(equalTo:  gridImageView.heightAnchor),
//            
//            verticalStackView.centerXAnchor.constraint(equalTo:  gridImageView.centerXAnchor),
//            verticalStackView.centerYAnchor.constraint(equalTo:  gridImageView.centerYAnchor),
//                
//            ])
            
        
        
    }


}

