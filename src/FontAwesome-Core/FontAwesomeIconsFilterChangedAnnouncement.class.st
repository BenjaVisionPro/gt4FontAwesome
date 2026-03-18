Class {
	#name : 'FontAwesomeIconsFilterChangedAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'iconLibraryClass',
		'queryText'
	],
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'instance creation' }
FontAwesomeIconsFilterChangedAnnouncement class >> iconLibraryClass: anIconLibraryClass queryText: aString [
	^ self new
		iconLibraryClass: anIconLibraryClass;
		queryText: aString;
		yourself
]

{ #category : 'accessing' }
FontAwesomeIconsFilterChangedAnnouncement >> iconLibraryClass [
	^ iconLibraryClass
]

{ #category : 'accessing' }
FontAwesomeIconsFilterChangedAnnouncement >> iconLibraryClass: anIconLibraryClass [
	iconLibraryClass := anIconLibraryClass
]

{ #category : 'accessing' }
FontAwesomeIconsFilterChangedAnnouncement >> queryText [
	^ queryText
]

{ #category : 'accessing' }
FontAwesomeIconsFilterChangedAnnouncement >> queryText: aString [
	queryText := aString
]
