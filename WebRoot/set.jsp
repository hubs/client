<%@ page language="java" import="java.util.*,com.jzero.util.MTool,guilinsoft.sky.utils.MMsg" pageEncoding="UTF-8"%>
<%@include file="/front/top.jsp" %>
<%
	String read_all=MPro.me().getStr("read_all");
	String read_notice=MPro.me().getStr("read_notice");
	String read_contact=MPro.me().getStr("read_contact");
	String read_category=MPro.me().getStr("read_category");
%>
<%=T.form_open_m("index/save_set","return window.confirm(\"是否保存?\")") %>
<table>
	<tr>
		<th>字段</th><th>值</th><th align="left">说明</th>
	</tr>
	<tr>
		<td>同步所有数据</td>
		<td>
			<input type="radio" name="read_all" value="true" <%if(read_all.equals("true")){%> checked<%} %>/>是
			<input type="radio" name="read_all" value="false" <%if(read_all.equals("false")){%> checked<%} %>/>否
		</td>
		<td align="left">
			选择〖是〗:则会跟服务器同步所有数据。
			选择〖否〗:则会只同步服务上新的数据。
		</td>
	</tr>
	<tr>
		<td>远程下载地址</td>
		<td><input type="text" name="target_url" value="<%=MPro.me().getStr("target_url") %>"/></td>
		<td align="left">远程服务器的地址:格式为 http://服务器IP:端口/服务器名称</td>
	</tr>
	<tr>
		<td>远程服务器IP</td>
		<td><input type="text" name="target_ip" value="<%=MPro.me().getStr("target_ip") %>"/></td>
		<td align="left">远程服务器的IP地址,用于通信连接</td>
	</tr>
	<tr>
		<td>远程服务器端口:</td>
		<td><input type="text" name="target_port" value="<%=MPro.me().getStr("target_port") %>"/></td>
		<td align="left">远程服务器开放的监听端口,请不要随意更改,否则会造成通信失败。</td>
	</tr>
	<tr>
		<td>等待时间:</td>
		<td><input type="text" name="wait_time" value="<%=MPro.me().getStr("wait_time") %>"/></td>
		<td align="left">客户端定时访问服务器所等待时间,以分钟为单位。</td>
	</tr>
	<tr>
		<td>终端编号:</td>
		<td><input type="text" name="serno" value="<%=MPro.me().getStr("serno") %>"/></td>
		<td align="left">终端唯一标识符,需要与服务器中的终端表中的编号对应,请不要随意更改,不然后造成通信失败。</td>
	</tr>
	<tr>
		<td>最后更新时间:</td>
		<td><input type="date" name="lastsyn" value="<%=MPro.me().getStr("lastsyn") %>"/></td>
		<td align="left">用于服务器判断是否有新的数据需要发送<b style="color: red">(当同步所有数据选〖是〗时不起作用)</b></td>
	</tr>
	<tr>
		<td>是否读取菜单表</td>
		<td>
			<input type="radio" name="read_category" value="true" <%if(read_category.equals("true")){%> checked<%} %>/>是
			<input type="radio" name="read_category" value="false" <%if(read_category.equals("false")){%> checked<%} %>/>否
		</td>
		<td align="left">
			因为目录表很少改变,所以一般不需要每次都读取.<b style="color: red">(当同步所有数据选〖是〗时不起作用)</b>
		</td>
	</tr>
	<tr>
		<td>读取联系我们</td>
		<td>
			<input type="radio" name="read_contact" value="true" <%if(read_contact.equals("true")){%> checked<%} %>/>是
			<input type="radio" name="read_contact" value="false" <%if(read_contact.equals("false")){%> checked<%} %>/>否
		</td >
		<td align="left">
			读取联系我们信息,当联系我们有变更时,选择[是]则会同服务器同步。<b style="color: red">(当同步所有数据选〖是〗时不起作用)</b>
		</td>
	</tr>
	<tr>
		<td>读取公告信息</td>
		<td>
			<input type="radio" name="read_notice" value="true" <%if(read_notice.equals("true")){%> checked<%} %>/>是
			<input type="radio" name="read_notice" value="false" <%if(read_notice.equals("false")){%> checked<%} %>/>否
		</td>
		<td align="left">
			读取公告信息,选择[是]则会同服务器同步。<b style="color: red">(当同步所有数据选〖是〗时不起作用)</b>
		</td>
	</tr>
	<tr><td colspan="3"><input type="submit" class="btn btn-large btn-primary" value="保存"/></td></tr>
</table>
<%=T.form_close() %>
<% if(!MCheck.isNull(obj.getStr(MMsg.MESSAGE))){%>
	<script type="text/javascript">alert("<%=obj.getStr(MMsg.MESSAGE)%>")</script>
<%} %>
</body>
</html>
