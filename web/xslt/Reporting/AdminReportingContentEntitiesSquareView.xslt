<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
	<xsl:output method="html" indent="yes"/>
	<xsl:param name="selected"/>
	<xsl:param name="register"/>
	<xsl:param name="requestedData"/>
	<xsl:param name="square-type"/>
	<xsl:param name="title"/>
	<xsl:param name="begin"/>
	<xsl:param name="top"/>

	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/formatterChartXml.xslt" />


	<xsl:template match="/Hoozin">


		<!-- All JS should be under the $isCallBack = 'False' section now -->
		<xsl:if test="$isCallBack = 'False'">

			<script type="text/javascript">

        $(function () {

          // Register context zone
          hoozin.UI.register(
            '<xsl:value-of select="$register"/>',
            '<xsl:value-of select="$register"/>',
            '<xsl:value-of select="$webpart_storagekey" />',
            {},
            '<xsl:value-of select="$current_page_serverrelativeurl" />'
          );

        });

      </script>

		</xsl:if>

		<div id="{$webpart_id}_content">

			<div class="kpiWrapper square" id="{$register}">

				<div class="kpiHeader">
					<script type="text/javascript">
									$(function() {
										hoozin.KPI.SquareZone.setBegin(<xsl:value-of select="$begin"/>);
										hoozin.KPI.SquareZone.setTop(<xsl:value-of select="$top"/>);
										hoozin.KPI.SquareZone.setMax(<xsl:value-of select="/Hoozin/NewDataSet/*[1]/MaxRow"/>);
										hoozin.KPI.SquareZone.initArrow('<xsl:value-of select="$register"/>');
									});
								</script>
					<span class="kpiIcon"></span>
					<h2>
						<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $title)"/>
					</h2>
					<xsl:if test="$selected != ''">
						<xsl:variable name="days" select="pxs:GetDaysFromDuration(./Dates/InstallationDate, ./Dates/ActualDate)"/>
						<div class="dateSelector btn-group">
							<a class="dateSelectorBt dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"></a>
							<ul class="dropdown-menu pull-right" >
								<li>
									<a
										href="javascript:void(0);"
										data-interval-key="Yesterday"
										data-request="{$requestedData}"
										data-days="">
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_Yesterday')"/>
									</a>
								</li>
								<li>
									<a
										href="javascript:void(0);"
										data-interval-key="LastWeek"
										data-request="{$requestedData}"
										data-days="">
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_LastWeek')"/>
									</a>
								</li>
								<li>
									<a
										href="javascript:void(0);"
										data-interval-key="LastMonth"
										data-request="{$requestedData}"
										data-days="">
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_LastMonth')"/>
									</a>
								</li>
								<li class="divider"></li>
								<li>
									<a
										href="javascript:void(0);"
										data-interval-key="AllTime"
										data-request="{$requestedData}"
										data-days="{$days}">
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_AllTime')"/>
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


					<xsl:for-each select="/Hoozin/NewDataSet/*">
						<xsl:sort select="position()" data-type="number" order="descending"/>
						<xsl:variable name="square-id" select="./serieUniqueIdentifier"/>
						<xsl:variable name="square-count" >
							<xsl:choose>
								<xsl:when test="sum(./value) != ''">
									<xsl:value-of select="sum(./value)"/>
								</xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="square-change" select="./Change"/>
						<xsl:variable name="square-name" >
							<xsl:choose>
								<xsl:when test="$square-type = 'user'">
									<xsl:value-of select="/Hoozin/Profiles/Profile[Sid = $square-id]/DisplayName"/>
								</xsl:when>
								<xsl:when test="$square-type = 'community'">
									<xsl:value-of select="/Hoozin/Communities/Community[WebGUID = $square-id]/Name"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="last-modified" >
							<xsl:choose>
								<xsl:when test="$square-type = 'user'">
									<xsl:value-of select="/Hoozin/Profiles/Profile[Sid = $square-id]/LastModifiedShort"/>
								</xsl:when>
								<xsl:when test="$square-type = 'community'">
									<xsl:value-of select="/Hoozin/Communities/Community[WebGUID = $square-id]/LastModifiedShort"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="avatar-url" >
							<xsl:choose>
								<xsl:when test="$square-type = 'user'">/HoozinAvatar.axd?sid=<xsl:value-of select="$square-id"/>&amp;size=218&amp;lastModified=<xsl:value-of select="$last-modified"/>
											</xsl:when>
								<xsl:when test="$square-type = 'community'">/GetHoozinCommunityImage.axd?type=avatar&amp;size=218&amp;guid=<xsl:value-of select="$square-id"/>&amp;lastModified=<xsl:value-of select="$last-modified"/>
											</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="miniprofile-url" >
							<xsl:choose>
								<xsl:when test="$square-type = 'user'">HoozinData.axd?settings=hoozin&amp;name=UserMiniProfile&amp;sid=<xsl:value-of select="$square-id"/>
											</xsl:when>
								<xsl:when test="$square-type = 'community'">HoozinData.axd?settings=hoozin&amp;name=CommunityMiniProfile&amp;communityWebGUID=<xsl:value-of select="$square-id"/>
											</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="square-position" select="11-position() -(10-count(/Hoozin/NewDataSet/*))"/>
						<div class="p{$square-position} column showMiniProfile"
							data-href="{$miniprofile-url}">
							<xsl:if test="$begin &lt;= 1">
								<div>
									<xsl:attribute name="class">
										<xsl:choose>
											<xsl:when test="$square-change &gt; 0">trendArrow up</xsl:when>
											<xsl:when test="$square-change &lt; 0">trendArrow down</xsl:when>
											<xsl:when test="$square-change = 0">trendArrow equal</xsl:when>
										</xsl:choose>
									</xsl:attribute>
								</div>
							</xsl:if>
							<div class="userName">
								<span>
									<xsl:value-of select="$square-name"/>
								</span>
							</div>
							<img class="userAvatar hoozinTooltip" data-tooltip-delay="0" title="{$square-name} ({$square-count})" src="{$avatar-url}" alt="{$square-name} ({$square-count})" />
							<div class="position">
								<xsl:value-of select="$begin + $square-position -1"/>
							</div>
						</div>
					</xsl:for-each>
					<div class="clear"></div>
				</div>

				<div class="kpiFooter">
					<span class="previous" data-request="{$requestedData}"></span>
					<span class="next" data-request="{$requestedData}"></span>
				</div>

			</div>

		</div>


	</xsl:template>
</xsl:stylesheet>
