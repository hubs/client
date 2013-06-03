
(function($) {
	$.fn.validationEngineLanguage = function() {};
	$.validationEngineLanguage = {
		newLang: function() {
			$.validationEngineLanguage.allRules = {
                "required": {    			// Add your regex rules here, you can take telephone as an example
						"regex":"none",
						"alertText":"* required",
						"alertTextCheckboxMultiple":"* 请选择一个选项",
						"alertTextCheckboxe":"* 此选择框为必选"
						}}
					
		}
	};
})(jQuery);

$(document).ready(function() {	
	$.validationEngineLanguage.newLang();
});