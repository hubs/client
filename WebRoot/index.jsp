<%@ page language="java" import="java.util.*,com.jzero.util.MTool" pageEncoding="UTF-8"%>
<%@include file="/front/top.jsp" %>
<%
	List<MRecord> recommendLst=obj.get("recommendLst");//推荐商品
	List<MRecord> adLst=obj.get("adLst");//推荐广告
	List<MRecord> picLst=obj.get("picLst");//首页图片
%>
    <!-- 中间栏开始 -->
    <table>
        <tr align="center" valign="top">
          <!-- 左边栏目开始 -->
          <td width="255px">
	          <table border="1"  id="left_table">
	            <tr>
	              <td class="bg_color">分类栏目</td>
	            </tr>
	            <%if(!MCheck.isNull(categoryLst)){for(MRecord row:categoryLst){%>
	            <tr >
	              <td onclick="javascript:window.location='<%=MTool.getBase() %>index/submenu/<%=row.getStr("id") %>/<%=row.getStr("parent_id") %>';"><%=row.getStr("name") %></td>
	            </tr>
				<%}}  %>
	          </table>
          </td>
          <!-- 左边栏目结束 -->
          
          <!-- 中间栏目开始 -->
          <td width="65%">
	          <table>
	            <tr>
	              <td>
	              <div class="flexslider">
				    <ul class="slides" >
				        <%if(!MCheck.isNull(picLst)){for(MRecord row:picLst){%>
				        <li data-thumb="upload/<%=row.getStr("path") %>">
				        <a href="index/ad/<%=row.getStr("id") %>/<%=row.getStr("parent_id") %>" title="<%=row.getStr("title") %>">
					      <img src="upload/<%=row.getStr("path") %>" height="405px" width="940px"/>
<%--					      <p class="flex-caption"><%=row.getStr("title") %></p>--%>
						</a>
					    </li>
				    	 <%}}  %>
				    </ul>
				  </div>
	               </td>
	            </tr>
	           
	          </table>
          </td>
         <!-- 中间栏目结束 -->
         
         <!-- 右边栏目开始 -->
          <td width="175px">
          	<table>
	            <tr>
	              <td>
	              <table border="1" id="ad" >
	                <tr class="bg_color"><td>分类广告</td></tr>
	                <%if(!MCheck.isNull(adLst)){for(MRecord row:adLst){%>
	                 <tr><td >
	                 <a href="index/ad/<%=row.getStr("id") %>/<%=row.getStr("parent_id") %>" title="<%=row.getStr("title") %>"><img title="<%=row.getStr("title") %>" src="upload/<%=row.getStr("path") %>" /></a>
	                 </td></tr>
					<%}}  %>
	              </table>
	              </td>
	            </tr>
          </table>
          </td>
          <!-- 右边栏目结束 -->
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
<script type="text/javascript">
	$(function(){$('.flexslider').flexslider({  animation: "slide",controlNav: "thumbnails"});})
</script>
</body>
</html>
