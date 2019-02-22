//
//  ViewController.swift
//  Balance
//
//  Created by Richard Burton on 19/02/2019.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit

let cdpsTableView = UITableView() // view


private var CDPs = [CDP]()

//homeViewC: UIViewController, UITableViewDataSource {}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    override func viewWillAppear(_ animated: Bool) {

        //        guard let url = URL(string: "https://mkr.tools/api/v1/lad/0x1db7332D24EBbdC5F49c34AA6830Cb7f46A3647C") else {return} // liquidated
//                guard let url = URL(string: "https://mkr.tools/api/v1/lad/0x03c245bAFCC0a80cD73b170D26e3d3663B90793C") else {return} // one big cdp + API broken
//                guard let url = URL(string: "https://mkr.tools/api/v1/lad/0x1db7332D24EBbdC5F49c34AA6830Cb7f46A3647C") else {return} // 420
//        guard let url = URL(string: "https://mkr.tools/api/v1/lad/0x3A306a399085F3460BbcB5b77015Ab33806A10d5") else {return}// lots of cdps
//                guard let url = URL(string: "https://mkr.tools/api/v1/cdp/3228") else {return}// biggest CDP
        
        guard let url = URL(string: "https://mkr.tools/api/v1/cdp/14165") else {return}// a CDP
        
        
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
                    cdpsTableView.reloadData()
                }
                
            } catch let parsingError {
                //                return(parsingError)
                print("Error", parsingError)
            }
            
        }
        
        task.resume()
    }
    
    func setUpNavigation() {
//        DispatchQueue.main.async {
//            if let pip = CDPs[0].pip {
//
//                self.navigationItem.title = "$\(String(format:"%.2f", pip)) "
//            }
//        }
        
        navigationItem.title = "CDPs"
        self.navigationController?.navigationBar.barTintColor = _ColorLiteralType(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
//        self.navigationController?.navigationBar.barTintColor = UIColor(cgColor: CGColor.b)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:_ColorLiteralType(red: 1, green: 1, blue: 1, alpha: 1)]
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
        
        
        
        setUpNavigation()
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
        return 80
    }
}

