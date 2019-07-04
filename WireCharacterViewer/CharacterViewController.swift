//
//  CharacterViewController.swift
//  WireCharacterViewer
//
//  Created by Gregory Jones on 7/4/19.
//  Copyright © 2019 Gregory Jones. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    let urlString = "http://api.duckduckgo.com/?q=the+wire+characters&format=json"
    let searchController = UISearchController(searchResultsController: nil)
    
    var detailViewController: DetailViewController? = nil
    var filteredListOfCharacters = [CharacterDetails]()
    var listOfCharacters = [CharacterDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertMessage()
        downloadJson()
        setupSearchController()
        setupTableView()
        
       
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if splitViewController!.isCollapsed {
            if let selectionIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectionIndexPath, animated: animated)
            }
        }
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func downloadJson() {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            
            do {
                let characters = try JSONDecoder().decode(Initial.self, from: data)
                self.listOfCharacters = characters.RelatedTopics
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            } catch let jsonErr {
                print("Error serializing json: ", jsonErr)
            }
            }.resume()
    }
   
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
    }
    
    func searchBarIsEmty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
        
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredListOfCharacters = listOfCharacters.filter({ (character: CharacterDetails) -> Bool in
            return character.Text!.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmty()
    }
    func alertMessage() {
        let alert = UIAlertController(title: "Search Bar", message: "Pull down to view search bar", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Thank you", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

}

extension CharacterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredListOfCharacters.count
        } else {
            return listOfCharacters.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CharacterCell else { return UITableViewCell() }
        let character: CharacterDetails
        
        if isFiltering() {
            character = filteredListOfCharacters[indexPath.row]
            
        } else {
            character = listOfCharacters[indexPath.row]
        }
        cell.nameLabel.text = character.Text
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedCharacter: CharacterDetails
                if isFiltering() {
                    selectedCharacter = filteredListOfCharacters[indexPath.row]
                } else {
                    selectedCharacter = listOfCharacters[indexPath.row]
                }
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailCharacter =  selectedCharacter
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}

extension CharacterViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
}

