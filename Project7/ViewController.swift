//
//  ViewController.swift
//  Petition
//
//  Created by Ritik Srivastava on 28/08/20.
//  Copyright © 2020 Ritik Srivastava. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petition = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchData()
        
    }
}


//fetch data
extension ViewController {
    func fetchData(){
        var urlString:String?
        if navigationController?.tabBarItem.tag == 0{
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else{
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }

        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            if let url = URL(string: urlString!){
                if let data = try? Data(contentsOf: url){
                    print(data)
                    self?.parse(json: data)
                }
            }
        }
        
//        if let url = URL(string: urlString!){
//            if let data = try? Data(contentsOf: url){
//                print(data)
//                parse(json: data)
//            }
//        }
        

        
        
    }
    
    func parse(json : Data){
        
        let decoder = JSONDecoder()
        if let jsonPetition = try? decoder.decode(Petitions.self, from: json){
            petition = jsonPetition.results
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        
        
        
    }
}


//table view controller
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petition.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" ,for : indexPath)
        cell.textLabel?.text=petition[indexPath.row].title
        cell.detailTextLabel?.text = petition[indexPath.row].body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detail = petition[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
//        present(vc,animated: true)
    }
    
}

//this from it called from viewDidLoad()
// performSelector(inBackground: #selector(fetchJSON), with: nil)

//@objc func fetchJSON() {
//    let urlString: String
//
//    if navigationController?.tabBarItem.tag == 0 {
//        urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
//    } else {
//        urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
//    }
//
//    if let url = URL(string: urlString) {
//        if let data = try? Data(contentsOf: url) {
//            parse(json: data)
//            return
//        }
//    }
//
//    performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
//}
//
//func parse(json: Data) {
//    let decoder = JSONDecoder()
//
//    if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
//        petitions = jsonPetitions.results
//        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
//    }
//}
//
//@objc func showError() {
//    let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
//    ac.addAction(UIAlertAction(title: "OK", style: .default))
//    present(ac, animated: true)
//}


//if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
//    petitions = jsonPetitions.results
//    tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
//} else {
//    performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
//}
