//
//  PageControl.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/5/1.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI

struct PageControl:UIViewRepresentable{
    var numberOFPages:Int
    
    @Binding var currentPageIndex: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOFPages
        control.currentPageIndicatorTintColor = UIColor(named: "ThemeColor")
        control.pageIndicatorTintColor = UIColor.gray
        return control
    }
    
    func updateUIView(_ uiView:UIPageControl,context:Context){
        uiView.currentPage = currentPageIndex
    }
}
