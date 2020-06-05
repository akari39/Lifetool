//
//  RegisterPageViewController.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/4/11.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI
import UIKit

//struct RegisterPageViewController: UIViewControllerRepresentable {
//    @Binding var currentPageIndex:Int
//    @Binding var isFirst:Bool
//    @Binding var isLast:Bool
//    @Binding var direction:UIPageViewController.NavigationDirection
//
//    var viewControllers: [UIViewController]
//    
//    func makeUIViewController(context: Context) -> UIPageViewController {
//        let pageViewController = UIPageViewController(
//            transitionStyle: .scroll,
//            navigationOrientation: .horizontal)
//        pageViewController.delegate = context.coordinator
//        return pageViewController
//    }
//    
//    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
//        pageViewController.setViewControllers(
//            [viewControllers[currentPageIndex]], direction: direction, animated: true)
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator:NSObject,UIPageViewControllerDelegate{
//        var parent: RegisterPageViewController
//
//        init(_ pageViewController: RegisterPageViewController) {
//            self.parent = pageViewController
//        }
//        
//        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//            //retrieves the index of the currently displayed view controller
//            guard let index = parent.viewControllers.firstIndex(of: viewController) else {
//                 return nil
//             }
//            
//            //shows the last view controller when the user swipes back from the first view controller
//            if index == 0 {
//                parent.isFirst = true
//                return nil
//            }
//            
//            //show the view controller before the currently displayed view controller
//            return parent.viewControllers[index - 1]
//        }
//        
//        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//                //retrieves the index of the currently displayed view controller
//                guard let index = parent.viewControllers.firstIndex(of: viewController) else {
//                    return nil
//                }
//                //shows the first view controller when the user swipes further from the last view controller
//                if index + 1 == parent.viewControllers.count {
//                    parent.isLast = true
//                    return nil
//                }
//                //show the view controller after the currently displayed view controller
//                return parent.viewControllers[index + 1]
//        }
////        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
////            if completed,
////                let visibleViewController = pageViewController.viewControllers?.first,
////                let index = parent.viewControllers.firstIndex(of:visibleViewController){
////                parent.currentPageIndex = index
////            }
////        }
//    }
//}
