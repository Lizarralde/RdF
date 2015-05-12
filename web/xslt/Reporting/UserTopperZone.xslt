<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
	<xsl:param name="requestedData"/>
	<xsl:param name="selected"/>
	<xsl:param name="register"/>
	<xsl:param name="title"/>
	<xsl:param name="add-to-refresh"/>
	<xsl:output indent="no" method="html"/>

	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/global.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/small-templates.xslt" />

	<xsl:template match="/Hoozin">

		<xsl:variable name="days" select="pxs:GetDaysFromDuration(./Dates/InstallationDate, ./Dates/ActualDate)"/>
		<xsl:variable name="topper-id" select="/Hoozin/NewDataSet/*[1]/serieUniqueIdentifier"/>
		<xsl:variable name="topper-like-count" >
			<xsl:choose>
				<xsl:when test="/Hoozin/NewDataSet/*[serieUniqueIdentifier = $topper-id and plugin = /Hoozin/ActionPlugins/ActionPlugin[Name = 'Like']/ID ]/Count != ''">
					<xsl:value-of select="/Hoozin/NewDataSet/*[serieUniqueIdentifier = $topper-id and plugin = /Hoozin/ActionPlugins/ActionPlugin[Name = 'Like']/ID ]/Count"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="topper-comment-count" >
			<xsl:choose>
				<xsl:when test="/Hoozin/NewDataSet/*[serieUniqueIdentifier = $topper-id and plugin = /Hoozin/ActionPlugins/ActionPlugin[Name = 'Comment']/ID ]/Count != ''">
					<xsl:value-of select="/Hoozin/NewDataSet/*[serieUniqueIdentifier = $topper-id and plugin = /Hoozin/ActionPlugins/ActionPlugin[Name = 'Comment']/ID ]/Count"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="topper-post-count" >
			<xsl:choose>
				<xsl:when test="/Hoozin/NewDataSet/*[1]/PostCount != ''">
					<xsl:value-of select="/Hoozin/NewDataSet/*[1]/PostCount"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="topper-name" >
			<xsl:value-of select="/Hoozin/Profiles/Profile[Sid = $topper-id]/DisplayName"/>
		</xsl:variable>
		<xsl:variable name="last-modified" >
			<xsl:value-of select="/Hoozin/Profiles/Profile[Sid = $topper-id]/LastModifiedShort"/>
		</xsl:variable>
		<xsl:variable name="avatar-url" >/HoozinAvatar.axd?sid=<xsl:value-of select="$topper-id"/>&amp;size=40&amp;lastModified=<xsl:value-of select="$last-modified"/>
		</xsl:variable>
		<xsl:variable name="miniprofile-url" >HoozinData.axd?settings=hoozin&amp;name=UserMiniProfile&amp;sid=<xsl:value-of select="$topper-id"/>
		</xsl:variable>
		<xsl:variable name="post-label" >
			<xsl:choose>
				<xsl:when test="$topper-post-count > 1">AdminHome_Posts</xsl:when>
				<xsl:otherwise>AdminHome_Post</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="like-label" >
			<xsl:choose>
				<xsl:when test="$topper-like-count > 1">AdminHome_LikesOnPosts</xsl:when>
				<xsl:otherwise>AdminHome_LikeOnPosts</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="comment-label" >
			<xsl:choose>
				<xsl:when test="$topper-comment-count > 1">AdminHome_CommentsOnPosts</xsl:when>
				<xsl:otherwise>AdminHome_CommentOnPosts</xsl:otherwise>
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

			<div class="kpiWrapper topper" id="{$register}">

				<div class="kpiHeader">
					<script type="text/javascript">
						$(function () {
							hoozin.KPI.TopperZone.clearEntities("<xsl:value-of select="$register"/>");
							<xsl:for-each select="/Hoozin/NewDataSet/*">
								<xsl:variable name="for-topper-id" select="./serieUniqueIdentifier"/>
								<xsl:variable name="for-topper-like-count" >
									<xsl:choose>
										<xsl:when test="/Hoozin/NewDataSet/*[serieUniqueIdentifier = $for-topper-id and plugin = /Hoozin/ActionPlugins/ActionPlugin[Name = 'Like']/ID ]/Count != ''">
											<xsl:value-of select="/Hoozin/NewDataSet/*[serieUniqueIdentifier = $for-topper-id and plugin = /Hoozin/ActionPlugins/ActionPlugin[Name = 'Like']/ID ]/Count"/>
										</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="for-topper-comment-count" >
									<xsl:choose>
										<xsl:when test="/Hoozin/NewDataSet/*[serieUniqueIdentifier = $for-topper-id and plugin = /Hoozin/ActionPlugins/ActionPlugin[Name = 'Comment']/ID ]/Count != ''">
											<xsl:value-of select="/Hoozin/NewDataSet/*[serieUniqueIdentifier = $for-topper-id and plugin = /Hoozin/ActionPlugins/ActionPlugin[Name = 'Comment']/ID ]/Count"/>
										</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="for-topper-post-count" >
									<xsl:choose>
										<xsl:when test="./PostCount != ''">
											<xsl:value-of select="./PostCount"/>
										</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="for-topper-name" >
									<xsl:value-of select="/Hoozin/Profiles/Profile[Sid = $for-topper-id]/DisplayName"/>
								</xsl:variable>
								<xsl:variable name="for-last-modified" >
									<xsl:value-of select="/Hoozin/Profiles/Profile[Sid = $for-topper-id]/LastModifiedShort"/>
								</xsl:variable>
									hoozin.KPI.TopperZone.addEntity("<xsl:value-of select="$register"/>", {
																								id:"<xsl:value-of select="$for-topper-id"/>",
																								name:"<xsl:value-of select="pxs:ReplaceDoubleQuote($for-topper-name)"/>",
																								lastModified:"<xsl:value-of select="$for-last-modified"/>",
																								postsCount:<xsl:value-of select="$for-topper-post-count"/>,
																								likesCount:<xsl:value-of select="$for-topper-like-count"/>,
																								commentsCount:<xsl:value-of select="$for-topper-comment-count"/>
																								}, hoozin.KPI.TopperZone.setUserInfo );
							</xsl:for-each>
						});
					</script>
					<span class="kpiIcon"></span>
					<h2 >
						<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $title)"/>
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
					<xsl:choose>
							<xsl:when test="$topper-id != ''">
								<div class="theNumberWrapper col">

									<div
										class="toperDiv showMiniProfile"
										data-href="{$miniprofile-url}">

										<img src="{$avatar-url}" class="avatar" alt="{$topper-name}" />

										<span class="toperValueWrapper" style="height:36px; font-weight:normal; color:#3E3E3E;font-size:32px">
											#1
										</span>
										<span class="toperNameWrapper">
											<b>
												<xsl:value-of select="$topper-name"/>
											</b>
										</span>
										<div class="clear"></div>
									</div>
									<div class="lineWrapper">
										<div class="line">
											<span class="icon posts"/>
											<span class="value postTopperPosts"><xsl:value-of select="$topper-post-count"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $post-label)"/></span>
											<span class="inlineClear"></span>
										</div>
										<div class="line">
											<span class="icon likes"/>
											<span class="value postTopperLikes"><xsl:value-of select="$topper-like-count"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $like-label)"/></span>
											<span class="inlineClear"></span>
										</div>
										<div class="line">
											<span class="icon comments"/>
											<span class="value postTopperComments"><xsl:value-of select="$topper-comment-count"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $comment-label)"/></span>
											<span class="inlineClear"></span>
										</div>
									</div>
								</div>
								<div class="clear">
								</div>
						</xsl:when>
						<xsl:otherwise>
							<span class="noData"><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.SharePoint', 'TopperZone_ErrorMessage')"/></span>
						</xsl:otherwise>
					</xsl:choose>
				</div>
				<div class="kpiFooter">
					<span class="arrow previous"></span>
					<span class="position"> <b>#1</b> </span>
					<span class="arrow next active"></span>
				</div>
			</div>


		</div>

	</xsl:template>

</xsl:stylesheet>
