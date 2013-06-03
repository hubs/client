<%@ page language="java" import="java.util.*,com.jzero.util.MTool" pageEncoding="UTF-8"%>
<%@include file="/front/top.jsp" %>
<%
	List<MRecord> submenuLst=obj.get("submenuLst");//子菜单
	MRecord contentObj=obj.get("contentObj");//实体内容
%>
<div style="float:left;width:255px">
  <table border="1"  id="left_table">
	    <tr><td class="bg_color">分类栏目</td></tr>
	    <%if(!MCheck.isNull(submenuLst)){for(MRecord row:submenuLst){%>
	    <tr ><td onclick="javascript:window.location='<%=MTool.getBase() %>index/subcontent/<%=row.getStr("id") %>/<%=row.getStr("parent_id") %>';"><%=row.getStr("name") %></td></tr>
	    <%}}  %>
	</table>
</div>
<div style="float:right;width:80%" class="content_info">
<!--头开始-->
	  <table>
		<tr><td   width="40%">
			<table><tr><td>
							<img src="<%=MTool.getBase() %>upload/<%=contentObj.getStr("path") %>" height="280px" />
				   </td></tr>
			</table>
			</td>
			<td valign="top" width="59%">
			<table>
				 <tr bgcolor="#66CCFF" ><td>介绍</td></tr>
				 <tr><td align="left"><%=contentObj.getStr("introduce") %></td></tr>
			</table>
			</td>
		</tr>
	</table>
<!--头结束-->			

</div>

</td></tr></table>
</body>
</html>
