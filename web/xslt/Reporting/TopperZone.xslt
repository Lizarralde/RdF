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
		<xsl:variable name="topper-id" select="/Hoozin/NewDataSet/*[1]/serieUniqueIdentifier"/>
		<xsl:variable name="topper-count" >
			<xsl:choose>
				<xsl:when test="sum(/Hoozin/NewDataSet/*[1]/value) != ''">
					<xsl:value-of select="sum(/Hoozin/NewDataSet/*[1]/value)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="topper-entity">
			<xsl:choose>
				<xsl:when test="$topper-type = 'user'">
					<xsl:copy-of select="/Hoozin/Profiles/Profile[Sid = $topper-id]"/>
				</xsl:when>
				<xsl:when test="$topper-type = 'community'">
					<xsl:copy-of select="/Hoozin/Communities/Community[WebGUID = $topper-id]"/>
				</xsl:when>
				<xsl:when test="$topper-type = 'app'">
					<xsl:copy-of select="/Hoozin/Apps/App[ID = $topper-id]"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="topper-name" >
			<xsl:choose>
				<xsl:when test="$topper-type = 'user'">
					<xsl:value-of select="msxsl:node-set($topper-entity)/Profile/DisplayName"/>
				</xsl:when>
				<xsl:when test="$topper-type = 'community'">
					<xsl:value-of select="msxsl:node-set($topper-entity)/Community/Name"/>
				</xsl:when>
				<xsl:when test="$topper-type = 'app'">
					<xsl:value-of select="pxs:TryEvaluateResource(msxsl:node-set($topper-entity)/App/DisplayName)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="last-modified" select="msxsl:node-set($topper-entity)//LastModifiedShort"/>

		<xsl:variable name="avatar-url" >
			<xsl:choose>
				<xsl:when test="$topper-type = 'user'">/HoozinAvatar.axd?sid=<xsl:value-of select="$topper-id"/>&amp;size=40&amp;lastModified=<xsl:value-of select="$last-modified"/>
				</xsl:when>
				<xsl:when test="$topper-type = 'community'">/GetHoozinCommunityImage.axd?type=avatar&amp;size=40&amp;guid=<xsl:value-of select="$topper-id"/>&amp;lastModified=<xsl:value-of select="$last-modified"/>
				</xsl:when>
				<xsl:when test="$topper-type = 'app'">background-image:url('<xsl:value-of select="msxsl:node-set($topper-entity)/App/Icon"/>');
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="miniprofile-url" >
			<xsl:choose>
				<xsl:when test="$topper-type = 'user'">HoozinData.axd?settings=hoozin&amp;name=UserMiniProfile&amp;sid=<xsl:value-of select="$topper-id"/>
				</xsl:when>
				<xsl:when test="$topper-type = 'community'">HoozinData.axd?settings=hoozin&amp;name=CommunityMiniProfile&amp;communityWebGUID=<xsl:value-of select="$topper-id"/>
				</xsl:when>
				<xsl:when test="$topper-type = 'app'">HoozinData.axd?settings=hoozin&amp;name=ApplicationMiniProfile&amp;appID=<xsl:value-of select="$topper-id"/>

				</xsl:when>
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
								<xsl:variable name="for-topper-id" select="./serieUniqueIdentifier"/>
								<xsl:variable name="for-topper-count" >
									<xsl:choose>
										<xsl:when test="sum(./value) != ''"><xsl:value-of select="sum(./value)"/></xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="for-topper-change" >
									<xsl:choose>
										<xsl:when test="sum(./Change) != ''"><xsl:value-of select="sum(./Change)"/></xsl:when>
										<xsl:otherwise>undefined</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="for-topper-name" >
									<xsl:choose>
										<xsl:when test="$topper-type = 'user'"><xsl:value-of select="/Hoozin/Profiles/Profile[Sid = $for-topper-id]/DisplayName"/></xsl:when>
										<xsl:when test="$topper-type = 'community'"><xsl:value-of select="/Hoozin/Communities/Community[WebGUID = $for-topper-id]/Name"/></xsl:when>
										<xsl:when test="$topper-type = 'app'"><xsl:value-of select="pxs:TryEvaluateResource(/Hoozin/Apps/App[ID = $for-topper-id]/DisplayName)"/></xsl:when>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="for-last-modified" >
									<xsl:choose>
										<xsl:when test="$topper-type = 'user'"><xsl:value-of select="/Hoozin/Profiles/Profile[Sid = $for-topper-id]/LastModifiedShort"/></xsl:when>
										<xsl:when test="$topper-type = 'community'"><xsl:value-of select="/Hoozin/Communities/Community[WebGUID = $for-topper-id]/LastModifiedShort"/></xsl:when>
										<xsl:when test="$topper-type = 'app'"><xsl:value-of select="/Hoozin/Apps/App[ID = $for-topper-id]/LastModifiedShort"/></xsl:when>
									</xsl:choose>
								</xsl:variable>
								hoozin.KPI.TopperZone.addEntity("<xsl:value-of select="$register"/>", {
																							id:"<xsl:value-of select="$for-topper-id"/>",
																							name:"<xsl:value-of select="pxs:ReplaceDoubleQuote($for-topper-name)"/>",
																							lastModified:"<xsl:value-of select="$for-last-modified"/>",
																							count:<xsl:value-of select="$for-topper-count"/>,
																							change:<xsl:value-of select="$for-topper-change"/>
								<xsl:if test="$topper-type">
									,imgUrl:"<xsl:value-of select="/Hoozin/Apps/App[ID = $for-topper-id]/Icon"/>"
								</xsl:if>
																							}, "<xsl:value-of select="$topper-type"/>" );
							</xsl:for-each>
						});
					</script>
					<xsl:if test="$selected != ''">
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
					</xsl:if>
				</div>

				<div class="kpiContent">
					<xsl:choose>
						<xsl:when test="$topper-id != '' and sum(./NewDataSet/*/value) != 0">
							<div class="theNumberWrapper">
								<div class="theNumber" style="text-align:left;">
									<span><xsl:value-of select="$topper-count"/></span><xsl:value-of select="$sufix"/>
								</div>
								<div class="theChapo" style="text-align:left; padding-bottom:10px">
									<xsl:choose>
										<xsl:when test="$topper-count > 1">
											<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $value-label-puriel)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $value-label)"/>
										</xsl:otherwise>
									</xsl:choose>
								</div>
								<div
									class="toperDiv showMiniProfile"
									data-href="{$miniprofile-url}">
									<xsl:choose>
										<xsl:when test="$topper-type = 'app'">
											<div style="{$avatar-url}" class="avatar" alt="{$topper-name}"></div>
										</xsl:when>
										<xsl:otherwise>
											<img src="{$avatar-url}" class="avatar" alt="{$topper-name}" />
										</xsl:otherwise>
									</xsl:choose>
									<span class="toperValueWrapper" style="height:13px; font-weight:lighter; color:#8B8B8B;">
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $topper-explanation)" />
									</span>
									<span class="toperNameWrapper">
										<b>
											<xsl:value-of select="$topper-name"/>
										</b>
									</span>
									<span class="toperValueWrapper" style="height:13px; font-weight:lighter; color:#8B8B8B;">
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'TopperZone_Since')" />
										<span class="date">
											<xsl:value-of select="pxs:FormatDateTime($var-since, 'dd/MM/yyyy')" />
										</span>
									</span>
									<div class="clear"></div>
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
					<span class="arrow previous"></span>
					<span class="position">
						<b>#1</b>
					</span>
					<span class="arrow next active"></span>
				</div>
			</div>


		</div>

	</xsl:template>

</xsl:stylesheet>
