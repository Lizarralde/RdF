<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
	<xsl:param name="selected"/>
	<xsl:param name="register"/>
	<xsl:param name="requestedData"/>
	<xsl:param name="topper-type"/>
	<xsl:param name="since"/>
	<xsl:param name="value-label"/>
	<xsl:param name="value-label-puriel"/>
	<xsl:param name="topper-explanation"/>
	<xsl:param name="add-to-refresh"/>
	<xsl:param name="sufix"/>
	<xsl:output indent="no" method="html"/>

	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/global.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/small-templates.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/helpers.xslt" />

	<xsl:template match="/Hoozin">

		<xsl:variable name="days" select="pxs:GetDaysFromDuration(./Dates/InstallationDate, ./Dates/ActualDate)"/>
		<xsl:variable name="var-since" >
			<xsl:choose>
				<xsl:when test="$since != ''">
					<xsl:value-of select="$since"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./Dates/InstallationDate"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="actif-users" >
			<xsl:choose>
				<xsl:when test="sum(/Hoozin/NewDataSet/*/value) != ''">
					<xsl:value-of select="sum(/Hoozin/NewDataSet/*/value)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="total-users" >
			<xsl:choose>
				<xsl:when test="sum(/Hoozin/NewDataSet/*/value) + /Hoozin/NewDataSet/*[1]/info != ''">
					<xsl:value-of select="sum(/Hoozin/NewDataSet/*/value) + /Hoozin/NewDataSet/*[1]/info"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="actif-users-percent" >
			<xsl:choose>
				<xsl:when test="($actif-users div $total-users) * 100 != ''">
					<xsl:value-of select="round($actif-users div $total-users*100)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

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

			<div class="kpiWrapper topper" id="{$register}" data-toppers-count="10">

				<div class="kpiHeader">
					<span class="kpiIcon"></span>
					<h2><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminReportingContent_CompletenessAverage')"/></h2>
				</div>

				<div class="kpiContent">
					<xsl:choose>
						<xsl:when test="$actif-users != 0">
							<div class="theNumberWrapper">
								<div class="theNumber" style="text-align:left;">
									<span><xsl:value-of select="$actif-users-percent"/></span><xsl:value-of select="$sufix"/>
								</div>
								<div class="theChapo" style="text-align:left; padding-bottom:10px">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'CompletenessTopperZone_Explanation')"/> <br/><br/>
									<xsl:value-of select="pxs:ReplaceString(pxs:ReplaceString(pxs:GetResource('Prexens.Hoozin.Sharepoint', 'CompletenessTopperZone_ExplanationDetail'), '{0}', $actif-users), '{1}', $total-users)"/>
								</div>
							</div>
							<div class="clear">
							</div>
						</xsl:when>
						<xsl:otherwise>
							<span class="noData">
								<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.SharePoint', 'TopperZone_ErrorMessage')"/>
							</span>
						</xsl:otherwise>
					</xsl:choose>
				</div>
				<div class="kpiFooter">
				</div>
			</div>


		</div>

	</xsl:template>

</xsl:stylesheet>
