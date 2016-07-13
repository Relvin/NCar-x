//
//  NSearchController.swift
//  NCar-X
//
//  Created by Relvin on 16/7/10.
//  Copyright © 2016年 Relvin. All rights reserved.
//

import UIKit

class NSearchController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    
    @IBOutlet weak var _searchBar: UISearchBar!
    
    @IBOutlet weak var _touchView: UIControl!
    override func viewDidLoad() {
        super.viewDidLoad();
        _touchView.hidden = true;
    }
    
    @IBAction func touchUpInside(sender: AnyObject) {
        self.view.endEditing(true);
        _touchView.hidden = true;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell();
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        _touchView.hidden = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true);
        _touchView.hidden = true;
    }
}
