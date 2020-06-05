//
//  HomeView.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/2/24.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit
import CoreLocation

struct HomeView: View {

    @State var distance = [String:MedicalAnnotation]()
    
    @State private var userTrackingMode: MKUserTrackingMode = .none
    @State var showingDetail = false
    
    @Binding var status:String
    @Binding var user:User
    @Binding var networkConnected:Bool
    @Binding var isSkip:Bool
    
    @State var refreshed:Bool = false
    @State var firstOpened:Bool = false
    
    @State var statusToChange:String = "HomeTabView"
    
    var body: some View {
        
        NavigationView{
            VStack{
                    ZStack(alignment: .bottomTrailing){
                        MapView(distance:$distance, userTrackingMode: $userTrackingMode,refreshed: $refreshed)
                        VStack{
                            Button(action: {
                                self.userTrackingMode = .follow
                            }) {
                                ZStack{
                                    Color("ThemeColor")
                                        .frame(width: 45, height: 45)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(radius: 2.0)
                                    Image(systemName: "location.fill")
                                        .foregroundColor(Color.white)
                                        .font(.headline)
                                }
                            }
                        }.padding()
                    }
                QuickNavigation(distance: $distance, user: $user, networkConnected: $networkConnected)
                    Spacer()
                    }.background(Color("Background")
                        .edgesIgnoringSafeArea(.all))

            .navigationBarTitle(Text("首页"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                        self.showingDetail = true
                }) {
                        Image(systemName: "person.crop.circle.fill").font(.title)
                }.sheet(isPresented: $showingDetail){
                    UserInfoSheet(user: self.$user, status: self.$statusToChange, isSkip: self.$isSkip, showSheet: self.$showingDetail)
                        .onDisappear{
                        self.status = self.statusToChange
                    }
            })
        }.onAppear(perform: {
            if self.firstOpened{
                self.refreshed = true
            }
            self.firstOpened = true
        })
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
