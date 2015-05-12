<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
<xsl:param name="selected"/>
<xsl:param name="register"/>
<xsl:param name="title"/>
	<xsl:output indent="no" method="html"/>

	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/global.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/small-templates.xslt" />

	<xsl:template match="/Hoozin">
		
		<xsl:variable name="days" select="pxs:GetDaysFromDuration(./Dates/InstallationDate, ./Dates/ActualDate)"/>
		<xsl:if test="$isCallBack = 'False'">

			<script type="text/javascript">

				$(function () {
					
					hoozin.UI.register(
						"<xsl:value-of select="$register"/>", 
						"<xsl:value-of select="$register"/>", 
						"<xsl:value-of select="$webpart_storagekey" />", 
						{}, 
						"<xsl:value-of select="$current_page_serverrelativeurl" />"
					);
          
				});
				
			</script>

		</xsl:if>

		<div id="{$webpart_id}_content">

			<div class="kpiWrapper topper" id="{$register}">

				<div class="kpiHeader">
					<span class="kpiIcon"></span>
					<h2>
						<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $title)"/>
					</h2>
				</div>

				<div class="kpiContent">

					<div class="theNumberWrapper">
						<xsl:for-each select="/Hoozin/NewDataSet/*">
							<xsl:variable name="tag-text" select="./Text"/>
							<xsl:variable name="tag-id" select="./ID"/>
							<xsl:variable name="tag-count" select="./Count"/>
							
							<span
								data-selected="off" class="aTag notclickable">
								<a title="{$tag-text}" href="javascript:void(0);">
									<span class="tagText">
										<xsl:value-of select="$tag-text" disable-output-escaping="yes"/>
									</span>
									<b>
										<xsl:value-of select="$tag-count"/>
									</b>
								</a>
							 </span>
						</xsl:for-each>
						
					</div>
					<div class="clear">
					</div>
				</div>
			</div>


		</div>

	</xsl:template>

</xsl:stylesheet>
