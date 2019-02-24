//
//  ViewController.swift
//  Balance
//
//  Created by Richard Burton on 19/02/2019.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit
import CoreData
import Floaty


//["tab": 42249.60231457469, "act": give, "ink": 278.7336414172244, "deleted": 0, "timestamp": 1548945287000, "pep": 645.17, "time": 2019-01-31T14:34:47.000Z, "arg": <null>, "block": 7154155, "id": 14165, "liq_price": 77.55783061819776, "ratio": 281.664015430498, "art": 15000, "per": 1.040800462956618, "ire": 14825.62108276614, "pip": 145.635, "lad": 0x507c0d38456a75b56d938228f0eb8Df00E2A2f15]
//private var CDPs = [CDP(identifier: 14165, ratio: 281.664015430498, pip: 145.635, art: 15000, ink: 278.7336414172244, liqPrice: 77.55783061819776)]

private var CDPs = [CDP]()

//homeViewC: UIViewController, UITableViewDataSource {}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let cdpsTableView = UITableView() // view
    
    
    var makers: [NSManagedObject] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    func getData() {
        
        CDPs.removeAll()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Maker")
        
        //3
        do {
            makers = try managedContext.fetch(fetchRequest)
            print("DATABASE")
            print(makers)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        //        var singleCollateralDaiIdentifiers = [3228, 9, 420, 3088]
        var singleCollateralDaiIdentifiers = [String]()
        
        if makers.count > 0 {
//            view.addSubview(cdpsTableView)
            for maker in makers {
                print("DATA")
                print(maker.value(forKey: "singleCollateralDaiIdentifier"))
                singleCollateralDaiIdentifiers.append(maker.value(forKey: "singleCollateralDaiIdentifier") as! String)
                
            }
            
            
            
            
            //        for maker in makers {
            for identifier in singleCollateralDaiIdentifiers {
                
                //            maker.fet
                
                //            let identifier = maker.value(forKeyPath: "singleCollateralDaiIdentifier") as? String
                
                //        guard let url = URL(string: "https://mkr.tools/api/v1/lad/0x1db7332D24EBbdC5F49c34AA6830Cb7f46A3647C") else {return} // liquidated
                //                guard let url = URL(string: "https://mkr.tools/api/v1/lad/0x03c245bAFCC0a80cD73b170D26e3d3663B90793C") else {return} // one big cdp + API broken
                //                guard let url = URL(string: "https://mkr.tools/api/v1/lad/0x1db7332D24EBbdC5F49c34AA6830Cb7f46A3647C") else {return} // 420
                //        guard let url = URL(string: "https://mkr.tools/api/v1/lad/0x3A306a399085F3460BbcB5b77015Ab33806A10d5") else {return}// lots of cdps
                guard let url = URL(string: "https://mkr.tools/api/v1/cdp/\(String(describing: identifier))") else {return}// biggest CDP
                
                //        guard let url = URL(string: "https://mkr.tools/api/v1/cdp/14165") else {return}// a CDP
                
                
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let dataResponse = data,
                        error == nil else {
                            print(error?.localizedDescription ?? "Response Error")
                            return }
                    do{
                        //here dataResponse received from a network request
                        let jsonResponse = try JSONSerialization.jsonObject(with:
                            dataResponse, options: [])
                        //print(jsonResponse) //Response result
                        
                        guard let jsonArray = jsonResponse as? [[String: Any]] else {
                            return
                        }
                        print(jsonArray)
                        //                print(jsonArray[0])
                        //                print(jsonArray[0]["id"])
                        //Now get title value
                        //                guard let cdpId = jsonArray[0]["id"] as? Int else { return }
                        
                        //                print(cdpId)
                        //                print(jsonArray)
                        //                print(title) // delectus aut autem
                        
                        for dic in jsonArray{
                            
                            guard let identifier = dic["id"] as? Int else { return }
                            guard let ratio = dic["ratio"] as? Double else { return }
                            guard let pip = dic["pip"] as? Double else { return }
                            guard let art = dic["art"] as? Double else { return }
                            guard let ink = dic["ink"] as? Double else { return }
                            guard let liqPrice = dic["liq_price"] as? Double else { return }
                            
                            //                    print("Dictionary")
                            //                    print(identifier)
                            //                    print(liqPrice)
                            //                    print(art)
                            //                    print(ink)
                            
                            
                            CDPs.append(CDP(identifier: identifier, ratio: ratio, pip: pip, art: art, ink: ink, liqPrice: liqPrice))
                            //                    guard CDP.idNumber(dic["id"] as? Int else { return })
                            //                    Contact(name: "Kelly Goodwin", jobTitle: "Designer", country: "bo"),
                            //                    Contact(name: "Kelly Goodwin", jobTitle: "Designer", country: "bo"),
                            
                            //                    guard let liqPrice = dic["liq_price"] as? Int64 else { return }
                            
                            //                    print(cdpId) //Output
                            //                    print(liqPrice)
                            //                    print(art)
                            //                    print(ink)
                        }
                        
                        //                print(CDPs)
                        //                print(CDPs[0])
                        //                return(jsonArray[0])
                        
                        DispatchQueue.main.async {
                            //                    self.feed = feedWrapper["feed"]!
                            //                    self.tableView.reloadData()
                            //                    self.tabl
                            //                    self.cdps
                            self.cdpsTableView.reloadData()
                        }
                        
                        
                        
                    } catch let parsingError {
                        //                return(parsingError)
                        print("Error", parsingError)
                    }
                    
                }
                
                task.resume()
                
            }
        } else {
//            self.cdpsTableView.removeFromSuperview()
            CDPs.removeAll()
            self.cdpsTableView.reloadData()
        }
        
        
        

    }
    
    func setUpNavigation() {
//        DispatchQueue.main.async {
//            if let pip = CDPs[0].pip {
//
//                self.navigationItem.title = "$\(String(format:"%.2f", pip)) "
//            }
//        }
        
        navigationItem.title = "Watchlist"
//        navigationItem.
//        UINavigationBar.appearance().barTintColor = UIColor(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)
//        UINavigationBar.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        
        let darkCardBackgroundColor = UIColor(red: 0.176, green: 0.196, blue: 0.220, alpha: 1.000)
        self.navigationController?.navigationBar.barTintColor = .white
//        self.navigationController?.navigationBar.barTintColor = _ColorLiteralType(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
//        self.navigationController?.navigationBar.barTintColor = UIColor(cgColor: CGColor.b)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        
    
        cdpsTableView.dataSource = self
        cdpsTableView.delegate = self
        

        cdpsTableView.register(CDPTableViewCell.self, forCellReuseIdentifier: "cdpCell")
        view.addSubview(cdpsTableView)
        cdpsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        cdpsTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        cdpsTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        cdpsTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        cdpsTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        cdpsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
        let floaty = Floaty()

        floaty.openAnimationType = .slideUp
        
        floaty.overlayColor = UIColor.black.withAlphaComponent(0.7)
        
        
        let ethItem = FloatyItem()
        ethItem.buttonColor = .black
        ethItem.title = "ETH Address"
        ethItem.icon = UIImage(named: "ethWhiteCircle")!
        ethItem.handler = { ethItem in
            let alert = UIAlertController(title: "Soon™️", message: "Coming Soon", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            floaty.close()
        }
        floaty.addItem(item: ethItem)
        
        let contactItem = FloatyItem()
        contactItem.buttonColor = .black
        contactItem.title = "Contact"
        contactItem.icon = UIImage(named: "contact")!
        contactItem.handler = { ethItem in
            let alert = UIAlertController(title: "Soon™️", message: "Coming Soon", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            floaty.close()
        }
        floaty.addItem(item: contactItem)
        
        let cdpItem = FloatyItem()
        cdpItem.buttonColor = .black
        cdpItem.title = "CDP"
        cdpItem.icon = UIImage(named: "cdp")!
        cdpItem.handler = { ethItem in
            let alert = UIAlertController(title: "Add a CDP number", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Enter the number. e.g. 3228"
                textField.keyboardType = .numberPad
            })
            
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
                
                if let cdp = alert.textFields?.first?.text {
                    print("Your CDP: \(cdp)")
                    
                    guard let appDelegate =
                        UIApplication.shared.delegate as? AppDelegate else {
                            return
                    }
                    
                    // 1
                    let managedContext =
                        appDelegate.persistentContainer.viewContext
                    
                    // 2
                    let entity =
                        NSEntityDescription.entity(forEntityName: "Maker",
                                                   in: managedContext)!
                    
                    let maker = NSManagedObject(entity: entity,
                                                insertInto: managedContext)
                    
                    maker.setValue(cdp, forKeyPath: "singleCollateralDaiIdentifier")
                    
                    // 4
                    do {
                        try managedContext.save()
                        self.makers.append(maker)
                        self.getData()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
                
    //            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //            let task = Task(context: context) // Link Task & Context
    //            task.name = taskTextField.text!
    //
    //            // Save the data to coredata
    //            (UIApplication.shared.delegate as! AppDelegate).saveContext()
    //            let task = Maker(singleCollateralDaiIdentifier: cdp) // Link Task & Context
                
    //            let maker = Maker(context: context)
    //            maker.singleCollateralDaiIdentifier = cdp
                
                
                
                // Save the data to coredata
    //            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }))
            
//            DispatchQueue.main.async {
                //                    self.feed = feedWrapper["feed"]!
                //                    self.tableView.reloadData()
                //                    self.tabl
                //                    self.cdps
            
//            }
            
            self.present(alert, animated: true)
        }
        floaty.addItem(item: cdpItem)
        
        let deleteItem = FloatyItem()
        deleteItem.buttonColor = .black
        deleteItem.title = "Delete All"
        deleteItem.icon = UIImage(named: "trash")!
        deleteItem.handler = { ethItem in
//            let alert = UIAlertController(title: "Soon™️", message: "Coming Soon", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            floaty.close()
            
//            guard let appDelegate =
//                UIApplication.shared.delegate as? AppDelegate else {
//                    return
//            }
//
//            let managedContext = appDelegate.persistentContainer.viewContext
//
//            //2
////            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Maker")
//
//
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Maker")
//            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//            do {
//                try NSPersistentStoreCoordinator.executeRequest(deleteRequest, withContext: managedContext)
//            } catch let error as NSError {
//                // TODO: handle the error
//            }
            self.deleteAllData("Maker")
            self.getData()
            
        }
        floaty.addItem(item: deleteItem)
        
        
        self.view.addSubview(floaty)
        
        setUpNavigation()
    }
    
    func deleteAllData(_ entity:String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

//        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                appDelegate.persistentContainer.viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CDPs.count
//        return 10
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cdpCell", for: indexPath) as! CDPTableViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
        
//        cell.textLabel?.text = "\(CDPs[indexPath.row].identifier!)"
        
        cell.cdp = CDPs[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}

