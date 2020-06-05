//
//  Register.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/4/11.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI

func validatePassword(password:String) -> Bool {
    let passWordRegex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
    let passWordPredicate = NSPredicate(format: "SELF MATCHES%@", passWordRegex)
    return passWordPredicate.evaluate(with: password)
}

func validateNickname(name:String) -> Bool {
    let nicknameRegex = "^[\u{4e00}-\u{9fa5}]{4,8}$"
    let passWordPredicate = NSPredicate(format: "SELF MATCHES%@", nicknameRegex)
    return passWordPredicate.evaluate(with: name)
}

struct Register: View {
    @State var currentPageIndex = 0
    @State var isFirst = true
    @State var isLast = false
    
    
    @State var isShowFailAlert = false
    @State var alertText:String = ""
    
    @Binding var user:User
    @Binding var status:String
    @Binding var isSkip:Bool
    
    @State var errorText:String = ""
    
    @State var view1_account_type = 0
    @State var view1_name = ""
    @State var view1_password = ""
    @State var view1_passwordConfirm = ""
    
    @State var view2_selected_sex = 0
    @State var view2_selectedBloodType = 0
    @State var view2_bornyear = "（可选）"
    
    @State var view3_name = ""
    @State var view3_height = ""
    @State var view3_weight = ""
    @State var view3_diseaseHistory = ""
    @State var view3_anaphylaxis = ""
    
    @State var view4_isDoctor = false
    @State var view4_isTrained = false
    
    var sex = ["（可选）","男","女"]
    var bloodType = ["（可选）","A+","A-","B+","B-","AB+","AB-","O+","O-"]
    var userAccountTypes = ["用户名","邮箱","手机号"]
    
    init(status:Binding<String>,user:Binding<User>,isSkip:Binding<Bool>){
        UINavigationBar.appearance().barTintColor = UIColor(named:"Background")
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = UIColor(named:"Background")
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(named: "ThemeColor") as Any]
        
