Class {
	#name : 'FontAwesomeIconFieldStencilBuilder',
	#superclass : 'GtMagritteDescriptionElementStencilBuilder',
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'api - instantiation' }
FontAwesomeIconFieldStencilBuilder >> buildDefault [
	^ FontAwesomeIconFieldElement new
		fieldViewModel: (GtMagritteFieldViewModel new
				memento: self memento;
				description: self description;
				yourself);
		yourself
]
