<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
	<xsl:param name="selected"/>
	<xsl:output indent="no" method="html"/>

	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/global.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/small-templates.xslt" />

	<xsl:template match="/Hoozin">


		<!--variable declaration-->
		<xsl:variable name="actual-internal-users-count">
			<xsl:choose>
				<xsl:when test="/Hoozin/NewDataSet/LOG_USERS[serieUniqueIdentifier = 'false']/value != ''">
					<xsl:value-of select="/Hoozin/NewDataSet/LOG_USERS[serieUniqueIdentifier = 'false']/value"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="actual-external-users-count">
			<xsl:choose>
				<xsl:when test="/Hoozin/NewDataSet/LOG_USERS[serieUniqueIdentifier = 'true']/value != ''">
					<xsl:value-of select="/Hoozin/NewDataSet/LOG_USERS[serieUniqueIdentifier = 'true']/value"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="old-internal-users-count">
			<xsl:choose>
				<xsl:when test="/Hoozin/NewDataSet/LOG_USERS[serieUniqueIdentifier = 'false']/Change != ''">
					<xsl:value-of select="/Hoozin/NewDataSet/LOG_USERS[serieUniqueIdentifier = 'false']/Change"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="old-external-users-count">
			<xsl:choose>
				<xsl:when test="/Hoozin/NewDataSet/LOG_USERS[serieUniqueIdentifier = 'true']/Change != ''">
					<xsl:value-of select="/Hoozin/NewDataSet/LOG_USERS[serieUniqueIdentifier = 'true']/Change"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!--variable declaration-->
		<xsl:variable name="internal-users-count-tendance" select="round((($actual-internal-users-count - $old-internal-users-count)*100 div $old-internal-users-count)*100) div 100"/>
		<xsl:variable name="external-users-count-tendance" select="round((($actual-external-users-count - $old-external-users-count)*100 div $old-external-users-count)*100) div 100"/>

		<xsl:variable name="external-users-count-tendance-sign">
			<xsl:choose>
				<xsl:when test="external-users-count-tendance >= 0">+</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="internal-users-count-tendance-sign">
			<xsl:choose>
				<xsl:when test="internal-users-count-tendance > 0">+</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<xsl:if test="$isCallBack = 'False'">

			<script type="text/javascript">

				$(function () {
					
					hoozin.UI.register(
						"internalExternalUsers", 
						"internalExternalUsers", 
						"<xsl:value-of select="$webpart_storagekey" />", 
						{}, 
						"<xsl:value-of select="$current_page_serverrelativeurl" />"
					);
          
				});

			</script>

		</xsl:if>

		<div id="{$webpart_id}_content">
			<div class="kpiWrapper" id="internalExternalUsers">
				<div class="kpiHeader">
					<h2>
						<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_UsersCount')"/>
					</h2>
					<xsl:if test="$selected != ''">
						<div class="dateSelector btn-group">
							<a class="dateSelectorBt dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"></a>
							<ul class="dropdown-menu pull-right" >
								<li>
									<a
										href="javascript:void(0);"
										data-interval-key="DAY"
										data-resource-key="Yesterday"
										data-request="UsersCountByExternalStatut"
										data-days="">
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_Yesterday')"/>
									</a>
								</li>
								<li>
									<a
										href="javascript:void(0);"
										data-interval-key="WEEK"
										data-resource-key="LastWeek"
										data-request="UsersCountByExternalStatut"
										data-days="">
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_LastWeek')"/>
									</a>
								</li>
								<li>
									<a
										href="javascript:void(0);"
										data-interval-key="MONTH"
										data-resource-key="LastMonth"
										data-request="UsersCountByExternalStatut"
										data-days="">
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_LastMonth')"/>
									</a>
								</li>
							</ul>
						</div>
						<div class="dateSelected">
							<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $selected)"/>
						</div>
					</xsl:if>
				</div>
				<div class="kpiContent">
					<div class="theNumberWrapper" style="float: left; width: 50%">
						<div class="theNumber">
							<xsl:value-of select="$actual-internal-users-count"/>
						</div>
						<div class="theChapo">
							<xsl:choose>
								<xsl:when test="$actual-internal-users-count > 1">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_InternalUsers')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_InternalUser')"/>
								</xsl:otherwise>
							</xsl:choose>
						</div>
						<div class="trendWrapper">
							<xsl:if test="string(number($internal-users-count-tendance)) != 'NaN' and string(number($internal-users-count-tendance)) != 'Infinity' and string(number($internal-users-count-tendance)) != '-Infinity'">
								<xsl:if test="$selected != ''">
									<div class="">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$internal-users-count-tendance &gt; 0">trendArrow up</xsl:when>
												<xsl:when test="$internal-users-count-tendance &lt; 0">trendArrow down</xsl:when>
												<xsl:when test="$internal-users-count-tendance = 0">trendArrow equal</xsl:when>
											</xsl:choose>
										</xsl:attribute>
									</div>

								
									<div class="trendTitle"><xsl:value-of select="$internal-users-count-tendance-sign"/><xsl:value-of select="$internal-users-count-tendance"/>%</div>
									<div class="trendDesc">
												// <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $selected)"/>
									</div>
								</xsl:if>
							</xsl:if>
						</div>
					</div>
					<div class="theNumberWrapper" style="float: left; width: 50%">
						<div class="theNumber">
							<xsl:value-of select="$actual-external-users-count"/>
						</div>
						<div class="theChapo">
							<xsl:choose>
								<xsl:when test="$actual-external-users-count > 1">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_ExternalUsers')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_ExternalUser')"/>
								</xsl:otherwise>
							</xsl:choose>
						</div>
						<div class="trendWrapper">
							<xsl:if test="string(number($external-users-count-tendance)) != 'NaN' and string(number($external-users-count-tendance)) != 'Infinity' and string(number($external-users-count-tendance)) != '-Infinity'">
								<xsl:if test="$selected != ''">
									<div class="">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$external-users-count-tendance &gt; 0">trendArrow up</xsl:when>
												<xsl:when test="$external-users-count-tendance &lt; 0">trendArrow down</xsl:when>
												<xsl:when test="$external-users-count-tendance = 0">trendArrow equal</xsl:when>
											</xsl:choose>
										</xsl:attribute>
									</div>

								
									<div class="trendTitle"><xsl:value-of select="$external-users-count-tendance-sign"/><xsl:value-of select="$external-users-count-tendance"/>%</div>
								
									<div class="trendDesc">
											// <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $selected)"/>
									</div>
								</xsl:if>
							</xsl:if>
						</div>
					</div>
				</div>
			</div>


		</div>

	</xsl:template>

</xsl:stylesheet>
