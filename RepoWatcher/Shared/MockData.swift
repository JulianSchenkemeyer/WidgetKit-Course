//
//  MockData.swift
//  RepoWatcher
//
//  Created by Julian Schenkemeyer on 28.08.22.
//

import Foundation

struct MockData {
	static let repoOne = Repository(name: "Repository One",
									owner: Owner(avatarUrl: ""),
									hasIssues: true,
									forks: 12,
									watchers: 999,
									openIssues: 16,
									pushedAt: "2022-08-12T18:09:00Z",
									avatarData: Data())
	
	static let repoTwo = Repository(name: "Repository Two",
									owner: Owner(avatarUrl: ""),
									hasIssues: false,
									forks: 120,
									watchers: 509,
									openIssues: 0,
									pushedAt: "2021-08-12T18:09:00Z",
									avatarData: Data())

}
