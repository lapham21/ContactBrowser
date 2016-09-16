//
//  ContactBrowserTableViewController.swift
//  ContactBrowser
//
//  Created by Nolan Lapham on 9/12/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import UIKit
import Contacts

class ContactBrowserTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    // MARK: - Outlets, View Model and Variables
    
    @IBOutlet weak var searchBar: UISearchBar!

    var contactViewModel = ContactViewModel()
    
    private let contactBrowserCellIdentifier = "ContactTableViewCell"
 
    // MARK: - UITableViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        contactViewModel.loadContacts { err in
            if let err = err {
                print(err)
            } else {
                self.tableView.reloadData()
            }
        }
    }
 
    // MARK: - UISearchBarDelegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        contactViewModel.loadFilteredContacts(searchText: searchText) {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableView Datasource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: contactBrowserCellIdentifier, for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = contactViewModel.fullNameStringForContactAtIndexPath(indexPath: indexPath)
        cell.detailTextLabel?.text = contactViewModel.phoneNumberFancyStringForContactAtIndexPath(indexPath: indexPath)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertMessage = contactViewModel.alertControllerMessageForContactAtIndexPath(indexPath: indexPath)
        
        let alertController = UIAlertController(title: "Call Contact", message: alertMessage, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            let url = self.contactViewModel.urlForPlacingACallToContactAtIndexPath(indexPath: indexPath)
            let phoneNumberForCalling = self.contactViewModel.phoneNumberForContactAtIndexPath(indexPath: indexPath)
            
            UIApplication.shared.open(url!, options: [:]) { completion in print("Was number \(phoneNumberForCalling) called? \(completion)") }

        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactViewModel.titleForHeaderInSection(section: section)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactViewModel.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactViewModel.numberOfRowsInSection(section: section)
    }
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactViewModel.returnAlphabetArray()
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return contactViewModel.sectionForSectionIndexTitle(title: title, index: index)
    }
    
}
