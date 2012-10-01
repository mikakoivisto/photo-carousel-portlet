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

<%@ include file="/init.jsp" %>

<%
List<FileEntry> fileEntries = new ArrayList<FileEntry>();

long repositoryId = scopeGroupId;
long parentFolderId = DLFolderConstants.DEFAULT_PARENT_FOLDER_ID;

if (rootFolderId != DLFolderConstants.DEFAULT_PARENT_FOLDER_ID) {
	Folder rootFolder = DLAppServiceUtil.getFolder(rootFolderId);

	repositoryId = rootFolder.getRepositoryId();
	parentFolderId = rootFolderId;
}

try {
	if (includeSubfolders) {
		fileEntries.addAll(DLAppServiceUtil.getFileEntries(repositoryId, parentFolderId));

		List<Long> subfolderIds = DLAppServiceUtil.getSubfolderIds(repositoryId, parentFolderId, true);

		for (long folderId : subfolderIds) {
			try {
				Folder folder = DLAppServiceUtil.getFolder(folderId);

				fileEntries.addAll(DLAppServiceUtil.getFileEntries(folder.getRepositoryId(), folderId));
			}
			catch (RepositoryException re) {
			}
		}
	}
	else {
		fileEntries = DLAppServiceUtil.getFileEntries(repositoryId, parentFolderId);
	}
}
catch (NoSuchFolderException nsfe) {
}
catch (RepositoryException re) {
}

if (shuffleImages) {
	java.util.Collections.shuffle(fileEntries);
}

if (maxImages > 0 && fileEntries.size() > maxImages) {
	fileEntries = fileEntries.subList(0, maxImages);
}

Format dateFormatDateTime = FastDateFormatFactoryUtil.getDateTime(locale, timeZone);
%>
<style type="text/css">
	#<portlet:namespace />photoCarousel {
		height: <%= carouselHeight %>px;
		position: relative;
		width: <%= carouselWidth %>px;
		clear: both;
	}

	#<portlet:namespace />photoCarousel .photo-carousel-item {
		max-height: <%= carouselHeight %>px;
		width: <%= carouselWidth %>px;
	}

	<c:if test="<%= !showControls %>">
		#<portlet:namespace />photoCarousel menu {
			display: none;
		}
	</c:if>

	<c:if test="<%= !showMenuIndex %>">
		#<portlet:namespace />photoCarousel menu .aui-carousel-menu-index {
			display: none;
		}
	</c:if>

	<c:if test="<%= !showCount %>">
		#<portlet:namespace />photoCarouselCount {
			display: none;
		}
	</c:if>

	#<portlet:namespace />photoCarousel img {
		max-width: <%= imgWidth %>px;
		max-height: <%= imgHeight %>px;
	}
</style>

<div id="<portlet:namespace />photoCarousel" class="photo-carousel">
	<% for (FileEntry fileEntry : fileEntries) { %>
	<div class="photo-carousel-item">
		<img src="<%= DLUtil.getPreviewURL(fileEntry, fileEntry.getFileVersion(), themeDisplay, "") %>" />

		<c:if test="<%= showTitle %>">
			<div class="lfr-asset-title">
				<%= HtmlUtil.escape(fileEntry.getTitle()) %>
			</div>
		</c:if>

		<c:if test="<%= showDescription && Validator.isNotNull(fileEntry.getDescription()) %>">
			<div class="lfr-asset-description">
				<%= HtmlUtil.escape(fileEntry.getDescription()) %>
			</div>
		</c:if>

		<div class="lfr-asset-metadata">
			<c:if test="<%= showModifiedDate %>">
				<div class="lfr-asset-icon lfr-asset-date">
					<%= dateFormatDateTime.format(fileEntry.getModifiedDate()) %>
				</div>
			</c:if>

			<c:if test="<%= showCategorization && fileEntry.isSupportsSocial() %>">
				<div class="lfr-asset-categories">
					<liferay-ui:asset-categories-summary
						className="<%= DLFileEntryConstants.getClassName() %>"
						classPK="<%= fileEntry.getFileEntryId() %>"
					/>
				</div>

				<div class="lfr-asset-tags">
					<liferay-ui:asset-tags-summary
						className="<%= DLFileEntryConstants.getClassName() %>"
						classPK="<%= fileEntry.getFileEntryId() %>"
						message="tags"
					/>
				</div>
			</c:if>
		</div>
	</div>
	<% } %>
	<div id="<portlet:namespace />photoCarouselCount" class="photo-carousel-count"><span class="photo-carousel-index-current"></span> / <span class="photo-carousel-count-total"><%= fileEntries.size() %></span></div>
</div>
<br />

<aui:script use="aui-carousel">
	<% if (fileEntries.size() > 0) { %>
	var indexCurrent = A.one("#<portlet:namespace />photoCarouselCount .photo-carousel-index-current");

	var carousel = new A.Carousel(
		{
			activeIndex: '0',
			contentBox: '#<portlet:namespace />photoCarousel',
			height: <%= carouselHeight %>,
			intervalTime: <%= transitionDelay %>,
			width: <%= carouselWidth %>,
			playing: <%= autoTransition %>,
			itemSelector: '.photo-carousel-item'
		}
	);

	carousel.on(
		'activeIndexChange',
		function(event) {
			indexCurrent.setContent(event.newVal + 1);
		});

	carousel.render();

	indexCurrent.setContent(carousel.get('activeIndex') + 1);
	<% } %>
</aui:script>