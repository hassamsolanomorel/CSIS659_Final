//
//  DetailsViewController.swift
//  CSIS659Final
//
//  Created by Hassam Solano-Morel on 6/28/18.
//  Copyright © 2018 Hassam. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var ClientNameTextbox: UITextField!
    @IBOutlet weak var AmountSpentTextbox: UITextField!
    @IBOutlet weak var PhoneTextbox: UITextField!
    
    public var  json:JSON = JSON();
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareTextboxes();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressSave(_ sender: Any) {
        activity.startAnimating()
        
        var params:[String:Any] = [:];
        if json["Id"] != nil{
            params.updateValue(json["Id"].stringValue, forKey: "Id")
        }
        params.updateValue(ClientNameTextbox.text!, forKey: "Name")
        params.updateValue(PhoneTextbox.text!, forKey: "Phone__c")
        params.updateValue(Double(AmountSpentTextbox.text!), forKey: "AmountSpent__c")
        
        RequestManager.postClientInfo(params: params) { (json) in
            print("POSTED CLIENT INFO! RESPONSE:\n \(json)")
            self.json = json
            self.prepareTextboxes()
            self.activity.stopAnimating()
        }
        
    }
    
    @IBAction func didPressDelete(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title: "Delete?",
                                                        message: "Are you sure you want to perform this action?",
                                                        preferredStyle: .alert)
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        let deleteAction:UIAlertAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.activity.startAnimating()
            RequestManager.deleteClientInfo(id: self.json["Id"].stringValue) { (json) in
                print("DELETED CLIENT INFO! RESPONSE: \(json)")
                self.activity.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)

    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func prepareTextboxes(){
        if json["Name"] != nil{
            ClientNameTextbox.text = json["Name"].stringValue
        }
        if json["Phone__c"] != nil{
            PhoneTextbox.text = json["Phone__c"].stringValue
        }
        if json["AmountSpent__c"] != nil{
            AmountSpentTextbox.text =  String(json["AmountSpent__c"].double!)
        }
        if json["Id"] != nil{
            idLabel.text = json["Id"].stringValue
        }
    }
    
}
