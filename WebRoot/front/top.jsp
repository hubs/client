<%@ page language="java" import="java.util.*,com.jzero.util.MTool" pageEncoding="UTF-8"%>
<%@ page import="com.jzero.util.*,com.jzero.tag.*,com.jzero.core.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<base href="<%=MTool.getBase() %>">
<%
	MRecord obj=MR.me().getAttr(Msg.OBJECT);
	String notice=obj.getStr("noticeContent");		//滚动内容
	List<MRecord> categoryLst=obj.get("categoryLst");//一级分类
	String pages=obj.getStr("page");
%>
<%=T.js("js/jquery.js") %>
<%=T.css("css/front.css") %>
<%=T.css("js/flexslider/flexslider.css") %>
<%=T.js("js/flexslider/jquery.flexslider-min.js") %>
 <script type="text/javascript" charset="utf-8">
    $(function(){
    	<% if(!MCheck.isNull(pages)){%>
    		 var id="<%=pages%>";
    	$("a[dir='"+id+"']").addClass("current");
    	<%}%>
	 })
 </script>
</head>
<body>
<table>
  <tr>
    <td>
    <!-- head 开始 -->
    <table style="height: 60px">
      <tr>
        <td style="float:right;"><img src="images/front/logo.png"  width="53px" height="56px" /></td>
        <td style="width:78px"><span class="演示">星空</span><br />旅游商务</td>
        <td>
	   <table>
	       <tr>
	       	<td>
	       	<div id="mainmenu">
				<ul>
					<li><a href="#" target="_self"  dir="index_first">首页</a></li> 
					<%if(!MCheck.isNull(categoryLst)){for(MRecord row:categoryLst){%>
						<li ><a href="index/submenu/<%=MTool.encode(row.getStr("id")) %>" target="_self" dir="index_<%=row.getStr("id") %>"><%=row.getStr("name") %></a></li> 
					<%}}  %>
					<li ><a href="index/contact" target="_self" dir="index_last">联系我们</a></li> 
				</ul>
			</div>
	       	</td>
	       </tr>
	   </table>
       </td>
      </tr>
    </table>
    <!-- head 结束 -->
    <!-- 滚动开始 -->
    <table>
        <tr bgcolor="#CCCCCC">
          <td>
	          <marquee><%=notice %></marquee>
          </td>
        </tr>
    </table>
    <!-- 滚动结束 -->  