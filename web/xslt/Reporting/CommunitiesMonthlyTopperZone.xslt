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

		<!--<xsl:variable name="days" select="pxs:GetDaysFromDuration(./Dates/InstallationDate, ./Dates/ActualDate)"/>-->
		
		<xsl:variable name="topper-month" select="/Hoozin/NewDataSet/*[last()]/Month"/>
		<xsl:variable name="topper-year" select="/Hoozin/NewDataSet/*[last()]/Year"/>
		<xsl:variable name="topper-count" >
			<xsl:choose>
				<xsl:when test="sum(/Hoozin/NewDataSet/*[Month = $topper-month and Year = $topper-year]/value) != ''">
					<xsl:value-of select="sum(/Hoozin/NewDataSet/*[Month = $topper-month and Year = $topper-year]/value)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="month-resource-name">CommunitiesMonthlyTopper_Month<xsl:value-of select="$topper-month"/></xsl:variable>
		
		<xsl:variable name="communities-public-count" >
			<xsl:choose>
				<xsl:when test="/Hoozin/NewDataSet/LOG_COMMUNITIES[ Month = $topper-month and Year = $topper-year and serieUniqueIdentifier = 'Public']/value != ''"><xsl:value-of select="/Hoozin/NewDataSet/LOG_COMMUNITIES[serieUniqueIdentifier = 'Public' and  Month = $topper-month and Year = $topper-year]/value"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="communities-private-count"  >
			<xsl:choose>
				<xsl:when test="/Hoozin/NewDataSet/LOG_COMMUNITIES[serieUniqueIdentifier = 'Private'and  Month = $topper-month and Year = $topper-year]/value != ''"><xsl:value-of select="/Hoozin/NewDataSet/LOG_COMMUNITIES[serieUniqueIdentifier = 'Private' and  Month = $topper-month and Year = $topper-year]/value"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="communities-hidden-count"  >
			<xsl:choose>
				<xsl:when test="/Hoozin/NewDataSet/LOG_COMMUNITIES[serieUniqueIdentifier = 'Hidden'and  Month = $topper-month and Year = $topper-year]/value != ''"><xsl:value-of select="/Hoozin/NewDataSet/LOG_COMMUNITIES[serieUniqueIdentifier = 'Hidden' and  Month = $topper-month and Year = $topper-year]/value"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="communities-public-count-resource">
			<xsl:choose>
				<xsl:when test="$communities-public-count &lt;= 1">AdminHome_Public</xsl:when>
				<xsl:otherwise>AdminHome_Publics</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="communities-private-count-resource">
			<xsl:choose>
				<xsl:when test="$communities-private-count &lt;= 1">AdminHome_Private</xsl:when>
				<xsl:otherwise>AdminHome_Privates</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="communities-hidden-count-resource">
			<xsl:choose>
				<xsl:when test="$communities-hidden-count &lt;= 1">AdminHome_Hidden</xsl:when>
				<xsl:otherwise>AdminHome_Hiddens</xsl:otherwise>
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
					<script type="text/javascript">
						$(function () {
							hoozin.KPI.TopperZone.clearEntities("<xsl:value-of select="$register"/>");
					
							<xsl:for-each select="/Hoozin/NewDataSet/*">
								<xsl:variable name="for-topper-month" select="./Month"/>
								<xsl:variable name="for-topper-year" select="./Year"/>
								<xsl:variable name="for-topper-count" >
									<xsl:choose>
										<xsl:when test="sum(/Hoozin/NewDataSet/*[Month = $for-topper-month and Year = $for-topper-year]/value) != ''">
											<xsl:value-of select="sum(/Hoozin/NewDataSet/*[Month = $for-topper-month and Year = $for-topper-year]/value)"/>
										</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="for-month-resource-name">CommunitiesMonthlyTopper_Month<xsl:value-of select="$for-topper-month"/></xsl:variable>
								hoozin.KPI.TopperZone.addEntity("<xsl:value-of select="$register"/>", {
																							id:"<xsl:value-of select="$for-topper-month"/>-<xsl:value-of select="$for-topper-year"/>",
																							month:"<xsl:value-of select="$for-topper-month"/>",
																							year:"<xsl:value-of select="$for-topper-year"/>",
																							count:<xsl:value-of select="$for-topper-count"/>,
																							monthResource:'<xsl:value-of select="$for-month-resource-name"/>'
																							}, hoozin.KPI.TopperZone.setCommunitiesCreatedInfo );
							</xsl:for-each>
							hoozin.KPI.TopperZone.getEntities("<xsl:value-of select="$register"/>").index = hoozin.KPI.TopperZone.getEntities("<xsl:value-of select="$register"/>").entities.length-1;
						});
					</script>
					<span class="kpiIcon"></span>
					<h2 >
						<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $title)"/>
					</h2>
				</div>

				<div class="kpiContent">

					<div class="theTextWrapper col" > <!--style="line-height:11px;margin-top:0px;"-->

						<div class="theText" style="text-align:left; padding-bottom:10px">	
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $month-resource-name)"/>
									<br/>
									<xsl:value-of select="$topper-year"/>
								</div>
								<div class="theChapo">
									<span class="icon community"></span>
									<span class="text">
										<xsl:value-of select="$topper-count"/>
										<xsl:choose>
											<xsl:when test="$topper-count > 1">
												<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'CommunitiesMonthlyTopperZone_CommunitiesCreated')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'CommunitiesMonthlyTopperZone_CommunityCreated')"/>
											</xsl:otherwise>
										</xsl:choose>
									</span>
								</div>
									
									

						</div>
						<!--<div class="lineWrapper" style="margin-top:0px;">
							<div class="line">
								<span class="icon public"></span>
								<span class="value public"><xsl:value-of select="$communities-public-count"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $communities-public-count-resource)"/></span>
								<span class="inlineClear"></span>
							</div>
							<div class="line">
								<span class="icon private"></span>
								<span class="value private"><xsl:value-of select="$communities-private-count"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $communities-private-count-resource)"/></span>
								<span class="inlineClear">
								</span>
							</div>
							<div class="line">
								<span class="icon hidden"></span>
								<span class="value hidden"><xsl:value-of select="$communities-hidden-count"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $communities-hidden-count-resource)"/></span>
								<span class="inlineClear"></span>
							</div>
						</div>-->
						<div class="clear">
						</div>
				</div>
				<div class="kpiFooter">
					<span class="arrow previous active hoozinTooltip" data-tooltip-delay="0" alt="{pxs:GetResource('Prexens.Hoozin.Sharepoint', 'CommunitiesMonthlyTopperZone_PreviousMonth')}" title="{pxs:GetResource('Prexens.Hoozin.Sharepoint', 'CommunitiesMonthlyTopperZone_PreviousMonth')}"></span>
					<span class="arrow next hoozinTooltip" data-tooltip-delay="0" alt="{pxs:GetResource('Prexens.Hoozin.Sharepoint', 'CommunitiesMonthlyTopperZone_NextMonth')}" title="{pxs:GetResource('Prexens.Hoozin.Sharepoint', 'CommunitiesMonthlyTopperZone_NextMonth')}"></span>
				</div>
			</div>


		</div>

	</xsl:template>

</xsl:stylesheet>
