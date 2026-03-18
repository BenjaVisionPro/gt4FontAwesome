Class {
	#name : 'CFFontAwesomeMetadataImportedAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'iconLibraryClass'
	],
	#category : 'BVC-FontAwesome-Core',
	#package : 'BVC-FontAwesome-Core'
}

{ #category : 'instance creation' }
CFFontAwesomeMetadataImportedAnnouncement class >> iconLibraryClass: anIconLibraryClass [
	^ self new
		iconLibraryClass: anIconLibraryClass;
		yourself
]

{ #category : 'accessing' }
CFFontAwesomeMetadataImportedAnnouncement >> iconLibraryClass [
	^ iconLibraryClass
]

{ #category : 'accessing' }
CFFontAwesomeMetadataImportedAnnouncement >> iconLibraryClass: anIconLibraryClass [
	iconLibraryClass := anIconLibraryClass
]
