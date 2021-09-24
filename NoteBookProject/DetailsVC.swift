//
//  DetailsVC.swift
//  NoteBookProject
//
//  Created by Furkan Aykut on 19.09.2021.
//

import UIKit
import CoreData

class DetailsVC: UIViewController {
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteLabel: UITextView!
    
    var chosenNote = ""
    var chosenNoteId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chosenNote != ""{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            let idString = chosenNoteId?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                
                let results = try context.fetch(fetchRequest)
                if results.count > 0{
                    for result in results as! [NSManagedObject]{
                        if let note = result.value(forKey: "note") as? String{
                            noteLabel.text = note
                        }
                        if let title = result.value(forKey: "title") as? String{
                            noteTitle.text = title
                        }
                    }
                }
                
            }catch{
                print("Error")
            }
            
            
            
            
        }else{
            noteTitle.text = ""
            noteLabel.text = ""
        }
        
        

        let gestureRecognizer = UIGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
        
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if chosenNote == "" {
            saveData(context: context)
        }
        else{
            updateData(context: context)
        }
        
        do{
            try context.save()
            print("Saved")
        }catch{
            print("Error")
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateData(context : NSManagedObjectContext ) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let idString = chosenNoteId?.uuidString
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            
            let results = try context.fetch(fetchRequest)
            if results.count > 0{
                for result in results as! [NSManagedObject]{
                        result.setValue(noteLabel.text!, forKey: "note")
                        result.setValue(noteTitle.text!, forKey: "title")
                }
            }
         
        }catch{
            print("error")
        }
    }
    

    func saveData(context : NSManagedObjectContext) {
        let newNotes = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context)
        
        newNotes.setValue(noteTitle.text!, forKey: "title")
        newNotes.setValue(noteLabel.text!, forKey: "note")
        newNotes.setValue(UUID(), forKey: "id")
    }
   

}
