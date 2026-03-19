"
I represent the imported metadata of a Font Awesome icon family.

## Responsibilities
- I keep family-level information such as family name, version, and available styles.
- I manage the collection of {{gtClass:FontAwesomeIconMetadata}} instances indexed by selector.
- I provide search operations over the imported icon metadata.
- I integrate with GT search so icon libraries can expose searchable icon results.

## Example usage
```smalltalk
someMetadata searchIconsMatching: 'address card'
```

Use me as the searchable catalog behind an icon library.
"
Class {
	#name : 'FontAwesomeMetadata',
	#superclass : 'Object',
	#instVars : [
		'familyName',
		'version',
		'styles',
		'iconsBySelector'
	],
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'adding' }
FontAwesomeMetadata >> addIconMetadata: anIconMetadata [
	iconsBySelector at: anIconMetadata selectorSymbol put: anIconMetadata
]

{ #category : 'accessing' }
FontAwesomeMetadata >> allIconMetadata [
	^ iconsBySelector values asArray
]

{ #category : 'accessing' }
FontAwesomeMetadata >> familyName [
	^ familyName
]

{ #category : 'accessing' }
FontAwesomeMetadata >> familyName: aString [
	familyName := aString
]

{ #category : 'searching' }
FontAwesomeMetadata >> filterIconsMatching: aString [
	^ self searchIconsMatching: aString
]

{ #category : 'gt extensions' }
FontAwesomeMetadata >> gtSearchForFontAwesomeIconsFor: aSearch [
	^ self
		gtSearchForFontAwesomeIconsFor: aSearch
		satisfying: [ :each | true ]
]

{ #category : 'gt extensions' }
FontAwesomeMetadata >> gtSearchForFontAwesomeIconsFor: aSearch satisfying: aBlock [
	<gtSearch>
	^ aSearch list
		title: 'Font Awesome Icons';
		priority: 5;
		items: [ :aContext |
			self
				searchIconsMatching: aContext searchQuery
				satisfying: aBlock ];
		itemsLimit: Float infinity;
		itemName: [ :each | each selectorSymbol asString ];
		previewElement: [ :each | each asSpotterPreviewElement ];
		send: [ :each :step :search | each ];
		filter: [ :aSpotterContext | GtSpotterNoFilter new ];
		wantsToDisplayOnEmptyQuery: true;
		yourself
]

{ #category : 'accessing' }
FontAwesomeMetadata >> iconMetadataAt: aSelectorSymbol [
	^ iconsBySelector at: aSelectorSymbol ifAbsent: [ nil ]
]

{ #category : 'accessing' }
FontAwesomeMetadata >> iconsBySelector [
	^ iconsBySelector
]

{ #category : 'initialization' }
FontAwesomeMetadata >> initialize [
	super initialize.
	styles := #().
	iconsBySelector := Dictionary new
]

{ #category : 'searching' }
FontAwesomeMetadata >> queryTermsFor: aString [
	^ ((aString ifNil: [ '' ]) asLowercase findTokens: Character space asString)
		reject: [ :each | each isEmpty ]
]

{ #category : 'searching' }
FontAwesomeMetadata >> searchIconsMatching: aString [
	^ self
		searchIconsMatching: aString
		satisfying: [ :each | true ]
]

{ #category : 'searching' }
FontAwesomeMetadata >> searchIconsMatching: aString satisfying: aBlock [
	| terms |
	terms := self queryTermsFor: aString.
	^ self
		sortedMetadata: (self allIconMetadata
				select: [ :each |
					(aBlock value: each)
						and: [ terms isEmpty or: [ each matchesAllSearchTerms: terms ] ] ])
		matchingSearchTerms: terms
]

{ #category : 'searching' }
FontAwesomeMetadata >> sortedMetadata: aCollection matchingSearchTerms: terms [
	^ (aCollection
		asSortedCollection: [ :a :b |
			terms isEmpty
				ifTrue: [ a selectorSymbol asString <= b selectorSymbol asString ]
				ifFalse: [
					| sa sb |
					sa := a scoreForSearchTerms: terms.
					sb := b scoreForSearchTerms: terms.
					sa = sb
						ifTrue: [ a selectorSymbol asString <= b selectorSymbol asString ]
						ifFalse: [ sa > sb ] ] ])
		asArray
]

{ #category : 'accessing' }
FontAwesomeMetadata >> styles [
	^ styles
]

{ #category : 'accessing' }
FontAwesomeMetadata >> styles: aCollection [
	styles := aCollection asArray
]

{ #category : 'accessing' }
FontAwesomeMetadata >> version [
	^ version
]

{ #category : 'accessing' }
FontAwesomeMetadata >> version: aString [
	version := aString
]
