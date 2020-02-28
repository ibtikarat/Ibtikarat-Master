//
//  TrackingVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 29/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import Segmentio

protocol EventCells {
    func event()
}

enum OrderPageOfTabs :String {
    case new,processing,delivering,completed,rejected
}


class MainOrderVC: UIViewController ,EventCells{

    
    @IBOutlet weak var segmentioView: Segmentio!
    @IBOutlet weak var containerView: UIView!
    
    var newOrderVC :OrderVC! = {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController:OrderVC = storyboard.instanceVC()
        viewController.pageOfTaps = .new

        return viewController
    }()
    
    
     var processingOrderVC :OrderVC! = {
         let storyboard = UIStoryboard(name: "Main", bundle: .main)
         let viewController:OrderVC = storyboard.instanceVC()
         viewController.pageOfTaps = .processing

          return viewController
     }()
    
    var completedOrderVC :OrderVC! = {
         let storyboard = UIStoryboard(name: "Main", bundle: .main)
         let viewController:OrderVC = storyboard.instanceVC()
         viewController.pageOfTaps = .completed

          return viewController
     }()
    
    
      var rejectedOrderVC :OrderVC! = {
           let storyboard = UIStoryboard(name: "Main", bundle: .main)
           let viewController:OrderVC = storyboard.instanceVC()
            viewController.pageOfTaps = .rejected
            return viewController
       }()
      
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        newOrderVC.delegate = self
//        processingOrderVC.delegate = self
//        newOrderVC.delegate = self

        initSegmento()
//        self.navigationController?.navigationBar.backItem?.title = "الطلبات"

        
        self.edgesForExtendedLayout = UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars = false

        self.addViewControllerAsChaildView(childVC: newOrderVC)
        self.addViewControllerAsChaildView(childVC: processingOrderVC)
        self.addViewControllerAsChaildView(childVC: completedOrderVC)
        self.addViewControllerAsChaildView(childVC: rejectedOrderVC)

        // Do any additional setup after loading the view.
    }
 
    
    override func viewWillAppear(_ animated: Bool) {

        

        setBackTitle(title: "my_orders".localized)

//        self.navigationController?.navigationBar.backItem?.title = "الطلبات"
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

    
    func initSegmento(){

           
           let segmentState = SegmentioStates(
               defaultState: SegmentioState(
                   backgroundColor: .clear,
                   titleFont: UIFont(name: "BahijTheSansArabic-SemiBold", size: 10)!,
                   titleTextColor: UIColor.black
               ),
               selectedState: SegmentioState(
                   backgroundColor: .clear,
                   titleFont: UIFont(name: "BahijTheSansArabic-Plain", size: 10)!,
                   titleTextColor: UIColor.CustomColor.primaryColor
               ),
               highlightedState: SegmentioState(
                   backgroundColor: .clear,
                   titleFont: UIFont(name: "BahijTheSansArabic-Plain", size: 10)!,
                   titleTextColor: UIColor.CustomColor.primaryColor
               )
           )
           
        let segmentioIndicatorOptions = SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 2, color: UIColor.CustomColor.primaryColor)
           
           let verticalSeparatorOptions = SegmentioVerticalSeparatorOptions(ratio: 0, color: .clear)
           let horizontalSeparatorOptions  = SegmentioHorizontalSeparatorOptions(type: .none, height: 0, color: .clear)

           let options = SegmentioOptions(
                backgroundColor: UIColor.white ,
               segmentPosition: SegmentioPosition.fixed(maxVisibleItems: 5),
               scrollEnabled: false,
               indicatorOptions: segmentioIndicatorOptions,
               horizontalSeparatorOptions: horizontalSeparatorOptions,
               verticalSeparatorOptions: verticalSeparatorOptions,
               labelTextAlignment: .center,
               segmentStates: segmentState
           )
           
           
           
           let item1 = SegmentioItem(
            title: "news".localized, image: nil
           )
           
           let item2 = SegmentioItem(
               title: "current".localized, image: nil
           )
           
           let item3 = SegmentioItem(
               title: "completed".localized, image: nil
           )
           
           let item4 = SegmentioItem(
               title: "rejected".localized, image: nil
           )
           
           segmentioView.setup(
               content: [item1,item2,item3,item4],
               style: SegmentioStyle.onlyLabel,
               options: options
           )
           
           
           
           segmentioView.valueDidChange = { [weak self] _, segmentIndex in

                self!.newOrderVC.view.isHidden = true
               self!.processingOrderVC.view.isHidden = true
               self!.completedOrderVC.view.isHidden = true
               self!.rejectedOrderVC.view.isHidden = true
            
      
 
            
            
                       if segmentIndex == 0 {
                           self!.newOrderVC.view.isHidden = false
                           self!.newOrderVC.startRequset()
                       }else if segmentIndex == 1{
                           self!.processingOrderVC.view.isHidden = false
                           self!.processingOrderVC.startRequset()
                       }else if segmentIndex == 2{
                           self!.completedOrderVC.view.isHidden = false
                           self!.completedOrderVC.startRequset()
                       }else if segmentIndex == 3{
                           self!.rejectedOrderVC.view.isHidden = false
                           self!.rejectedOrderVC.startRequset()
                       }
            
            
           }
           
           segmentioView.selectedSegmentioIndex = 0


       }
       
    
    func event(){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "RateVC")
        present(vc, animated: true, completion: nil)
    }

    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
}



