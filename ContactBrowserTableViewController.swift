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
    
    // MARK: - Outlets, Classes and Variables
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var contactViewModel = ContactViewModel()
    
    private let contactBrowserCellIdentifier = "ContactTableViewCell"
    
    
    
    
    
    // MARK: - UITableViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        DispatchQueue.global(qos: .background).async { [weak self] () -> Void in
            self?.contactViewModel.loadContacts()
            DispatchQueue.main.async { () -> Void in
                self?.tableView.reloadData()
            }
        }
    }
    
    
    
    
    
    
    // MARK: - UISearchBarDelegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText != "" {
            contactViewModel.shouldShowSearchResults = true
            contactViewModel.resetFilteredContactArray()
            DispatchQueue.global(qos: .background).async { [weak self] () -> Void in
                self?.contactViewModel.loadFilteredContacts(filterString: searchText)
                DispatchQueue.main.async { () -> Void in
                    self?.tableView.reloadData()
                }
            }
        } else {
            contactViewModel.shouldShowSearchResults = false
            self.tableView.reloadData()
        }
    }
    
    
    
    
    
    
    // MARK: - UITableView Datasource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: contactBrowserCellIdentifier, for: indexPath) as UITableViewCell
        
        let contact = contactViewModel.contactAtIndex(indexPath: indexPath)
        
        cell.textLabel?.text = "\(contact.givenName) \(contact.familyName)"
        let phoneNumber = contactViewModel.phoneNumberStringModifier(contact: contact)
        cell.detailTextLabel?.text = "\(phoneNumber)"
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contact = contactViewModel.contactAtIndex(indexPath: indexPath)
        
        let contactName = "\(contact.givenName) \(contact.familyName)"
        let phoneNumber = contactViewModel.phoneNumberStringModifier(contact: contact)
        
        let alertController = UIAlertController(title: "Call Contact", message: "Would you like to call \(contactName) at number: \(phoneNumber)?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            let phoneNumberForCalling = (contact.phoneNumbers[0].value).value(forKey: "digits") as! String
            if let url = NSURL(string: "tel://\(phoneNumberForCalling)") {
                UIApplication.shared.open(URL(string: "\(url)")!, options: [:]) { completion in print("Was number \(phoneNumberForCalling) called? \(completion)") }
            }
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return contactViewModel.titleForHeaderInSection(section: section)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        var sections = 0
        
        if (contactViewModel.shouldShowSearchResults) {
            return 1
        } else {
            for _ in contactViewModel.contactModel.contacts.keys {
                sections += 1
            }
        }
        return sections
        
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





// MARK: - Extensions to Fundamental Classes

extension String {
    func insert(string:String,ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
    
}
