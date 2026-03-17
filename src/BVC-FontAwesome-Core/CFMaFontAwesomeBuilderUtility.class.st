Class {
	#name : 'CFMaFontAwesomeBuilderUtility',
	#superclass : 'Object',
	#category : 'BVC-FontAwesome-Core',
	#package : 'BVC-FontAwesome-Core'
}

{ #category : 'elements' }
CFMaFontAwesomeBuilderUtility class >> newChooseIconAffordanceFor: aDescription [
	^ BrLabel new
		aptitude: BrLabelAptitude new;
		text: aDescription chooseIconLabel;
		padding: (BlInsets all: 4);
		fitContent;
		yourself
]

{ #category : 'icons' }
CFMaFontAwesomeBuilderUtility class >> newFontAwesomeIconFor: aSelectorSymbol using: aDescription [
	| icon |
	^ [
		icon := aDescription iconLibraryClass
			icon: aSelectorSymbol
			styleName: aDescription styleName.
		icon color: Color black.
		aDescription scaledElementForIcon: icon ]
		on: Error
		do: [ self newChooseIconAffordanceFor: aDescription ]
]

{ #category : 'icons' }
CFMaFontAwesomeBuilderUtility class >> newFontAwesomeIconForMetadata: anIconMetadata styleName: aStyleName fitInto: anExtent [
	^ [ | icon |
		icon := anIconMetadata iconLibraryClass
			icon: anIconMetadata selectorSymbol
			styleName: aStyleName.
		icon color: Color black.
		icon fitInto: anExtent ]
		on: Error
		do: [ BrLabel new
				aptitude: BrLabelAptitude new;
				text: anIconMetadata selectorSymbol asString;
				fitContent;
				yourself ]
]
