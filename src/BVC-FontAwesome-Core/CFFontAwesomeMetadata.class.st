Class {
	#name : 'CFFontAwesomeMetadata',
	#superclass : 'Object',
	#instVars : [
		'familyName',
		'version',
		'styles',
		'iconsBySelector'
	],
	#category : 'BVC-FontAwesome-Core',
	#package : 'BVC-FontAwesome-Core'
}

{ #category : 'adding' }
CFFontAwesomeMetadata >> addIconMetadata: anIconMetadata [
	iconsBySelector at: anIconMetadata selectorSymbol put: anIconMetadata
]

{ #category : 'accessing' }
CFFontAwesomeMetadata >> allIconMetadata [
	^ iconsBySelector values asArray
]

{ #category : 'accessing' }
CFFontAwesomeMetadata >> familyName [
	^ familyName
]

{ #category : 'accessing' }
CFFontAwesomeMetadata >> familyName: aString [
	familyName := aString
]

{ #category : 'searching' }
CFFontAwesomeMetadata >> filterIconsMatching: aString [
	^ self searchIconsMatching: aString
]

{ #category : 'gt extensions' }
CFFontAwesomeMetadata >> gtSearchForFontAwesomeIconsFor: aSearch [
	^ self
		gtSearchForFontAwesomeIconsFor: aSearch
		satisfying: [ :each | true ]
]

{ #category : 'gt extensions' }
CFFontAwesomeMetadata >> gtSearchForFontAwesomeIconsFor: aSearch satisfying: aBlock [
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
		send: [ :each :step :search | each ];
		filter: [ :aSpotterContext | GtSpotterNoFilter new ];
		wantsToDisplayOnEmptyQuery: true;
		yourself
]

{ #category : 'accessing' }
CFFontAwesomeMetadata >> iconMetadataAt: aSelectorSymbol [
	^ iconsBySelector at: aSelectorSymbol ifAbsent: [ nil ]
]

{ #category : 'accessing' }
CFFontAwesomeMetadata >> iconsBySelector [
	^ iconsBySelector
]

{ #category : 'initialization' }
CFFontAwesomeMetadata >> initialize [
	super initialize.
	styles := #().
	iconsBySelector := Dictionary new
]

{ #category : 'searching' }
CFFontAwesomeMetadata >> queryTermsFor: aString [
	^ ((aString ifNil: [ '' ]) asLowercase findTokens: Character space asString)
		reject: [ :each | each isEmpty ]
]

{ #category : 'searching' }
CFFontAwesomeMetadata >> searchIconsMatching: aString [
	^ self
		searchIconsMatching: aString
		satisfying: [ :each | true ]
]

{ #category : 'searching' }
CFFontAwesomeMetadata >> searchIconsMatching: aString satisfying: aBlock [
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
CFFontAwesomeMetadata >> sortedMetadata: aCollection matchingSearchTerms: terms [
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
CFFontAwesomeMetadata >> styles [
	^ styles
]

{ #category : 'accessing' }
CFFontAwesomeMetadata >> styles: aCollection [
	styles := aCollection asArray
]

{ #category : 'accessing' }
CFFontAwesomeMetadata >> version [
	^ version
]

{ #category : 'accessing' }
CFFontAwesomeMetadata >> version: aString [
	version := aString
]
