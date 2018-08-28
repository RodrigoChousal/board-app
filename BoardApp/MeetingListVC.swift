//
//  MeetingListVC.swift
//  BoardApp
//
//  Created by Rodrigo Chousal on 8/28/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit

class MeetingListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "TestMeeting" {
            // Template meeting for testing:
            let meetingVC = segue.destination as! MeetingVC
            meetingVC.meeting = generateTestMeeting()
        }
    }
    
    // MARK: - Helper Methods
    
    func generateTestMeeting() -> Meeting {
        
        let person1 = Person(firstName: "Jesús", lastName: "Parás", roles: [Person.Role.administrador])
        let person2 = Person(firstName: "Roberto", lastName: "Marcos", roles: [Person.Role.presidente])
        let person3 = Person(firstName: "Manuel", lastName: "Doblado", roles: [Person.Role.secretario])
        let person4 = Person(firstName: "Alfredo", lastName: "Peña", roles: [Person.Role.consejero])
        let people = [person1, person2, person3, person4]
        
        let duration1 = TimeInterval(exactly: 30)
        let topic1 = Topic(color: UIColor.red, title: "Tema 1", objective: "Objetivo del tema", pointsToDiscuss: [DiscussionPoint(point: "Punto 1"),
                                                                                              DiscussionPoint(point: "Punto 2"),
                                                                                              DiscussionPoint(point: "Punto 3"),
                                                                                              DiscussionPoint(point: "Punto 4")], duration: duration1!)
        
        let duration2 = TimeInterval(exactly: 25)
        let topic2 = Topic(color: UIColor.gray, title: "Tema 2", objective: "Objetivo del tema 2", pointsToDiscuss: [DiscussionPoint(point: "Punto 5"),
                                                                                                DiscussionPoint(point: "Punto 6"),
                                                                                                DiscussionPoint(point: "Punto 7"),
                                                                                                DiscussionPoint(point: "Punto 8")], duration: duration2!)
        let duration3 = TimeInterval(exactly: 290)
        let topic3 = Topic(color: UIColor.green, title: "Tema 3", objective: "Objetivo del tema 3", pointsToDiscuss: [DiscussionPoint(point: "Punto 9"),
                                                                                                DiscussionPoint(point: "Punto 10"),
                                                                                                DiscussionPoint(point: "Punto 11"),
                                                                                                DiscussionPoint(point: "Punto 12")], duration: duration3!)
        let topics = [topic1, topic2, topic3]
        
        let location = Location(name: Location.ValidName.sala1)
        
        return Meeting(title: "Test Meeting", participants: people, topics: topics, location: location)
    }
}
