//
//  HomeViewController.swift
//  ChargeAccount
//
//  Created by Lei on 2022/5/9.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
     
    @IBAction func chargeAccountButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "ChargeAccountViewSegue", sender: nil)
    }
    
    @IBAction func billListButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "BillListViewSegue", sender: nil)
    }
    
    @IBAction func settingButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "SettingViewSegue", sender: nil)
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
