//
//  HelpList.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/5/6.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI
import CoreLocation


struct HelpUserCard: View{
    var name:String? = "某位用户"
    var distance:String = "未知位置"
    var user:User
    
    init(user:User) {
        self.user = user
        self.name = user.userHealth?.Name
        self.distance = "nmsl"
        if user.userLocation?.latitude != nil && user.userLocation?.longitude != nil{
            let latitude = Double(user.userLocation!.latitude!)
            let longitude = Double(user.userLocation!.longitude!)
            let usercoordinate = CLLocation(latitude:latitude!, longitude:longitude!)
            guard let mycoordinate = locationManager.location else { return }

            var distanceInMeters = usercoordinate.distance(from: mycoordinate)
            distanceInMeters = distanceInMeters*0.62137
            print(String(Int(distanceInMeters)) + "m")
            self.distance = String(Int(distanceInMeters)) + "m"
        }
    }
    
    var body: some View{

        ZStack{
            NavigationLink(destination: HelpDetailView(user: user, distance: self.distance)){
                EmptyView()
            }
            HStack{
                Spacer().frame(width: 20)
                VStack(alignment: .leading){
                    Text(name ?? "某位用户").font(.headline).foregroundColor(Color.white)
                    Text(distance).font(.caption).foregroundColor(Color.white)
                }
                Spacer()
                Image(systemName: "person.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color.white)
                Spacer().frame(width: 20)
            }.background(RoundedRectangle(cornerRadius: 10).fill(Color("ThemeColor"))
            .frame(width: 340, height: 70))
        }
    }
}

struct HelpUserList: View {
    @ObservedObject var user:User
    @State var isAlertPresent:Bool = false
    @State var name = "某位用户"
    @State var distance = "距离未知"
    @Binding var iamalerting:Bool
    
    init(user:User,iamalerting:Binding<Bool>){
        UITableView.appearance().separatorColor = .clear
        UITableViewCell.appearance().backgroundColor = .none
        UITableView.appearance().backgroundColor = .none
        self.user = user
        self._iamalerting = iamalerting
    }
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .bottomTrailing){
                Form{
                    if !(user.helpingUser?.isEmpty ?? true){
                        List{
                            ForEach(user.helpingUser!, id: \User.userLocation?.User_ID){ helpingUser in
                                HelpUserCard(user: helpingUser)
                                    .padding()
                            }
                        }
                    } else {
                        Text("当前没有求助信息")
                    }
                }.navigationBarTitle("求助", displayMode: .inline)
                .listRowBackground(Color("Background"))
                .background(Color("Background"))
                
                VStack(alignment: .trailing){
                    Button(action: {
                        if let latitude = locationManager.location?.coordinate.latitude{
                            if let longitude = locationManager.location?.coordinate.longitude{
                                self.user.userLocation = UserLocation(User_ID: self.user.userAccount?.User_ID, latitude: "\(latitude)", longitude: "\(longitude)", isAlerting: "1")
                                self.user.checkHelping(checkHelpingCompletionHandler: {_,_ in})
                            }
                        }
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 24, weight: .bold))
                            .frame(width: 66, height: 60)
                            .foregroundColor(Color("ThemeColor"))
                            .padding(.bottom, 7)
                    })
                        .background(Color.white)
                    .cornerRadius(38.5)
                        .padding()
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 2,
                            y: 2)
                    
                    
                    Button(action: {
                        if !self.iamalerting{
                            if let latitude = locationManager.location?.coordinate.latitude{
                                if let longitude = locationManager.location?.coordinate.longitude{
                                    self.user.userLocation = UserLocation(User_ID: self.user.userAccount?.User_ID, latitude: "\(latitude)", longitude: "\(longitude)", isAlerting: "1")
                                    self.user.changeUserLocation(changeUserLocationCompletionHandler: { accountExist,execSuccessfully in
                                        if !accountExist || !execSuccessfully{
                                            self.isAlertPresent = true
                                        } else if accountExist || execSuccessfully {
                                            self.user.checkHelping(checkHelpingCompletionHandler: {_,_ in} )
                                            self.iamalerting = true
                                        }
                                    })
                                } else {
                                    self.isAlertPresent = true
                                }
                            } else {
                                self.isAlertPresent = true
                            }
                        } else {
                            self.user.userLocation?.isAlerting = "0"
                            self.user.changeUserLocation(changeUserLocationCompletionHandler: {accountExist,execSuccessfully in
                                if !accountExist || !execSuccessfully{
                                    self.isAlertPresent = true
                                } else {
                                    self.user.checkHelping(checkHelpingCompletionHandler: {_,_ in} )
                                    self.iamalerting = false
                                }
                            })
                        }
                    }, label: {
                        if self.iamalerting{
                            Spacer().frame(width:20)
                            Text("取消求助")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color.white)
                            Text("×")
                                .font(.system(size: 32, weight: .medium))
                                .frame(width: 66, height: 60)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 6)
                        } else {
                            Image(systemName: "bell")
                                .font(.system(size: 24, weight: .bold))
                                .frame(width: 66, height: 66,alignment: .center)
                                .foregroundColor(Color.white)

                        }
                    })
                    .background(Color("ThemeColor"))
                    .cornerRadius(38.5)
                        .padding([.leading, .bottom, .trailing])
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 2,
                            y: 2)
                        .alert(isPresented: $isAlertPresent){
                            Alert(title: Text("上传失败"), message: Text(""), dismissButton: .default(Text("好")))
                    }
                }
            }.onAppear(perform: {
                self.user.checkHelping(checkHelpingCompletionHandler: {_,_ in})
            })
        }
    }
}

//struct HelpList_Previews: PreviewProvider {
//    static var previews: some View {
//        HelpUserList()
//    }
//}
