"
I am the common base class for generated Font Awesome icon factory classes.
Each discovered Font Awesome style is represented by a subclass created on demand by CFFontAwesomeMetadataImporter.
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
	| availableIconsBySelector activeStyleName |
	self hasImportedIcons ifFalse: [ ^ #() ].
	(aString ifNil: [ '' ]) trimBoth isEmpty ifTrue: [ ^ self availableIcons ].
	availableIconsBySelector := Dictionary new.
	self availableIcons do: [ :eachAssociation |
		availableIconsBySelector
			at: eachAssociation key
			put: eachAssociation ].
	activeStyleName := self styleNameOrDefault: self styleName.
	^ ((self metadata
		searchIconsMatching: aString
		satisfying: [ :each | each supportsStyleNamed: activeStyleName ])
		collect: [ :each |
			availableIconsBySelector
				at: each selectorSymbol
				ifAbsent: [ nil ] ])
		reject: [ :each | each isNil ]
]

{ #category : 'gt extensions' }
FontAwesomeIcons class >> gtIconsClearFilter [
	self gtIconsFilterQuery: ''
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
			iconElement := icon asScalableElementSized: (icon extentFittingInto: 64 @ 64).
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
FontAwesomeIcons class >> gtImportActionFor: anAction [
	<gtAction>
	(FontAwesomeImportMenuElement shouldShowActionFor: self)
		ifFalse: [ ^ anAction noAction ].

	^ anAction dropdown
		priority: 44;
		target: GtCoderClassTarget;
		icon: (FontAwesomeImportMenuElement menuActionIconFor: self);
		label: 'Import Icons';
		menuItemPreview: self gtImportStatusLabel;
		menuItemGroup: FontAwesomeImportMenuElement menuItemGroup;
		menuItemPinSubmenu;
		content: [ :aButton :aTargetElement :anExplicitMenu |
			FontAwesomeImportMenuElement
				menuContentFor: self
				button: aButton
				menuModel: anExplicitMenu ]
]

{ #category : 'gt extensions' }
FontAwesomeIcons class >> gtImportStatusLabel [
	self hasImportedIcons
		ifFalse: [ ^ 'Not imported' ].
	^ self metadata allIconMetadata size asString, ' icons'
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
		text: 'Use the class hamburger menu, then choose Font Awesome > Import Icons. Point it to metadata/icons.json from your licensed Font Awesome download, choose the styles you want, and optionally limit the import to selected categories.';
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
	activeStyleName := self styleNameOrDefault: self styleName.
	^ self metadata
		gtSearchForFontAwesomeIconsFor: aSearch
		satisfying: [ :each | each supportsStyleNamed: activeStyleName ]
]

{ #category : 'testing' }
FontAwesomeIcons class >> hasImportedIcons [
	^ self metadata allIconMetadata notEmpty
]

{ #category : 'instance creation' }
FontAwesomeIcons class >> icon: aSelectorSymbol [
	self styleName ifNil: [ ^ self defaultStyle perform: aSelectorSymbol asSymbol ].
	^ self perform: aSelectorSymbol asSymbol
]

{ #category : 'instance creation' }
FontAwesomeIcons class >> icon: aSelectorSymbol color: aColor [
	^ (self icon: aSelectorSymbol)
		color: aColor;
		yourself
]

{ #category : 'instance creation' }
FontAwesomeIcons class >> icon: aSelectorSymbol fitInto: anExtent color: aColor [
	| icon |
	icon := (self icon: aSelectorSymbol)
		color: aColor;
		yourself.
	^ [ icon fitInto: anExtent ] asStencil
]

{ #category : 'instance creation' }
FontAwesomeIcons class >> icon: aSelectorSymbol height: aNumber color: aColor [
	| icon |
	icon := (self icon: aSelectorSymbol)
		color: aColor;
		yourself.
	^ [ icon height: aNumber ] asStencil
]

{ #category : 'instance creation' }
FontAwesomeIcons class >> icon: aSelectorSymbol size: aSize color: aColor [
	(aSize isPoint or: [ aSize respondsTo: #x ]) ifTrue: [
		^ self icon: aSelectorSymbol fitInto: aSize color: aColor ].
	^ self icon: aSelectorSymbol height: aSize color: aColor
]

{ #category : 'instance creation' }
FontAwesomeIcons class >> icon: aSelectorSymbol styleName: aStyleName [
	^ (self styleOrDefaultNamed: aStyleName) icon: aSelectorSymbol
]

{ #category : 'instance creation' }
FontAwesomeIcons class >> icon: aSelectorSymbol width: aNumber color: aColor [
	| icon |
	icon := (self icon: aSelectorSymbol)
		color: aColor;
		yourself.
	^ [ icon width: aNumber ] asStencil
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

{ #category : 'styles' }
FontAwesomeIcons class >> loadFromDisc [
	"Point this to your licensed download of the font awesome metadata"

	FontAwesomeMetadataImporter
		importFromIconsJsonFile: '/Users/jupiter/Downloads/fontawesome-pro-5.15.4-desktop/metadata/icons.json'
				asFileReference
		packageName: 'BVC-FontAwesome-Fonts'
		version: '5.15.4'
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
	icon := (FontAwesomeIcons style: 'brands') icon: #fontAwesomeLogoFull.
	logo := (icon asScalableElementSized: (icon extentFittingInto: 180 @ 28))
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
