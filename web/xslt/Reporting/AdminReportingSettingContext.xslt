<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
	<xsl:output method="html" indent="yes"/>

	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/formatterChartXml.xslt" />

	
	<xsl:template match="/">
		<xsl:variable name="profiles" select="/hoozin/Profiles"/>
		<!-- All JS should be under the $isCallBack = 'False' section now -->
		<xsl:if test="$isCallBack = 'False'">

			<script type="text/javascript">

        $(function () {

          // Register context zone
          hoozin.UI.register(
            'contextZone',
            'AdminDashboardContext',
            '<xsl:value-of select="$webpart_storagekey" />',
            {},
            '<xsl:value-of select="$current_page_serverrelativeurl" />'
          );

        });

      </script>

		</xsl:if>

		<div id="{$webpart_id}_content">
			<div class="infosBloc">
				<h4>
					<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.SharePoint','backoffice-dashboard-communities-content-view-zone_DashboardSettingHeaderTitle')" />
				</h4>
				<div class="infosBlocContent text arrow">
					<p>
						<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.SharePoint','backoffice-dashboard-communities-content-view-zone_StatisticsSettingHeaderMessage')" />
					</p>
				</div>
			</div>
		</div>

		
	</xsl:template>
</xsl:stylesheet>
