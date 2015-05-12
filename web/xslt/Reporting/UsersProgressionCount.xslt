<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">

	<xsl:output indent="no" method="html"/>

	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/admin/Reporting/AdminReportingContent.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/small-templates.xslt" />

	<xsl:template match="/Hoozin">

		<xsl:if test="$isCallBack = 'False'">

			<script type="text/javascript">


			</script>

		</xsl:if>
		<div id="{$webpart_id}_content">
			<div class="kpiWrapper" id="usersProgressionCount">
				<div class="kpiHeader">
					<span class="kpiIcon"></span>
					<h2>
						<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_UsersProgression')"/>
					</h2>
					
				</div>
				<div class="kpiContent highchartsWrapper" id="usersProgression">
					<xsl:if test="count(./NewDataSet//*) != 0">
						<xsl:variable name="var-serie-name">
							<xsl:choose>
								<xsl:when test="not($serie-name = '')">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $serie-name)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$serie-name"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="var-node">
							<xsl:choose>
								<xsl:when test="$template-name = ''">
									<xsl:copy-of select="$node"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="$chart-template[@name=$template-name]">
										<xsl:with-param name ="node" select="."/>
									</xsl:apply-templates>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:call-template name="hoozin-chart">
							<xsl:with-param name="node" select="$var-node"/>
							<xsl:with-param name="page" select="$page"/>
							<xsl:with-param name="limit" select="$limit"/>
							<xsl:with-param name="y-axis-name" select="pxs:GetResource('Prexens.Hoozin.SharePoint',$y-axis-name)" />
							<xsl:with-param name="x-axis-name" select="pxs:GetResource('Prexens.Hoozin.SharePoint',$x-axis-name)"/>
							<!--<xsl:with-param name="title" select="$title"/>
					<xsl:with-param name="sub-title" select="$sub-title"/>-->
							<xsl:with-param name="container" select="'usersProgression'"/>
							<xsl:with-param name="type" select="$type"/>
							<xsl:with-param name="column-stacked" select="$column-stacked"/>
							<xsl:with-param name="sufix" select="$sufix"/>
							<xsl:with-param name="vertical-label-x-axis" select="false()"/>
							<xsl:with-param name="show-in-legend" select="$show-in-legend = 'true'"/>
							<xsl:with-param name="show-tooltip" select="$show-tooltip = 'true'"/>
							<xsl:with-param name="total-height" select="'200'"/>
							<xsl:with-param name="total-width" select="$total-width"/>
							<xsl:with-param name="datetime-zoomable" select="$datetime-zoomable = 'true'"/>
							<xsl:with-param name="datetime-zoomable-axis" select="$datetime-zoomable-axis"/>
							<xsl:with-param name="datetime-zoomable-max-zoom" select="$datetime-zoomable-max-zoom"/>
							<xsl:with-param name="bands" select="$bands = 'true'"/>
							<xsl:with-param name="grouped-column-or-bar" select="$grouped-column-or-bar"/>
							<xsl:with-param name="average" select="$average"/>
							<xsl:with-param name="background" select="$background"/>
							<xsl:with-param name="border-color" select="$border-color"/>
							<xsl:with-param name="border-radius" select="$border-radius"/>
							<xsl:with-param name="class-name" select="$class-name"/>
							<xsl:with-param name="margin-left" select="50"/>
							<xsl:with-param name="margin-top" select="0"/>
							<xsl:with-param name="margin-right"  select="0"/>
							<xsl:with-param name="margin-bottom" select="20"/>
							<xsl:with-param name="style" select="$style"/>
							<xsl:with-param name="legend-style" select="'{font-size:&quot;10px&quot;}'"/>
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
							<xsl:with-param name="interval" select="$interval-days"/>
							<xsl:with-param name="marker" select="$marker = 'true'"/>
							<xsl:with-param name="end-on-tick" select="'false'"/>
							<xsl:with-param name="y-tick-pixel-interval" select="30"/>
						</xsl:call-template>
					</xsl:if>
				</div>
			</div>
		</div>

	</xsl:template>

</xsl:stylesheet>
