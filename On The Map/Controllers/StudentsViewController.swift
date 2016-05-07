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
    private var pConnection: ParseConnection = ParseConnection.sharedInstance()
    private var tmpData: TemporalData = TemporalData.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tmpData.students.isEmpty {
            getStudents()
        }
        
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
        let subtitle = tmpData.students[indexPath.row].mediaURL
        cell.textLabel!.text = name
        cell.detailTextLabel?.text = subtitle
        
        let image = UIImage(named: "pin")!
        cell.imageView?.image = image
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Helper.openURL(self, urlString: tmpData.students[indexPath.row].mediaURL)
    }
}
