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
