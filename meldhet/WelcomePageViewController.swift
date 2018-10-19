//
//  PageViewController.swift
//  meldhet
//
//  Created by Sascha Worms on 18/10/2018.
//  Copyright © 2018 cheesycode.com. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newNumberedViewController(number: "1"),
                self.newNumberedViewController(number: "2"),
                self.newNumberedViewController(number: "3"),
                self.newNumberedViewController(number: "4")]
    }()
    
    var pageControl = UIPageControl()

    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x:  (UIScreen.main.bounds.maxX -  (UIScreen.main.bounds.maxX/2)) - 25,y: UIScreen.main.bounds.maxY - 50,width: 50,height: 50))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.alpha = 0.5
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        dataSource = self
        configurePageControl()

        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    

    

    
    private func newNumberedViewController(number: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "Welcome\(number)ViewController")
    }
    
    public func nextView(){
        print("NEXT")
        guard let currentViewController = self.viewControllers?.first else { return }
        
        guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }
        
        setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)
        self.pageControl.currentPage = orderedViewControllers.index(of: nextViewController)!
    }
    
    public func skip(){
        print("SKIP")
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainViewController") as! ViewController
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            skip()
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }

}
