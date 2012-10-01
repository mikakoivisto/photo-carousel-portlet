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

package fi.javaguru.photocarousel.hook.events;

import com.liferay.portal.kernel.events.ActionException;
import com.liferay.portal.kernel.events.SimpleAction;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.UnicodeProperties;
import com.liferay.portlet.documentlibrary.model.DLFileEntry;
import com.liferay.portlet.expando.DuplicateColumnNameException;
import com.liferay.portlet.expando.NoSuchColumnException;
import com.liferay.portlet.expando.NoSuchTableException;
import com.liferay.portlet.expando.model.ExpandoColumn;
import com.liferay.portlet.expando.model.ExpandoColumnConstants;
import com.liferay.portlet.expando.model.ExpandoTable;
import com.liferay.portlet.expando.service.ExpandoColumnLocalServiceUtil;
import com.liferay.portlet.expando.service.ExpandoTableLocalServiceUtil;

/**
 * @author Mika Koivisto
 */
public class ExpandoStartupAction extends SimpleAction {

	public void run(String[] ids) throws ActionException {
		for (String id : ids) {
			long companyId = Long.parseLong(id);

			try {
				addExpandoField(companyId);
			}
			catch (Exception e) {
				_log.error(
					"Failed to add url expando field for companyId: " +
						companyId, e);
			}
		}
	}

	protected void addExpandoField(long companyId) throws Exception {
		ExpandoTable table = null;

		try {
			table = ExpandoTableLocalServiceUtil.getDefaultTable(
				companyId, DLFileEntry.class.getName());
		}
		catch(NoSuchTableException nste) {
			table = ExpandoTableLocalServiceUtil.addDefaultTable(
				companyId, DLFileEntry.class.getName());
		}

		ExpandoColumn column = ExpandoColumnLocalServiceUtil.getColumn(
			table.getTableId(), "url");

		if (column == null) {
			column = ExpandoColumnLocalServiceUtil.addColumn(
				table.getTableId(), "url", ExpandoColumnConstants.STRING);

			UnicodeProperties properties = new UnicodeProperties();

			properties.setProperty(
				ExpandoColumnConstants.INDEX_TYPE, Boolean.TRUE.toString());

			column.setTypeSettingsProperties(properties);

			ExpandoColumnLocalServiceUtil.updateExpandoColumn(column);
		}
	}

	private static Log _log = LogFactoryUtil.getLog(ExpandoStartupAction.class);
}
