<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
<xsl:param name="selected"/>
<xsl:param name="interval" select="'DAY'"/>
<xsl:param name="title" select="'AdminHome_UsersAdoption'"/>
	
	<xsl:output indent="no" method="html"/>

	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/global.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/small-templates.xslt" />

	<xsl:template match="/Hoozin">

		<xsl:if test="$isCallBack = 'False'">

			<script type="text/javascript">

				
				$(function () {
					
					hoozin.UI.register(
						"userAdoption", 
						"userAdoption", 
						"<xsl:value-of select="$webpart_storagekey" />", 
						{}, 
						"<xsl:value-of select="$current_page_serverrelativeurl" />"
					);
          
				});
				
				
			</script>

		</xsl:if>

		
		<div id="{$webpart_id}_content">

			<xsl:variable name="days" select="pxs:GetDaysFromDuration(./Dates/InstallationDate, ./Dates/ActualDate)"/>
			<xsl:variable name="nbr-interval">
				<xsl:choose>
					<xsl:when test="$interval = 'DAY'">
						<xsl:value-of select="round(pxs:GetDaysFromDuration(./Dates/InstallationDate, ./Dates/ActualDate) div 7)*5"/>
					</xsl:when>
					<xsl:when test="$interval = 'WEEK'">
						<xsl:value-of select="round(pxs:GetDaysFromDuration(./Dates/InstallationDate, ./Dates/ActualDate) div 7)"/>
					</xsl:when>
					<xsl:when test="$interval = 'MONTH'">
						<xsl:value-of select="round(pxs:GetDaysFromDuration(./Dates/InstallationDate, ./Dates/ActualDate) div 31)-1"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<div class="kpiWrapper" id="userAdoption">

				<div class="kpiHeader">
					<span class="kpiIcon"></span>
					<h2><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $title)"/></h2>
					<div class="dateSelector btn-group">
						<a class="dateSelectorBt dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"></a>
						<ul class="dropdown-menu pull-right" >
							<li>
								<a
									href="javascript:void(0);"
									data-interval-key="Yesterday"
									data-request="UserAdoption"
									data-days="">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_Yesterday')"/>
								</a>
							</li>
							<li>
								<a
									href="javascript:void(0);"
									data-interval-key="LastWeek"
									data-request="UserAdoption"
									data-days="">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_LastWeek')"/></a>
							</li>
							<li>
								<a
									href="javascript:void(0);"
									data-interval-key="LastMonth"
									data-request="UserAdoption"
									data-days="">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_LastMonth')"/></a>
							</li>
							<li class="divider"></li>
							<li>
								<a
									href="javascript:void(0);"
									data-interval-key="AllTime"
									data-request="UserAdoption"
									data-days="{$days}">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_AllTime')"/></a>
							</li>
						</ul>
					</div>
					<div class="dateSelected"><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $selected)"/></div>
				</div>
				<div class="kpiContent">
					<div class="col">
						<!--variable declaration-->
						<xsl:variable name="posts-count">
							<xsl:choose>
								<xsl:when test="sum(/Hoozin/NewDataSet/POSTS/Count) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/POSTS/Count)"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="posts-tweet-count" >
							<xsl:choose>
								<xsl:when test="sum(/Hoozin/NewDataSet/POSTS[PostPluginID = '71fddf67-8363-4382-a38a-bee0f5269939']/Count) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/POSTS[PostPluginID = '71fddf67-8363-4382-a38a-bee0f5269939']/Count)"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="old-posts-count" select="sum(/Hoozin/NewDataSet/POSTS/Change)"/>
						<xsl:variable name="old-posts-tweet-count" select="sum(/Hoozin/NewDataSet/POSTS[PostPluginID = '71fddf67-8363-4382-a38a-bee0f5269939']/Change)"/>
						<xsl:variable name="posts-count-resource">
							<xsl:choose>
								<xsl:when test="$posts-count &lt;= 1">AdminHome_Post</xsl:when>
								<xsl:otherwise>AdminHome_Posts</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="posts-tweet-count-resource">
							<xsl:choose>
								<xsl:when test="$posts-tweet-count &lt;= 1">AdminHome_Tweet</xsl:when>
								<xsl:otherwise>AdminHome_Tweets</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
						<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
						
						<div class="top">
							<div class="icon posts">
							</div>
							<div class="number">
											<xsl:value-of select="$posts-count"/></div>
							<div class="desc">
											<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $posts-count-resource)"/></div>
							<div class="trend">
								
							</div>
							<div class="clear">
							</div>
						</div>
						<div class="lineWrapper">
							<div class="line">
								<span class="icon posts"></span>
								<span class="value"><xsl:value-of select="$posts-tweet-count"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $posts-tweet-count-resource)"/></span>
								<span class="inlineClear"></span>
							</div>
							<xsl:for-each select="//POSTS[PostPluginID != '71fddf67-8363-4382-a38a-bee0f5269939']">
								<xsl:variable name="post-plugin-label">
									<xsl:choose>
										<xsl:when test="./Count &lt;= 1"><xsl:value-of select="./PluginName"/></xsl:when>
										<xsl:otherwise><xsl:value-of select="./PluginName"/>Many</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<div class="line">
									<span style="background-image:url('{./IconUrl}');background-position: -40px 0;" class="icon"></span>
									<span class="value"><xsl:value-of select="./Count"/>&#160;<xsl:value-of select="translate(pxs:GetResource($post-plugin-label), $uppercase, $smallcase)"/></span>
									<span class="inlineClear">
									</span>
								</div>
							</xsl:for-each>
						</div>
					</div>
					<div class="col">
						<!--variable declaration-->
						<xsl:variable name="actions-count">
							<xsl:choose>
								<xsl:when test="sum(/Hoozin/NewDataSet/ACTIONS/Count) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/ACTIONS/Count)"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="actions-like-count">
							<xsl:choose>
								<xsl:when test="sum(/Hoozin/NewDataSet/ACTIONS[PluginName = 'Like']/Count) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/ACTIONS[PluginName = 'Like']/Count)"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="actions-comment-count">
							<xsl:choose>
								<xsl:when test="sum(/Hoozin/NewDataSet/ACTIONS[PluginName = 'Comment']/Count) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/ACTIONS[PluginName = 'Comment']/Count)"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="old-actions-count" select="sum(/Hoozin/NewDataSet/ACTIONS/Change)"/>
						<xsl:variable name="old-actions-like-count" select="sum(/Hoozin/NewDataSet/ACTIONS[PluginName = 'Like']/Change)"/>
						<xsl:variable name="old-actions-comment-count" select="sum(/Hoozin/NewDataSet/ACTIONS[PluginName = 'Comment']/Change)"/>
		
						<xsl:variable name="actions-count-resource">
							<xsl:choose>
								<xsl:when test="$actions-count &lt;= 1">AdminHome_Reaction</xsl:when>
								<xsl:otherwise>AdminHome_Reactions</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="actions-like-count-resource">
							<xsl:choose>
								<xsl:when test="$actions-like-count &lt;= 1">AdminHome_Like</xsl:when>
								<xsl:otherwise>AdminHome_Likes</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="actions-comment-count-resource">
							<xsl:choose>
								<xsl:when test="$actions-comment-count &lt;= 1">AdminHome_Comment</xsl:when>
								<xsl:otherwise>AdminHome_Comments</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<div class="top">
							<div class="icon reactions">
							</div>
							<div class="number">
											<xsl:value-of select="$actions-count"/></div>
							<div class="desc"><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $actions-count-resource)"/></div>
							<div class="trend">
							</div>
							<div class="clear">
							</div>
						</div>
						<div class="lineWrapper">
							<div class="line">
								<span class="icon likes"></span>
								<span class="value"><xsl:value-of select="$actions-like-count"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $actions-like-count-resource)"/></span>
								
								<span class="inlineClear"></span>
							</div>
							<div class="line">
								<span class="icon comments"></span>
								<span class="value"><xsl:value-of select="$actions-comment-count"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $actions-comment-count-resource)"/></span>
								<span class="inlineClear">
								</span>
							</div>
						</div>
					</div>
					<div class="clear">
					</div>
				</div>
			</div>

		</div>

	</xsl:template>

</xsl:stylesheet>
