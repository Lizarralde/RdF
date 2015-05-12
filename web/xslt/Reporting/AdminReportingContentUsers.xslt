<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
	<xsl:output method="html" indent="yes"/>
	<xsl:param name="register"/>
	<xsl:param name="selected"/>
	<xsl:param name="title"/>
	<xsl:param name="requestedData"/>
	<xsl:param name="add-to-refresh"/>
	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/formatterChartXml.xslt" />


	<xsl:template match="/Hoozin">
		<xsl:variable name="profiles" select="/Hoozin/Profiles"/>
		<xsl:variable name="days" select="pxs:GetDaysFromDuration(./Dates/InstallationDate, ./Dates/ActualDate)"/>
		<!-- All JS should be under the $isCallBack = 'False' section now -->
		<xsl:if test="$isCallBack = 'False'">

			<script type="text/javascript">

        $(function () {

          // Register context zone
          hoozin.UI.register(
            '<xsl:value-of select="$register"/>',
            null,
            '<xsl:value-of select="$webpart_storagekey" />',
            {},
            '<xsl:value-of select="$current_page_serverrelativeurl" />'
          );

        });

      </script>

		</xsl:if>

		<div id="{$webpart_id}_content">

			<div class="kpiWrapper " id="{$register}" data-toppers-count="7">

				<div class="kpiHeader">
					<span class="kpiIcon"></span>
					<h2>
						<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.SharePoint',$title)" />
					</h2>
					<div class="dateSelector btn-group">
						<a class="dateSelectorBt dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"></a>
						<ul class="dropdown-menu pull-right" >
							<li>
								<a
									href="javascript:void(0);"
									data-interval-key="Yesterday"
									data-request="{$requestedData}"
									data-refresh="{$add-to-refresh}"
									data-days="">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_Yesterday')"/>
								</a>
							</li>
							<li>
								<a
									href="javascript:void(0);"
									data-interval-key="LastWeek"
									data-request="{$requestedData}"
									data-refresh="{$add-to-refresh}"
									data-days="">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_LastWeek')"/>
								</a>
							</li>
							<li>
								<a
									href="javascript:void(0);"
									data-interval-key="LastMonth"
									data-request="{$requestedData}"
									data-refresh="{$add-to-refresh}"
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
									data-refresh="{$add-to-refresh}"
									data-days="{$days}">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_AllTime')"/>
								</a>
							</li>
						</ul>
					</div>
					<div class="dateSelected">
						<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $selected)"/>
					</div>
				</div>

				<div class="kpiContent">

					<div class="infosBlocContent">
						<xsl:choose>
							<xsl:when test="count(./NewDataSet//*) != 0">
								<xsl:for-each select="/Hoozin/NewDataSet/*">

									<xsl:variable name="user-sid" select="./serieUniqueIdentifier"/>
									<xsl:variable name="user-display-name" select="msxsl:node-set($profiles)/Profile[Sid = $user-sid]/DisplayName"/>
									<xsl:variable name="user-last-modified" select="msxsl:node-set($profiles)/Profile[Sid = $user-sid]/LastModifiedShort"/>
									<xsl:variable name="user-count" select="./value"/>
									<xsl:variable name="user-change" select="./Change"/>
									<xsl:variable name="user-direction">
										<xsl:choose>
											<xsl:when test="$user-change = -1">toperTrendPic down</xsl:when>
											<xsl:when test="$user-change = 0">toperTrendPic equal</xsl:when>
											<xsl:when test="$user-change = 1">toperTrendPic up</xsl:when>
										</xsl:choose>
									</xsl:variable>

									<div
										class="toperDiv showMiniProfile"
										data-href="HoozinData.axd?settings=hoozin&amp;name=UserMiniProfile&amp;sid={$user-sid}">
										<img src="/HoozinAvatar.axd?sid={$user-sid}&amp;size=30&amp;lastModified={$user-last-modified}" class="avatar" alt="{$user-display-name}" />
										<span class="toperNameWrapper" style="margin-right:0">
											<xsl:value-of select="$user-display-name"/>
										</span>
										<span class="toperValueWrapper">
											<span class="{$user-direction}"></span>
											<span class="toperValue">
												<xsl:value-of select="$user-count"/>
											</span>
										</span>
										<div class="clear"></div>
									</div>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<span class="noData"><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.SharePoint', 'AdminReportingContent_ErrorMessage')"/></span>
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</div>
			</div>

		</div>


	</xsl:template>
</xsl:stylesheet>
