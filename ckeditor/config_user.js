/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	config.language = 'ko';
	config.height=300;
	config.enterMode=CKEDITOR.ENTER_BR;
	config.shiftEnterMode=CKEDITOR.ENTER_BR;
	//config.uiColor='#000000'

	config.toolbar = [
		 ['Bold','Italic','Underline','Strike','-','RemoveFormat'],
		 ['Font','FontSize'],
		 ['TextColor','BGColor'],
		 ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
		 ['Link','Unlink','Image','Flash'],
		 ['About'],
		 '/'
	];

};