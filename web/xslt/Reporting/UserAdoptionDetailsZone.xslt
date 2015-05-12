<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
	<xsl:param name="selected"/>
	<xsl:param name="register"/>
	<xsl:param name="title"/>
	<xsl:param name="requestedData"/>

	<xsl:output indent="no" method="html"/>

	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/small-templates.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/formatterChartXml.xslt"/>

	<xsl:template match="/Hoozin">

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
					<h2><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $title)"/></h2>
				</div>

				<div class="kpiContent" style="height: 290px;">
					<xsl:variable name="total" select="/Hoozin/NewDataSet/*[1]/Total"/>
					<xsl:variable name="contributer" select="/Hoozin/NewDataSet/*[1]/Contributer"/>
					<xsl:variable name="participater" select="/Hoozin/NewDataSet/*[1]/Participater"/>
					<xsl:variable name="register" select="/Hoozin/NewDataSet/*[1]/Register"/>
					

					<xsl:variable name="total-label" >
						<xsl:choose>
							<xsl:when test="$total > 1">UserAdoption_TotalUsers</xsl:when>
							<xsl:otherwise>UserAdoption_TotalUser</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="contributer-label" >
						<xsl:choose>
							<xsl:when test="$contributer > 1">UserAdoption_Contributers</xsl:when>
							<xsl:otherwise>UserAdoption_Contributer</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="participater-label" >
						<xsl:choose>
							<xsl:when test="$participater > 1">UserAdoption_Participaters</xsl:when>
							<xsl:otherwise>UserAdoption_Participater</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="register-label" >
						<xsl:choose>
							<xsl:when test="$register > 1">UserAdoption_Registers</xsl:when>
							<xsl:otherwise>UserAdoption_Register</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<div class="theNumberWrapper col" style="width:100%">
							<div class="theNumber" style="text-align:left;font-size:54px">
								
							</div>
							<div class="theChapo" style="text-align:left">
								<b>
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'UserAdoptionDetailsZone_ActualState')"/>
								</b>
							</div>


							<table class="lineWrapper" valign="top">
								<tr class="line">
									<td ><span class="icon peoples"/></td>
									<td class="value" style="float:none;">
										<xsl:value-of select="$total"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $total-label)"/>
									</td>
								</tr>
								<tr class="line">
									<td ><span class="icon registers"/></td>
									<td class="value" style="float:none;">
										<xsl:value-of select="$register"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $register-label)"/>
									</td>
								</tr>
								<tr class="line">
									<td ><span class="icon posts"/></td>
									<td class="value" style="float:none;">
										<xsl:value-of select="$contributer"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $contributer-label)"/>
									</td>
								</tr>
								<tr class="line">
									<td ><span class="icon comments"/></td>
									<td class="value" style="float:none;">
										<xsl:value-of select="$participater"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $participater-label)"/>
									</td>
								</tr>
							</table>

						</div>
					
					<div class="clear">
					</div>
				</div>
			</div>


		</div>

	</xsl:template>

</xsl:stylesheet>
