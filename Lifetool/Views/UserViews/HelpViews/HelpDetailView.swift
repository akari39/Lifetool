//
//  HelpDetailView.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/5/6.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI

func getAgeFromDOF(date: String) -> String {

    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "YYYY-MM-dd"
    let dateOfBirth = dateFormater.date(from: date)

    let calender = Calendar.current

    let dateComponent = calender.dateComponents([.year, .month, .day], from:
    dateOfBirth!, to: Date())

    return String(dateComponent.year!)
}

struct HelpDetailView: View {
    @State var user:User
    @State var distance:String = "未知位置"
    
    var body: some View {
            Form{
                HelpMap(title: user.userHealth?.Name ?? "某位用户", subtitle: self.distance, user: user)
                    .frame(height: 300)
                List{
                    Text(user.userHealth?.Name ?? "某位用户").font(.largeTitle)
                    HStack{
                        Text("距离 ").font(.system(size: 24, weight: .bold))
                        Text(distance).font(.system(size: 24, weight: .bold))
                    }
                    
                    Section{
                        HStack{
                            Text("性别").font(.headline)
                            Spacer()
                            if user.userHealth?.Sex != nil{
                                Text(user.userHealth?.Sex ?? "未设定")
                            }
                        }
                        
                        HStack{
                            Text("血型").font(.headline)
                            Spacer()
                            if user.userHealth?.BloodType != nil{
                                Text(user.userHealth?.BloodType ?? "未设定")
                            }
                        }
                        
                        HStack{
                            Text("年龄").font(.headline)
                            Spacer()
                            if user.userHealth?.BornYear != nil{
                                Text(getAgeFromDOF(date: (user.userHealth!.BornYear!)) + " 岁")
                            }
                        }
                        
                        HStack{
                            Text("身高").font(.headline)
                            Spacer()
                            if user.userHealth?.Height != nil{
                                Text(user.userHealth!.Height! + " 厘米")
                            }
                        }
                        
                        HStack{
                            Text("体重").font(.headline)
                            Spacer()
                            if user.userHealth?.Weight != nil{
                                Text(user.userHealth!.Weight! + " 千克")
                            }
                        }
                        
                        VStack(alignment: .leading){
                            Text("病史").font(.headline)
                            Spacer()
                            if user.userHealth?.DiseaseHistory != nil {
                                Text(user.userHealth?.DiseaseHistory ?? "未设定")
                            }
                        }
                        
                        VStack(alignment: .leading){
                            Text("过敏反应").font(.headline)
                            Spacer()
                            if user.userHealth?.Anaphylaxis != nil{
                                Text(user.userHealth?.Anaphylaxis ?? "未设定")
                            }
                        }
                    }
                }
        }.background(Color("Background"))
        .listRowBackground(Color("Background"))
    }
}

//struct HelpDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        HelpDetailView()
//    }
//}
