<%@ include file="/init.jsp" %>

<%
String rootFolderName = "";

if (rootFolderId != DLFolderConstants.DEFAULT_PARENT_FOLDER_ID) {
	try {
		Folder rootFolder = DLAppLocalServiceUtil.getFolder(rootFolderId);

		rootFolderName = rootFolder.getName();
	}
	catch (NoSuchFolderException nsfe) {
	}
}
%>

<liferay-portlet:actionURL portletConfiguration="true" var="configurationURL" />

<aui:form action="<%= configurationURL %>" method="post">
	<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />

	<aui:input name="preferences--shuffleImages--" type="checkbox" value="<%= shuffleImages %>"/>

	<aui:input name="preferences--maxImages--" value="<%= maxImages %>"/>

	<aui:input name="preferences--showTitle--" type="checkbox" value="<%= showTitle %>"/>

	<aui:input name="preferences--showDescription--" type="checkbox" value="<%= showDescription %>"/>

	<aui:input name="preferences--showModifiedDate--" type="checkbox" value="<%= showModifiedDate %>"/>

	<aui:input name="preferences--showCategorization--" type="checkbox" value="<%= showCategorization %>"/>

	<aui:input name="preferences--carouselWidth--" value="<%= carouselWidth %>" />

	<aui:input name="preferences--carouselHeight--" value="<%= carouselHeight %>" />

	<aui:input name="preferences--imgWidth--" value="<%= imgWidth %>" />

	<aui:input name="preferences--imgHeight--" value="<%= imgHeight %>" />

	<aui:input name="preferences--showControls--" type="checkbox" value="<%= showControls %>"/>

	<aui:input name="preferences--showMenuIndex--" type="checkbox" value="<%= showMenuIndex %>"/>

	<aui:input name="preferences--showCount--" type="checkbox" value="<%= showCount %>"/>

	<aui:input name="preferences--autoTransition--" type="checkbox" value="<%= autoTransition %>"/>

	<aui:input name="preferences--transitionDelay--" value="<%= transitionDelay %>" />

	<aui:input name="preferences--rootFolderId--" type="hidden" value="<%= rootFolderId %>" />

	<aui:field-wrapper label="root-folder">
		<label id="<portlet:namespace />rootFolderName"><%= rootFolderName %></label>

		<aui:button name="openFolderSelectorButton" onClick='<%= renderResponse.getNamespace() + "openFolderSelector();" %>' value="select" />

		<%
		String taglibRemoveFolder = "Liferay.Util.removeFolderSelection('rootFolderId', 'rootFolderName', '" + renderResponse.getNamespace() + "');";
		%>

		<aui:button disabled="<%= rootFolderId <= 0 %>" name="removeFolderButton" onClick="<%= taglibRemoveFolder %>" value="remove" />
	</aui:field-wrapper>

	<aui:input name="preferences--includeSubfolders--" type="checkbox" value="<%= includeSubfolders %>"/>

	<aui:button-row>
		<aui:button type="submit" />
	</aui:button-row>
</aui:form>

<aui:script>
	var A = AUI();

	function <portlet:namespace />openFolderSelector() {
		<liferay-portlet:renderURL windowState="pop_up" portletName="31" var="selectFolderURL">
			<portlet:param name="struts_action" value='/document_library_display/select_folder' />
		</liferay-portlet:renderURL>
		var folderWindow = window.open('<%= selectFolderURL %>', 'folder', 'directories=no,height=640,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no,width=830');

		folderWindow.focus();
	}

	function _31_selectFolder(rootFolderId, rootFolderName) {
		var namespace = '<portlet:namespace />';

		A.byIdNS(namespace, 'rootFolderId').val(rootFolderId);
		A.byIdNS(namespace, 'rootFolderName').setContent(rootFolderName);

		var button = A.byIdNS(namespace, 'removeFolderButton');

		if (button) {
			button.set('disabled', false);

			button.ancestor('.aui-button').removeClass('aui-button-disabled');
		}
	}
</aui:script>