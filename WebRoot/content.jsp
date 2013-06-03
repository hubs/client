<%@ page language="java" import="java.util.*,com.jzero.util.MTool" pageEncoding="UTF-8"%>
<%@include file="/front/top.jsp" %>
<%
	List<MRecord> submenuLst=obj.get("submenuLst");//子菜单
	MRecord contentObj=obj.get("contentObj");//实体内容
	List<MRecord> subImg=obj.get("subImg");//子图
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
				 <div class="flexslider">
					<ul class="slides" >
					<%if(!MCheck.isNull(subImg)){for(MRecord row:subImg){%>
						<li data-thumb="upload/<%=row.getStr("path") %>">
							<img src="upload/<%=row.getStr("path") %>" height="210px" />
						</li>
					<%}}%>
					</ul>
				</div>
				   </td></tr>
			</table>
			</td>
			<td valign="top" width="59%">
			<table>
				 <tr bgcolor="#66CCFF" ><td>景区介绍</td></tr>
				 <tr><td align="left"><%=contentObj.getStr("introduce") %></td></tr>
			</table>
			</td>
		</tr>
	</table>
<!--头结束-->			
	<table>	     
		<tr >
		<td valign="top" width="50%">
			<table>
				<tr><td bgcolor="#66CCFF">位置</td></tr>
				<tr><td><div id="map"></div></td></tr>
			</table>
		</td>
		<td width="50%" valign="top">
			<table>
				<tr><td bgcolor="#66CCFF">交易</td></tr>
				<tr><td>市场价：<b><%=contentObj.getStr("market_price") %></b>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;星空优惠价：<b style="color:red"><%=contentObj.getStr("preferential_price") %></b>元</td></tr>
				<tr><td ><a href="index/buy/<%=contentObj.getStr("id")%>/<%=contentObj.getStr("parent_id")%>" class="btn btn-large btn-primary">决定购买&gt;&gt;</a></td></tr>
			</table>
		</td>
		</tr>
     </table>

</div>

</td></tr></table>

<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script>
<%=T.js("js/gmaps/gmaps.js") %>
<%=T.css("js/gmaps/examples.css") %>
<script type="text/javascript">
var map;
    $(document).ready(function(){
      $('.flexslider').flexslider({animation: "slide",controlNav: "thumbnails"});
      map = new GMaps({
        el: '#map',
        lat: 25.25028397985944,
        lng: 110.2793878027344
      });
      map.addMarker({
        lat: <%=contentObj.getStr("longitude","0")%>,
        lng: <%=contentObj.getStr("latitude","0")%>,
        title: '<%=contentObj.getStr("title")%>',
        infoWindow: {content: '<p><%=contentObj.getStr("introduce")%></p>'}
      });
    });
</script>
</body>
</html>
