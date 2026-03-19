"
I announce that the default style changed for a given icon library.

## Responsibilities
- I carry the icon library class whose default style changed.
- I carry the selected style name.
- I let interested widgets refresh their previews and lists.

Use me to broadcast style changes without coupling publishers and subscribers directly.
"
Class {
	#name : 'FontAwesomeDefaultStyleChangedAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'iconLibraryClass',
		'styleName'
	],
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'instance creation' }
FontAwesomeDefaultStyleChangedAnnouncement class >> iconLibraryClass: anIconLibraryClass styleName: aStyleName [
	^ self new
		iconLibraryClass: anIconLibraryClass;
		styleName: aStyleName;
		yourself
]

{ #category : 'accessing' }
FontAwesomeDefaultStyleChangedAnnouncement >> iconLibraryClass [
	^ iconLibraryClass
]

{ #category : 'accessing' }
FontAwesomeDefaultStyleChangedAnnouncement >> iconLibraryClass: anIconLibraryClass [
	iconLibraryClass := anIconLibraryClass
]

{ #category : 'accessing' }
FontAwesomeDefaultStyleChangedAnnouncement >> styleName [
	^ styleName
]

{ #category : 'accessing' }
FontAwesomeDefaultStyleChangedAnnouncement >> styleName: aStyleName [
	styleName := aStyleName
]
