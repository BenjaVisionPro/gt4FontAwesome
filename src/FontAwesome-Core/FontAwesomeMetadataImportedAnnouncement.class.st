"
I announce that metadata was imported for an icon library class.

## Responsibilities
- I carry the icon library class whose metadata changed.
- I provide a synchronization point for browsers and tools that should refresh after an import.

Use me to decouple import operations from the widgets that visualize imported icons.
"
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
