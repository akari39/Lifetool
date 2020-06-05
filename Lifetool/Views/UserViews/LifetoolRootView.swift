//
//  LifetoolRootView.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/4/11.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI

struct AppRootView: View {
    @State var status:String = "HomeTabView"
    @State var user = User()
    
    @State var isSkip = false
    
    @State var networkConnected = false
    @State var autoLoginfailed = false
    init(){
        let network: NetworkManager = NetworkManager.sharedInstance
        user.read()
    }
    
    var body: some View {
        Group {
            if status == "Login" {
                Login(status:$status, user:$user, isSkip: $isSkip)
            } else if status == "Register" {
                Register(status: $status, user: $user, isSkip: $isSkip)
            } else {
                HomeTabView(user: $user,status:$status,networkConnected:$networkConnected,isSkip:$isSkip)
            }
        }
        .alert(isPresented: $autoLoginfailed){
            Alert(title: Text("登录失败！"), message: Text(""), dismissButton: .default(Text("好")))
        }
        .onAppear(perform: {
            NetworkManager.isReachable { _ in
                DispatchQueue.main.async {
                    self.networkConnected = true
                    self.isSkip = true
                    if self.user.isExist! {
                        self.user.login(loginCompletionHandler: { accountExist,execSuccessfully in
                            if accountExist && execSuccessfully {
                                DispatchQueue.main.async {
                                    self.status = "HomeTabView"
                                    self.isSkip = false
                                }
                            } else {
                                self.autoLoginfailed = true
                            }
                        })
                    } else {
                        self.status = "Login"
                    }
                }
            }
            
            NetworkManager.isUnreachable(completed: { _ in
                DispatchQueue.main.async {
                    self.status = "HomeTabView"
                }
            })
        })
    }
}
