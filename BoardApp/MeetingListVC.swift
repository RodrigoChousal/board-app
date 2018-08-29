//
//  MeetingListVC.swift
//  BoardApp
//
//  Created by Rodrigo Chousal on 8/28/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit
import FirebaseAuth

class MeetingListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user: LocalUser!
    
    @IBOutlet weak var meetingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch user meetings from Firebase

        meetingTableView.delegate = self
        meetingTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.meetings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingCell", for: indexPath) as! MeetingTVCell
        let meeting = user.meetings[indexPath.row]
        cell.titleLabel.text = meeting.title
        cell.timeDateLabel.text = meeting.timeDate.description
        cell.participantsLabel.text = meeting.participantList
        cell.topicsLabel.text = meeting.topicList
        cell.durationLabel.text = meeting.totalDuration.description
        cell.fileCountLabel.text = meeting.fileCount.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        } else if segue.identifier == "MeetingSegue" {
            let meetingVC = segue.destination as! MeetingVC
            if let selectedRow = self.meetingTableView.indexPathForSelectedRow?.row {
                meetingVC.meeting = user.meetings[selectedRow]
            }
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func showPastMeetings(_ sender: Any) {
        
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        if let _ = try? Auth.auth().signOut(), let _ = try? KeychainManager.deleteCredentials(credentials: KeychainManager.fetchCredentials()) {
            self.dismiss(animated: true) {
                print("Deleted local credentials, user signed out, and dismissed view controller")
            }
        } else {
            print("There was an error signing out!")
        }
    }
    
    // MARK: - Helper Methods
    
    func generateTestMeeting() -> Meeting {
        
        let person1 = Person(firstName: "Jesús", lastName: "Parás")
        let person2 = Person(firstName: "Roberto", lastName: "Marcos")
        let person3 = Person(firstName: "Manuel", lastName: "Doblado")
        let person4 = Person(firstName: "Alfredo", lastName: "Peña")
        let participants = [Person.Role.administrador : person1, Person.Role.consejero : person2, Person.Role.secretario : person3, Person.Role.presidente : person4]
        
        let duration1 = TimeInterval(exactly: 30)
        let topic1 = Topic(color: UIColor.red, title: "Tema 1", responsible: person4, objective: "Objetivo del tema", pointsToDiscuss: [DiscussionPoint(point: "Punto 1"),
                                                                                                                                        DiscussionPoint(point: "Punto 2"),
                                                                                                                                        DiscussionPoint(point: "Punto 3"),
                                                                                                                                        DiscussionPoint(point: "Punto 4")], duration: duration1!)
        
        let duration2 = TimeInterval(exactly: 25)
        let topic2 = Topic(color: UIColor.gray, title: "Tema 2", responsible: person3, objective: "Objetivo del tema 2", pointsToDiscuss: [DiscussionPoint(point: "Punto 5"),
                                                                                                                                           DiscussionPoint(point: "Punto 6"),
                                                                                                                                           DiscussionPoint(point: "Punto 7"),
                                                                                                                                           DiscussionPoint(point: "Punto 8")], duration: duration2!)
        let duration3 = TimeInterval(exactly: 290)
        let topic3 = Topic(color: UIColor.brown, title: "Tema 3", responsible: person1, objective: "Objetivo del tema 3", pointsToDiscuss: [DiscussionPoint(point: "Punto 9"),
                                                                                                                                            DiscussionPoint(point: "Punto 10"),
                                                                                                                                            DiscussionPoint(point: "Punto 11"),
                                                                                                                                            DiscussionPoint(point: "Punto 12")], duration: duration3!)
        let topics = [topic1, topic2, topic3]
        
        let location = Location(name: Location.ValidName.sala1)
        
        return Meeting(title: "Test Meeting", timeDate: Date(), participants: participants, topics: topics, location: location)
    }
}
