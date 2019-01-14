//
//  ViewController.swift
//  MuseumAPI
//
//  Created by Stephanie Ramirez on 12/28/18.
//  Copyright © 2018 Stephanie Ramirez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private var object: ObjectData!{
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private var objectIDs = [Int]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar.delegate = self
//        searchBar.autocapitalizationType = .none
        fetchIds()
    }
    private func fetchIds() {
        MuseumAPIClient.getObjectIds { (appError, objectIds) in
            if let appError = appError {
                print(appError.errorMessage())
            } else if let objectIds = objectIds {
                self.objectIDs = objectIds
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
            let detailViewController = segue.destination as? DetailViewController else { fatalError("indexPath, detailViewController nil")}
        let objectId = objectIDs[indexPath.row]
        detailViewController.objectId = objectId
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectCell", for: indexPath)
        let object = objectIDs[indexPath.row]
        cell.textLabel?.text = "Object ID: \(object)"
        

        return cell
    }
}
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text {
            if let searchTermInt = Int(searchTerm) {
                MuseumAPIClient.searchEvents(keyword: searchTermInt) { (appError, object) in
                    if let appError = appError {
                        print(appError)
                    }
                    if let object = object {
                        self.object = object
                    }
                }
            }
        }
        searchBar.resignFirstResponder()

    }
}

