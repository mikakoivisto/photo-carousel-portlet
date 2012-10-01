<%--
/**
 * Copyright (c) 2012 Mika Koivisto <mika@javaguru.fi>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>

<%@page import="com.liferay.portlet.documentlibrary.model.DLFileEntryConstants" %><%@
page import="com.liferay.portlet.documentlibrary.model.DLFolderConstants" %><%@
page import="com.liferay.portlet.documentlibrary.service.DLAppLocalServiceUtil" %><%@
page import="com.liferay.portlet.documentlibrary.service.DLAppServiceUtil" %><%@
page import="com.liferay.portlet.documentlibrary.NoSuchFolderException" %><%@
page import="com.liferay.portlet.documentlibrary.util.DLUtil" %><%@
page import="com.liferay.portal.kernel.repository.RepositoryException" %><%@
page import="com.liferay.portal.kernel.repository.model.FileEntry" %><%@
page import="com.liferay.portal.kernel.repository.model.FileVersion" %><%@
page import="com.liferay.portal.kernel.repository.model.Folder" %><%@
page import="com.liferay.portal.kernel.util.FastDateFormatFactoryUtil" %><%@
page import="com.liferay.portal.kernel.util.HtmlUtil" %><%@
page import="com.liferay.portal.kernel.util.ParamUtil" %><%@
page import="com.liferay.portal.kernel.util.PrefsParamUtil" %>

<%@ page import="java.util.List" %><%@
page import="java.util.ArrayList" %><%@
page import="java.text.Format" %>

<%@ page import="javax.portlet.MimeResponse" %><%@
page import="javax.portlet.PortletConfig" %><%@
page import="javax.portlet.PortletContext" %><%@
page import="javax.portlet.PortletException" %><%@
page import="javax.portlet.PortletMode" %><%@
page import="javax.portlet.PortletPreferences" %><%@
page import="javax.portlet.PortletRequest" %><%@
page import="javax.portlet.PortletResponse" %><%@
page import="javax.portlet.PortletURL" %><%@
page import="javax.portlet.ResourceURL" %><%@
page import="javax.portlet.UnavailableException" %><%@
page import="javax.portlet.ValidatorException" %><%@
page import="javax.portlet.WindowState" %>

<%@ page import="com.liferay.portal.kernel.language.LanguageUtil" %><%@
page import="com.liferay.portal.kernel.util.Constants" %><%@
page import="com.liferay.portal.kernel.util.GetterUtil" %><%@
page import="com.liferay.portal.kernel.util.ParamUtil" %><%@
page import="com.liferay.portal.kernel.util.StringBundler" %><%@
page import="com.liferay.portal.kernel.util.StringPool" %><%@
page import="com.liferay.portal.kernel.util.Validator" %><%@
page import="com.liferay.portlet.PortletPreferencesFactoryUtil" %>

<liferay-theme:defineObjects />

<portlet:defineObjects />

<%
PortletPreferences preferences = renderRequest.getPreferences();

String portletResource = ParamUtil.getString(request, "portletResource");

if (Validator.isNotNull(portletResource)) {
	preferences = PortletPreferencesFactoryUtil.getPortletSetup(request, portletResource);
}

long rootFolderId = PrefsParamUtil.getLong(preferences, request, "rootFolderId", DLFolderConstants.DEFAULT_PARENT_FOLDER_ID);
boolean includeSubfolders = PrefsParamUtil.getBoolean(preferences, request, "includeSubfolders");

boolean shuffleImages = PrefsParamUtil.getBoolean(preferences, request, "shuffleImages", false);
int maxImages = PrefsParamUtil.getInteger(preferences, request, "maxImages", 0);

boolean showTitle = PrefsParamUtil.getBoolean(preferences, request, "showTitle", false);
boolean showDescription = PrefsParamUtil.getBoolean(preferences, request, "showDescription", false);
boolean showModifiedDate = PrefsParamUtil.getBoolean(preferences, request, "showModifiedDate", false);
boolean showCategorization = PrefsParamUtil.getBoolean(preferences, request, "showCategorization", false);

int carouselWidth = PrefsParamUtil.getInteger(preferences, request, "carouselWidth", 300);
int carouselHeight = PrefsParamUtil.getInteger(preferences, request, "carouselHeight", 300);
int imgWidth = PrefsParamUtil.getInteger(preferences, request, "imgWidth", 300);
int imgHeight = PrefsParamUtil.getInteger(preferences, request, "imgHeight", 300);

boolean showControls = PrefsParamUtil.getBoolean(preferences, request, "showControls", true);
boolean showMenuIndex = PrefsParamUtil.getBoolean(preferences, request, "showMenuIndex", true);
boolean showCount = PrefsParamUtil.getBoolean(preferences, request, "showCount", false);
boolean autoTransition = PrefsParamUtil.getBoolean(preferences, request, "autoTransition", true);
int transitionDelay = PrefsParamUtil.getInteger(preferences, request, "transitionDelay", 5);
%>