//
//  ViewController.swift
//  CSIS659Final
//
//  Created by Hassam Solano-Morel on 6/27/18.
//  Copyright © 2018 Hassam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    private var numRecords:Int = 0;
    private var resultJSON:JSON = JSON();
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        RequestManager.getClients { (json) in
            self.resultJSON = json
            self.numRecords = self.resultJSON.count
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressAddClient(_ sender: Any) {
        performSegue(withIdentifier: "toDetailsView", sender: JSON())
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let json:JSON = sender as! JSON
        let dest:DetailsViewController = segue.destination as! DetailsViewController
        
        dest.json = json
    }
}

extension ViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRecords
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell")
        cell?.textLabel?.text = resultJSON[indexPath.row]["Name"].stringValue
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let json:JSON = resultJSON[indexPath.row] as JSON
        performSegue(withIdentifier: "toDetailsView", sender: json)
    }
    
    
}

