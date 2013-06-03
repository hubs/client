function go_back(){history.go(-1);return false ;  } 
function go_to_url(url){location=url;}
function getObjById(name){return document.getElementById(name); }
function chkNull(str) {
    if(str==undefined){return true;}
    else if (str == "") {return true;}
    else if (str == null) {return true;}
    else if(str=='[]'){return true;}
   	return false;
} 
//校验是否是数字
function isNum(v){
    var s = v;
    if(s!=""){ if(isNaN(s)){return false;}else{return true;}}
    return false;
}
function remove_nnum(id){
    return input_only_float(id);
}
function input_only_float(id){
	var obj=getObjById(id);
    var v=obj.value;
    if (/^(\+|-)?\d+($|\.\d+$)/.test(v)){ return true;      } //
    obj.value=v.replace(/[^\d\.]/g, '').replace(/\.{2,}/g,".");
    return false;            
}   
function getObjByName(name) {return document.getElementsByName(name);} 
function checkTextIsNumAndNotZero(ids,msg){
    var obj=getObjById(ids);
    var boolNum=isNum(obj.value);
    if(!boolNum){return true;}
  return  checkSelectIsNull(ids,msg);
}

//当srcId的text存放隐藏的destid中
function select_name(srcid,destid){
    var o_select = getObjById(srcid);	   
    var s_value = o_select.options[o_select.selectedIndex];
    if(chkNull(s_value.value)){getObjById(destid).value="";
    }else{getObjById(destid).value=s_value.text;}
}



function checkTextIsNull(ids,msg){
    var obj=getObjById(ids);
    if(obj!=undefined&&chkNull(obj.value)){ 
       alertMsg(msg); 
       obj.focus();
       return false;
    }
    return true;
}
function checkSelectIsNull(ids,msg){
    var obj=getObjById(ids);
    if(obj.value=='all'){ return true;}
    if(chkNull(obj.value) || obj.value==0 ){
       alertMsg(msg); 
       obj.focus();
       return false;
    }
    return false;
}

//根据传入的checkbox的选中状态设置所有checkbox的选中状态
function selectAll(obj,name){
        var allInput =document.getElementsByName(name);
        var loopTime = allInput.length;
        for(i = 0;i < loopTime;i++){         
            allInput[i].checked = obj.checked;
        }
} 
function checkIsSelect(name) {
	var flag = false;
	for ( var i = 0; i < getObjByName(name).length; i++) {
		if (getObjByName(name)[i].checked) {
			flag = true;
		}
	}
	return flag;
}

/**
--2012-7-19:在list 排序时调用
<td><a id="clhm" href="javascript:void(0)" onclick="orderby(this.id,'kahao/show_list')" class="down">车牌号&nbsp;</a></td>
*/
function orderby(id,url,parm){
    var obj=getObjById(id);
    var cn=obj.getAttribute("class");
    var to_url=null;
    if(cn=="desc"){
        to_url=AJAX_URL+url+"/"+id+"_asc";
        obj.setAttribute("class","asc");
    }else if(cn=="asc"){
        to_url=AJAX_URL+url+"/"+id+"_desc";
        obj.setAttribute("class","desc");
    }
    if(parm!=undefined){
        to_url=to_url+"/"+parm;
    }
//alert(to_url);
   go_to_url(to_url);
}

function c_order(o_s){
    if(!chkNull(o_s)){
        var arr= o_s.split("_");
        if(arr[1]=="desc"){
        	$("#"+arr[0]).attr("class","desc");
            //getObjById(arr[0]).setAttribute("class","desc");
        } else if(arr[1]=="asc"){
        	$("#"+arr[0]).attr("class","asc");
            // getObjById(arr[0]).setAttribute("class","asc");
        }
    }
}

/**
 *使用
  <script type="text/javascript">  
        ajax({  
            method : 'post',  
            url : 'data/test.do',  
            params : {e:'中文abc123',r:5},  
            callback : function(responseText){  
                var o = eval('('+responseText+')');  
                alert(o.success);  
            }  
        });  
    </script>  
 *
 *
 */
function ajax(o){     
    var XHR,  
        config = (typeof o === 'object' && o!=null)?o : {},  
        scope = config.scope||window,  
        method = config.method||'GET',  
        cb = typeof config.callback === 'function' ? config.callback : function(){},  
        url = config.url,  
        params = config.params||{},  
        p = null,  

        addURLParam = function(url,key,value){  
            url += (url.indexOf('?') == -1 ? '?' : '&');  
            url += encodeURIComponent(key) + '=' + encodeURIComponent(value); 
            return url;  
        },  
        timeout = 30000;//30s  s
          
    if(typeof url !== 'string'){  
        throw new Error('配置的请求地址错误!');  
    }  
      
    if(typeof XMLHttpRequest != 'undefined'){  
        XHR = new XMLHttpRequest();  
    }else if(typeof ActiveXObject != 'undefined'){  
        var versions = ['MSXML2.XMLHTTP.3.0','Msxml2.XMLHTTP.6.0','MSXML2.XMLHTTP','Microsoft.XMLHTTP'];  
        for(var i=0,len=versions.length;i<len;i++){  
            try{  
                XHR = new ActiveXObject(versions[i]);  
                break;  
            }catch(ex){  
                  
            }  
        }  
    }else{  
        throw new Error('您的浏览器不能创建XHR对象!');  
    }  
      
    var t = setTimeout(function(){  
        XHR.abort();  
        throw new Error('timeout!');  
    },timeout);  
      
    XHR.onreadystatechange = function(){  
        if(XHR.readyState == 4){  
            if((XHR.status >= 200 && XHR.status < 300) || XHR.status == 304){  
                //success  
                //XHR.responseText  
                clearTimeout(t);  
                cb.call(scope,XHR.responseText);  
            }else{  
                //exception  
                throw new Error('Request is unsuccessfull: '+ XHR.status);  
            }  
        }  
    }  
    if(method.toUpperCase() == 'GET'){  
        for(var f in params){  
            url = addURLParam(url,f,params[f]);  
        }  
        url += (url.indexOf('?') == -1 ? '?' : '&');
        url += 'ts=' + (new Date()).valueOf(); 
    }else if(method.toUpperCase() == 'POST'){  
        var a = [];  
        for(var f in params){  
            a.push(f+'='+encodeURIComponent(params[f]));  
        }  
        p = a.join('&');  
    }  
      
    XHR.open(method,url,true);  
    XHR.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');  
    XHR.send(p);  
}  

