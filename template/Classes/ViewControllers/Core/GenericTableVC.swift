//
//  PrototypedVC.swift
//  template
//
//  Created by Alexis Creuzot on 06/08/2019.
//  Copyright © 2019 waverlylabs. All rights reserved.
//

import UIKit

class GenericTableVC : CoreVC, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    public var datasource = [GenericTableCellVM]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = datasource[indexPath.row]
        return viewModel.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = datasource[indexPath.row]
        return viewModel.estimatedHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = datasource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier, for: indexPath)
        if let cell = cell as? GenericTableCell {
            cell.setViewModel(viewModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

