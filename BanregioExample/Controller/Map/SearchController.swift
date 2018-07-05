//
//  SearchController.swift
//  BanregioExamen
//
//  Created by Abraham Barcenas on 30/06/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit

protocol SearchControllerDelegate: class {
    func didSelectOption(sucursal: Sucursal)
}

class SearchController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var branches: [Sucursal] = []
    var branchesFiltered : [Sucursal] = []
    var inSearchMode : Bool = false
    weak var delegate: SearchControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension SearchController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            tableView.reloadData()
        }else{
            inSearchMode = true
            branchesFiltered = []
            
            branchesFiltered = branches.filter({
                return "\($0.nombre) \($0.domicilio) \($0.horario) \($0.tipoCompleto)".lowercased().contains(searchText.lowercased())
            })
            
            tableView.reloadData()
        }
    }
}

extension SearchController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? branchesFiltered.count : branches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sucursal = inSearchMode ? branchesFiltered[indexPath.row] : branches[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.configureCell(sucursal: sucursal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sucursal = inSearchMode ? branchesFiltered[indexPath.row] : branches[indexPath.row]
        delegate?.didSelectOption(sucursal: sucursal)
    }
}


