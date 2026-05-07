//
//  Router.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/4/26.
//

import SwiftUI
import Observation

enum Route: Hashable {
    case orgDetail(organization: Organization)
    case calendarDetail(day: Day)
    case memberList(organization: Organization)
    case memberDetail(member: Member, organization: Organization)
    case subgroupList(organization: Organization)
    case subgroupDetail(organization: Organization, subgroup: String)
}

