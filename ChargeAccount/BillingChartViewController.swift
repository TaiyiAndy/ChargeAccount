//
//  SettingViewController.swift
//  ChargeAccount
//
//  Created by Lei on 2022/5/9.
//  Implemented by Taiyi on 2022/5/13
//

import Foundation
import UIKit
import Charts

class BillingChartViewController: UIViewController,ChartViewDelegate{
    
    let data_store = DataStorageManager()
    var type_dict : [String:[String]] = [:]
    var dataCounter = 0
    
    var moneyCloth = 0
    var moneyEnt = 0
    var moneyFood = 0
    var moneyTravel = 0
    var moneyOther = 0
    
    var pieChart = PieChartView()
    

    override func viewDidLoad() {
        super.viewDidLayoutSubviews()
        super.viewDidLoad()
        pieChart.delegate = self
        
        do {let data = try data_store.readBillModels()
            while(dataCounter<data.count){
  //              print(data)
                if(!type_dict.keys.contains(data[dataCounter].type)){
                    type_dict.updateValue([data[dataCounter].money + "," + data[dataCounter].dateTime], forKey: data[dataCounter].type)
                    dataCounter+=1
                }else if (type_dict.keys.contains(data[dataCounter].type)) {
                    type_dict[data[dataCounter].type]?.append(data[dataCounter].money + "," + data[dataCounter].dateTime)
                    dataCounter+=1
                }
                
                
            }
        }catch{
            print("Error")
        }
        
        if(type_dict.count>0){
        for key in type_dict.keys {
            if(key=="Food"){
                for ele in type_dict[key]!{
                    moneyFood += Int(ele.split(separator: ",").first!) ?? 0
                }
            }else if(key=="Clothing"){
                for ele in type_dict[key]!{
                    moneyCloth += Int(ele.split(separator: ",").first!) ?? 0
                }
            }else if(key == "Entertainment"){
                for ele in type_dict[key]!{
                    moneyEnt += Int(ele.split(separator: ",").first!) ?? 0
                }
            }else if(key == "Travel"){
                for ele in type_dict[key]!{
                    moneyTravel += Int(ele.split(separator: ",").first!) ?? 0
                }
            }else if(key == "Other"){
                for ele in type_dict[key]!{
                    moneyOther += Int(ele.split(separator: ",").first!) ?? 0
                }
            }
        }
        }else {
            let alert = UIAlertController(title: "Alert", message: "You don't record any bills!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK",style: .default, handler: { action in
                switch action.style{
                case .cancel:
                    print("cancel")
                case .default:
                    self.navigationController?.popToRootViewController(animated: true)
                case .destructive:
                    print("destructive")
                @unknown default:
                    fatalError()
                }
                
            }))
            self.present(alert,animated: true,completion: nil)
        }
        print(type_dict)
        
    }
    
    override func viewDidLayoutSubviews() {
            
            pieChart.frame = CGRect(x:0,y:0,width: self.view.frame.size.width, height:self.view.frame.size.width)
            
            pieChart.center = view.center
            view.addSubview(pieChart)
            
            var entries = [ChartDataEntry]()
            
            for key in type_dict.keys{
                if(key=="Food"){
                    
                        let entry = PieChartDataEntry(value: Double(moneyFood),label: key)
                        entries.append(entry)
                    
                }else if(key=="Clothing"){
    
                        let entry = PieChartDataEntry(value: Double(moneyCloth),label: key)
                        entries.append(entry)
                    
                }else if(key == "Entertainment"){
                    
                        let entry = PieChartDataEntry(value: Double(moneyEnt),label: key)
                        entries.append(entry)
                    
                }else if(key == "Travel"){
                        let entry = PieChartDataEntry(value: Double(moneyTravel),label: key)
                        entries.append(entry)
                    
                }else if(key == "Other"){
                        let entry = PieChartDataEntry(value: Double(moneyOther),label: key)
                        entries.append(entry)
                    
                }
            }
            
            
            let set = PieChartDataSet(entries: entries,label:"Billing type")
            set.colors = ChartColorTemplates.colorful()
            let data = PieChartData(dataSet: set)
            pieChart.data=data
        
            let pertentage = NumberFormatter()
            pertentage.numberStyle = .currency
            pieChart.data!.setValueFormatter(DefaultValueFormatter(formatter: pertentage))
        
        
        }

    
//    func clearAllUserDefault(){
//        let user = UserDefaults.standard
//        let dics = user.dictionaryRepresentation()
//        for key in dics{
//            user.removeObject(forKey: key.key)
//        }
//        user.synchronize()
//    }
    
    
    @IBAction func onSubmitTapped(_ sender: UIButton) {
    
         self.navigationController?.popToRootViewController(animated: true)
    }
        
}
