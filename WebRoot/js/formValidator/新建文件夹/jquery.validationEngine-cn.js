(function($) {   
    $.fn.validationEngineLanguage = function() {};   
    $.validationEngineLanguage = {   
        newLang: function() {   
            $.validationEngineLanguage.allRules =   {"required":{               // Add your regex rules here, you can take telephone as an example   
                        "regex":"none",   
                        "alertText":"* 非空选项.",   
                        "alertTextCheckboxMultiple":"* 请选择一个单选框.",   
                        "alertTextCheckboxe":"* 请选择一个复选框."}} 
                  
        }   
    }   
})(jQuery);   
  
$(document).ready(function() {     
    $.validationEngineLanguage.newLang()   
});  
