<%@ page language="java" import="java.util.*,com.jzero.util.MTool" pageEncoding="UTF-8"%>
<%@include file="/front/top.jsp" %>
<%
	List<MRecord> submenuLst=obj.get("submenuLst");//子菜单
	List<MRecord> contentLst=obj.get("contentLst");//实体内容
	List<MRecord> recommendLst=obj.get("recommendLst");//本栏推荐
%>
    <!-- 中间栏开始 -->
    <table height="400px">
        <tr align="center" valign="top">
          <!-- 左边栏目开始 -->
          <td width="255px">
	          <table border="1"  id="left_table">
	            <tr>
	              <td class="bg_color">分类栏目</td>
	            </tr>
	            <%if(!MCheck.isNull(submenuLst)){for(MRecord row:submenuLst){%>
	            <tr >
	              <td onclick="javascript:window.location='<%=MTool.getBase() %>index/subcontent/<%=row.getStr("id") %>/<%=row.getStr("parent_id") %>';"><%=row.getStr("name") %></td>
	            </tr>
				<%}}  %>
	          </table>
          </td>
          <!-- 左边栏目结束 -->
          <!-- 中间栏目开始 -->
          <td>
	          <table>
	            <tr align="left">
	              	<%if(!MCheck.isNull(contentLst)){for(MRecord row:contentLst){%>
	              	  <td><a href="index/content/<%=row.getStr("id") %>/<%=row.getStr("parent_id") %>"><img src="upload/<%=row.getStr("path") %>" alt="<%=row.getStr("title") %>" width="180" height="150"></a>
		               <p><%=row.getStr("title") %></p>
		               </td>
					<%}}  %>
	            </tr>
	          </table>
          </td>
         <!-- 中间栏目结束 -->
        </tr>
    </table>
    <!-- 中间栏结束 --> 
    
    <!-- 底部栏开始 -->
    <table border="1"	>
        <tr bgcolor="#FF9966">
          <td width="96" height="135" align="center" valign="middle"><strong>推荐<br /><br />商品</strong></td>
           <td >
           <marquee onmouseover="this.stop()" onmouseout="this.start()" behavior="alternate" scrollamount="2" >
           <%if(!MCheck.isNull(recommendLst)){for(MRecord row:recommendLst){%>
	           <a href="index/content/<%=row.getStr("id") %>/<%=row.getStr("parent_id") %>"  title="<%=row.getStr("title") %>"><img title="<%=row.getStr("title") %>" src="upload/<%=row.getStr("path") %>" width="185" height="110" /></a>
		   <%}}  %>
          </marquee>
           </td>
        </tr>
    </table>
    <!-- 底部栏结束 -->
    </td>
  </tr>
</table>
</body>
</html>
