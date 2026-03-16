Class {
	#name : 'CFMaFontAwesomeIconFieldStencilBuilder',
	#superclass : 'GtMagritteDescriptionElementStencilBuilder',
	#category : 'BVC-FontAwesome-Core',
	#package : 'BVC-FontAwesome-Core'
}

{ #category : 'api - instantiation' }
CFMaFontAwesomeIconFieldStencilBuilder >> buildDefault [
	^ CFMaFontAwesomeIconFieldElement new
		fieldViewModel: (GtMagritteFieldViewModel new
				memento: self memento;
				description: self description;
				yourself);
		yourself
]
