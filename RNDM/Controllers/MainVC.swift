//
//  ViewController.swift
//  RNDM
//
//  Created by Harshit Gajjar on 6/25/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit

class MainVc: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var thoughtsTV: UITableView!
    
    // MARK:- Variables
    private let thoughtsArr = [Thought]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thoughtsTV.estimatedRowHeight = 80
        thoughtsTV.rowHeight = UITableView.automaticDimension
    }
}

extension MainVc: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughtsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCell", for: indexPath) as? ThoughtCell else { return UITableViewCell() }
        
        cell.configureCell(thought: thoughtsArr[indexPath.row])
        return cell
    }
    
    
}

