Class {
	#name : 'CFFontAwesomeIconMetadata',
	#superclass : 'Object',
	#instVars : [
		'selectorSymbol',
		'fontAwesomeName',
		'label',
		'searchTerms',
		'styles',
		'categories',
		'iconLibraryClass'
	],
	#category : 'BVC-FontAwesome-Core',
	#package : 'BVC-FontAwesome-Core'
}

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> categories [
	^ categories
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> categories: aCollection [
	categories := aCollection asArray
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> fontAwesomeName [
	^ fontAwesomeName
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> fontAwesomeName: aString [
	fontAwesomeName := aString
]

{ #category : 'gt extensions' }
CFFontAwesomeIconMetadata >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [ {
			{'Selector'. self selectorSymbol asString}.
			{'Font Awesome Name'. self fontAwesomeName ifNil: [ '' ]}.
			{'Title'. self label ifNil: [ '' ]}.
			{'Styles'. ' , ' join: self styles}.
			{'Categories'. ' , ' join: self categories} } ];
		column: 'Field' text: [ :each | each first ];
		column: 'Value' text: [ :each | each second ]
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> gtDisplayText [
	^ self label ifNil: [ self selectorSymbol asString ]
]

{ #category : 'gt extensions' }
CFFontAwesomeIconMetadata >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 0;
		stencil: [ | icon |
			icon := self iconLibraryClass
				icon: self selectorSymbol
				styleName: self preferredStyleName.
			icon color: Color black.
			GtInspectorElementLiveViewContainer new
				element: (icon asScalableElementSized: (icon extentForHeight: 64));
				clipChildren: false ]
]

{ #category : 'gt extensions' }
CFFontAwesomeIconMetadata >> gtSpotterPreviewDetailRowLabel: aLabel value: aValue [
	| row keyLabel valueLabel |
	row := BrHorizontalPane new
		cellSpacing: 8;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.

	keyLabel := BrLabel new
		aptitude: BrLabelAptitude new;
		text: aLabel;
		opacity: 0.6;
		constraintsDo: [ :c |
			c horizontal exact: 92.
			c vertical fitContent ];
		yourself.

	valueLabel := BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		text: aValue;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.

	row addChildren: { keyLabel. valueLabel }.
	^ row
]

{ #category : 'gt extensions' }
CFFontAwesomeIconMetadata >> gtSpotterPreviewElement [
	| root samplesRow details |
	root := BrVerticalPane new
		cellSpacing: 12;
		matchParent;
		padding: (BlInsets all: 10);
		yourself.

	samplesRow := BrHorizontalPane new
		cellSpacing: 12;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ];
		yourself.
	#(24 48 96) do: [ :eachHeight |
		samplesRow addChild: (self gtSpotterPreviewSampleForHeight: eachHeight) ].

	details := BrVerticalPane new
		cellSpacing: 4;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.
	details addChildren: {
		(self gtSpotterPreviewDetailRowLabel: 'Selector' value: self selectorSymbol asString).
		(self gtSpotterPreviewDetailRowLabel: 'FA name' value: (self fontAwesomeName ifNil: [ '' ])).
		(self gtSpotterPreviewDetailRowLabel: 'Style' value: self preferredStyleName).
		(self gtSpotterPreviewDetailRowLabel: 'Styles' value: (' , ' join: self styles)).
		(self gtSpotterPreviewDetailRowLabel: 'Categories' value: (' , ' join: self categories)).
		(self gtSpotterPreviewDetailRowLabel: 'Search' value: (' , ' join: (self searchTerms collect: #asString))) }.

	root addChildren: { samplesRow. details }.
	^ root
]

{ #category : 'gt extensions' }
CFFontAwesomeIconMetadata >> gtSpotterPreviewSampleForHeight: aHeight [
	| container iconElement label frameExtent |
	frameExtent := aHeight + 24.
	iconElement := CFMaFontAwesomeBuilderUtility
		newFontAwesomeIconForMetadata: self
		styleName: self preferredStyleName
		fitInto: aHeight @ aHeight.
	iconElement constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].

	container := BlElement new
		layout: BlFrameLayout new;
		constraintsDo: [ :c |
			c horizontal exact: frameExtent.
			c vertical exact: frameExtent ];
		yourself.
	container addChild: iconElement.

	label := BrLabel new
		aptitude: BrLabelAptitude new;
		text: aHeight asString;
		opacity: 0.6;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent.
			c linear horizontal alignCenter ];
		yourself.

	^ BrVerticalPane new
		cellSpacing: 4;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ];
		addChildren: { container. label };
		yourself
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> iconLibraryClass [
	^ iconLibraryClass ifNil: [ CFFontAwesomeIcons ]
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> iconLibraryClass: aClass [
	iconLibraryClass := aClass
]

{ #category : 'initialization' }
CFFontAwesomeIconMetadata >> initialize [
	super initialize.
	searchTerms := #().
	styles := #().
	categories := #()
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> label [
	^ label
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> label: aString [
	label := aString
]

{ #category : 'searching' }
CFFontAwesomeIconMetadata >> matchesAllSearchTerms: aCollection [
	| lowered |
	lowered := self searchableStrings collect: [ :each | each asLowercase ].
	^ aCollection allSatisfy: [ :term |
		lowered anySatisfy: [ :each | each includesSubstring: term ] ]
]

{ #category : 'searching' }
CFFontAwesomeIconMetadata >> matchesSearchText: aString [
	^ self matchesAllSearchTerms: { aString asLowercase }
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> preferredStyleName [
	(styles includes: self iconLibraryClass defaultStyleName) ifTrue: [
		^ self iconLibraryClass defaultStyleName ].
	(styles includes: 'regular') ifTrue: [ ^ 'regular' ].
	styles isEmpty ifTrue: [ ^ self iconLibraryClass defaultStyleName ].
	^ styles first
]

{ #category : 'searching' }
CFFontAwesomeIconMetadata >> scoreForSearchTerms: aCollection [
	| selector name title score |
	selector := self selectorSymbol asString asLowercase.
	name := (self fontAwesomeName ifNil: [ '' ]) asLowercase.
	title := (self label ifNil: [ '' ]) asLowercase.
	score := 0.
	aCollection do: [ :term |
		selector = term ifTrue: [ score := score + 1000 ].
		(selector beginsWith: term) ifTrue: [ score := score + 300 ].
		(title beginsWith: term) ifTrue: [ score := score + 200 ].
		((selector includesSubstring: term)
			or: [ (name includesSubstring: term)
				or: [ title includesSubstring: term ] ])
			ifTrue: [ score := score + 50 ].
		(self searchTerms anySatisfy: [ :each | each asString asLowercase includesSubstring: term ])
			ifTrue: [ score := score + 20 ].
		(self categories anySatisfy: [ :each | each asString asLowercase includesSubstring: term ])
			ifTrue: [ score := score + 10 ] ].
	^ score
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> searchTerms [
	^ searchTerms
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> searchTerms: aCollection [
	searchTerms := aCollection asArray
]

{ #category : 'searching' }
CFFontAwesomeIconMetadata >> searchableStrings [
	^ ({ self selectorSymbol asString.
		self fontAwesomeName ifNil: [ '' ].
		self label ifNil: [ '' ] }
		, self searchTerms
		, self categories)
		collect: [ :each | each asString ]
]

{ #category : 'searching' }
CFFontAwesomeIconMetadata >> searchableText [
	^ ' ' join: self searchableStrings
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> selectorSymbol [
	^ selectorSymbol
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> selectorSymbol: aSymbol [
	selectorSymbol := aSymbol
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> styles [
	^ styles
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> styles: aCollection [
	styles := aCollection asArray
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> supportsStyleNamed: aStyleName [
	^ styles includes: aStyleName
]
