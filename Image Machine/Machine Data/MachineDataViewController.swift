//
//  MachineDataViewController.swift
//  Image Machine
//
//  Created by User on 28/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import UIKit

class MachineDataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView!
    private let cellId = "machineDataCell"
    
    var cellData: [MachineDataStruct]!
    
    lazy var buttonAdd: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("Add Machine Data", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.blue
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Machine Data"
        
        let widthScreen = UIScreen.main.bounds.width
        let heightScreen = UIScreen.main.bounds.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: widthScreen, height: heightScreen - 100))
        tableView.dataSource = self
        tableView.delegate = self
        
        let bottomView = UIView(frame: CGRect(x: 0, y: heightScreen - 100, width: widthScreen, height: 100))
        bottomView.addSubview(buttonAdd)
        bottomView.backgroundColor = .white
        
        buttonAdd.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buttonAdd.widthAnchor.constraint(equalToConstant: 230).isActive = true
        buttonAdd.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        buttonAdd.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        buttonAdd.addTarget(self, action: #selector(addDataAction(sender:)), for: .touchUpInside)
        
        let userDefaults = UserDefaults.standard
        let array : [MachineDataStruct]
        array = NSKeyedUnarchiver.unarchiveObject(with: (userDefaults.object(forKey: "machine_data") as! NSData) as Data) as! [MachineDataStruct]
        
        self.cellData = array
        
        view.addSubview(tableView)
        view.addSubview(bottomView)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if (cell == nil){
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        
        cell?.textLabel?.text = cellData[indexPath.row].machineName
        cell?.detailTextLabel?.text = cellData[indexPath.row].machineType
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.cellData.remove(at: indexPath.row)
            self.tableView.reloadData()
            
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(NSKeyedArchiver.archivedData(withRootObject: self.cellData), forKey: "machine_data")
            userDefaults.synchronize()
        }
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            
            let alert = UIAlertController(title: "Edit Machine Data", message: nil, preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Machine Name"
                textField.text = self.cellData[indexPath.row].machineName
            }
            
            alert.addTextField { (textField) in
                textField.placeholder = "Machine Type"
                textField.text = self.cellData[indexPath.row].machineType
            }
            
            let actionAdd = UIAlertAction(title: "Edit", style: .default) { (alertAction) in
                
                self.cellData.remove(at: indexPath.row)
                
                let textFieldMachineName = alert.textFields![0] as UITextField
                let textFieldMachineType = alert.textFields![1] as UITextField
                
                let randomNumber = Int.random(in: 0..<999999)
                let randomId = Int.random(in: 0..<99999)
                
                let machineData = MachineDataStruct(machineId: randomId, machineName: textFieldMachineName.text, machineType: textFieldMachineType.text, machineNumber: randomNumber as NSNumber, lastMaintenanceDate: Date())
                
                self.cellData.append(machineData)
                self.tableView.reloadData()
                
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(NSKeyedArchiver.archivedData(withRootObject: self.cellData), forKey: "machine_data")
                userDefaults.synchronize()
                
            }
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: {(alertAction) in
                alert.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(actionAdd)
            alert.addAction(actionCancel)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        edit.backgroundColor = UIColor.lightGray
        
        return [delete, edit]

        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetailMachineDataViewController()
        vc.selectedMachineData = self.cellData[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func addDataAction(sender: UIButton?){
    
        let alert = UIAlertController(title: "Add Machine Data", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Machine Name"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Machine Type"
        }
        
        let actionAdd = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let textFieldMachineName = alert.textFields![0] as UITextField
            let textFieldMachineType = alert.textFields![1] as UITextField
            
            var machineName = textFieldMachineName.text
            var machineType = textFieldMachineType.text
            
            if (machineName == nil){
                machineName = "No Name"
            }
            
            if (machineType == nil){
                machineType = "No Type"
            }
            
            let randomNumber = Int.random(in: 0..<999999)
            let randomId = Int.random(in: 0..<99999)
            
            let machineData = MachineDataStruct(machineId: randomId, machineName: machineName, machineType: machineType, machineNumber: randomNumber as NSNumber, lastMaintenanceDate: Date())
            
            self.cellData.append(machineData)
            self.tableView.reloadData()
            
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(NSKeyedArchiver.archivedData(withRootObject: self.cellData), forKey: "machine_data")
            userDefaults.synchronize()
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: {(alertAction) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    

}


class MachineDataStruct: NSObject, NSCoding {
    
    
    
    var machineId : Int?
    var machineName: String?
    var machineType: String?
    var machineNumber: NSNumber?
    var lastMaintenanceDate: Date?
    
    init( machineId : Int, machineName: String?, machineType: String?, machineNumber: NSNumber?, lastMaintenanceDate: Date?) {
        self.machineId = machineId
        self.machineName = machineName
        self.machineType = machineType
        self.machineNumber = machineNumber
        self.lastMaintenanceDate = lastMaintenanceDate
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.machineId = aDecoder.decodeObject(forKey: "machineId") as? Int
        self.machineName = aDecoder.decodeObject(forKey: "machineName") as? String
        self.machineType = aDecoder.decodeObject(forKey: "machineType") as? String
        self.machineNumber = aDecoder.decodeObject(forKey: "machineNumber") as? NSNumber
        self.lastMaintenanceDate = aDecoder.decodeObject(forKey: "lastMaintenanceDate") as? Date
        
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.machineId, forKey: "machineId")
        aCoder.encode(self.machineName, forKey: "machineName")
        aCoder.encode(self.machineType, forKey: "machineType")
        aCoder.encode(self.machineNumber, forKey: "machineNumber")
        aCoder.encode(self.lastMaintenanceDate, forKey: "lastMaintenanceDate")
    }
    
}
