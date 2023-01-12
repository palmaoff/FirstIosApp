//
//  WallController.swift
//  RandomPhoto
//
//  Created by eflorean on 11.01.2023.
//

import FirebaseFirestore
import UIKit

class WallController: UIViewController, UITableViewDataSource {
    
    var items = [String]()
    let database = Firestore.firestore()
        
    private let table: UITableView = {
        
        let table = UITableView()
        
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        
        return table
        
    }()
    
    private let button: UIButton  = {
        let button = UIButton()

        button.backgroundColor = .white
        button.setTitle("Write something", for: .normal)
        button.setTitleColor(.black, for: .normal)

        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let docRef = database.document("efloren/test")
        
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            if data["data"] != nil {
                self.items = data["data"] as? [String] ?? ["nothing new"]
                self.table.reloadData()
            }
        }
        
        view.addSubview(table)
        table.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        table.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    
    @objc func didTapAdd() {
        let alert = UIAlertController(title: "New Post", message: "Enter something...", preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = "Enter here..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default , handler: { [weak self] (_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    
                    DispatchQueue.main.async {
                        self?.items.append(text)
                        self?.table.reloadData()
                        
                        self?.writeData()
                    }
                    
                }
            }
        }))
        
        present(alert, animated: true)
    }
    
    func writeData() {
        
        let docRef = database.document("efloren/test")
        docRef.setData(["data": items])

    }
    
}
