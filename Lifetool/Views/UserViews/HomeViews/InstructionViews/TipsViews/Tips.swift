//
//  Tips.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/3/17.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI

struct Tips: View {
    
    init(){
        UITableView.appearance().separatorColor = .clear
        UITableViewCell.appearance().backgroundColor = .none
        UITableView.appearance().backgroundColor = .none
        
        UINavigationBar.appearance().barTintColor = UIColor(named:"Background")
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = UIColor(named: "Background")
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(named: "ThemeColor") as Any]
    }
    
    var body: some View {
        NavigationView{
            Form{
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10).fill(Color(red: 244/255, green: 159/255, blue: 97/255, opacity: 25/100)).frame(height: 60)
                        HStack{
                            Spacer().frame(width:50)
                            Image("CPR").resizable().frame(width: 30, height: 30)
                            Spacer()
                            Text("心肺复苏").font(.system(size: 20))
                                .foregroundColor(Color(red: 244/255, green: 159/255, blue: 97/255)).fontWeight(.bold)
                            Spacer()
                        }
                    }.listRowBackground(Color("Background"))
                    
                    NavigationLink(destination: CPRPageView()){
                            EmptyView()
                        }.frame(width: 0)
                }
                    
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10).fill(Color(red: 244/255, green: 159/255, blue: 97/255, opacity: 25/100)).frame(height: 60)
                        HStack{
                            Spacer().frame(width:50)
                            Image("AED_orange")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(red: 244/255, green: 159/255, blue: 97/255))
                            Spacer()
                            Text("AED使用指南")
                                .foregroundColor(Color(red: 244/255, green: 159/255, blue: 97/255)).font(.system(size: 20)).fontWeight(.bold)
                            Spacer()
                        }
                    }
                    NavigationLink(destination: AEDPageView()){
                            EmptyView()
                        }.frame(width: 0)
                }
            }.background(Color("Background").edgesIgnoringSafeArea(.all))
            .navigationBarTitle("急救方法", displayMode: .inline)
        }
    }
}

struct Tips_Previews: PreviewProvider {
    static var previews: some View {
        Tips()
    }
}
