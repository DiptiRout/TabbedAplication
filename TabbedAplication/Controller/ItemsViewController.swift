//
//  ItemsViewController.swift
//  TabbedAplication
//
//  Created by Muvi on 30/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController  {

    @IBOutlet weak var segmentController: CustomSegmentedController!
    
    private var pageController: UIPageViewController!
    private var arrVC:[UIViewController] = []
    private var currentPage: Int!
    
    // MARK: All ViewController
    lazy var vc1: ItemSegmentViewController = {
        
        
        var viewController = storyboard?.instantiateViewController(withIdentifier: "ItemsSegmentVC") as! ItemSegmentViewController
        viewController.segmentSelection = 0
        return viewController
    }()
    
    // MARK: cat-A ViewController
    
    lazy var vc2: ItemSegmentViewController = {
        
        var viewController = storyboard?.instantiateViewController(withIdentifier: "ItemsSegmentVC") as! ItemSegmentViewController
        viewController.segmentSelection = 1
        return viewController
    }()
    
    // MARK: cat-B ViewController
    
    lazy var vc3: ItemSegmentViewController = {
        
        var viewController = storyboard?.instantiateViewController(withIdentifier: "ItemsSegmentVC") as! ItemSegmentViewController
        viewController.segmentSelection = 2
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegment()
        currentPage = 0
        createPageViewController()

        arrVC.append(vc1)
        arrVC.append(vc2)
        arrVC.append(vc3)
    }
    
    func setupSegment() {
        
        segmentController.backgroundColor = .white
        segmentController.commaSeperatedButtonTitles = "All, Catagory A, Catagory B"
        segmentController.addTarget(self, action: #selector(onChangeOfSegment(_:)), for: .valueChanged)
        
        self.view.addSubview(segmentController)
        
    }

    //MARK: - CreatePagination
    
    private func createPageViewController() {
        
        pageController = UIPageViewController.init(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        
        pageController.view.backgroundColor = UIColor.clear
        pageController.delegate = self
        pageController.dataSource = self
        
        for svScroll in pageController.view.subviews as! [UIScrollView] {
            svScroll.delegate = self
        }
        self.addChild(pageController)
        self.view.addSubview(pageController.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pageController.view.anchor(self.segmentController.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            
        }
        pageController.setViewControllers([vc1], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
        pageController.didMove(toParent: self)
    }
    
    private func indexofviewController(viewCOntroller: UIViewController) -> Int {
        if(arrVC .contains(viewCOntroller)) {
            return arrVC.index(of: viewCOntroller)!
        }
        
        return -1
    }
    
    @objc func onChangeOfSegment(_ sender: CustomSegmentedController) {
        
        
        switch sender.selectedSegmentIndex {
        case 0:
            pageController.setViewControllers([arrVC[0]], direction: UIPageViewController.NavigationDirection.reverse, animated: true, completion: nil)
            currentPage = 0
            
        case 1:
            if currentPage > 1{
                pageController.setViewControllers([arrVC[1]], direction: UIPageViewController.NavigationDirection.reverse, animated: true, completion: nil)
                currentPage = 1
            }else{
                pageController.setViewControllers([arrVC[1]], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
                currentPage = 1
                
            }
        case 2:
            if currentPage < 2 {
                pageController.setViewControllers([arrVC[2]], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
                currentPage = 2
                
                
            }else{
                pageController.setViewControllers([arrVC[2]], direction: UIPageViewController.NavigationDirection.reverse, animated: true, completion: nil)
                currentPage = 2
                
            }
        default:
            break
        }
        
        
    }
}

//MARK: - Pagination Delegate Methods

extension ItemsViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index - 1
        }
        
        if(index < 0) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index + 1
        }
        
        if(index >= arrVC.count) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController1: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if(completed) {
            currentPage = arrVC.index(of: (pageViewController1.viewControllers?.last)!)
            // self.segmentedControl.selectedSegmentIndex = currentPage
            
            self.segmentController.updateSegmentedControlSegs(index: currentPage)
            
        }
        
    }
    
    
}

