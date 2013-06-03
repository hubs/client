<%@ page language="java" import="java.util.*,com.jzero.util.MTool" pageEncoding="UTF-8"%>
<%@include file="/front/top.jsp" %>
<%
	MRecord contentObj=obj.get("contentObj");//实体内容
%>
    <!-- 中间栏开始 -->
    <table >
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
          <td>
          <form>
	         <table  style="margin:2px 0 0 0px" border=1>
                <tbody>
                 <tr bgcolor="#66CCFF"><td colspan="4">客户资料</td></tr>
                 <tr><td>身份证号:</td><td colspan="3"> <input  type="text"  id="idcard" maxlength="18"  autocomplete="off"></td></tr>
                 <tr><td>手机号码:</td><td colspan="3"> <input  type="text"  id="tel" maxlength="11"  autocomplete="off" required="required"></td></tr>
                 <tr bgcolor="#66CCFF"><td colspan="4">购票信息</td></t</tr>
                 <tr><td>门票名称:</td><td colspan="3"> <%=contentObj.getStr("title")%></td></tr>
                 <tr><td>优惠价:</td><td> <input type="hidden" id="preferential" value="<%=contentObj.getStr("preferential_price")%>"/><%=contentObj.getStr("preferential_price")%></td><td>参考市场价:</td><td> <%=contentObj.getStr("market_price")%></td></tr>
                 <tr><td>日期:</td><td colspan="3"><input type="date" value="<%=MDate.get_ymd()%>"/> </td></tr>
                 <tr><td>数量(张):</td><td><input   type="number" name="num" id="num" min="1" max="50" value="1"></td><td>总价(元):</td><td><input  type="text" id="totalcount" name="totalcount" value="<%=contentObj.getStr("preferential_price")%>" readonly></td></tr>
                 <tr><td>出票方式:</td><td colspan="3"><input name="radio2" type="radio"  value="打印纸质门票" checked>打印纸质门票<input type="radio" name="radio2"  value="radio2">发送手机二维码</td></tr>
                 <tr><td colspan="4"><input type="submit" class="btn btn-large btn-primary" value="提交"></td></tr>
          		</tbody>
          	</table>
          </form>
          </td>
         <!-- 中间栏目结束 -->
        </tr>
    </table>
    <!-- 中间栏结束 --> 
 </td></tr></table>
<%=T.css("js/Keyboard/jquery-ui.css")%>
<%=T.css("js/Keyboard/keyboard.css")%>
<%=T.js("js/Keyboard/jquery-ui.min.js")%>
<%=T.js("js/Keyboard/jquery.keyboard.js")%>
<script type="text/javascript">
	$(function(){
		$("#num").change(function(){var pre=$("#preferential").val();$("#totalcount").val(this.value*pre);})
        $('#tel').keyboard({layout: 'num',restrictInput : true, preventPaste : true, autoAccept : true});
	    $('#idcard').keyboard({layout: 'num',restrictInput : true,preventPaste : true,autoAccept : true});
	});
</script>
</body>
</html>
