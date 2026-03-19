"
I am a vertical UI element that displays the icons of one icon library together with filtering controls.

## Responsibilities
- I present the available icons of an icon library.
- I manage the current search text and refresh the visible list accordingly.
- I react to lifecycle events so I can subscribe and unsubscribe from announcements.
- I offer a lightweight browser for inspecting and refreshing imported icons.

## Example usage
```smalltalk
FontAwesomeIconsViewElement new
	iconLibraryClass: FontAwesomeIcons;
	yourself
```

Use me when you want an embeddable browser for an imported icon library.
"
Class {
	#name : 'FontAwesomeIconsViewElement',
	#superclass : 'BrVerticalPane',
	#instVars : [
		'iconLibraryClass',
		'list',
		'searchText'
	],
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'private - ui' }
FontAwesomeIconsViewElement >> buildContent [
	self
		hMatchParent;
		vMatchParent;
		cellSpacing: 6;
		padding: (BlInsets all: 4);
		addChild: self createControlsRow;
		addChild: (list := self createList)
]

{ #category : 'private - ui' }
FontAwesomeIconsViewElement >> createControlsRow [
	| row spacer |
	row := BrHorizontalPane new
		hMatchParent;
		vFitContent;
		cellSpacing: 6;
		yourself.
	spacer := BlElement new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.

	row addChildren: {
		spacer.
		self createRefreshButton.
		self createSearchDropdown }.
	^ row
]

{ #category : 'private - ui' }
FontAwesomeIconsViewElement >> createList [
	| newList |
	newList := BrSimpleList new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1 ];
		yourself.
	newList stencil: self iconRowStencil.
	^ newList
]

{ #category : 'private - ui' }
FontAwesomeIconsViewElement >> createRefreshButton [
	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAptitude new;
		icon: BrGlamorousVectorIcons refresh;
		label: '';
		action: [ :aButton | self refreshList ];
		yourself
]

{ #category : 'private - ui' }
FontAwesomeIconsViewElement >> createSearchDropdown [
	^ BrFrame new
		fitContent;
		addAptitude: (BrGlamorousWithExplicitDropdownAptitude
				handle: [ self createSearchHandle ]
				content: [ self createSearchDropdownContent ]);
		yourself
]

{ #category : 'private - ui' }
FontAwesomeIconsViewElement >> createSearchDropdownContent [
	| container editor |
	container := BrFrame new
		padding: (BlInsets all: 6);
		yourself.
	editor := BrEditor new
		constraintsDo: [ :c |
			c horizontal exact: 220.
			c vertical fitContent ];
		yourself.
	editor aptitude: BrEditorAptitude new.
	editor text: searchText.
	editor when: BlKeyUpEvent do: [ :anEvent |
		self searchText: editor text asString trimBoth ].
	container addChild: editor.
	editor inUIProcessDo: [ editor requestFocus ].
	^ container
]

{ #category : 'private - ui' }
FontAwesomeIconsViewElement >> createSearchHandle [
	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAptitude new;
		label: (searchText isEmpty
			ifTrue: [ 'Search' ]
			ifFalse: [ searchText ]);
		yourself
]

{ #category : 'private - ui' }
FontAwesomeIconsViewElement >> iconElementForAssociation: anAssociation [
	^ anAssociation value fitInto: 64 @ 64
]

{ #category : 'private - ui' }
FontAwesomeIconsViewElement >> iconLabelForAssociation: anAssociation [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		constraintsDo: [ :c | c linear vertical alignCenter ];
		padding: (BlInsets left: 20 right: 3);
		text: anAssociation key asString;
		yourself
]

{ #category : 'accessing' }
FontAwesomeIconsViewElement >> iconLibraryClass [
	^ iconLibraryClass
]

{ #category : 'accessing' }
FontAwesomeIconsViewElement >> iconLibraryClass: aClass [
	iconLibraryClass := aClass.
	self refreshList
]

{ #category : 'private - ui' }
FontAwesomeIconsViewElement >> iconRowStencil [
	^ [ :anAssociation :anIndex :aList |
		BlElement new
			layout: BlLinearLayout horizontal;
			margin: (BlInsets all: 3);
			constraintsDo: [ :c |
				c vertical fitContent.
				c horizontal matchParent ];
			when: BlClickEvent
				do: [ :anEvent |
					anEvent consumed: true.
					anEvent currentTarget phlow spawnObject: anAssociation value ];
			addChild: (self iconElementForAssociation: anAssociation);
			addChild: (self iconLabelForAssociation: anAssociation) ]
]

{ #category : 'initialization' }
FontAwesomeIconsViewElement >> initialize [
	super initialize.
	searchText := ''.
	self buildContent
]

{ #category : 'hooks - children' }
FontAwesomeIconsViewElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	iconLibraryClass ifNotNil: [
		iconLibraryClass announcer weak
			when: FontAwesomeDefaultStyleChangedAnnouncement
			send: #onDefaultStyleChanged:
			to: self ]
]

{ #category : 'hooks - children' }
FontAwesomeIconsViewElement >> onDefaultStyleChanged: anAnnouncement [
	self inUIProcessDo: [ self refreshList ]
]

{ #category : 'hooks - children' }
FontAwesomeIconsViewElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	iconLibraryClass ifNotNil: [
		[ iconLibraryClass announcer unsubscribe: self ]
			on: Error
			do: [ :anError | anError return ] ]
]

{ #category : 'private' }
FontAwesomeIconsViewElement >> refreshList [
	list ifNil: [ ^ self ].
	list items: self visibleIconAssociations
]

{ #category : 'accessing' }
FontAwesomeIconsViewElement >> searchText [
	^ searchText
]

{ #category : 'accessing' }
FontAwesomeIconsViewElement >> searchText: aString [
	searchText := aString ifNil: [ '' ].
	self refreshList
]

{ #category : 'private' }
FontAwesomeIconsViewElement >> visibleIconAssociations [
	iconLibraryClass ifNil: [ ^ #() ].
	^ iconLibraryClass gtIconAssociationsMatching: searchText
]
