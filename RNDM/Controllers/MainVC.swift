//
//  ViewController.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/25/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit
import Firebase

class MainVc: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var thoughtsTV: UITableView!
    
    // MARK:- Variables
    private var thoughtsArr = [Thought]()
    private var categorySelected = Categories.funny.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thoughtsTV.estimatedRowHeight = 80
        thoughtsTV.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AuthService.instance.authActionListener { (status) in
            if status{
                self.setListeners()  // user is logged in
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVc = storyboard.instantiateViewController(identifier: "LoginVC")
                loginVc.modalPresentationStyle = .fullScreen
                self.present(loginVc, animated: true, completion: nil)
            }
        }
    }
    
    // good practise to remove listener when we are not using it
    override func viewWillDisappear(_ animated: Bool) {
        if DataService.instance.ACTION_LISTENER != nil{
            DataService.instance.removeListener()
        }
    }
    
    func setListeners(){
        DataService.instance.getAllDocuments(category: self.categorySelected) { (thoughts, error) in
            if let err = error{
                debugPrint(err.localizedDescription)
            }else{
                guard let arr = thoughts else { return }
                self.thoughtsArr = arr
                self.thoughtsTV.reloadData()
            }
        }
    }
    
    func getPopularThoughts(){
        DataService.instance.getPopularDocuments { (thoughts, error) in
            if let err = error{
                debugPrint(err.localizedDescription)
            }else{
                guard let arr = thoughts else { return }
                self.thoughtsArr = arr
                self.thoughtsTV.reloadData()
            }
        }
    }
    
    // MARK:- Actions
    
    @IBAction func categoryChanged(_ sender: Any) {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            self.categorySelected = Categories.funny.rawValue
            break
            
        case 1:
            self.categorySelected = Categories.serious.rawValue
            break
            
        case 2:
            self.categorySelected = Categories.crazy.rawValue
            break

        default:
            self.categorySelected = Categories.popular.rawValue
            break
        }
        
        DataService.instance.removeListener() // to avoid multiple listeners
        Categories.popular.rawValue == self.categorySelected ? getPopularThoughts() : setListeners()
    }
    
    
    @IBAction func logoutUser(_ sender: Any) {
        AuthService.instance.logoutUser()
    }
    
}

extension MainVc: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughtsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCell", for: indexPath) as? ThoughtCell else { return UITableViewCell() }
        
        cell.configureCell(thought: thoughtsArr[indexPath.row], delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "tocomments", sender: thoughtsArr[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tocomments"{
            if let destinationVc = segue.destination as? CommentsVC{
                if let thought = sender as? Thought{
                    destinationVc.thought = thought
                }
            }
        }
    }
}

extension MainVc: ThoughtDelegate{
    
    func thoughtOptionTapped(thought: Thought) {
        // here we handle the alert
       
        let alert = UIAlertController(title: "Delete Though", message: "you can delete a comment", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete Comment", style: .default) { (action) in
            // here we will perform the delete action
            
            self.delete(collection: Firestore.firestore().collection("thoughts").document(thought.docuemntId).collection(COMMENTS)) { (error) in
                
                if let err = error{
                    debugPrint(err.localizedDescription)
                }else{
                    // delete of sub collection was successful
                    DataService.instance.deleteThought(uid: thought.docuemntId) { (status) in
                        
                        if status {
                            print("success")
                        }else{
                            print("failure")
                        }
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func delete(collection: CollectionReference, batchSize: Int = 100, completion: @escaping (Error?) -> ()) {

           //Limit query to avoid out-of-memory errors on large collections.

           //When deleting a collection guaranteed to fit in memory, batching can be avoided entirely.

           collection.limit(to: batchSize).getDocuments { (docset, error) in

               // An error occured.

               guard let docset = docset else {

                   completion(error)

                   return

               }

               //There's nothing to delete.

               guard docset.count > 0 else {

                   completion(nil)

                   return

               }
            let batch = collection.firestore.batch()

               docset.documents.forEach { batch.deleteDocument($0.reference) }
               batch.commit { (batchError) in

                   if let batchError = batchError {

                       // Stop the deletion process and handle the error. Some elements

                       // may have been deleted.

                       completion(batchError)

                   } else {

                       self.delete(collection: collection, batchSize: batchSize, completion: completion)

                   }

               }

           }

       }
    
    
}
