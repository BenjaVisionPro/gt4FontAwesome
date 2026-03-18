Class {
	#name : 'FontAwesomeIconSelectorElement',
	#superclass : 'BlElement',
	#traits : 'TGtMagritteWithFieldViewModel',
	#classTraits : 'TGtMagritteWithFieldViewModel classTrait',
	#instVars : [
		'dropdownAnchor',
		'searchEditor',
		'sizeEditor',
		'list',
		'searchIconContainer',
		'sizeIconContainer',
		'infoSummaryLabel',
		'versionLabel',
		'logoContainer',
		'currentColumnCount'
	],
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'private' }
FontAwesomeIconSelectorElement >> activeStyleName [
	^ self description iconLibraryClass
		styleNameOrDefault: self description styleName
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> availableMetadata [
	^ self metadata
		searchIconsMatching: ''
		satisfying: self metadataFilterBlock
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> buildItemStencil [
	^ [ :aRowMetadata :anIndex :aList |
		self newIconRowFor: aRowMetadata ]
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> configureList [
	list
		stencil: self buildItemStencil.
	self refreshInfoBar.
	self refreshGrid
]

{ #category : 'accessing' }
FontAwesomeIconSelectorElement >> dropdownAnchor [
	^ dropdownAnchor
]

{ #category : 'accessing' }
FontAwesomeIconSelectorElement >> dropdownAnchor: anElement [
	dropdownAnchor := anElement
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> filteredMetadata [
	^ self metadata
		searchIconsMatching: self searchText
		satisfying: self metadataFilterBlock
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> filteredMetadataRows [
	| columns metadata rows |
	columns := currentColumnCount ifNil: [ self gridColumnCount ].
	metadata := self filteredMetadata.
	rows := OrderedCollection new.
	1 to: metadata size by: columns do: [ :start |
		rows add: (metadata
			copyFrom: start
			to: ((start + columns - 1) min: metadata size)) ].
	^ rows
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> focusSearchEditor [
	searchEditor ifNotNil: [
		searchEditor inUIProcessDo: [ searchEditor requestFocus ] ]
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> gridCellSpacing [
	^ 8
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> gridColumnCount [
	| availableWidth tileFootprint spacing |
	availableWidth := list width > 0
		ifTrue: [ list width ]
		ifFalse: [ self width > 0
			ifTrue: [ self width ]
			ifFalse: [ 600 ] ].
	spacing := self gridCellSpacing.
	tileFootprint := self tileExtentForPreviewHeight: self previewHeight.
	^ (((availableWidth + spacing) / (tileFootprint + spacing)) floor max: 1)
]

{ #category : 'actions' }
FontAwesomeIconSelectorElement >> hideDropdown [
	dropdownAnchor ifNotNil: [ dropdownAnchor fireEvent: BrDropdownHideWish new ]
]

{ #category : 'initialization' }
FontAwesomeIconSelectorElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		padding: (BlInsets all: 4);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].

	currentColumnCount := nil.
	searchEditor := self newSearchEditor.
	sizeEditor := self newSizeEditor.
	list := self newList.
	list when: BlElementExtentChangedEvent do: [ :anEvent | self refreshGridForExtentChange ].
	self when: BlElementExtentChangedEvent do: [ :anEvent | self refreshGridForExtentChange ].

	self addChildren: { self newControlsRow. list. self newInfoBar }
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> metadata [
	self fieldViewModel ifNil: [ ^ FontAwesomeMetadata new ].
	^ self description iconLibraryClass metadata
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> metadataFilterBlock [
	^ [ :each | self shouldShowMetadata: each ]
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> newControlIconContainer [
	^ BrFrame new
		fitContent;
		constraintsDo: [ :c | c linear vertical alignCenter ];
		yourself
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> newControlIconNamed: aSelectorSymbol [
	^ [ | icon |
		icon := (self description iconLibraryClass style: 'solid')
			icon: aSelectorSymbol.
		(icon asScalableElementSized: (icon extentForHeight: 14))
			constraintsDo: [ :c | c linear vertical alignCenter ] ]
		on: Error
		do: [ BrLabel new
				aptitude: BrLabelAptitude new;
				text: '';
				fitContent;
				yourself ]
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> newControlsRow [
	| row |
	row := BrHorizontalPane new
		cellSpacing: 6;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		margin: (BlInsets bottom: 6);
		yourself.

	searchIconContainer := self newControlIconContainer.
	sizeIconContainer := self newControlIconContainer.

	row addChildren: {
		searchIconContainer.
		searchEditor.
		sizeIconContainer.
		sizeEditor }.

	^ row
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> newIconRowFor: aRowMetadata [
	^ BrHorizontalPane new
		cellSpacing: self gridCellSpacing;
		margin: (BlInsets bottom: self gridCellSpacing);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		addChildren: (aRowMetadata collect: [ :eachMetadata | self newIconTileFor: eachMetadata ]);
		yourself
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> newIconTileFor: anMetadata [
	| iconElement previewHeight tile tileExtent |
	previewHeight := self previewHeight.
	tileExtent := self tileExtentForPreviewHeight: previewHeight.
	iconElement := FontAwesomeBuilderUtility
		newFontAwesomeIconForMetadata: anMetadata
		styleName: self activeStyleName
		fitInto: previewHeight @ previewHeight.
	iconElement constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].

	tile := BlElement new
		layout: BlFrameLayout new;
		padding: (BlInsets all: 8);
		constraintsDo: [ :c |
			c horizontal exact: tileExtent.
			c vertical exact: tileExtent ];
		yourself.
	tile addChild: iconElement.
	tile when: BlClickEvent do: [ :anEvent | self selectMetadata: anMetadata ].
	^ tile
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> newInfoBar [
	| row spacer leftPane |
	row := BrHorizontalPane new
			cellSpacing: 2;
			constraintsDo: [ :c | 
				c horizontal matchParent.
				c vertical fitContent ];
			margin: (BlInsets top: 2);
			yourself.

	infoSummaryLabel := BrLabel new
			aptitude: BrLabelAptitude new;
			fitContent;
			yourself.

	versionLabel := BrLabel new
			aptitude: (BrLabelAptitude new
					fontSize: 9.0;
					yourself);
			opacity: 0.5;
			fitContent;
			yourself.

	logoContainer := BrFrame new
			height: 30;
			width: 200;
			constraintsDo: [ :c | 
				c linear horizontal alignRight ];
			yourself.

	spacer := BlElement new
			constraintsDo: [ :c | 
				c horizontal matchParent.
				c vertical fitContent ];
			yourself.

	leftPane := BrVerticalPane new
			cellSpacing: 0;
			constraintsDo: [ :c | 
				c horizontal fitContent.
				c vertical fitContent ];
			yourself.

	leftPane
		addChildren: {infoSummaryLabel.
				versionLabel}.

	row
		addChildren: {leftPane.
				spacer.
				logoContainer}.

	^ row
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> newList [
	| aList |
	aList := BrSimpleList new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1 ];
		yourself.
	^ aList
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> newLogoElement [
	^ [ | icon |
	icon := (FontAwesomeIcons style: 'brands') icon: #fontAwesomeLogoFull.
	(icon asScalableElementSized: (icon extentFittingInto: 200 @ 30))
		opacity: 0.8;
		yourself ]
		on: Error
		do: [ BrLabel new
				aptitude: BrLabelAptitude new;
				text: self metadata familyName;
				opacity: 0.5;
				fitContent;
				yourself ]
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> newSearchEditor [
	| editor |
	editor := BrEditor new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.
	editor aptitude: BrEditorAptitude new.
	editor when: BlKeyUpEvent do: [ :evt | self refreshList ].
	^ editor
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> newSizeEditor [
	| editor |
	editor := BrEditor new
		constraintsDo: [ :c |
			c horizontal exact: 50.
			c vertical fitContent ];
		yourself.
	editor aptitude: BrEditorAptitude new.
	editor text: '32'.
	editor when: BlKeyUpEvent do: [ :evt | self refreshGrid ].
	^ editor
]

{ #category : 'api - field view model' }
FontAwesomeIconSelectorElement >> onFieldViewModelChanged [
	self inUIProcessDo: [ self refreshContent ]
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> previewHeight [
	| text number |
	text := sizeEditor text asString trimBoth.
	text isEmpty ifTrue: [ ^ 32 ].
	number := [ text asNumber ] on: Error do: [ 32 ].
	^ number
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> refreshContent [
	self refreshControlIcons.
	self configureList.
	self focusSearchEditor.
	self enqueueTask: (BlTaskAction new action: [ self refreshGridForExtentChange ])
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> refreshControlIcons [
	searchIconContainer
		removeChildren;
		addChild: (self newControlIconNamed: #search).
	sizeIconContainer
		removeChildren;
		addChild: (self newControlIconNamed: #expandAlt)
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> refreshGrid [
	currentColumnCount := self gridColumnCount.
	self refreshList
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> refreshGridForExtentChange [
	| newColumnCount |
	newColumnCount := self gridColumnCount.
	currentColumnCount = newColumnCount ifTrue: [ ^ self ].
	currentColumnCount := newColumnCount.
	self refreshList
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> refreshInfoBar [
	| metadata availableCount |
	metadata := self metadata.
	availableCount := self availableMetadata size.
	infoSummaryLabel ifNotNil: [
		infoSummaryLabel text: availableCount asString, ' icons  ', metadata styles size asString, ' styles' ].
	versionLabel ifNotNil: [
		versionLabel text: 'v', metadata version ].
	logoContainer ifNotNil: [
		logoContainer
			removeChildren;
			addChild: self newLogoElement ]
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> refreshList [
	list items: self filteredMetadataRows
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> searchText [
	^ searchEditor text asString trimBoth
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> selectMetadata: selectedMetadata [
	GtMagritteBuilderUtility
		write: selectedMetadata selectorSymbol
		using: self description
		memento: self memento
		element: self.
	self hideDropdown
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> shouldShowMetadata: anIconMetadata [
	self activeStyleName = 'brands'
		ifTrue: [ ^ anIconMetadata supportsStyleNamed: 'brands' ].
	^ (anIconMetadata supportsStyleNamed: self activeStyleName)
		and: [ (anIconMetadata supportsStyleNamed: 'brands') not ]
]

{ #category : 'private' }
FontAwesomeIconSelectorElement >> tileExtentForPreviewHeight: aNumber [
	^ (aNumber + 16) max: 44
]
