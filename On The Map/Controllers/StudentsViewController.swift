//
//  StudentsViewController.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 01-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cellID = "cellStudent"
    private var pConnection: ParseConnection!
    private var tmpData: TemporalData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pConnection = ParseConnection.sharedInstance()
        tmpData = TemporalData.sharedInstance()
        
        getStudents()
    }
    
    private func getStudents() {
        pConnection.getStudentLocationsFromParse { (result, errorString) in
            if let result = result {
                self.tmpData.students = result
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
                
            }else {
                print(errorString)
            }
        }
    }

}

extension StudentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmpData.students.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID)!
        
        let name = "\(tmpData.students[indexPath.row].firstName) \(tmpData.students[indexPath.row].lastName)"
        cell.textLabel!.text = name
        let image = UIImage(named: "pin")!
        cell.imageView?.image = image
        
        return cell
    }
}
