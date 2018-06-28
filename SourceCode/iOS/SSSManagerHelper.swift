//
//  SSSManagerHelper.swift
//  CSIS659Final
//
//  Created by Hassam Solano-Morel on 6/28/18.
//  Copyright © 2018 Hassam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public class RequestManager{
    private static let key:String = "Bearer 00Df4000003l8xX!AR4AQLRNyf2zZ4EOAeIIDlNa3PqvQ_XpgVcR8ghM6J02oCV5gQT9hwt6yGjFddzKMyn9yvnCfAUwCkiQozlsLsEK0Ii.zp3s"
    private static let url:String = "https://curious-bear-427411-dev-ed.my.salesforce.com/services/apexrest/SSSClient/"
    private static let header:[String:String] = ["Authorization": key]
    
    
    
    public static func getClients(completion:@escaping (_ json:JSON)->()){
        Alamofire.request(url, method: .get, headers: header)
            .responseJSON { (json) in
                do{
                    let rtnJSON:JSON = try JSON(data:json.data!)
                    //print(rtnJSON)
                    completion(rtnJSON)
                }catch{
                    print("DEBUG: There was an issue getting all the records")
                }
        }
    }
    
    
    public static func postClientInfo(params:[String:Any],  completion:@escaping (_ result:JSON)->()){
        Alamofire.request(url,method: .post, parameters: params, encoding: JSONEncoding.default, headers:header)
            .responseJSON { (json) in
                //debugPrint(json)
                do{
                    let rtnJSON:JSON = try JSON(json.result.value)
                    //print(rtnJSON)
                    completion(rtnJSON)
                }catch{
                    print("DEBUG: There was an issue posting record!")
                }
        }
    }
    
    public static func deleteClientInfo(id:String, completion:@escaping (_ result:JSON) -> ()){
        Alamofire.request(url + id, method: .delete, headers: header)
            .responseJSON { (json) in
                do{
                    let rtnJSON:JSON = try JSON(json.result.value)
                    //print(rtnJSON)
                    completion(rtnJSON)
                }catch{
                    print("DEBUG: There was an issue deleting record with id: \(id).")
                }
        }
    }
    
}