        self._status = status
        self._user = user
        self._isSkip = isSkip
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color("Background").edgesIgnoringSafeArea(.all)
                VStack(alignment:.leading){
//                    RegisterPageViewController(currentPageIndex: $currentPageIndex, isFirst: $isFirst,isLast: $isLast, direction: $direction,viewControllers: [UIHostingController(rootView:RegisterPassword(user: $user, errorText: $errorText)),UIHostingController(rootView:DetailHealth1(user: $user)),UIHostingController(rootView: DetailHealth2(user: $user)),UIHostingController(rootView: DetailHealth3(user: $user))])
                    PagerManager(pageCount: 4, currentIndex: $currentPageIndex){
                        RegisterPassword(name: $view1_name, password: $view1_password, password_confirm: $view1_passwordConfirm, pickerSelection: $view1_account_type)
                        DetailHealth1(selectedSex: $view2_selected_sex, selectedBloodType: $view2_selectedBloodType, date: $view2_bornyear)
                        DetailHealth2(name: $view3_name, height: $view3_height, weight: $view3_weight, diseaseHistory: $view3_diseaseHistory, anaphylaxis: $view3_anaphylaxis)
                        DetailHealth3(isDoctor: $view4_isDoctor, isTrained: $view4_isTrained)
                    }
                    Spacer()
                    HStack{
                        HStack(alignment: .center){
                            Button(action: {
                                if self.currentPageIndex == 0{
                                    self.isFirst = true
                                    self.isLast = false
                                    self.status = "Login"
                                } else {
                                    self.isLast = false
                                    self.currentPageIndex -= 1
                                }
                            }){
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 22))
                                Text("返回")
                                    .font(.system(size: 22))
                            }
                        }.foregroundColor(Color("ThemeColor").opacity(75/100))
                        Spacer()
                        HStack(alignment:.center){
                            Button(action: {
//                                if self.currentPageIndex == 2{
//                                    self.isLast = true
//                                    self.currentPageIndex += 1
//                                } else if self.currentPageIndex != 3{
//                                    self.currentPageIndex += 1
//                                }
                                self.isFirst = false
                                
                                if self.currentPageIndex == 0 {
                                    if self.view1_name == ""{
                                        self.isShowFailAlert = true
                                        self.errorText = "用户名不能为空"
                                    } else if self.view1_account_type == 1 && !validateEmail(email: self.view1_name){
                                        self.isShowFailAlert = true
                                        self.errorText = "邮箱格式错误"
                                    } else if self.view1_account_type == 2 && !validateMobile(phone: self.view1_name){
                                        self.isShowFailAlert = true
                                        self.errorText = "手机格式错误"
                                    } else if self.view1_password != self.view1_passwordConfirm {
                                        self.isShowFailAlert = true
                                        self.errorText = "两次密码不一致"
                                    } else if !validatePassword(password: self.view1_password) {
                                        self.isShowFailAlert = true
                                        self.errorText = "密码必须大于8位小于16位且必须是大小写英文字母和数字的组合"
                                    } else {
                                        self.user.userVerify?.User_Password = self.view1_password
                                        
                                        if self.view1_account_type == 0{
                                            self.user.userVerify?.Account_Type = "NormalName"
                                        }else if self.view1_account_type == 1{
                                            self.user.userVerify?.Account_Type = "Email"
                                        }else if self.view1_account_type == 2{
                                            self.user.userVerify?.Account_Type = "phone"
                                        }
                                        
                                        switch(self.view1_account_type){
                                        case 0:
                                        self.user.userAccount?.User_name = self.view1_name
                                        case 1:
                                        self.user.userAccount?.User_email = self.view1_name
                                        case 2:
                                        self.user.userAccount?.User_phone = self.view1_name
                                        default:
                                            self.isShowFailAlert = true
                                            self.errorText = "未选择用户类型"
                                        }
                                        self.currentPageIndex += 1
                                    }
                                
//                                if self.currentPageIndex == 0 {
//                                    if self.view1_name == ""{
//                                        self.isShowFailAlert = true
//                                        self.errorText = "用户名不能为空"
//                                    } else if self.view1_password != self.view1_passwordConfirm {
//                                        self.isShowFailAlert = true
//                                        self.errorText = "两次密码不一致"
//                                    } else if self.view1_password.count<8 {
//                                        self.isShowFailAlert = true
//                                        self.errorText = "密码必须大于8位"
//                                    } else {
//                                        self.user.userVerify?.User_Password = self.view1_password
//
//                                        if self.view1_account_type == 0{
//                                            self.user.userVerify?.Account_Type = "NormalName"
//                                        }else if self.view1_account_type == 1{
//                                            self.user.userVerify?.Account_Type = "Email"
//                                        }else if self.view1_account_type == 2{
//                                            self.user.userVerify?.Account_Type = "phone"
//                                        }
//
//                                        switch(self.view1_account_type){
//                                        case 0:
//                                        self.user.userAccount?.User_name = self.view1_name
//                                        case 1:
//                                        self.user.userAccount?.User_email = self.view1_name
//                                        case 2:
//                                        self.user.userAccount?.User_phone = self.view1_name
//                                        default:
//                                            self.isShowFailAlert = true
//                                            self.errorText = "未选择用户类型"
//                                        }
//
//                                        self.currentPageIndex += 1
//                                    }
                                }
                                
                                else if self.currentPageIndex == 1 {
                                    
                                    if self.sex[self.view2_selected_sex] != "（可选）"{
                                        self.user.userHealth?.Sex = self.sex[self.view2_selected_sex]
                                    }
                                    
                                    if self.bloodType[self.view2_selectedBloodType] != "（可选）"{
                                        self.user.userHealth?.BloodType = self.bloodType[self.view2_selectedBloodType]
                                    }
                                    
                                    if self.view2_bornyear != "（可选）"{
                                        self.user.userHealth?.BornYear = self.view2_bornyear
                                    }
                                    self.currentPageIndex += 1
                                }
                                
                                else if self.currentPageIndex == 2 {
                                    self.isLast = true
                                    self.user.userHealth?.Name = self.view3_name
                                    self.user.userHealth?.Height = self.view3_height
                                    self.user.userHealth?.Weight = self.view3_weight
                                    self.user.userHealth?.DiseaseHistory = self.view3_diseaseHistory
                                    self.user.userHealth?.Anaphylaxis = self.view3_anaphylaxis
                                    
                                    self.currentPageIndex += 1
                                }
                                
                                else if self.currentPageIndex == 3 {
                                    
                                    if self.view4_isDoctor{
                                        self.user.userSkill?.isDoctor = "1"
                                    }
                                    
                                    if self.view4_isTrained{
                                        self.user.userSkill?.isTrained = "1"
                                    }
                                    
                                    self.user.register(registerCompletionHandler: {accountExist,execSuccessfully in
                                        if accountExist{
                                            self.isShowFailAlert = true
                                            self.errorText = "账号已存在"
                                            return
                                        }
                                        
                                        if !execSuccessfully{
                                            self.isShowFailAlert = true
                                            self.errorText = "无法注册"
                                            return
                                        }
                                        
                                        if !accountExist && execSuccessfully {
                                            self.user.changeHealth(changeHealthCompletionHandler: {accountExist,execSuccessfully in
                                                if accountExist && execSuccessfully {
                                                    self.user.changeSkill(changeSkillCompletionHandler: {accountExist,execSuccessfully in
                                                        if accountExist && execSuccessfully{
                                                            self.isSkip = false
                                                            self.user.save()
                                                            self.status = "HomeTabView"
                                                        } else {
                                                            self.isShowFailAlert = true
                                                            self.errorText = "无法注册"
                                                            return
                                                        }
                                                    })
                                                } else {
                                                    self.isShowFailAlert = true
                                                    self.errorText = "无法注册"
                                                    return
                                                }
                                            })

                                        }
                                        
                                    })
                                }
                            }) {
                                if isLast{
                                    Text("完成")
                                        .font(.system(size: 22))
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 20))
                                } else {
                                    Text("继续")
                                        .font(.system(size: 22))
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 22))
                                }
                            }.alert(isPresented: $isShowFailAlert){
                                Alert(title: Text("注册失败"), message: Text(errorText), dismissButton: .default(Text("好")))
                            }
                        }.foregroundColor(Color("ThemeColor"))
                    }.padding()
                }.navigationBarTitle(
                    Text("注册").foregroundColor(Color("ThemeColor"))
                )
            }
        }
    }
}
