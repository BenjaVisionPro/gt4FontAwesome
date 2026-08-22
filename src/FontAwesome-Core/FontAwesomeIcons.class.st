"
I am the common base class for generated Font Awesome icon factory classes.

## Responsibilities
- I serve as the facade through which clients ask for icons.
- I manage imported metadata and the list of available styles.
- I manage the current default style.
- I expose GT views, Spotter integrations, and actions for browsing icons.
- I announce important state changes such as metadata imports and default style updates.

Subclasses can be generated per imported style, while I provide the common API and tooling integration.

## Example usage
```smalltalk
FontAwesomeIcons icon: #addressCard
```

```smalltalk
FontAwesomeIcons icon: #addressCard styleName: 'light'
```

Use me as the main entry point to a Font Awesome icon library in the image.
"
Class {
	#name : 'FontAwesomeIcons',
	#superclass : 'Object',
	#classVars : [
		'DefaultStyleAnnouncer',
		'DefaultStyleName',
		'GtIconsFilterQuery',
		'Metadata'
	],
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'announcing' }
FontAwesomeIcons class >> announceDefaultStyleChanged [
	self announcer
		announce: (FontAwesomeDefaultStyleChangedAnnouncement
				iconLibraryClass: self
				styleName: self defaultStyleName)
]

