<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
<xsl:param name="selected"/>
	<xsl:output indent="no" method="html"/>

	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/global.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/small-templates.xslt" />

	<xsl:template match="/Hoozin">
		<xsl:variable name="days" select="pxs:GetDaysFromDuration(./Dates/InstallationDate, ./Dates/ActualDate)"/>
		<xsl:variable name="actives-communities-count" >
			<xsl:choose>
				<xsl:when test="sum(/Hoozin/NewDataSet/*/Count) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/*/Count)"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$isCallBack = 'False'">

			<script type="text/javascript">

				$(function () {
					
					hoozin.UI.register(
						"activeCommunitiesLiveTop", 
						"activeCommunitiesLiveTop", 
						"<xsl:value-of select="$webpart_storagekey" />", 
						{}, 
						"<xsl:value-of select="$current_page_serverrelativeurl" />"
					);
          
				});
				
			</script>

		</xsl:if>

		<div id="{$webpart_id}_content">

			<div class="kpiWrapper" id="activeCommunitiesLiveTop">

				<div class="kpiHeader">
					<div class="dateSelector btn-group">
						<a class="dateSelectorBt dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"></a>
						<ul class="dropdown-menu pull-right" >
							<li>
								<a
									href="javascript:void(0);"
									data-interval-key="Today"
									data-request="ActivesCommunities"
									data-days="">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_Today')"/>
								</a>
							</li>
							<li>
								<a
									href="javascript:void(0);"
									data-interval-key="Yesterday"
									data-request="ActivesCommunities"
									data-days="">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_Yesterday')"/></a>
							</li>
							<li>
								<a
									href="javascript:void(0);"
									data-interval-key="LastWeek"
									data-request="ActivesCommunities"
									data-days="">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_LastWeek')"/></a>
							</li>
							<li class="divider"></li>
							<li>
								<a
									href="javascript:void(0);"
									data-interval-key="AllTime"
									data-request="ActivesCommunities"
									data-days="{$days}">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_AllTime')"/></a>
							</li>
						</ul>
					</div>
					<div class="dateSelected"><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $selected)"/></div>
				</div>

				<div class="kpiContent">
					<div class="theNumberWrapper">
						<div class="theNumber"><xsl:value-of select="$actives-communities-count"/></div>
						<div class="theChapo"><span class="greenSquare"></span> 
							<xsl:choose>
								<xsl:when test="$actives-communities-count > 1"><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_ActivesCommunities')"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_ActiveCommunity')"/></xsl:otherwise>
							</xsl:choose>
						</div>
					</div>
				</div>

			</div>


		</div>

	</xsl:template>

</xsl:stylesheet>
