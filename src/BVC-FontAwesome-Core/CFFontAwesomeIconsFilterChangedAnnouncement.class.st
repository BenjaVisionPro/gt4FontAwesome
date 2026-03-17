Class {
	#name : 'CFFontAwesomeIconsFilterChangedAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'iconLibraryClass',
		'queryText'
	],
	#category : 'BVC-FontAwesome-Core',
	#package : 'BVC-FontAwesome-Core'
}

{ #category : 'instance creation' }
CFFontAwesomeIconsFilterChangedAnnouncement class >> iconLibraryClass: anIconLibraryClass queryText: aString [
	^ self new
		iconLibraryClass: anIconLibraryClass;
		queryText: aString;
		yourself
]

{ #category : 'accessing' }
CFFontAwesomeIconsFilterChangedAnnouncement >> iconLibraryClass [
	^ iconLibraryClass
]

{ #category : 'accessing' }
CFFontAwesomeIconsFilterChangedAnnouncement >> iconLibraryClass: anIconLibraryClass [
	iconLibraryClass := anIconLibraryClass
]

{ #category : 'accessing' }
CFFontAwesomeIconsFilterChangedAnnouncement >> queryText [
	^ queryText
]

{ #category : 'accessing' }
CFFontAwesomeIconsFilterChangedAnnouncement >> queryText: aString [
	queryText := aString
]