//判断是否存在
function exists(id,t,msg){
       var v=getObjById(id).value;
       if(!chkNull(v)){
           ajax({  
                method : 'post',  
                url : AJAX_URL+"common/check_is_exist",  
                params : {nStr:id,qStr:getObjById(id).value,t_str:t},  
                callback : function(responseText){ 
                    if(responseText=="true"){ 
                        alertMsg(msg,id); 
                    }
                }  
            }); 
        }
}
//读取cookie
function getCookie(name){  
        var value="";  
        var cookie = ";"+document.cookie.replace(/;\s+/g,";")+";"  
        var pos = cookie.indexOf(";"+name+"=");  
        if(pos>-1){  
            var start = cookie.indexOf("=",pos);  
            var end = cookie.indexOf(";",start);  
            value = unescape(cookie.substring(start+1,end));  
        }  
        return value;  
}  
//-----------------------dialog区
function confirms_msg(msg,fid){   
    
   $.dialog.confirm(msg, function(){
        if(fid!=undefined){
           $("#"+fid).submit();
           return true;
        }
    }, function(){ $.dialog.tips('执行取消操作'); });
  return false;
}
//确认后跳转
function confirm_msg(msg,url){
    $.dialog.confirm(msg, function(){
         go_to_url(AJAX_URL+url);
    	 return true;
    }, function(){ $.dialog.tips('执行取消操作'); });
     return false;
}
function alertMsg(msg,id,defaul){
    $.dialog.alert(msg,function(){
        if(id!=undefined){
            if(defaul!=undefined){
                $("#"+id).val(defaul);
            }else{
                $("#"+id).val("");
            }
        }
    });
      return false;
}
function del(url,msg){

    var m=msg||"您确定要删除当前记录?";
    $.dialog.confirm(m, function(){
         location=url;  
    	 return true;
    }, function(){ $.dialog.tips('执行取消操作'); });
     return false;
}
function submit(url,msg){
    $.dialog.confirm(msg, function(){
         location=url;  
	    return true;
     },function(){ $.dialog.tips('执行取消操作'); });
    return false;
}

function submitForm(fname,uri){
    if(!checkIsSelect("select[]")){
        alertMsg("请选择要删除的选项.");
        return false;
    }
    $.dialog.confirm("确定删除选中的项?", function(){
        document.forms[fname].action =uri;
        document.forms[fname].submit();
    },function(){ $.dialog.tips('执行取消操作'); });
       return false;
}
//删除时调用
function del_form(form,url,e_msg,a_msg){
  var e=e_msg||"请选择要删除的选项.";
  var a=a_msg||"确定删除选中的项?";
  if(!checkIsSelect("select[]")){
        alertMsg(e);
        return false;
  }
   $.dialog.confirm(a, function(){
        document.forms[form].action =url;
        document.forms[form].submit();
    	 return true;
    }, function(){ $.dialog.tips('执行取消操作'); });
     return false;

}
function onlyNumber(){
    $(function(){
           $("[alt='msk']").each(function(i,item){
              $(this).keyup(function(){
                 return input_only_float($(this).attr('id'));
              })
          });  
    }) ;
}
function list_page(){
    $(function(){   
      color(".list");
      $('.list tr:gt(1):not(:last)').mouseover(function(){$(this).addClass("over");}).mouseout(function(){$(this).removeClass("over");})
    }); 
}
//新增/修改页面
function other_page(){
    $(function(){ 
      $('.other tr:gt(0):not(:last)').mouseover(function(){$(this).addClass("over");}).mouseout(function(){$(this).removeClass("over");})
    });   
}
function color(cn){
      $(cn+">tbody>tr:odd").addClass("odd");   //为奇数行添加样式  
      $(cn+">tbody>tr:even").addClass("even"); //为偶数行添加样式  
}
function check_find(){
    if(checkSelectIsNull('cxzd','请选择字段类型.')){
        return true;
    }else if(checkTextIsNull('cxnr','请输入查询的内容.')){
        return true;
    }
    return false;
   
}

//2012-9-2
function audit(url){
    $.dialog.select(
        function(val){
                 location=url+"/"+val;  
            	 return true;
        });
}
function audit_list(form,url){
    if(!checkIsSelect("select[]")){
        alertMsg("请选择要审核的选项");
        return false;
    }
    $.dialog.select(
        function(val){
            document.forms[form].action =url+"/"+val;
            document.forms[form].submit();
     });
     return false;
}
//清除图片时用到
function remove_this(id){
	$("#show_img").find("."+id).remove(); 
}
//禁止右键
function no_right(){
    $(function(){
    $(document).bind("contextmenu",function(e){
        return false;
     });  
    });
}