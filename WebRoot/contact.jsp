<%@ page language="java" import="java.util.*,com.jzero.util.MTool" pageEncoding="UTF-8"%>
<%@include file="/front/top.jsp" %>
<%
	String contact=obj.get("contact");//实体内容
%>
    <!-- 中间栏开始 -->
    <table height="442px"">
        <tr align="center" valign="top">
          <!-- 左边栏目开始 -->
          <td width="255px">
	          <table border="1"  id="left_table">
	            <tr>
	              <td class="bg_color">分类栏目</td>
	            </tr>
	            <%if(!MCheck.isNull(categoryLst)){for(MRecord row:categoryLst){%>
	            <tr >
	              <td><a href="#" target="_self"><%=row.getStr("name") %></a></td>
	            </tr>
				<%}}  %>
	          </table>
          </td>
          <!-- 左边栏目结束 -->
          <!-- 中间栏目开始 -->
          <td>
	          <table>
	            <tr>
	              <td>
	              	<%=contact %>
	              </td>
	            </tr>
	           
	          </table>
          </td>
         <!-- 中间栏目结束 -->
         
        </tr>
    </table>
    <!-- 中间栏结束 --> 
    </td>
  </tr>
</table>
</body>
</html>
