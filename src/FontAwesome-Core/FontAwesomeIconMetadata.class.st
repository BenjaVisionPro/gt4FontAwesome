"
I represent searchable metadata for one Font Awesome icon.

## Responsibilities
- I keep the selector name, Font Awesome name, label, categories, styles, and search terms for one icon.
- I answer whether I match a search query.
- I provide inspector views and preview elements that make the icon explorable.
- I link metadata back to the icon library class that can build the real icon element.

I do not render the icon myself. Instead, I describe how to find and present it.

## Example usage
```smalltalk
someMetadata matchesSearchText: 'address card'
```

```smalltalk
someMetadata asSpotterPreviewElement
```

Use me as the domain object for search, inspection, and selection workflows.
"
Class {
	#name : 'FontAwesomeIconMetadata',
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
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'accessing' }
FontAwesomeIconMetadata >> asSpotterPreviewElement [
	^ FontAwesomeIconMetadataPreviewElement forMetadata: self
]

{ #category : 'accessing' }
FontAwesomeIconMetadata >> categories [
	^ categories
]

{ #category : 'accessing' }
FontAwesomeIconMetadata >> categories: aCollection [
	categories := aCollection asArray
]

{ #category : 'accessing' }
FontAwesomeIconMetadata >> fontAwesomeName [
	^ fontAwesomeName
]

{ #category : 'accessing' }
FontAwesomeIconMetadata >> fontAwesomeName: aString [
	fontAwesomeName := aString
]

{ #category : 'gt extensions' }
FontAwesomeIconMetadata >> gtDetailsFor: aView [
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
FontAwesomeIconMetadata >> gtDisplayText [
	^ self label ifNil: [ self selectorSymbol asString ]
]

{ #category : 'gt extensions' }
FontAwesomeIconMetadata >> gtLiveFor: aView [
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

{ #category : 'accessing' }
FontAwesomeIconMetadata >> iconLibraryClass [
	^ iconLibraryClass ifNil: [ FontAwesomeIcons ]
]

{ #category : 'accessing' }
FontAwesomeIconMetadata >> iconLibraryClass: aClass [
	iconLibraryClass := aClass
]

{ #category : 'initialization' }
FontAwesomeIconMetadata >> initialize [
	super initialize.
	searchTerms := #().
	styles := #().
	categories := #()
]

{ #category : 'accessing' }
FontAwesomeIconMetadata >> label [
	^ label
]

{ #category : 'accessing' }
FontAwesomeIconMetadata >> label: aString [
	label := aString
]

{ #category : 'searching' }
FontAwesomeIconMetadata >> matchesAllSearchTerms: aCollection [
	| lowered |
	lowered := self searchableStrings collect: [ :each | each asLowercase ].
	^ aCollection allSatisfy: [ :term |
		lowered anySatisfy: [ :each | each includesSubstring: term ] ]
]

{ #category : 'searching' }
FontAwesomeIconMetadata >> matchesSearchText: aString [
	^ self matchesAllSearchTerms: { aString asLowercase }
]

{ #category : 'accessing' }
FontAwesomeIconMetadata >> preferredStyleName [
	(styles includes: self iconLibraryClass defaultStyleName) ifTrue: [
		^ self iconLibraryClass defaultStyleName ].
	(styles includes: 'regular') ifTrue: [ ^ 'regular' ].
	styles isEmpty ifTrue: [ ^ self iconLibraryClass defaultStyleName ].
	^ styles first
]

{ #category : 'searching' }
FontAwesomeIconMetadata >> scoreForSearchTerms: aCollection [
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
FontAwesomeIconMetadata >> searchTerms [
	^ searchTerms
]

{ #category : 'accessing' }
FontAwesomeIconMetadata >> searchTerms: aCollection [
	searchTerms := aCollection asArray
]

{ #category : 'searching' }
FontAwesomeIconMetadata >> searchableStrings [
	^ ({ self selectorSymbol asString.
		self fontAwesomeName ifNil: [ '' ].
		self label ifNil: [ '' ] }
		, self searchTerms
		, self categories)
		collect: [ :each | each asString ]
]

{ #category : 'searching' }
FontAwesomeIconMetadata >> searchableText [
	^ ' ' join: self searchableStrings
]

{ #category : 'accessing' }
FontAwesomeIconMetadata >> selectorSymbol [
	^ selectorSymbol
]

{ #category : 'accessing' }
FontAwesomeIconMetadata >> selectorSymbol: aSymbol [
	selectorSymbol := aSymbol
]

{ #category : 'accessing' }
FontAwesomeIconMetadata >> styles [
	^ styles
]

{ #category : 'accessing' }
FontAwesomeIconMetadata >> styles: aCollection [
	styles := aCollection asArray
]

{ #category : 'accessing' }
FontAwesomeIconMetadata >> supportsStyleNamed: aStyleName [
	^ styles includes: aStyleName
]
