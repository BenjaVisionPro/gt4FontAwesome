Class {
	#name : 'CFFontAwesomeIconsViewElement',
	#superclass : 'BrVerticalPane',
	#instVars : [
		'iconLibraryClass',
		'list',
		'searchText'
	],
	#category : 'BVC-FontAwesome-Core',
	#package : 'BVC-FontAwesome-Core'
}

{ #category : 'private - ui' }
CFFontAwesomeIconsViewElement >> buildContent [
	self
		hMatchParent;
		vMatchParent;
		cellSpacing: 6;
		padding: (BlInsets all: 4);
		addChild: self createControlsRow;
		addChild: (list := self createList)
]

{ #category : 'private - ui' }
CFFontAwesomeIconsViewElement >> createControlsRow [
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
CFFontAwesomeIconsViewElement >> createList [
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
CFFontAwesomeIconsViewElement >> createRefreshButton [
	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAptitude new;
		icon: BrGlamorousVectorIcons refresh;
		label: '';
		action: [ :aButton | self refreshList ];
		yourself
]

{ #category : 'private - ui' }
CFFontAwesomeIconsViewElement >> createSearchDropdown [
	^ BrFrame new
		fitContent;
		addAptitude: (BrGlamorousWithExplicitDropdownAptitude
				handle: [ self createSearchHandle ]
				content: [ self createSearchDropdownContent ]);
		yourself
]

{ #category : 'private - ui' }
CFFontAwesomeIconsViewElement >> createSearchDropdownContent [
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
CFFontAwesomeIconsViewElement >> createSearchHandle [
	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAptitude new;
		label: (searchText isEmpty
			ifTrue: [ 'Search' ]
			ifFalse: [ searchText ]);
		yourself
]

{ #category : 'private - ui' }
CFFontAwesomeIconsViewElement >> iconElementForAssociation: anAssociation [
	^ anAssociation value fitInto: 64 @ 64
]

{ #category : 'private - ui' }
CFFontAwesomeIconsViewElement >> iconLabelForAssociation: anAssociation [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		constraintsDo: [ :c | c linear vertical alignCenter ];
		padding: (BlInsets left: 20 right: 3);
		text: anAssociation key asString;
		yourself
]

{ #category : 'accessing' }
CFFontAwesomeIconsViewElement >> iconLibraryClass [
	^ iconLibraryClass
]

{ #category : 'accessing' }
CFFontAwesomeIconsViewElement >> iconLibraryClass: aClass [
	iconLibraryClass := aClass.
	self refreshList
]

{ #category : 'private - ui' }
CFFontAwesomeIconsViewElement >> iconRowStencil [
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
CFFontAwesomeIconsViewElement >> initialize [
	super initialize.
	searchText := ''.
	self buildContent
]

{ #category : 'hooks - children' }
CFFontAwesomeIconsViewElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	iconLibraryClass ifNotNil: [
		iconLibraryClass announcer weak
			when: CFFontAwesomeDefaultStyleChangedAnnouncement
			send: #onDefaultStyleChanged:
			to: self ]
]

{ #category : 'hooks - children' }
CFFontAwesomeIconsViewElement >> onDefaultStyleChanged: anAnnouncement [
	self inUIProcessDo: [ self refreshList ]
]

{ #category : 'hooks - children' }
CFFontAwesomeIconsViewElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	iconLibraryClass ifNotNil: [
		[ iconLibraryClass announcer unsubscribe: self ]
			on: Error
			do: [ :anError | anError return ] ]
]

{ #category : 'private' }
CFFontAwesomeIconsViewElement >> refreshList [
	list ifNil: [ ^ self ].
	list items: self visibleIconAssociations
]

{ #category : 'accessing' }
CFFontAwesomeIconsViewElement >> searchText [
	^ searchText
]

{ #category : 'accessing' }
CFFontAwesomeIconsViewElement >> searchText: aString [
	searchText := aString ifNil: [ '' ].
	self refreshList
]

{ #category : 'private' }
CFFontAwesomeIconsViewElement >> visibleIconAssociations [
	iconLibraryClass ifNil: [ ^ #() ].
	^ iconLibraryClass gtIconAssociationsMatching: searchText
]
