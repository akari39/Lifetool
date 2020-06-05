//
//  Login.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/4/2.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI

//https://www.jianshu.com/p/3d36474a01d7
func validateEmail(email:String) -> Bool {
    let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with: email)
}

func validateMobile(phone:String) -> Bool {
    let phoneRegex: String = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    return phoneTest.evaluate(with: phone)
}

struct Login: View {
    
    @State private var name:String = ""
    @State private var password:String = ""
    @Binding var status:String
    @Binding var user:User
    
    @State var isshowAlert = false
    @State var errorMessage = ""
    
    @Binding var isSkip:Bool
    
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
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        Text("用户名/手机/邮箱")
                            .font(.headline)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(5/100))
                                .frame(height: 45)
//                            TextField("输入用户名/手机/邮箱", text: $name)
//                                .textContentType(.name)
//                                .keyboardType(.asciiCapable)
//                                .frame(height: 40, alignment: .leading).padding(.horizontal, 10.0)
                            CustomTextField(keyboardType: .asciiCapable, text: $name, placeholder: "输入用户名/手机/邮箱", isSafeText: false, textAlignment: .left)
                            .frame(height: 40, alignment: .leading).padding(.horizontal, 10.0)
                        }
                    }
                    
                    Spacer().frame(height:15)
                    
                    VStack(alignment: .leading){
                        Text("密码")
                            .font(.headline)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(5/100))
                            .frame(height: 45)
                            CustomTextField(keyboardType: .asciiCapable, text: $password, placeholder: "输入密码", isSafeText: true, textAlignment: .left)
                            .frame(height: 40, alignment: .leading).padding(.horizontal, 10.0)
                        }
                    }
            //                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
            //                Text("忘记密码？")
            //                    .foregroundColor(Color("ThemeColor"))
            //                }
                    Spacer()
                    HStack(alignment:.center){
                        Spacer()
                        Button(action:{
                            self.isSkip = true
                            self.status = "HomeTabView"
                        }){
                            HStack{
                                Text("跳过登录")
                                        .font(.system(size: 18))
                                }.foregroundColor(Color("ThemeColor").opacity(75/100))
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("ThemeColor").opacity(75/100))
                        }
                        Spacer()
                    }
                    Spacer().frame(height:30)
                    HStack{
                        Button(action:{
                            self.status = "Register"
                        }){
                            ZStack(alignment: .center){
                                RoundedRectangle(cornerRadius: 20).fill(Color("ThemeColor")).frame(width:110,height: 40)
                                Text("注册")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.white)
                            }
                        }
                        Spacer()
                        Button(action:{
                            if validateEmail(email: self.name) {
                                self.user.userVerify?.Account_Type = "Email"
                                self.user.userAccount?.User_email = self.name
                            } else if validateMobile(phone: self.name) {
                                self.user.userVerify?.Account_Type = "phone"
                                self.user.userAccount?.User_phone = self.name
                            } else {
                                self.user.userVerify?.Account_Type = "NormalName"
                                self.user.userAccount?.User_name = self.name
                            }
                            self.user.userVerify?.User_Password = self.password
                            self.user.login(loginCompletionHandler: { L_accountExist,L_execSuccessfully in
                                if (L_accountExist && L_execSuccessfully) {
                                    self.user.checkAccount(checkAccountCompletionHandler: {CA_accountExist,CA_execSuccessfully in
                                        if(CA_accountExist&&CA_execSuccessfully){
                                            self.user.save()
                                            self.isSkip = false
                                            self.status = "HomeTabView"
                                        }
                                    })
                                } else {
                                    if !L_accountExist {
                                        self.isshowAlert = true
                                        self.errorMessage = "用户不存在"
                                    } else if L_accountExist && !L_execSuccessfully {
                                        self.errorMessage = "密码错误"
                                        self.isshowAlert = true
                                    } else {
                                        self.errorMessage = "查询错误"
                                    }
                                }
                            })
                        }){
                            HStack(alignment:.center){
                                Text("登录")
                                    .font(.system(size: 22))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 22))
                            }.foregroundColor(Color("ThemeColor"))
                        }.alert(isPresented: $isshowAlert){
                            Alert(title: Text("登录失败"), message: Text(errorMessage), dismissButton: .default(Text("好")))
                        }
                    }
                }.padding()
            }.navigationBarTitle(Text("登录").foregroundColor(Color("ThemeColor")))
        }
    }
}

//struct Login_Previews: PreviewProvider {
//    static var previews: some View {
//        Login(status:.constant("Login"))
//    }
//}
