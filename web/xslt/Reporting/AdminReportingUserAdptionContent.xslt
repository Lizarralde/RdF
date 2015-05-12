<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
	<xsl:param name="container"/>

	<xsl:param name="checkXPath" />
	<xsl:param name="node" select="."/>
	<xsl:param name="page" select="0"/>
	<xsl:param name="limit" select="0"/>
	<xsl:param name="y-axis-name" />
	<xsl:param name="title" />
	<xsl:param name="sub-title" />
	<xsl:param name="type" select="'line'"/>
	<xsl:param name="column-stacked"/>
	<xsl:param name="sufix" />
	<xsl:param name="vertical-label-x-axis" select="'true'"/>
	<xsl:param name="show-in-legend" select="'false'"/>
	<xsl:param name="show-tooltip" select="'true'"/>
	<xsl:param name="total-height" select="300"/>
	<xsl:param name="total-width"/>
	<xsl:param name="datetime-zoomable" select="'false'"/>
	<xsl:param name="datetime-zoomable-axis" select="'x'"/>
	<xsl:param name="datetime-zoomable-max-zoom" select="14"/>
	<xsl:param name="bands" select="'false'"/>
	<xsl:param name="grouped-column-or-bar"/>
	<xsl:param name="average" select="'false'"/>
	<xsl:param name="background" select="'transparent'"/>
	<xsl:param name="border-color"/>
	<xsl:param name="border-radius"/>
	<xsl:param name="class-name"/>
	<xsl:param name="margin-left"/>
	<xsl:param name="margin-top"/>
	<xsl:param name="margin-right"/>
	<xsl:param name="margin-bottom"/>
	<xsl:param name="style"/>
	<xsl:param name="legend-style"/>
	<xsl:param name="colors"/>
	<xsl:param name="serie-name"/>
	<xsl:param name="data-labels" select="'false'"/>
	<xsl:param name="legend-layout"/>
	<xsl:param name="legend-align"/>
	<xsl:param name="legend-vertical-align"/>
	<xsl:param name="navigation" select="'false'"/>
	<xsl:param name="active-color"/>
	<xsl:param name="inactive-color"/>
	<xsl:param name="arrow-size"/>
	<xsl:param name="maxHeightLegend"/>
	<xsl:param name="max-char-in-legend"/>
	<xsl:param name="mini-profile-type"/>
	<xsl:param name="data-labels-distance"/>
	<xsl:param name="data-labels-inside"/>
	<xsl:param name="data-labels-color"/>
	<xsl:param name="total-in-legend"/>
	<xsl:param name="value-in-tooltip" select="'true'"/>
	<xsl:param name="percent-in-tooltip" select="'false'"/>
	<xsl:param name="interval" select="1"/>
	<xsl:param name="mini-profile-in-x-axis"/>

	<xsl:output indent="no" method="html"/>

	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/Includes/small-templates.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/Includes/chart.xslt" />

	<xsl:template match="/">

		<xsl:if test="$isCallBack = 'False'">
			<script type="text/javascript">

        $(function () {

        hoozin.Interface.activeSubMenu('dashboardLink');

        hoozin.UI.register(
        "contentZone",
        "adminStatistics",
        "<xsl:value-of select="$webpart_storagekey" />",
        null,
        "<xsl:value-of select="$current_page_serverrelativeurl" />"
        );
        });
      </script>
		</xsl:if>
		


		<fieldset class="hoozinFielset noLine noPadding" style="margin-top:0px;">

			<table class="legendDiv" style="margin-bottom: 10px;">
				<tr>
					<td class="roundNumber empty">
					</td>
					<td class="title">
						<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.SharePoint',$title)"/>
						<span class="titleDesc">
						</span>
					</td>
				</tr>
			</table>
		</fieldset>

		<xsl:choose>
			<xsl:when test="not(./hoozin/NewDataSet//name) = false()">
				<div>
					<xsl:attribute name="id">
						<xsl:value-of select="$container"/>
					</xsl:attribute>
					<xsl:attribute name="class">hightchartsWrapper</xsl:attribute>
				</div>

				<xsl:variable name="var-serie-name">
					<xsl:choose>
						<xsl:when test="not($serie-name = '')"><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $serie-name)"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$serie-name"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:call-template name="hoozin-chart">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="page" select="$page"/>
					<xsl:with-param name="limit" select="$limit"/>
					<xsl:with-param name="y-axis-name" select="$y-axis-name" />
					<!--<xsl:with-param name="title" select="$title"/>
					<xsl:with-param name="sub-title" select="$sub-title"/>-->
					<xsl:with-param name="container" select="$container"/>
					<xsl:with-param name="type" select="$type"/>
					<xsl:with-param name="column-stacked" select="$column-stacked"/>
					<xsl:with-param name="sufix" select="$sufix"/>
					<xsl:with-param name="vertical-label-x-axis" select="$vertical-label-x-axis = 'true'"/>
					<xsl:with-param name="show-in-legend" select="$show-in-legend = 'true'"/>
					<xsl:with-param name="show-tooltip" select="$show-tooltip = 'true'"/>
					<xsl:with-param name="total-height" select="$total-height"/>
					<xsl:with-param name="total-width" select="$total-width"/>
					<xsl:with-param name="datetime-zoomable" select="$datetime-zoomable = 'true'"/>
					<xsl:with-param name="datetime-zoomable-axis" select="$datetime-zoomable-axis"/>
					<xsl:with-param name="datetime-zoomable-max-zoom" select="$datetime-zoomable-max-zoom"/>
					<xsl:with-param name="bands" select="$bands = 'true'"/>
					<xsl:with-param name="grouped-column-or-bar" select="$grouped-column-or-bar"/>
					<xsl:with-param name="average" select="$average = 'true'"/>
					<xsl:with-param name="background" select="$background"/>
					<xsl:with-param name="border-color" select="$border-color"/>
					<xsl:with-param name="border-radius" select="$border-radius"/>
					<xsl:with-param name="class-name" select="$class-name"/>
					<xsl:with-param name="margin-left" select="$margin-left"/>
					<xsl:with-param name="margin-top" select="$margin-top"/>
					<xsl:with-param name="margin-right"  select="$margin-right"/>
					<xsl:with-param name="margin-bottom" select="$margin-bottom"/>
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="legend-style" select="$legend-style"/>
					<xsl:with-param name="colors" select="$colors"/>
					<xsl:with-param name="serie-name" select="$var-serie-name"/>
					<xsl:with-param name="data-labels" select="$data-labels = 'true'"/>
					<xsl:with-param name="legend-layout" select="$legend-layout"/>
					<xsl:with-param name="legend-align" select="$legend-align"/>
					<xsl:with-param name="legend-vertical-align" select="$legend-vertical-align"/>
					<xsl:with-param name="navigation" select="$navigation = 'true'"/>
					<xsl:with-param name="active-color" select="$active-color"/>
					<xsl:with-param name="inactive-color" select="$inactive-color"/>
					<xsl:with-param name="arrow-size" select="$arrow-size"/>
					<xsl:with-param name="maxHeightLegend" select="$maxHeightLegend"/>
					<xsl:with-param name="max-char-in-legend" select="$max-char-in-legend"/>
					<xsl:with-param name="mini-profile-type" select="$mini-profile-type"/>
					<xsl:with-param name="data-labels-distance" select="$data-labels-distance"/>
					<xsl:with-param name="data-labels-inside" select="$data-labels-inside"/>
					<xsl:with-param name="data-labels-color" select="$data-labels-color"/>
					<xsl:with-param name="total-in-legend" select="$total-in-legend"/>
					<xsl:with-param name="mini-profile-in-x-axis" select="$mini-profile-in-x-axis = 'true'"/>
					<xsl:with-param name="value-in-tooltip" select="$value-in-tooltip = 'true'"/>
					<xsl:with-param name="percent-in-tooltip" select="$percent-in-tooltip = 'true'"/>
					<xsl:with-param name="interval" select="$interval"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<div class="alert alert-info">

					<p><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminReportingContent_ErrorMessage')"/></p>
				</div>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

</xsl:stylesheet>
