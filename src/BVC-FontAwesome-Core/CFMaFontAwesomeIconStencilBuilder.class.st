Class {
	#name : 'CFMaFontAwesomeIconStencilBuilder',
	#superclass : 'GtMagritteModelStencilBuilder',
	#category : 'BVC-FontAwesome-Core',
	#package : 'BVC-FontAwesome-Core'
}

{ #category : 'api - instantiation' }
CFMaFontAwesomeIconStencilBuilder >> buildDefault [
	^ self model
		ifNil: [ CFMaBuilderUtility newChooseIconAffordanceFor: self description ]
		ifNotNil: [ CFMaBuilderUtility newFontAwesomeIconFor: self model using: self description ]
]
