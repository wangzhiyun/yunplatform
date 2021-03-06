<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript">
<!--
	//垃圾箱恢复
	ns.email.resetMailState = function(id){
		if(id){
			var url = "<%=basePath%>/pages/platform/email/rubbishMail/resetState.action?rubbishMailIDs="+id;
		}else{
			var url = "<%=basePath%>/pages/platform/email/rubbishMail/resetState.action";
			var param = $("#mailBoxListArea #tableForm").serialize();
			var url = url + "?" + param;
			var items = $("#mailBoxListArea #tableForm input[type='checkbox']:checked").length;
			if(items == 0){alertMsg.warn("请选择要恢复的数据!");return;}
		}
		$.post(url,null,refreshList,'json');
	}
	//垃圾箱删除
	ns.email.deleteRubbishMail = function(id){
		if(id){
			var url = "<%=basePath%>/pages/platform/email/rubbishMail/delete.action?rubbishMailIDs="+id;
		}else{
			var url = "<%=basePath%>/pages/platform/email/rubbishMail/delete.action";
			var param = $("#mailBoxListArea #tableForm").serialize();
			var url = url + "?" + param;
			var items = $("#mailBoxListArea #tableForm input[type='checkbox']:checked").length;
			if(items == 0){alertMsg.warn("请选择要删除的数据!");return;}
		}
		alertMsg.confirm("删除后数据将不能恢复,您确定吗?", {okCall:function(){ajaxTodo(url,refreshList);}});
	}
	ns.email.viewRubbishMail = function(id){
		navTab.openTab('viewRubbishMailTab'+id,'<%=basePath %>/pages/platform/email/rubbishMail/view.action?id='+id,{title:'已删除邮件'});
	}
	$(function() {
		ns.common.showQuery('${queryType}')
		ns.common.mouseForButton();
	});
//-->
</script>
</head>
<body>	
	<form id="pagerForm" method="post" action="<%=basePath%>/pages/platform/email/rubbishMail/list.action?queryType=${queryType}">
		<input type="hidden" name="pageNum" value="1" />
		<input type="hidden" name="numPerPage" value="${pageResult.pageSize }" />
		<input type="hidden" name="rubbishMail.subject" value="${rubbishMail.subject}" />
	</form>
	<div class="pageContent">
		<div class="panelBar">
			<table>
				<tr><td>
					<button type="button" class="listbutton" onclick="ns.email.resetMailState();" >恢复</button>				
					<button type="button" class="listbutton" onclick="ns.email.deleteRubbishMail();" >删除</button>				
				</td></tr>
			</table>
		</div>
	</div>
	<div id="defaultQuery" class="pageHeader">
		<div class="searchBar">
			<form id="defaultQueryForm" onsubmit="return divSearch(this,'mailBoxListArea');"" action="<%=basePath%>/pages/platform/email/rubbishMail/list.action?queryType=0" method="post">
				<table class="searchContent">
					<tr>
						<td class="queryTd">主题	<input name="rubbishMail.subject" value="${rubbishMail.subject}"/></td>
						<td>
							<button type="button" class="listbutton" onclick="ns.common.query('defaultQueryForm');">查询</button>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	<div class="panelBar">
		<div class="pages">
			<span>显示</span>
			<select class="combox" name="numPerPage" onchange="navTabPageBreak({numPerPage:this.value},'mailBoxListArea')">
				<option value="20" <c:if test="${pageResult.pageSize==20}">selected</c:if>>20</option>
				<option value="50" <c:if test="${pageResult.pageSize==50}">selected</c:if>>50</option>
				<option value="100" <c:if test="${pageResult.pageSize==100}">selected</c:if>>100</option>
				<option value="200" <c:if test="${pageResult.pageSize==200}">selected</c:if>>200</option>
			</select>
			<span>条，共${pageResult.totalCount}条</span>
		</div>
		<div class="pagination" rel="mailBoxListArea" targetType="navTab" totalCount="${pageResult.totalCount}" numPerPage="${pageResult.pageSize }" pageNumShown="${pageResult.pageCountShow}" currentPage="${pageResult.currentPage}"></div>
	</div>
	<form id="tableForm" name="tableForm" method="post">
		<div>
			<table class="table" width="100%">
				<thead>
					<tr>
						<th align="center" width="5%" ><input name="all" type="checkbox"  class="checkbox" onclick="ns.common.selectAll(this,'rubbishMailIDs')"/></th>
						<th align="center" width="5%" >序号</th>
						<th align="center" width="65%">主题</th>
						<th align="center" width="15%">时间</th>
						<th align="center" width="10%" >管理</th>
					</tr>
				</thead>
				<tbody>
		            <c:forEach items="${pageResult.content}" var="rubbishMail" varStatus="status">
		                <c:if test="${status.count%2==0}">
		                	<tr target="id_column" rel="1" class='event'>
		                </c:if>
		                <c:if test="${status.count%2!=0}">
		                	<tr target="id_column" rel="1">
		                </c:if>
		                    	<td align="center"><input type="checkbox" class="checkbox"  name="rubbishMailIDs" value="${rubbishMail.id}"/></td>
		                    	<td align="center">${(pageResult.currentPage-1) * pageResult.pageSize + status.count}</td>
		                    	<td><div style="text-align:left;">${rubbishMail.subject}</div></td>
		                    	<td align="center"><fmt:formatDate value="${rubbishMail.date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
		                    	<td align="center">
		                    		<a style="cursor: pointer;color:blue;" onclick="ns.email.viewRubbishMail('${rubbishMail.id}');">查看</a>&nbsp;
		                    		<a style="cursor: pointer;color:blue;" onclick="ns.email.deleteRubbishMail('${rubbishMail.id}');">删除</a>
		                    	</td>
		                    </tr>
		            </c:forEach>
				</tbody>	
			</table>
		</div>
	</form>
</body>
</html>