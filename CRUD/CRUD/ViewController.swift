//
//  ViewController.swift
//  CRUD
//
//  Created by Noura Alahmadi on 11/04/1443 AH.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var studentTable: UITableView!
    @IBOutlet weak var textStudentName : UITextField!
    
    //handel for the whole DataModel to Interact with.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var result = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentTable.delegate = self
        studentTable.dataSource = self
        fetchDataFromDB()
    }
    
    @IBAction func onPressAdd(_ sender: UIButton) {
        
        // Add the Text from TextField To DB
        let newStudent = Student(context: context)
        newStudent.name = textStudentName.text!
        
        // Save Context
        do {try! context.save()}
        
        // fetch data from DB agin
        
        // FtechDataFromDB ()
        fetchDataFromDB()
    }
    
    func fetchDataFromDB(){
        // Get contect
        
        let request = Student.fetchRequest() //as! NSFetchRequest <Student> // the way of fetch data
        
        // Configure the request - NSFetchRequest
        // sort the names from A - Z ,  with no Caps
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        request.sortDescriptors = [sortDescriptor]
        
            // with Caps only
//        let sorting = NSSortDescriptor(key: "name", ascending: true)
//        request.sortDescriptors = [sorting]
      
        // filtring
        
//        let filtring = NSPredicate(format: " name CONTAINS 'A' ")
//        request.predicate = filtring
//        
        // Assign the result of FetchRequest to array
        
        do{
            try!
            result = context.fetch(request)
            studentTable.reloadData()
            
        }
    }
    @IBAction func addRandomName(_ sender: Any) {
        do {
            for _ in 0...20 {
                let n = Student(context: context)
                n.name = "random name"
                
                try!
                context.save()
                fetchDataFromDB()
            }
          }
          
     
    }
    
    @IBAction func removeLast(_ sender: Any) {
        
        do {
            for _ in 0...10 {
              if let item = result.last {
                context.delete(item)
              }
              try!
                context.save()
              fetchDataFromDB()
            }
          }
        
        
    }
    

    
    // MARK: Table View
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") { _, _, handler in
            
            let itemToDelet = self.result[indexPath.row]
            
            self.context.delete(itemToDelet)
            do{ try!
                self.context.save()
                self.fetchDataFromDB()
            }
        }
        return UISwipeActionsConfiguration (actions: [actionDelete])
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = result[indexPath.row].name
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Edite", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        
        let textBox = alert.textFields![0]
        textBox.text = result[indexPath.row].name
        
        let saveAction = UIAlertAction(title: "save", style: .default, handler: {action in
            
            self.result[indexPath.row].name = textBox.text
            do{try!
                self.context.save()
                self.fetchDataFromDB()
            }
        })
        
        
        let cancelAction = UIAlertAction(title: "cancel", style: .default, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}



