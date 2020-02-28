//
//  MainVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 07/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import Segmentio
class MainVC: UIViewController {
    
    static let goToFirstTapInHome =  NSNotification.Name("goToFirstTapInHome")
    var observer :Any!

     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent 
     }
    
    @IBOutlet weak var segmentioView: Segmentio!

    
    
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var searchTF: UITextField!

    var mainPageVC :MainPageVC! = {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController:MainPageVC = storyboard.instanceVC()
         return viewController
    }()
    
    
    
    var offersPageVC :MostRequestPageVC! = {
          let storyboard = UIStoryboard(name: "Main", bundle: .main)
          let viewController:MostRequestPageVC = storyboard.instanceVC()
           viewController.pageOfTaps = .offers
          return viewController
      }()
      
      
    var mostRequestPageVC :MostRequestPageVC! = {
         let storyboard = UIStoryboard(name: "Main", bundle: .main)
         let viewController:MostRequestPageVC = storyboard.instanceVC()
        viewController.pageOfTaps = .mostRequset

         return viewController
     }()
     
    
    var recentlyPageVC :MostRequestPageVC! = {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController:MostRequestPageVC = storyboard.instanceVC()
        viewController.pageOfTaps = .recentlyArrived

        return viewController
    }()
    
    
    
    var marketPageVC :MarketPageVC! = {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController:MarketPageVC = storyboard.instanceVC()
        return viewController
    }()
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSegmento()
        // Do any additional setup after loading the view.
        //
        self.addViewControllerAsChaildView(childVC: mainPageVC)
        self.addViewControllerAsChaildView(childVC: mostRequestPageVC)
        self.addViewControllerAsChaildView(childVC: recentlyPageVC)
        self.addViewControllerAsChaildView(childVC: offersPageVC)

        self.addViewControllerAsChaildView(childVC: marketPageVC)

        
        //leftView(uiImage: #imageLiteral(resourceName: "ic_profile_saudi_ar"))
    }
    
    
    
    private func addViewControllerAsChaildView(childVC :UIViewController){
        self.addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        childVC.didMove(toParent: childVC)
    }
    
    
    private func removeViewControllerAsChaildView(childVC :UIViewController){
        childVC.willMove(toParent: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
        
        self.addChild(childVC)
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        observer =  NotificationCenter.default.addObserver(forName: MainVC.goToFirstTapInHome, object: nil, queue: nil) { (notification) in
            self.segmentioView.selectedSegmentioIndex = 0
             }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          NotificationCenter.default.removeObserver(observer)
          
      }
    
    
    

    
    func initSegmento(){

        
        
        let segmentState = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont(name: "SSTArabic-Medium", size: 10)!,
                titleTextColor: #colorLiteral(red: 0.7372105013, green: 0.7372105013, blue: 0.7372105013, alpha: 1)
            ),
            selectedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont(name: "SSTArabic-Medium", size: 10)!,
                titleTextColor: .white
            ),
            highlightedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont(name: "SSTArabic-Medium", size: 10)!,
                titleTextColor: .white
            )
        )
        
        let segmentioIndicatorOptions = SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 2, color: .white)
        
        let verticalSeparatorOptions = SegmentioVerticalSeparatorOptions(ratio: 0, color: .clear)
        

        let options = SegmentioOptions(
            backgroundColor: UIColor(rgb: 0x595BB5)  ,
            segmentPosition: SegmentioPosition.fixed(maxVisibleItems: 5),
            scrollEnabled: false,
            indicatorOptions: segmentioIndicatorOptions,
            verticalSeparatorOptions: verticalSeparatorOptions,
            labelTextAlignment: .center,
            labelTextNumberOfLines: 1,
            segmentStates: segmentState
        )
        
        
        
        let item1 = SegmentioItem(
            title: "main".localized , image: nil
        )
        
        let item2 = SegmentioItem(
            title: "most_order".localized, image: nil
        )
        
        let item3 = SegmentioItem(
            title: "offers".localized, image: nil
        )
        
        let item4 = SegmentioItem(
            title: "news".localized, image: nil
        )
        
        let item5 = SegmentioItem(
            title: "brand".localized , image: nil
        )
        
        
        segmentioView.setup(
            content: [item1,item2,item3,item4,item5],
            style: SegmentioStyle.onlyLabel,
            options: options
        )
        
        
        
        segmentioView.valueDidChange = { [weak self] _, segmentIndex in
            self!.mainPageVC.view.isHidden = true
            self!.marketPageVC.view.isHidden = true
            
            self!.mostRequestPageVC.view.isHidden = true
            self!.offersPageVC.view.isHidden = true
            self!.recentlyPageVC.view.isHidden = true

             if segmentIndex == 0 {
                self!.mainPageVC.view.isHidden = false
             }else if segmentIndex == 4 {
                self!.marketPageVC.view.isHidden = false
                self!.marketPageVC.startRequset()
             }else{
                
                if segmentIndex == 1 {
                    self!.mostRequestPageVC.view.isHidden = false
                    self!.mostRequestPageVC.startRequset()
                }else if segmentIndex == 2{
                    self!.offersPageVC.view.isHidden = false
                    self!.offersPageVC.startRequset()
                }else if segmentIndex == 3{
                    self!.recentlyPageVC.view.isHidden = false
                    self!.recentlyPageVC.startRequset()
                }
                

                
            }
        }
        
        segmentioView.selectedSegmentioIndex = 0


    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
  
    
  
}

