//
//  HomeTabView.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/2/27.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI
import UIKit

struct HomeTabView: View {
    @State private var selection = 1
    
//    @EnvironmentObject var socket:HelpAlertSyncSocket
    
    @Binding var user:User
    @Binding var status:String
    @Binding var isSkip:Bool
    @State var iamalerting = false
    @Binding var networkConnected:Bool
    
    init(user:Binding<User>,status:Binding<String>,networkConnected:Binding<Bool>,isSkip:Binding<Bool>){
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = UIColor(named:"Background")
        UITabBar.appearance().tintColor = .clear

        UINavigationBar.appearance().barTintColor = UIColor(named:"Background")
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = UIColor(named:"Background")
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(named: "ThemeColor") as Any]
        
        self._user = user
        self._status = status
        self._networkConnected = networkConnected
        self._isSkip = isSkip
    }
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView(status: $status, user: $user, networkConnected: $networkConnected, isSkip: $isSkip)
            .tabItem {
                Image(systemName: "paperplane")
                    .font(.system(size: 20,weight:.bold))
                Text("快捷入口")
            }.tag(1)
            
            Tips()
            .tabItem {
                Image(systemName: "cube.box")
                        .font(.system(size: 20,weight:.bold))
                Text("急救方法")
            }.tag(2)
//                HelpMap()
//                .tabItem {
//                VStack{
//                    Image(systemName: "heart.circle.fill")
//                        .font(.system(size: 25))
//                    Text("地图")
//                }
//                }.tag(2)
            if networkConnected && !isSkip{
                HelpUserList(user: user,iamalerting:$iamalerting)
                .onAppear(perform: {
                    if let latitude = locationManager.location?.coordinate.latitude{
                        if let longitude = locationManager.location?.coordinate.longitude{
                            self.user.userLocation = UserLocation(User_ID: self.user.userAccount?.User_ID, latitude: "\(latitude)", longitude: "\(longitude)", isAlerting: "1")
                            self.user.checkHelping(checkHelpingCompletionHandler: { _,_ in
                                if self.user.helpingUser != nil{
                                    for helpinguser in self.user.helpingUser!{
                                        if helpinguser.userHealth?.User_ID == self.user.userAccount?.User_ID{
                                            DispatchQueue.main.async{
                                                self.iamalerting = true
                                            }
                                            break
                                        }
                                    }
                                }
                            })
                        }
                    }
                })
                    .tabItem {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 20,weight:.bold))
                        Text("附近求助")
                }.tag(3)
            }
        }.accentColor(Color("ThemeColor"))
    }
}

//struct HomeTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeTabView()
//    }
//}
