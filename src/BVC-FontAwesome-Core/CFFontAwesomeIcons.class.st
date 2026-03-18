"
I am the common base class for generated Font Awesome icon factory classes.
Each discovered Font Awesome style is represented by a subclass created on demand by CFFontAwesomeMetadataImporter.
"
Class {
	#name : 'CFFontAwesomeIcons',
	#superclass : 'Object',
	#classVars : [
		'DefaultStyleAnnouncer',
		'DefaultStyleName',
		'GtIconsFilterQuery',
		'Metadata'
	],
	#category : 'BVC-FontAwesome-Core',
	#package : 'BVC-FontAwesome-Core'
}

{ #category : 'announcing' }
CFFontAwesomeIcons class >> announceDefaultStyleChanged [
	self announcer
		announce: (CFFontAwesomeDefaultStyleChangedAnnouncement
				iconLibraryClass: self
				styleName: self defaultStyleName)
]

{ #category : 'announcing' }
CFFontAwesomeIcons class >> announceGtIconsFilterChanged [
	self announcer
		announce: (CFFontAwesomeIconsFilterChangedAnnouncement
				iconLibraryClass: self
				queryText: self gtIconsFilterQuery)
]

{ #category : 'announcing' }
CFFontAwesomeIcons class >> announcer [
	^ DefaultStyleAnnouncer ifNil: [ DefaultStyleAnnouncer := Announcer new ]
]

{ #category : 'metadata' }
CFFontAwesomeIcons class >> availableIcons [
	^ self defaultStyle availableIcons
]

{ #category : 'metadata' }
CFFontAwesomeIcons class >> availableIconsForStyleNamed: aStyleName [
	^ (self styleOrDefaultNamed: aStyleName) availableIcons
]

{ #category : 'styles' }
CFFontAwesomeIcons class >> availableStyles [
	| styleBaseClass |
	styleBaseClass := self styleName
		ifNil: [ self ]
		ifNotNil: [ self superclass ].
	^ ((styleBaseClass subclasses
		collect: [ :each | each styleName ])
		reject: [ :each | each isNil ])
		asSortedCollection asArray
]

{ #category : 'styles' }
CFFontAwesomeIcons class >> defaultStyle [
	^ self style: self defaultStyleName
]

{ #category : 'styles' }
CFFontAwesomeIcons class >> defaultStyleName [
	^ DefaultStyleName
		ifNil: [ self error: 'No default Font Awesome style has been configured' ]
]

{ #category : 'styles' }
CFFontAwesomeIcons class >> defaultStyleName: aStyleName [
	DefaultStyleName = aStyleName ifTrue: [ ^ self ].
	DefaultStyleName := aStyleName.
	self announceDefaultStyleChanged
]

{ #category : 'gt extensions' }
CFFontAwesomeIcons class >> gtDefaultStyleActionFor: anAction [
	<gtAction>
	(CFFontAwesomeDefaultStyleMenuElement shouldShowActionFor: self)
		ifFalse: [ ^ anAction noAction ].

	^ anAction dropdown
		priority: 45;
		target: GtCoderClassTarget;
		icon: (CFFontAwesomeDefaultStyleMenuElement menuActionIconFor: self);
		label: 'Default Style';
		menuItemPreview: (CFFontAwesomeDefaultStyleMenuElement styleLabelFor: self defaultStyleName);
		menuItemGroup: CFFontAwesomeDefaultStyleMenuElement menuItemGroup;
		menuItemPinSubmenu;
		content: [ :aButton :aTargetElement :anExplicitMenu |
			CFFontAwesomeDefaultStyleMenuElement
				menuContentFor: self
				button: aButton
				menuModel: anExplicitMenu ]
]

{ #category : 'gt extensions' }
CFFontAwesomeIcons class >> gtFilterTooltip [
	self gtIconsFilterQuery isEmpty ifTrue: [ ^ 'Filter icons' ].
	^ 'Filter icons: ', self gtIconsFilterQuery
]

{ #category : 'gt extensions' }
CFFontAwesomeIcons class >> gtIconAssociationsMatching: aString [
	| availableIconsBySelector activeStyleName |
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
CFFontAwesomeIcons class >> gtIconsClearFilter [
	self gtIconsFilterQuery: ''
]

{ #category : 'gt extensions' }
CFFontAwesomeIcons class >> gtIconsFilterButtonFor: aButton [
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
CFFontAwesomeIcons class >> gtIconsFilterQuery [
	^ GtIconsFilterQuery ifNil: [ '' ]
]

{ #category : 'gt extensions' }
CFFontAwesomeIcons class >> gtIconsFilterQuery: aString [
	| normalized |
	normalized := (aString ifNil: [ '' ]) trimBoth.
	GtIconsFilterQuery = normalized ifTrue: [ ^ self ].
	GtIconsFilterQuery := normalized.
	self announceGtIconsFilterChanged
]

{ #category : 'gt extensions' }
CFFontAwesomeIcons class >> gtIconsFor: aView [
	<gtView>
	<gtClassView>
	^ aView list
		title: 'Icons';
		priority: -10;
		items: [ self gtIconAssociationsMatching: self gtIconsFilterQuery ];
		updateWhen: CFFontAwesomeDefaultStyleChangedAnnouncement in: [ self announcer ];
		updateWhen: CFFontAwesomeIconsFilterChangedAnnouncement in: [ self announcer ];
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
CFFontAwesomeIcons class >> gtSpotterForVectorIconFor: aSearch [
	<gtSearch>
	| activeStyleName |
	activeStyleName := self styleNameOrDefault: self styleName.
	^ self metadata
		gtSearchForFontAwesomeIconsFor: aSearch
		satisfying: [ :each | each supportsStyleNamed: activeStyleName ]
]

{ #category : 'private - gt' }
CFFontAwesomeIcons class >> spotterHeaderLogoElement [
	^ [ | icon |
	icon := (CFFontAwesomeIcons style: 'brands') icon: #fontAwesomeLogoFull.
		(icon asScalableElementSized: (icon extentFittingInto: 140 @ 22))
			opacity: 0.85;
			yourself ]
		on: Error
		do: [ BrLabel new
				aptitude: BrLabelAptitude new;
				text: 'Font Awesome';
				opacity: 0.6;
				fitContent;
				yourself ]
]

{ #category : 'private - gt' }
CFFontAwesomeIcons class >> updateSpotterHeaderIn: aSpotterElement [
	| breadcrumb firstItem |
	breadcrumb := aSpotterElement children
		ifEmpty: [ ^ self ]
		ifNotEmpty: [ :children |
			children first children
				ifEmpty: [ ^ self ]
				ifNotEmpty: [ :headerChildren | headerChildren first children first ] ].
	firstItem := [ breadcrumb aptitude itemElements first ]
		on: Error
		do: [ ^ self ].
	firstItem
		aptitude: BrGlamorousButtonIconAptitude new;
		background: Color transparent;
		border: BlBorder empty;
		padding: BlInsets empty;
		icon: self spotterHeaderLogoElement;
		label: '';
		action: [ :anElement :aButtonModel :anEvent | ]
]

{ #category : 'instance creation' }
CFFontAwesomeIcons class >> icon: aSelectorSymbol [
	self styleName ifNil: [ ^ self defaultStyle perform: aSelectorSymbol asSymbol ].
	^ self perform: aSelectorSymbol asSymbol
]

{ #category : 'instance creation' }
CFFontAwesomeIcons class >> icon: aSelectorSymbol color: aColor [
	^ (self icon: aSelectorSymbol)
		color: aColor;
		yourself
]

{ #category : 'instance creation' }
CFFontAwesomeIcons class >> icon: aSelectorSymbol fitInto: anExtent color: aColor [
	| icon |
	icon := (self icon: aSelectorSymbol)
		color: aColor;
		yourself.
	^ [ icon fitInto: anExtent ] asStencil
]

{ #category : 'instance creation' }
CFFontAwesomeIcons class >> icon: aSelectorSymbol height: aNumber color: aColor [
	| icon |
	icon := (self icon: aSelectorSymbol)
		color: aColor;
		yourself.
	^ [ icon height: aNumber ] asStencil
]

{ #category : 'instance creation' }
CFFontAwesomeIcons class >> icon: aSelectorSymbol size: aSize color: aColor [
	(aSize isPoint or: [ aSize respondsTo: #x ]) ifTrue: [
		^ self icon: aSelectorSymbol fitInto: aSize color: aColor ].
	^ self icon: aSelectorSymbol height: aSize color: aColor
]

{ #category : 'instance creation' }
CFFontAwesomeIcons class >> icon: aSelectorSymbol styleName: aStyleName [
	^ (self styleOrDefaultNamed: aStyleName) icon: aSelectorSymbol
]

{ #category : 'instance creation' }
CFFontAwesomeIcons class >> icon: aSelectorSymbol width: aNumber color: aColor [
	| icon |
	icon := (self icon: aSelectorSymbol)
		color: aColor;
		yourself.
	^ [ icon width: aNumber ] asStencil
]

{ #category : 'instance creation' }
CFFontAwesomeIcons class >> iconNamed: aSelector styleKey: aStyleKey width: aWidth height: aHeight pathSpecs: pathSpecs unicode: aUnicodeString label: aLabelString [
	^ CFFontAwesomeIcon new
		initializeName: aSelector
		styleKey: aStyleKey
		unicode: aUnicodeString
		label: aLabelString
		viewBox: (0 @ 0 extent: aWidth @ aHeight)
		pathSpecs: pathSpecs
]

{ #category : 'styles' }
CFFontAwesomeIcons class >> loadFromDisc [
	"Point this to your licensed download of the font awesome metadata"

	CFFontAwesomeMetadataImporter
		importFromIconsJsonFile: '/Users/jupiter/Downloads/fontawesome-pro-5.15.4-desktop/metadata/icons.json'
				asFileReference
		packageName: 'BVC-FontAwesome-Fonts'
		version: '5.15.4'
]

{ #category : 'metadata' }
CFFontAwesomeIcons class >> metadata [
	^ Metadata ifNil: [ Metadata := CFFontAwesomeMetadata new ]
]

{ #category : 'metadata' }
CFFontAwesomeIcons class >> metadata: aMetadata [
	Metadata := aMetadata
]

{ #category : 'styles' }
CFFontAwesomeIcons class >> style: aStyleName [
	^ Smalltalk
		at: (CFFontAwesomeMetadataImporter styleClassNameFor: aStyleName) asSymbol
		ifAbsent: [ self error: 'No imported Font Awesome style named ', aStyleName printString ]
]

{ #category : 'styles' }
CFFontAwesomeIcons class >> styleName [
	^ nil
]

{ #category : 'styles' }
CFFontAwesomeIcons class >> styleNameOrDefault: aStyleName [
	^ aStyleName ifNil: [ self defaultStyleName ]
]

{ #category : 'styles' }
CFFontAwesomeIcons class >> styleOrDefaultNamed: aStyleName [
	^ aStyleName
		ifNil: [ self defaultStyle ]
		ifNotNil: [ self style: aStyleName ]
]
