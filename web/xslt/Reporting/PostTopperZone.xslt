<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
	<xsl:param name="selected"/>
	<xsl:param name="register"/>
	<xsl:param name="title"/>
	<xsl:param name="requestedData"/>

	<xsl:output indent="no" method="html"/>

	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/global.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/small-templates.xslt" />

	<xsl:template match="/Hoozin">

		<xsl:variable name="days" select="pxs:GetDaysFromDuration(./Dates/InstallationDate, ./Dates/ActualDate)"/>
		<xsl:variable name="topper-post-id" select="/Hoozin/NewDataSet/*[1]/ID"/>
		<xsl:variable name="topper-post-url" select="/Hoozin/NewDataSet/*[1]/PostUrl"/>
		<xsl:variable name="topper-id" select="/Hoozin/NewDataSet/*[1]/serieUniqueIdentifier"/>
		<xsl:variable name="post-date" select="/Hoozin/NewDataSet/*[1]/Created"/>
		<xsl:variable name="topper-name" select="/Hoozin/Profiles/Profile[Sid = $topper-id]/DisplayName"/>
		<xsl:variable name="last-modified" select="/Hoozin/Profiles/Profile[Sid = $topper-id]/LastModifiedShort"/>
		<xsl:variable name="topper-post-plugin" select="/Hoozin/PostPlugins/PostPlugin[ID = /Hoozin/NewDataSet/*[1]/postPlugin]/Name"/>
		<xsl:variable name="topper-like-count" >
			<xsl:choose>
				<xsl:when test="/Hoozin/NewDataSet/*[ID = $topper-post-id and actionPlugin = /Hoozin/ActionPlugins/ActionPlugin[Name = 'Like']/ID]/Count != ''">
					<xsl:value-of select="/Hoozin/NewDataSet/*[ID = $topper-post-id and actionPlugin = /Hoozin/ActionPlugins/ActionPlugin[Name = 'Like']/ID]/Count"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="topper-comment-count" >
			<xsl:choose>
				<xsl:when test="/Hoozin/NewDataSet/*[ID = $topper-post-id and actionPlugin = /Hoozin/ActionPlugins/ActionPlugin[Name = 'Comment']/ID]/Count != ''">
					<xsl:value-of select="/Hoozin/NewDataSet/*[ID = $topper-post-id and actionPlugin = /Hoozin/ActionPlugins/ActionPlugin[Name = 'Comment']/ID]/Count"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="topper-post-tweet-html" select="/Hoozin/NewDataSet/*[1]/TweetHTML"/>
		<xsl:variable name="avatar-url" >/HoozinAvatar.axd?sid=<xsl:value-of select="$topper-id"/>&amp;size=70&amp;lastModified=<xsl:value-of select="$last-modified"/>
		</xsl:variable>
		<xsl:variable name="miniprofile-url" >HoozinData.axd?settings=hoozin&amp;name=UserMiniProfile&amp;sid=<xsl:value-of select="$topper-id"/>
		</xsl:variable>
		<xsl:variable name="post-type-label" >DB_POSTS_PLUGINS_Description_<xsl:value-of select="$topper-post-plugin"/>
		</xsl:variable>
		<xsl:variable name="like-label" >
			<xsl:choose>
				<xsl:when test="$topper-like-count > 1">AdminHome_Likes</xsl:when>
				<xsl:otherwise>AdminHome_Like</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="comment-label" >
			<xsl:choose>
				<xsl:when test="$topper-comment-count > 1">AdminHome_Comments</xsl:when>
				<xsl:otherwise>AdminHome_Comment</xsl:otherwise>
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


			<div class="kpiWrapper topper topPost" id="{$register}" data-toppers-count="10">

				<div class="kpiHeader">
					<script type="text/javascript">
						$(function () {
							hoozin.KPI.TopperZone.clearEntities("<xsl:value-of select="$register"/>");
					
							<xsl:for-each select="/Hoozin/NewDataSet/*">
								<xsl:variable name="for-topper-id" select="./serieUniqueIdentifier"/>
								<xsl:variable name="for-topper-post-id" select="./ID"/>
								<xsl:variable name="for-topper-post-url" select="./PostUrl"/>
								<xsl:variable name="for-post-date" select="./Created"/>
								<xsl:variable name="for-topper-post-plugin-id" select="./postPlugin"/>
								<xsl:variable name="for-topper-name" select="/Hoozin/Profiles/Profile[Sid = $for-topper-id]/DisplayName"/>
								<xsl:variable name="for-last-modified" select="/Hoozin/Profiles/Profile[Sid = $for-topper-id]/LastModifiedShort"/>
								<xsl:variable name="for-miniprofile-url" >HoozinData.axd?settings=hoozin&amp;name=UserMiniProfile&amp;sid=<xsl:value-of select="$topper-id"/>
								</xsl:variable>
								<xsl:variable name="for-topper-post-plugin" select="/Hoozin/PostPlugins/PostPlugin[ID = $for-topper-post-plugin-id]/Name"/>
								<xsl:variable name="for-topper-like-count" >
									<xsl:choose>
										<xsl:when test="/Hoozin/NewDataSet/*[ID = $for-topper-post-id and actionPlugin = /Hoozin/ActionPlugins/ActionPlugin[Name = 'Like']/ID]/Count != ''">
											<xsl:value-of select="/Hoozin/NewDataSet/*[ID = $for-topper-post-id and actionPlugin = /Hoozin/ActionPlugins/ActionPlugin[Name = 'Like']/ID]/Count"/>
										</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="for-topper-comment-count" >
									<xsl:choose>
										<xsl:when test="/Hoozin/NewDataSet/*[ID = $for-topper-post-id and actionPlugin = /Hoozin/ActionPlugins/ActionPlugin[Name = 'Comment']/ID]/Count != ''">
											<xsl:value-of select="/Hoozin/NewDataSet/*[ID = $for-topper-post-id and actionPlugin = /Hoozin/ActionPlugins/ActionPlugin[Name = 'Comment']/ID]/Count"/>
										</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
									<xsl:variable name="for-topper-post-tweet-html" select="./TweetHTML"/>
								<xsl:variable name="for-post-type-label" >DB_POSTS_PLUGINS_Description_<xsl:value-of select="$for-topper-post-plugin"/></xsl:variable>
								hoozin.KPI.TopperZone.addEntity("<xsl:value-of select="$register"/>", {
																								userSid:"<xsl:value-of select="pxs:ReplaceDoubleQuote($for-topper-id)"/>",
																								id:"<xsl:value-of select="pxs:ReplaceDoubleQuote($for-topper-post-id)"/>",
																								url:"<xsl:value-of select="pxs:ReplaceDoubleQuote($for-topper-post-url)"/>",
																								postHtml:"<xsl:value-of select="pxs:EscapeUserEntryForJson($for-topper-post-tweet-html)"/>",
																								name:"<xsl:value-of select="pxs:ReplaceDoubleQuote($for-topper-name)"/>",
																								lastModified:"<xsl:value-of select="pxs:ReplaceDoubleQuote($for-last-modified)"/>",
																								postPlugin:"<xsl:value-of select="pxs:ReplaceDoubleQuote(pxs:GetResource('Prexens.Hoozin.Sharepoint', $for-post-type-label))"/>",
																								likesCount:<xsl:value-of select="$for-topper-like-count"/>,
																								commentsCount:<xsl:value-of select="$for-topper-comment-count"/>,
																								postDate:"<xsl:value-of select="$for-post-date"/>",
																								}, hoozin.KPI.TopperZone.setPostInfo, 10 );
								
							</xsl:for-each>
						});
					</script>
					<span class="kpiIcon"></span>
					<h2>
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
				</div>

				<div class="kpiContent">


					<xsl:choose>
						<xsl:when test="$topper-id != ''">
							<div class="theNumberWrapper col">

								<div
								class="toperDiv showMiniProfile" style="margin-bottom:-3px;"
								data-href="{$miniprofile-url}">

									<img src="{$avatar-url}" class="avatar" alt="{$topper-name}" />
									<span class="toperNameWrapper">
										<b>
											<xsl:value-of select="$topper-name"/>
										</b>
									</span>
									<span class="toperValueWrapper" style="height:13px; font-weight:lighter; color:#8B8B8B;">
										<xsl:value-of select="pxs:FormatDateTime($post-date, 'dd/MM/yyyy')" />
									</span>


									<span class="value postTopperPosts">
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'PostTopperZone_PostType')"/>
										<span>
											<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $post-type-label)"/>
										</span>
									</span>
									<span class="actionsWrapper">
										<div class="likesLine" style="float:left;line-height:26px;">
											<span class="icon likes"/>
											<span class="value postTopperLikes">
												<xsl:value-of select="$topper-like-count"/>
											</span>
										</div>
										<div class="commentsLine" style="line-height:26px;">
											<span class="icon comments"/>
											<span class="value postTopperComments">
												<xsl:value-of select="$topper-comment-count"/>
											</span>
										</div>
									</span>
									<span class="inlineClear"></span>

								</div>
								<!--
								<div class="lineWrapper" style="margin-top:0;">
									<div class="line">
										<span class="value postTopperPosts">
											<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'PostTopperZone_PostType')"/>
											<span>
												<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $post-type-label)"/>
											</span>
										</span>
										<span class="inlineClear"></span>
									</div>
									<div class="line horizontal">
										<span class="icon likes"/>
										<span class="value postTopperLikes">
											<xsl:value-of select="$topper-like-count"/>
											<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $like-label)"/>
										</span>
										<span class="inlineClear"></span>
									</div>
									<div class="line">
										<span class="icon comments"/>
										<span class="value postTopperComments">
											<xsl:value-of select="$topper-comment-count"/>
											<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $comment-label)"/>
										</span>
										<span class="inlineClear"></span>
									</div>
								</div>
								-->
								<div class="hoozinArrow relativePosition">
									<div class="tweetContent addPointer" data-post-id="{$topper-post-id}" data-post-url="{$topper-post-url}">
										<xsl:value-of select="$topper-post-tweet-html" disable-output-escaping="yes"/>
									</div>
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
