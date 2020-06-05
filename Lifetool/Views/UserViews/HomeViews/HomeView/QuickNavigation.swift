//
//  QuickNavigation.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/2/26.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit

struct QuickNavigation: View {
    
    @State private var HelpText = "求救"
    
    @State private var showingAlert = false
    @State private var countdown = 6
    
    @State private var hospital:String = "医院"
    @State private var AED:String = "AED"
    
    @Binding var distance:[String:MedicalAnnotation]
    
    @State private var timer:Timer!
    @State private var isHelp = false
    
    @State private var scrollText = false
    
    @Binding var user:User
    @Binding var networkConnected:Bool
    
//    func submitHelp(){
//        self.timer.invalidate()
//        let send = SocketSend(request: WebsocketRequestType.submitHelped, User_ID: user.userAccount!.User_ID!, latitude: String(Float(locationManager.location?.coordinate.latitude ?? 0)), longitude: String(Float(locationManager.location?.coordinate.longitude ?? 0)))
//        socket.send(request: send)
//        self.isHelp = true
//        self.countdown = 6
//        self.HelpText = "取消"
//    }
    
    var body: some View {
        VStack(alignment:.center){
            
            ZStack(alignment: .center){
                QuickShape()
                HStack{
                    Image("direction")
                        .resizable()
                        .frame(width: 14, height: 19)
                    Spacer()
                        .frame(width:10,alignment: .center)
                    Text("快速导航")
                        .font(.footnote)
                        .fontWeight(.black)
                        .foregroundColor(Color.white)
                        .frame(alignment: .center)
                }
            }.offset(y: -5)
            
            
            VStack(alignment: .center){
                HStack{
                    Button(action: {
                        if self.distance["医院"] != nil{
                            let region = MKCoordinateRegion(center: self.distance["医院"]!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.02))
                            let placemark = MKPlacemark(coordinate: self.distance["医院"]!.coordinate, addressDictionary: nil)
                            let mapItem = MKMapItem(placemark: placemark)
                            let options = [
                                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
                            mapItem.name = self.distance["医院"]?.title
                            mapItem.openInMaps(launchOptions: options)
                        }
                    }) {
                        HStack{
                            Spacer()
                                .frame(width: 20)
                            Image("医院")
                                .resizable()
                            .foregroundColor(Color("ThemeColor"))
                                .frame(width: 30, height: 30, alignment: .center)
                            Spacer()
                            VStack(alignment: .leading){
                                Text(distance["医院"]?.title ?? hospital)
                                    .foregroundColor(Color("ThemeColor"))
                                    .fontWeight(.black)
                                    .frame(alignment: .leading)
                                Text(distance["医院"]?.distance ?? "暂无数据")
                                    .font(.subheadline)
                                    .foregroundColor(Color("ThemeColor"))
                            }
                            Spacer()
                        }
                    }
                    .frame(width: 168, height: 55, alignment: .leading)
                    .background(Color("ThemeColor").opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
//                    Spacer()
//                        .frame(height: 20)
//                    if networkConnected{
//                        Button(action: {
//                            if self.HelpText == "求救"{
//                                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
//                                    self.countdown -= 1
//                                    if self.countdown == 0{
//                                        self.showingAlert = false
//                                        self.submitHelp()
//                                    }
//                                })
//
//                                self.isHelp = true
//                                self.showingAlert = true
//                                self.timer.fire()
//                            }else{
//                                self.socket.send(request: SocketSend(request: .cancelHelped, User_ID: self.user.userAccount?.User_ID))
//                                self.HelpText = "求救"
//                            }
//                        }) {
//                        Text("\(HelpText)")
//                            .multilineTextAlignment(.center)
//                            .padding()
//                            .foregroundColor(Color.white)
//                            .font(Font.largeTitle.bold())
//                        }
//
//
//                        .frame(width:130,height:130)
//                        .background(Color("ThemeColor"))
//                        .clipShape(Circle())
//                        .alert(isPresented: $showingAlert) {
//                            Alert(title: Text("确定要求救吗？"), message: Text("\(countdown)秒后开始求救"),primaryButton:
//                                .default(Text("取消"),action: {
//                                    self.timer.invalidate()
//                                    self.isHelp = false
//                                    self.countdown = 6
//                                }),secondaryButton:
//                                .destructive(Text("求救").bold(), action: {
//                                self.timer.invalidate()
//                                self.submitHelp()
//                            })
//                            )
//                        }
//                    } else {
//                        Spacer().frame(width:130,height:130)
//                    }
                
                Spacer()
                    .frame(width: 20, alignment: .center)
                
                
                    Button(action: {
                        if self.distance["AED"] != nil{
                            let region = MKCoordinateRegion(center: self.distance["AED"]!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.02))
                            let placemark = MKPlacemark(coordinate: self.distance["AED"]!.coordinate, addressDictionary: nil)
                            let mapItem = MKMapItem(placemark: placemark)
                            let options = [
                                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
                            mapItem.name = self.distance["AED"]?.title
                            mapItem.openInMaps(launchOptions: options)
                        }
                    }) {
                        HStack{
                            Spacer()
                                .frame(width: 20)
                            Image("AED")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(Color("ThemeColor"))
                            Spacer()
                            VStack(alignment: .leading){
                                Text(distance["AED"]?.title ?? AED)
                                    .foregroundColor(Color("ThemeColor"))
                                    .fontWeight(.black)
                                    .frame(alignment: .leading)
                                Text(distance["AED"]?.distance ?? "暂无数据")
                                    .font(.subheadline)
                                    .frame(alignment: .leading)
                                .foregroundColor(Color("ThemeColor"))
                            }
                            Spacer()
                        }
                    }
                    .frame(width: 168, height: 55, alignment: .center)
                    .background(Color("ThemeColor").opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            
                    Spacer()
                        .frame(height: 20)
                    
                    Button(action: {
                        let tel = "tel://120"
                        let url = URL(string: tel)!
                        UIApplication.shared.open(url,options: [:],completionHandler: nil)
                    }) {
                        VStack{
                            Text("拨打")
                                .multilineTextAlignment(.center)
                                
                                .foregroundColor(Color.white)
                                .font(Font.headline.bold())
                            Text("120")
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.white)
                                .font(.custom("Impact",size:48))
                        }
                    }
                    .frame(width:130,height:130)
                    .background(Color("ThemeColor"))
                    .clipShape(Circle())
            }
            
            Spacer()
                .frame(height: 20)
            
            NavigationLink(destination: CallGuide()) {
                HStack{
                    Text("拨打指南")
                        .fontWeight(.black)
                        .foregroundColor(Color("ThemeColor"))
                    Image(systemName: "chevron.right")
                    .foregroundColor(Color("ThemeColor"))
                }
            }
        }
    }
}

//struct QuickNavigation_Previews: PreviewProvider {
//    static var previews: some View {
//        QuickNavigation()
//    }
//}
