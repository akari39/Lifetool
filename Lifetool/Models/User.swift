//
//  User.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/4/14.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import Foundation
import Security

class User:Codable,ObservableObject {
    var userVerify:UserVerify?
    var userAccount:UserAccount?
    var userHealth:UserHealth?
    var userLocation:UserLocation?
    var userSkill:UserSkill?
    
    var isExist:Bool? = true
    @Published var helpingUser:[User]? = [User]()
    
    enum CodingKeys: CodingKey {
        case userVerify
        case userAccount
        case userHealth
        case userLocation
        case userSkill
    }
    
    init(){
        userVerify = UserVerify()
        userAccount = UserAccount()
        userHealth = UserHealth()
        userLocation = UserLocation()
        userSkill = UserSkill()
        read()
        if userAccount?.User_ID == nil{
            isExist = false
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        userVerify = try? container?.decode(UserVerify.self, forKey: .userVerify)
        userAccount = try? container?.decode(UserAccount.self, forKey: .userAccount)
        userHealth = try? container?.decode(UserHealth.self, forKey: .userHealth)
        userLocation = try? container?.decode(UserLocation.self, forKey: .userLocation)
        userSkill = try? container?.decode(UserSkill.self, forKey: .userSkill)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(userVerify, forKey: .userVerify)
        try? container.encode(userAccount, forKey: .userAccount)
        try? container.encode(userHealth, forKey: .userHealth)
        try? container.encode(userLocation, forKey: .userLocation)
        try? container.encode(userSkill, forKey: .userSkill)
    }
    
    public func save(){
        let encoder = JSONEncoder()
        let defaultStand = UserDefaults.standard
        
        if let encoded = try? encoder.encode(userVerify){
            defaultStand.set(encoded,forKey: "User_Verify")
        }
        
        if let encoded = try? encoder.encode(userAccount){
            defaultStand.set(encoded,forKey: "User_Account")
        }
        
        if let encoded = try? encoder.encode(userHealth){
            defaultStand.set(encoded,forKey: "User_Health")
        }
        
        if let encoded = try? encoder.encode(userLocation){
            defaultStand.set(encoded,forKey: "User_Location")
        }
        
        if let encoded = try? encoder.encode(userSkill){
            defaultStand.set(encoded,forKey: "User_Skill")
        }
    }
    
    public func read(){
        let decoder = JSONDecoder()
        let defaultStand = UserDefaults.standard
        
        if let userVerifyData = defaultStand.object(forKey: "User_Verify") as? Data {
            if let userVerify = try? decoder.decode(UserVerify.self, from: userVerifyData) {
                self.userVerify = userVerify
            }
        }
        
        if let userAccountData = defaultStand.object(forKey: "User_Account") as? Data {
            if let userAccount = try? decoder.decode(UserAccount.self, from: userAccountData) {
                self.userAccount = userAccount
            }
        }
        
        if let userHealthData = defaultStand.object(forKey: "User_Health") as? Data {
            if let userHealth = try? decoder.decode(UserHealth.self, from: userHealthData) {
                self.userHealth = userHealth
            }
        }
        
        if let userLocationData = defaultStand.object(forKey: "User_Location") as? Data {
            if let userLocation = try? decoder.decode(UserLocation.self, from: userLocationData) {
                self.userLocation = userLocation
            }
        }
        
        if let userSkillData = defaultStand.object(forKey: "User_Skill") as? Data {
            if let userSkill = try? decoder.decode(UserSkill.self, from: userSkillData) {
                self.userSkill = userSkill
            }
        }
    }
    
    public func login(loginCompletionHandler:@escaping (Bool,Bool)->Void){
        var User_Account:String?
        let loginURL = URL(string:"https://lifetool.suesiosclub.com/lifetoolapp/login.php")!
        
        switch(self.userVerify?.Account_Type){
        case "phone":
            User_Account = userAccount?.User_phone
        case "Email":
            User_Account = userAccount?.User_email
        case "NormalName":
            User_Account = userAccount?.User_name
        case "UUID":
            User_Account = ""
        case .none:
            loginCompletionHandler(false,false)
        case .some(_):
            loginCompletionHandler(false,false)
        }
        
        var accountExist:Bool = false
        var execSuccessfully:Bool = false
        
        let postContent = ["Account_Type":self.userVerify?.Account_Type,"User_ID":self.userAccount?.User_ID,"User_Account":User_Account,"User_Password":userVerify?.User_Password]
        post(url: loginURL, parameters: postContent as [String : String?], completionHandler: { decodedData,parseErr in
            if let decodedData = decodedData{
                if decodedData.accountBeingOrNotFlag=="1"{
                    accountExist = true
                }
                if decodedData.execOKOrNotFlag == "1"{
                    if self.userAccount?.User_ID == nil{
                        self.userAccount?.User_ID = decodedData.content?[0].userAccount?.User_ID
                        self.save()
                    }
                    execSuccessfully = true
                }
            }
            loginCompletionHandler(accountExist,execSuccessfully)
        })
    }
    
    public func register(registerCompletionHandler:@escaping (Bool,Bool)->Void){
        var User_Account:String?
        let registerURL = URL(string:"https://lifetool.suesiosclub.com/lifetoolapp/register.php")!
        
        switch(self.userVerify?.Account_Type){
        case "phone":
            User_Account = userAccount?.User_phone
        case "Email":
            User_Account = userAccount?.User_email
        case "NormalName":
            User_Account = userAccount?.User_name
        case .none:
            registerCompletionHandler(false,false)
        case .some(_):
            registerCompletionHandler(false,false)
        }
        
        let postContent = ["Account_Type":self.userVerify?.Account_Type,"User_Account":User_Account,"User_Password":userVerify?.User_Password,"Name":self.userHealth?.Name,"BornYear":self.userHealth?.BornYear,"Sex":self.userHealth?.Sex,"BloodType":self.userHealth?.BloodType,"Height":self.userHealth?.Height,"Weight":self.userHealth?.Weight,"DiseaseHistory":self.userHealth?.DiseaseHistory,"Anaphylaxis":self.userHealth?.Anaphylaxis,"isDoctor":self.userSkill?.isDoctor,"isTrained":self.userSkill?.isTrained]
        DispatchQueue.main.async {
            post(url: registerURL, parameters: postContent as [String : String?], completionHandler: { decodedData,parseErr in
                var accountExist:Bool = false
                var execSuccessfully:Bool = false
                DispatchQueue.main.async {
                    
                    if let decodedData = decodedData{
                        if decodedData.accountBeingOrNotFlag=="1"{
                            accountExist = true
                        }
                        
                        if decodedData.execOKOrNotFlag == "1"{
                            execSuccessfully = true
                            self.userAccount?.User_ID = decodedData.content?[0].userAccount?.User_ID
                        }
                    }
                    registerCompletionHandler(accountExist,execSuccessfully)
                }
            })
        }
    }
    
    public func changeAccount(changeAccountCompletionHandler:@escaping (Bool,Bool)->Void){
        let changeAccountURL = URL(string:"https://lifetool.suesiosclub.com/lifetoolapp/changeAccount.php")!
        
        let postContent = ["User_ID":self.userAccount?.User_ID,"User_Password":userVerify?.User_Password,"User_name":userAccount?.User_name,"User_email":userAccount?.User_email,"User_phone":userAccount?.User_phone]
        
        post(url: changeAccountURL, parameters: postContent, completionHandler: { decodedData,parseErr in
            var accountExist:Bool = false
            var execSuccessfully:Bool = false
            if let decodedData = decodedData{
                if decodedData.accountBeingOrNotFlag=="1"{
                    accountExist = true
                }
                if decodedData.execOKOrNotFlag == "1"{
                    execSuccessfully = true
                }
            }
            changeAccountCompletionHandler(accountExist,execSuccessfully)
        })
    }
    
    public func changeHealth(changeHealthCompletionHandler:@escaping (Bool,Bool)->Void){
        let registerURL = URL(string:"https://lifetool.suesiosclub.com/lifetoolapp/changeHealth.php")!
        
        let postContent = ["User_ID":self.userAccount?.User_ID,"User_Password":userVerify?.User_Password,"Name":self.userHealth?.Name,"BornYear":self.userHealth?.BornYear,"Sex":self.userHealth?.Sex,"BloodType":self.userHealth?.BloodType,"Height":self.userHealth?.Height,"Weight":self.userHealth?.Weight,"DiseaseHistory":self.userHealth?.DiseaseHistory,"Anaphylaxis":self.userHealth?.Anaphylaxis]
        post(url: registerURL, parameters: postContent as [String : String?], completionHandler: { decodedData,parseErr in
            var accountExist:Bool = false
            var execSuccessfully:Bool = false
            if let decodedData = decodedData{
                if decodedData.accountBeingOrNotFlag=="1"{
                    accountExist = true
                }
                if decodedData.execOKOrNotFlag == "1"{
                    execSuccessfully = true
                }
            }
            changeHealthCompletionHandler(accountExist,execSuccessfully)
        })
    }
    
    public func changeSkill(changeSkillCompletionHandler:@escaping (Bool,Bool)->Void){
        let registerURL = URL(string:"https://lifetool.suesiosclub.com/lifetoolapp/changeSkill.php")!
        
        let postContent = ["User_ID":self.userAccount?.User_ID,"User_Password":userVerify?.User_Password,"isDoctor":self.userSkill?.isDoctor,"isTrained":self.userSkill?.isTrained]
        post(url: registerURL, parameters: postContent as [String : String?], completionHandler: { decodedData,parseErr in
            var accountExist:Bool = false
            var execSuccessfully:Bool = false
            if let decodedData = decodedData{
                if decodedData.accountBeingOrNotFlag == "1"{
                    accountExist = true
                }
                if decodedData.execOKOrNotFlag == "1"{
                    execSuccessfully = true
                }
            }
            changeSkillCompletionHandler(accountExist,execSuccessfully)
        })
    }
    
    public func changeUserLocation(changeUserLocationCompletionHandler:@escaping (Bool,Bool)->Void){
        let registerURL = URL(string:"https://lifetool.suesiosclub.com/lifetoolapp/changeUserLocation.php")!
        
        let postContent = ["User_ID":self.userAccount?.User_ID,"User_Password":userVerify?.User_Password,"latitude":self.userLocation?.latitude,"longitude":self.userLocation?.longitude,"isAlerting":self.userLocation?.isAlerting]
        post(url: registerURL, parameters: postContent as [String : String?], completionHandler: { decodedData,parseErr in
            var accountExist:Bool = false
            var execSuccessfully:Bool = false
            if let decodedData = decodedData{
                
                if decodedData.accountBeingOrNotFlag=="1"{
                    accountExist = true
                }
                
                if decodedData.execOKOrNotFlag == "1"{
                    execSuccessfully = true
                }
            }
            changeUserLocationCompletionHandler(accountExist,execSuccessfully)
        })
    }
    
    public func deleteUser(deleteUserCompletionHandler:@escaping (Bool,Bool)->Void){
        let deleteURL = URL(string:"https://lifetool.suesiosclub.com/lifetoolapp/deleteUser.php")!
        
        let postContent = ["User_ID":self.userAccount?.User_ID,"User_Password":userVerify?.User_Password]
        post(url: deleteURL, parameters: postContent as [String : String?], completionHandler: { decodedData,parseErr in
            var accountExist:Bool = false
            var execSuccessfully:Bool = false
            if let decodedData = decodedData{
                if decodedData.accountBeingOrNotFlag=="1"{
                    accountExist = true
                }
                if decodedData.execOKOrNotFlag == "1"{
                    execSuccessfully = true
                }
            }
            deleteUserCompletionHandler(accountExist,execSuccessfully)
        })
    }
    
    public func checkAccount(checkAccountCompletionHandler:@escaping (Bool,Bool)->Void){
        let checkHealthURL = URL(string:"https://lifetool.suesiosclub.com/lifetoolapp/checkHealth.php")!
        
        let postContent = ["User_ID":self.userAccount?.User_ID,"User_Password":userVerify?.User_Password]
        post(url: checkHealthURL, parameters: postContent, completionHandler: { decodedData,parseErr in
            var accountExist:Bool = false
            var execSuccessfully:Bool = false
            if let decodedData = decodedData {
                if decodedData.accountBeingOrNotFlag == "1"{
                    accountExist = true
                }
                
                if decodedData.execOKOrNotFlag == "1"{
                    execSuccessfully = true
                    self.userAccount = decodedData.content?[0].userAccount
                    self.userHealth = decodedData.content?[0].userHealth
                    self.userSkill = decodedData.content?[0].userSkill
                    self.save()
                }
            }
            
            checkAccountCompletionHandler(accountExist,execSuccessfully)
        })
    }
    
    public func checkHelping(checkHelpingCompletionHandler:@escaping (Bool,Bool)->Void){
        let checkHelpingURL = URL(string:"https://lifetool.suesiosclub.com/lifetoolapp/checkAlertingUser.php")!
        
        let postContent = ["User_ID":self.userAccount?.User_ID,"User_Password":userVerify?.User_Password,"latitude":self.userLocation?.latitude,"longitude":self.userLocation?.longitude]
        post(url: checkHelpingURL, parameters: postContent, completionHandler: { decodedData,parseErr in
            var accountExist:Bool = false
            var execSuccessfully:Bool = false
            if let decodedData = decodedData {
                
                if decodedData.execOKOrNotFlag == "1"{
                    execSuccessfully = true
                    self.helpingUser = decodedData.content
                } else {
                    self.helpingUser?.removeAll()
                }
            }
            checkHelpingCompletionHandler(accountExist,execSuccessfully)
        })
    }
}

struct DataResponse:Codable{
    var accountBeingOrNotFlag:String?
    var execOKOrNotFlag:String?
    var content:[User]?
}

struct UserVerify:Codable,Hashable{
    var Account_Type:String?
    var User_ID:String?
    var User_Password:String?
}

struct UserAccount:Codable,Hashable {
    var User_ID:String?
    var User_name:String?
    var User_email:String?
    var User_phone:String?
}

struct UserHealth:Codable,Hashable {
    var User_ID:String?
    var Name:String?
    var BornYear:String?
    var Sex:String?
    var BloodType:String?
    var Height:String?
    var Weight:String?
    var DiseaseHistory:String?
    var Anaphylaxis:String?
}

struct UserSkill:Codable,Hashable{
    var User_ID:String?
    var isDoctor:String = "0"
    var isTrained:String = "0"
}

struct UserLocation:Codable,Hashable {
    var User_ID:String?
    var latitude:String?
    var longitude:String?
    var isAlerting:String?
}

//struct SocketSend:Convertable,Hashable{
//    var request:WebsocketRequestType?
//    var User_ID:String?
//    var Helping_User_ID:String?
//    var Helped_User_ID:String?
//    var latitude:String?
//    var longitude:String?
//}
//
//class HelpUser: Convertable {
//    var userHealth = UserHealth()
//    var userLocation = UserLocation()
//    var userSkill = UserSkill()
//}
//
//struct SocketContent:Convertable {
//    var request:WebsocketReceiveType?
//    var execOKOrNotFlag:String?
//    var user:[HelpUser?]
//}
//
//enum WebsocketReceiveType:String,Convertable {
//    case helpedraise = "helpedraise"
//    case helpingraise = "helpingraise"
//    case helpedcancel = "helpedcancel"
//    case helpingcancel = "helpingcancel"
//    case execResult = "execResult"
//}
//
//enum WebsocketRequestType:String,Convertable {
//    case searchHelped = "searchHelped"
//    case searchHelping = "searchHelping"
//    case submitHelping = "submitHelping"
//    case submitHelped = "submitHelped"
//    case cancelHelping = "cancelHelping"
//    case cancelHelped = "cancelHelped"
//    case searchNearby = "searchNearby"
//}
//
//struct SocketReceive:Convertable {
//    var type:WebsocketReceiveType?
//    var content:SocketContent?
//}
//
//protocol Convertable: Codable {
//
//}
//
//extension Convertable {
//
//    /// 直接将Struct或Class转成Dictionary
//    func convertToDict() -> Dictionary<String, Any>? {
//
//        var dict: Dictionary<String, Any>? = nil
//
//        do {
//            print("init student")
//            let encoder = JSONEncoder()
//
//            let data = try encoder.encode(self)
//            print("struct convert to data")
//
//            dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
//
//        } catch {
//            print(error)
//        }
//        return dict
//    }
//}
