"
I announce that the icon filter query changed for a given icon library.

## Responsibilities
- I carry the icon library class for which the filter changed.
- I carry the new query text.
- I let interested UI elements refresh themselves without being tightly coupled to the sender.

## Example usage
A publisher can announce me after changing the current filter text, and subscribers can use my payload to refresh their visible icon lists.
"
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
