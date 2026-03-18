Class {
	#name : 'FontAwesomeMetadataImportedAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'iconLibraryClass'
	],
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'instance creation' }
FontAwesomeMetadataImportedAnnouncement class >> iconLibraryClass: anIconLibraryClass [
	^ self new
		iconLibraryClass: anIconLibraryClass;
		yourself
]

{ #category : 'accessing' }
FontAwesomeMetadataImportedAnnouncement >> iconLibraryClass [
	^ iconLibraryClass
]

{ #category : 'accessing' }
FontAwesomeMetadataImportedAnnouncement >> iconLibraryClass: anIconLibraryClass [
	iconLibraryClass := anIconLibraryClass
]
