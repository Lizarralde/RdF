<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
	<xsl:param name="container"/>

	<xsl:param name="checkXPath" />
	<xsl:param name="node" select="."/>
	<xsl:param name="y-axis-name" />
	<xsl:param name="title" />
	<xsl:param name="sub-title" />
	<xsl:param name="sufix" />
	<xsl:param name="total-height"/>
	<xsl:param name="total-width"/>
	<xsl:param name="bands" select="'false'"/>
	<xsl:param name="background"/>
	<xsl:param name="border-color"/>
	<xsl:param name="border-radius"/>
	<xsl:param name="class-name"/>
	<xsl:param name="margin-left"/>
	<xsl:param name="margin-top"/>
	<xsl:param name="margin-right"/>
	<xsl:param name="margin-bottom"/>
	<xsl:param name="style"/>
	<xsl:param name="min-value"/>
	<xsl:param name="max-value"/>
	<xsl:param name="start-angle"/>
	<xsl:param name="end-angle"/>
	<xsl:param name="serie-name"/>

	<xsl:output indent="no" method="html"/>

	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/Includes/global.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/Includes/small-templates.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/Includes/chart.xslt" />

	<xsl:template match="/">

		<xsl:if test="$isCallBack = 'False'">
			<script type="text/javascript">

        $(function () {

        <!--hoozin.Interface.activeSubMenu('dashboardLink');-->

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

		<xsl:choose>
			<xsl:when test="not(./NewDataSet) = false()">
				<div>
					<xsl:attribute name="id">
						<xsl:value-of select="$container"/>
					</xsl:attribute>
				</div>
				<xsl:call-template name="hoozin-chart-gauge">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="y-axis-name" select="$y-axis-name" />
					<xsl:with-param name="title" select="$title"/>
					<xsl:with-param name="sub-title" select="$sub-title"/>
					<xsl:with-param name="container" select="$container"/>
					<xsl:with-param name="sufix" select="$sufix"/>
					<xsl:with-param name="total-height" select="$total-height"/>
					<xsl:with-param name="total-width" select="$total-width"/>
					<xsl:with-param name="bands" select="$bands"/>
					<xsl:with-param name="background" select="$background"/>
					<xsl:with-param name="border-color" select="$border-color"/>
					<xsl:with-param name="border-radius" select="$border-radius"/>
					<xsl:with-param name="class-name" select="$class-name"/>
					<xsl:with-param name="margin-left" select="$margin-left"/>
					<xsl:with-param name="margin-top" select="$margin-top"/>
					<xsl:with-param name="margin-right"  select="$margin-right"/>
					<xsl:with-param name="margin-bottom" select="$margin-bottom"/>
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="serie-name" select="$serie-name"/>
					<xsl:with-param name="min-value" select="$min-value"/>
					<xsl:with-param name="max-value" select="$max-value"/>
					<xsl:with-param name="start-angle" select="$start-angle"/>
					<xsl:with-param name="end-angle" select="$end-angle"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<div class="alert alert-info">
					<h5 >
						<xsl:value-of select="$title" />
					</h5>
					<p>Not enough datas for display this chart.</p>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
