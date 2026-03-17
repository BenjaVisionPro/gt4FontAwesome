Class {
	#name : 'CFMaFontAwesomeIconStencilBuilder',
	#superclass : 'GtMagritteModelStencilBuilder',
	#category : 'BVC-FontAwesome-Core',
	#package : 'BVC-FontAwesome-Core'
}

{ #category : 'api - instantiation' }
CFMaFontAwesomeIconStencilBuilder >> buildDefault [
	^ self model
		ifNil: [ CFMaFontAwesomeBuilderUtility newChooseIconAffordanceFor: self description ]
		ifNotNil: [ CFMaFontAwesomeBuilderUtility newFontAwesomeIconFor: self model using: self description ]
]
