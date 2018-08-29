//
//  DatabaseManager.swift
//  BoardApp
//
//  Created by Rodrigo Chousal on 8/29/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import Foundation
import UIKit

class DatabaseManager {
    
    // MARK: - Meetings Helper Methods
    
    static func stringsToMeetings(rawMeetings: NSArray) -> [Meeting] {
        let meetingCount = rawMeetings.count
        var meetingList = [Meeting]()
        for i in 0...(meetingCount - 1) {
            print(rawMeetings[i])
            if let meetingsDictionary = rawMeetings[i] as? NSDictionary {
                let meeting = Meeting(fromDictionary: meetingsDictionary)
                meetingList.append(meeting)
                print("Appended new meeting to internal list.")
            }
        }
        return meetingList
    }
    
    // MARK: - String Converters
    
    static func validTitle(fromString titleString: String) -> String {
        if titleString.isEmpty {
            return "No Title Found"
        } else {
            return titleString
        }
    }
    
    static func validDate(fromString dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        guard let date = dateFormatter.date(from: dateString) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        return date
    }
    
    static func validPerson(fromDictionary personDictionary: NSDictionary) -> Person {
        var person: Person
        if let firstName = personDictionary.value(forKey: "firstName") as? String, let lastName = personDictionary.value(forKey: "lastName") as? String {
            person = Person(firstName: firstName, lastName: lastName)
            return person
        } else {
            print("Error! Person was not valid, returned default value: Fake Person")
            return Person(firstName: "Fake", lastName: "Person")
        }
    }
    
    static func validRole(fromString roleString: String) -> Person.Role {
        if let role = Person.Role(rawValue: roleString) {
            return role
        } else {
            print("Error! Role was not valid, returned default value: Invitado")
            return Person.Role.invitado
        }
        
    }
    
    static func validParticipants(fromDictionary participantDictionary: NSDictionary) -> [Person.Role : Person] {
        var participants = [Person.Role : Person]()
        for (role, person) in participantDictionary {
            let validRole = self.validRole(fromString: role as? String ?? "")
            let validPerson = self.validPerson(fromDictionary: person as? NSDictionary ?? NSDictionary())
            participants[validRole] = validPerson //FIXME: Could prove faulty because of dual roles
        }
        return participants
    }
    
    static func validLocation(fromString locString: String) -> Location {
        if let name = Location.ValidName(rawValue: locString) {
            let location = Location(name: name)
            return location
        } else { // default
            print("Error! Location was not valid, returned default value: Sala1")
            return Location(name: Location.ValidName.sala1)
        }
    }
    
    static func validColor(fromString colorString: String) -> UIColor {
        if let validColor = UIColor(named: colorString) {
            return validColor
        } else {
            print("Error! Color was not valid, returned default value: Black")
            return UIColor.black
        }
    }
    
    static func validObjective(fromString objectiveString: String) -> String {
        if objectiveString.isEmpty {
            return "No Objective Found"
        } else {
            return objectiveString
        }
    }
    
    static func validDiscussionPoints(fromArray pointsArray: NSArray) -> [DiscussionPoint] {
        var validPoints = [DiscussionPoint]()
        for point in pointsArray {
            if let pointDictionary = point as? NSDictionary {
                let point = DiscussionPoint(point: pointDictionary.value(forKey: "point") as? String ?? "Invalid Point")
            } else {
                print("Error! Discussion Point was not valid, returned default value: Invalid Point")
                validPoints.append(DiscussionPoint(point: "Invalid Point"))
            }
        }
        return validPoints
    }
    
    static func validDuration(fromString durationString: String) -> TimeInterval {
        if let number = Double(durationString) {
            return TimeInterval(number)
        } else {
            print("Error! Duration was not valid, returned default value: 0 seconds")
            return TimeInterval(0)
        }
    }
    
    static func validTopics(fromArray topicsArray: NSArray) -> [Topic] {
        var validTopics = [Topic]()
        for topic in topicsArray {
            if let topicDictionary = topic as? NSDictionary {
                let color = validColor(fromString: topicDictionary.value(forKey: "color") as? String ?? "Invalid Color")
                let title = validTitle(fromString: topicDictionary.value(forKey: "title") as? String ?? "Invalid Title")
                let objective = validObjective(fromString: topicDictionary.value(forKey: "objective") as? String ?? "Invalid Objective")
                let discussionPoints = validDiscussionPoints(fromArray: topicDictionary.value(forKey: "discussionPoints") as? NSArray ?? NSArray())
                let duration = validDuration(fromString: topicDictionary.value(forKey: "duration") as? String ?? "Invalid Duration")
                let responsible = validPerson(fromDictionary: topicDictionary.value(forKey: "responsible") as?  NSDictionary ?? NSDictionary())
                let validTopic = Topic(color: color, title: title, responsible: responsible, objective: objective, pointsToDiscuss: discussionPoints, duration: duration)
                validTopics.append(validTopic)
            }
        }
        
        return [Topic(color: .red, title: "atitle", responsible: Person(firstName: "Fake", lastName: "Name"), objective: "Objective", pointsToDiscuss: [DiscussionPoint(point: "point")], duration: TimeInterval(20))]
    }
}