{ #category : 'announcing' }
FontAwesomeIcons class >> announceGtIconsFilterChanged [
	self announcer
		announce: (FontAwesomeIconsFilterChangedAnnouncement
				iconLibraryClass: self
				queryText: self gtIconsFilterQuery)
]

{ #category : 'announcing' }
FontAwesomeIcons class >> announceMetadataImported [
	self announcer
		announce: (FontAwesomeMetadataImportedAnnouncement
				iconLibraryClass: self)
]

{ #category : 'announcing' }
FontAwesomeIcons class >> announcer [
	^ DefaultStyleAnnouncer ifNil: [ DefaultStyleAnnouncer := Announcer new ]
]

{ #category : 'metadata' }
FontAwesomeIcons class >> availableIcons [
	self hasImportedIcons ifFalse: [ ^ #() ].
	^ self defaultStyle availableIcons
]

{ #category : 'metadata' }
FontAwesomeIcons class >> availableIconsForStyleNamed: aStyleName [
	self hasImportedIcons ifFalse: [ ^ #() ].
	^ (self styleOrDefaultNamed: aStyleName) availableIcons
]

{ #category : 'styles' }
FontAwesomeIcons class >> availableStyles [
	| styleBaseClass |
	self hasImportedIcons ifTrue: [ ^ self metadata styles ].
	styleBaseClass := self styleName
		ifNil: [ self ]
		ifNotNil: [ self superclass ].
	^ ((styleBaseClass subclasses
		collect: [ :each | each styleName ])
		reject: [ :each | each isNil ])
		asSortedCollection asArray
]

{ #category : 'styles' }
FontAwesomeIcons class >> defaultStyle [
	^ self style: self defaultStyleName
]

{ #category : 'styles' }
FontAwesomeIcons class >> defaultStyleName [
	^ DefaultStyleName
		ifNil: [ self error: 'No default Font Awesome style has been configured' ]
]

{ #category : 'styles' }
FontAwesomeIcons class >> defaultStyleName: aStyleName [
	DefaultStyleName = aStyleName ifTrue: [ ^ self ].
	DefaultStyleName := aStyleName.
	self announceDefaultStyleChanged
]

{ #category : 'gt extensions' }
FontAwesomeIcons class >> gtDefaultStyleActionFor: anAction [
	<gtAction>
	(FontAwesomeDefaultStyleMenuElement shouldShowActionFor: self)
		ifFalse: [ ^ anAction noAction ].

	^ anAction dropdown
		priority: 45;
		target: GtCoderClassTarget;
		icon: (FontAwesomeDefaultStyleMenuElement menuActionIconFor: self);
		label: 'Default Style';
		menuItemPreview: (FontAwesomeDefaultStyleMenuElement styleLabelFor: self defaultStyleName);
		menuItemGroup: FontAwesomeDefaultStyleMenuElement menuItemGroup;
		menuItemPinSubmenu;
		content: [ :aButton :aTargetElement :anExplicitMenu |
			FontAwesomeDefaultStyleMenuElement
				menuContentFor: self
				button: aButton
				menuModel: anExplicitMenu ]
]

{ #category : 'gt extensions' }
FontAwesomeIcons class >> gtFilterTooltip [
	self gtIconsFilterQuery isEmpty ifTrue: [ ^ 'Filter icons' ].
	^ 'Filter icons: ', self gtIconsFilterQuery
]

{ #category : 'gt extensions' }
FontAwesomeIcons class >> gtIconAssociationsMatching: aString [
	| activeStyleName metadataItems |
	self hasImportedIcons ifFalse: [ ^ #() ].
	activeStyleName := self styleName.
	metadataItems := self metadata
		searchIconsMatching: aString
		satisfying: [ :each |
			activeStyleName isNil or: [ each supportsStyleNamed: activeStyleName ] ].
	^ metadataItems collect: [ :each |
		each selectorSymbol -> (self icon: each selectorSymbol) ]
]

{ #category : 'gt extensions' }
FontAwesomeIcons class >> gtIconsFilterButtonFor: aButton [
	^ (GtSpotterDropdownButtonStencil new
		icon: BrGlamorousVectorIcons search;
		tooltip: self gtFilterTooltip;
		object: self;
		extent: [ 520 @ 430 ];
		spotterModelDo: [ :aSpotter |
			aSpotter currentStep searchQuery: self gtIconsFilterQuery.
			aSpotter currentStep
				when: GtSpotterStepSearchQueryChanged
				do: [ :anAnnouncement |
					self gtIconsFilterQuery: aSpotter currentStep searchQuery ] ];
		spotterElementDo: [ :aSpotterElement |
			self updateSpotterHeaderIn: aSpotterElement ];
		objectActOn: [ :anActOnEvent :anItem :theButton |
			self gtIconsFilterQuery: anActOnEvent spotterStep searchQuery.
			anActOnEvent beActed.
			theButton fireEvent: BrDropdownHideWish new ];
		asElement)
]

{ #category : 'gt extensions' }
FontAwesomeIcons class >> gtIconsFilterQuery [
	^ GtIconsFilterQuery ifNil: [ '' ]
]

{ #category : 'gt extensions' }
FontAwesomeIcons class >> gtIconsFilterQuery: aString [
	| normalized |
	normalized := (aString ifNil: [ '' ]) trimBoth.
	GtIconsFilterQuery = normalized ifTrue: [ ^ self ].
	GtIconsFilterQuery := normalized.
	self announceGtIconsFilterChanged
]

{ #category : 'gt extensions' }
FontAwesomeIcons class >> gtIconsFor: aView [
	<gtView>
	<gtClassView>
	self hasImportedIcons ifFalse: [ ^ self gtNoImportedIconsFor: aView ].
	^ aView list
		title: 'Icons';
		priority: -10;
		items: [ self gtIconAssociationsMatching: self gtIconsFilterQuery ];
		updateWhen: FontAwesomeMetadataImportedAnnouncement in: [ self announcer ];
		updateWhen: FontAwesomeDefaultStyleChangedAnnouncement in: [ self announcer ];
		updateWhen: FontAwesomeIconsFilterChangedAnnouncement in: [ self announcer ];
		itemStencil: [ BlElement new
				layout: BlLinearLayout horizontal;
				margin: (BlInsets all: 3);
				constraintsDo: [ :c |
					c vertical fitContent.
					c horizontal matchParent ];
				addChild: (BlElement new size: 64 @ 64) as: #icon;
				addChild: (BrLabel new
							aptitude: BrGlamorousLabelAptitude;
							constraintsDo: [ :c | c linear vertical alignCenter ];
							padding: (BlInsets left: 20 right: 3))
					as: #label ];
		itemDataBinder: [ :anElement :anIcon :anIndex |
			| icon iconElement |
			icon := self icon: anIcon key.
			iconElement := icon size: 64 @ 64.
			anElement
				replaceChild: (anElement childNamed: #icon)
				with: iconElement
				as: #icon.
			(anElement childNamed: #label) text: anIcon key asString.
			anElement ];
		actionStencil: [ :aButton |
			self gtIconsFilterButtonFor: aButton ]
			tooltip: self gtFilterTooltip;
		send: #value
]

{ #category : 'gt extensions' }
FontAwesomeIcons class >> gtNoImportedIconsElement [
	| container title description |
	container := BrVerticalPane new
		cellSpacing: 8;
		padding: (BlInsets all: 16);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.

	title := BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		text: 'No Font Awesome icons have been imported yet.';
		yourself.

	description := BrEditor new
		aptitude: BrGlamorousRegularEditorAptitude + BrGlamorousTextAreaSpacingAptitude;
		beReadOnlyWithoutSelection;
		background: Color transparent;
		border: BlBorder empty;
		padding: BlInsets empty;
		margin: BlInsets empty;
		text: 'Import metadata/icons.json with FontAwesomeMetadataImporter. The importer builds the selected Font Awesome styles and installs their searchable metadata on this icon library.';
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.

	container addChildren: { title. description }.
	^ container
]

{ #category : 'gt extensions' }
FontAwesomeIcons class >> gtNoImportedIconsFor: aView [
	^ aView explicit
		title: 'Icons';
		priority: -10;
		updateWhen: FontAwesomeMetadataImportedAnnouncement in: [ self announcer ];
		stencil: [ self gtNoImportedIconsElement ]
]

{ #category : 'gt extensions' }
FontAwesomeIcons class >> gtSpotterForVectorIconFor: aSearch [
	<gtSearch>
	| activeStyleName |
	self hasImportedIcons ifFalse: [
		^ aSearch list
			title: 'Font Awesome Icons';
			priority: 5;
			items: [ #() ];
			wantsToDisplayOnEmptyQuery: true;
			yourself ].
	activeStyleName := self styleName.
	^ self metadata
		gtSearchForFontAwesomeIconsFor: aSearch
		satisfying: [ :each |
			activeStyleName isNil or: [ each supportsStyleNamed: activeStyleName ] ]
]

{ #category : 'testing' }
FontAwesomeIcons class >> hasImportedIcons [
	^ self metadata allIconMetadata notEmpty
]

{ #category : 'instance creation' }
FontAwesomeIcons class >> icon: aSelectorSymbol [
	| metadataEntry |
	self styleName ifNotNil: [ ^ self perform: aSelectorSymbol asSymbol ].
	metadataEntry := self metadata iconMetadataAt: aSelectorSymbol asSymbol.
	metadataEntry ifNil: [ ^ self defaultStyle perform: aSelectorSymbol asSymbol ].
	^ (self style: metadataEntry preferredStyleName)
		perform: metadataEntry selectorSymbol
]

{ #category : 'instance creation' }
FontAwesomeIcons class >> icon: aSelectorSymbol color: aColor [
	^ (self icon: aSelectorSymbol)
		color: aColor;
		yourself
]

{ #category : 'instance creation' }
FontAwesomeIcons class >> icon: aSelectorSymbol size: aSize color: aColor [
	| extent |
	extent := (aSize isPoint or: [ aSize respondsTo: #x ])
		ifTrue: [ aSize ]
		ifFalse: [ aSize @ aSize ].
	^ (self icon: aSelectorSymbol color: aColor)
		size: extent;
		yourself
]

{ #category : 'instance creation' }
FontAwesomeIcons class >> icon: aSelectorSymbol styleName: aStyleName [
	| metadataEntry styleClass |
	aStyleName ifNil: [ ^ self icon: aSelectorSymbol ].
	styleClass := self style: aStyleName.
	metadataEntry := self metadata iconMetadataAt: aSelectorSymbol asSymbol.
	metadataEntry ifNil: [ ^ styleClass icon: aSelectorSymbol ].
	(metadataEntry supportsStyleNamed: aStyleName) ifFalse: [
		self error: metadataEntry selectorSymbol asString, ' is not available in Font Awesome style ', aStyleName printString ].
	^ styleClass icon: metadataEntry selectorSymbol
]

{ #category : 'instance creation' }
FontAwesomeIcons class >> iconNamed: aSelector styleKey: aStyleKey width: aWidth height: aHeight pathSpecs: pathSpecs unicode: aUnicodeString label: aLabelString [
	^ FontAwesomeIcon new
		initializeName: aSelector
		styleKey: aStyleKey
		unicode: aUnicodeString
		label: aLabelString
		viewBox: (0 @ 0 extent: aWidth @ aHeight)
		pathSpecs: pathSpecs
]

{ #category : 'metadata' }
FontAwesomeIcons class >> metadata [
	^ Metadata ifNil: [ Metadata := FontAwesomeMetadata new ]
]

{ #category : 'metadata' }
FontAwesomeIcons class >> metadata: aMetadata [
	Metadata := aMetadata
]

{ #category : 'private - gt' }
FontAwesomeIcons class >> spotterHeaderLogoElement [
	^ [ | icon logo wrapper |
	icon := (FontAwesomeIcons style: 'brands') icon: #fontAwesome.
	logo := (icon size: 28 @ 28)
			opacity: 0.85;
			yourself.
	wrapper := BlElement new
		layout: BlFrameLayout new;
		padding: (BlInsets left: 10);
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical exact: 40 ];
		yourself.
	logo constraintsDo: [ :c |
		c frame horizontal alignLeft.
		c frame vertical alignCenter ].
	wrapper addChild: logo.
	^ wrapper ]
		on: Error
		do: [ BrLabel new
				aptitude: BrLabelAptitude new;
				text: 'Font Awesome';
				opacity: 0.6;
				fitContent;
				yourself ]
]

{ #category : 'styles' }
FontAwesomeIcons class >> style: aStyleName [
	^ Smalltalk
		at: (FontAwesomeMetadataImporter styleClassNameFor: aStyleName) asSymbol
		ifAbsent: [ self error: 'No imported Font Awesome style named ', aStyleName printString ]
]

{ #category : 'styles' }
FontAwesomeIcons class >> styleName [
	^ nil
]

{ #category : 'styles' }
FontAwesomeIcons class >> styleNameOrDefault: aStyleName [
	^ aStyleName ifNil: [ self defaultStyleName ]
]

{ #category : 'styles' }
FontAwesomeIcons class >> styleOrDefaultNamed: aStyleName [
	^ aStyleName
		ifNil: [ self defaultStyle ]
		ifNotNil: [ self style: aStyleName ]
]

{ #category : 'private - gt' }
FontAwesomeIcons class >> updateSpotterHeaderIn: aSpotterElement [
	| headerElement topRow breadcrumb firstItem |
	headerElement := aSpotterElement children
		ifEmpty: [ ^ self ]
		ifNotEmpty: [ :children | children first ].
	topRow := headerElement children
		ifEmpty: [ ^ self ]
		ifNotEmpty: [ :headerChildren | headerChildren first ].
	breadcrumb := topRow children
		ifEmpty: [ ^ self ]
		ifNotEmpty: [ :rowChildren | rowChildren first ].
	firstItem := [ breadcrumb aptitude itemElements first ]
		on: Error
		do: [ ^ self ].
	firstItem
		aptitude: BrGlamorousButtonIconAptitude new;
		background: Color transparent;
		padding: BlInsets empty;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical exact: 40.
			c linear vertical alignCenter ];
		icon: self spotterHeaderLogoElement;
		label: '';
		action: [ :anElement :aButtonModel :anEvent | ]
]
