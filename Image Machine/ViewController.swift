//
//  ViewController.swift
//  Image Machine
//
//  Created by User on 28/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var buttonMachineData: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("Machine Data", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.blue
        
        return button
    }()
    
    lazy var buttonCodeReader: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("Code Reader", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.magenta
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Image Machine"
        view.backgroundColor = UIColor.white
        
        view.addSubview(buttonMachineData)
        view.addSubview(buttonCodeReader)
        
        buttonMachineData.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buttonMachineData.widthAnchor.constraint(equalToConstant: 200).isActive = true
        buttonMachineData.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        buttonMachineData.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonMachineData.addTarget(self, action: #selector(machineDataAction(sender:)), for: .touchUpInside)
        
        buttonCodeReader.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buttonCodeReader.widthAnchor.constraint(equalToConstant: 200).isActive = true
        buttonCodeReader.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        buttonCodeReader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonCodeReader.addTarget(self, action: #selector(codeReaderAction), for: .touchUpInside)
        
    }
    
    @objc func machineDataAction(sender: UIButton){
        let vc = MachineDataViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func codeReaderAction(){
        let vc = CodeReaderViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

