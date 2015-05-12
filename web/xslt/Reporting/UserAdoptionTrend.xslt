<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
<xsl:param name="selected"/>
<xsl:param name="interval" select="'DAY'"/>
	
	<xsl:output indent="no" method="html"/>

	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/global.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/small-templates.xslt" />

	<xsl:template match="/Hoozin">

		<xsl:if test="$isCallBack = 'False'">

			<script type="text/javascript">

				
				$(function () {
					
					hoozin.UI.register(
						"userAdoptionTrend", 
						"userAdoptionTrend", 
						"<xsl:value-of select="$webpart_storagekey" />", 
						{}, 
						"<xsl:value-of select="$current_page_serverrelativeurl" />"
					);
          
				});
				
				
			</script>

		</xsl:if>

		
		<div id="{$webpart_id}_content">
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
			<div class="kpiWrapper" id="userAdoptionTrend">
				<div class="kpiHeader">
					<span class="kpiIcon"></span>
					<h2><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_UsersAdoptionTrend')"/></h2>
					<div class="dateSelector btn-group">
						<a class="dateSelectorBt dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"></a>
						<ul class="dropdown-menu pull-right" >
							<li>
								<a
									href="javascript:void(0);"
									data-interval-key="Yesterday"
									data-resource-key="DayTendence"
									data-request="UserAdoption"
									data-days="">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_DayTendence')"/>
								</a>
							</li>
							<li>
								<a
									href="javascript:void(0);"
									data-interval-key="LastWeek"
									data-resource-key="WeekTendence"
									data-request="UserAdoption"
									data-days="">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_WeekTendence')"/></a>
							</li>
							<li>
								<a
									href="javascript:void(0);"
									data-interval-key="LastMonth"
									data-resource-key="MonthTendence"
									data-request="UserAdoption"
									data-days="">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_MonthTendence')"/></a>
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
								<xsl:when test="sum(/Hoozin/NewDataSet/POSTS[PluginName = 'Tweet']/Count) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/POSTS[PluginName = 'Tweet']/Count)"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="posts-image-count" >
							<xsl:choose>
								<xsl:when test="sum(/Hoozin/NewDataSet/POSTS[PluginName = 'Image']/Count) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/POSTS[PluginName = 'Image']/Count)"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="posts-link-count">
							<xsl:choose>
								<xsl:when test="sum(/Hoozin/NewDataSet/POSTS[PluginName = 'Link']/Count) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/POSTS[PluginName = 'Link']/Count)"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="posts-file-count" >
							<xsl:choose>
								<xsl:when test="sum(/Hoozin/NewDataSet/POSTS[PluginName = 'File']/Count) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/POSTS[PluginName = 'File']/Count)"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="old-posts-count" select="sum(/Hoozin/NewDataSet/POSTS/Change)"/>
						<xsl:variable name="old-posts-tweet-count" select="sum(/Hoozin/NewDataSet/POSTS[PluginName = 'Tweet']/Change)"/>
						<xsl:variable name="old-posts-image-count" select="sum(/Hoozin/NewDataSet/POSTS[PluginName = 'Image']/Change)"/>
						<xsl:variable name="old-posts-link-count" select="sum(/Hoozin/NewDataSet/POSTS[PluginName = 'Link']/Change)"/>
						<xsl:variable name="old-posts-file-count" select="sum(/Hoozin/NewDataSet/POSTS[PluginName = 'File']/Change)"/>
		
												
						<!--variable declaration-->
						<xsl:variable name="posts-count-average" select="round($old-posts-count div $nbr-interval)"/>
						<xsl:variable name="posts-tweet-count-average" select="round($old-posts-tweet-count div $nbr-interval)"/>
						<xsl:variable name="posts-image-count-average" select="round($old-posts-image-count div $nbr-interval)"/>
						<xsl:variable name="posts-link-count-average" select="round($old-posts-link-count div $nbr-interval)"/>
						<xsl:variable name="posts-file-count-average" select="round($old-posts-file-count div $nbr-interval)"/>
		
						<xsl:variable name="posts-count-tendance" select="round(($posts-count*100 div $posts-count-average) ) -100"/>
						<xsl:variable name="posts-tweet-count-tendance" select="round(($posts-tweet-count*100 div $posts-tweet-count-average) ) -100"/>
						<xsl:variable name="posts-image-count-tendance" select="round(($posts-image-count*100 div $posts-image-count-average) ) -100"/>
						<xsl:variable name="posts-link-count-tendance" select="round(($posts-link-count*100 div $posts-link-count-average) ) -100"/>
						<xsl:variable name="posts-file-count-tendance" select="round(($posts-file-count*100 div $posts-file-count-average) ) -100"/>
		
						<xsl:variable name="posts-count-tendance-sign">
							<xsl:choose>
								<xsl:when test="$posts-count-tendance >= 0">+</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="posts-tweet-count-tendance-sign">
							<xsl:choose>
								<xsl:when test="$posts-tweet-count-tendance > 0">+</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="posts-image-count-tendance-sign">
							<xsl:choose>
								<xsl:when test="$posts-image-count-tendance > 0">+</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="posts-link-count-tendance-sign">
							<xsl:choose>
								<xsl:when test="$posts-link-count-tendance > 0">+</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="posts-file-count-tendance-sign">
							<xsl:choose>
								<xsl:when test="$posts-file-count-tendance > 0">+</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:variable name="posts-count-resource">
							<xsl:choose>
								<xsl:when test="$posts-count &lt;= 1">AdminHome_Post</xsl:when>
								<xsl:otherwise>AdminHome_Posts</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="posts-count-average-resource">
							<xsl:choose>
								<xsl:when test="$posts-count-average &lt;= 1">AdminHome_Post</xsl:when>
								<xsl:otherwise>AdminHome_Posts</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<!--
						<xsl:variable name="posts-tweet-count-resource">
							<xsl:choose>
								<xsl:when test="$posts-tweet-count &lt;= 1">AdminHome_Tweet</xsl:when>
								<xsl:otherwise>AdminHome_Tweets</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="posts-image-count-resource">
							<xsl:choose>
								<xsl:when test="$posts-image-count &lt;= 1">AdminHome_Picture</xsl:when>
								<xsl:otherwise>AdminHome_Pictures</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="posts-link-count-resource">
							<xsl:choose>
								<xsl:when test="$posts-link-count &lt;= 1">AdminHome_Link</xsl:when>
								<xsl:otherwise>AdminHome_Links</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="posts-file-count-resource">
							<xsl:choose>
								<xsl:when test="$posts-file-count &lt;= 1">AdminHome_Document</xsl:when>
								<xsl:otherwise>AdminHome_Documents</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>-->
						
						<div class="top">
							<div class="icon posts">
							</div>
							<div class="number" style="font-size:30px">
								<xsl:if test="string(number($posts-count-tendance)) != 'NaN' and string(number($posts-count-tendance)) != 'Infinity' and string(number($posts-count-tendance)) != '-Infinity'">
											<xsl:value-of select="$posts-count-tendance-sign"/><xsl:value-of select="substring($posts-count-tendance,1,6)"/>%
								</xsl:if>
							</div>
							<div class="trend">
								<span class="num" style="color:#777777;font-size:11px;"><xsl:value-of select="$posts-count"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $posts-count-resource)"/></span>
								<xsl:if test="string(number($posts-count-tendance)) != 'NaN' and string(number($posts-count-tendance)) != 'Infinity' and string(number($posts-count-tendance)) != '-Infinity'">
									<span class="arrow" style="float:left; margin-right:5px;">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$posts-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$posts-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:when test="$posts-count-tendance = 0">arrow equal</xsl:when>
											</xsl:choose>
										</xsl:attribute>
									</span>
								</xsl:if>
							</div>
							<div class="clear">
							</div>
						</div>
						
						<div class="trendWrapper">
							
							<div class="trendDesc" style="text-align:left;">
								<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_GlobalAverage')"/>
							</div>
							<div class="lineWrapper" style="margin-top:-5px;">
								<div class="line">
									<span class="value">
										<xsl:choose>
											<xsl:when test="string(number($posts-count-average)) != 'NaN' and string(number($posts-count-average)) != 'Infinity' and string(number($posts-count-average)) != '-Infinity'">
												<xsl:value-of select="$posts-count-average"/> 
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose> 
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $posts-count-average-resource)"/>
									</span>
									<!--<span class="icon posts"></span>--> 
								</div>
							</div>
						</div>
						
						<div class="lineWrapper">
							
							<!--<div class="line">
								<span class="icon posts"></span>
								<span class="value"><xsl:value-of select="$posts-tweet-count-average"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $posts-tweet-count-resource)"/></span>
								<xsl:if test="string(number($posts-tweet-count-tendance)) != 'NaN' and string(number($posts-tweet-count-tendance)) != 'Infinity'">
									<span class="arrow">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$posts-tweet-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$posts-tweet-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:otherwise>arrow equal</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</span>
									<span class="percent"><xsl:value-of select="$posts-tweet-count-tendance-sign"/><xsl:value-of select="substring($posts-tweet-count-tendance,1,6)"/>%</span>
								</xsl:if>
								<span class="inlineClear"></span>
							</div>
							<div class="line">
								<span class="icon pictures"></span>
								<span class="value"><xsl:value-of select="$posts-image-count-average"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $posts-image-count-resource)"/></span>
								<xsl:if test="string(number($posts-image-count-tendance)) != 'NaN' and string(number($posts-image-count-tendance)) != 'Infinity'">
									<span class="arrow ">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$posts-image-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$posts-image-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:otherwise>arrow equal</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</span>
									<span class="percent"><xsl:value-of select="$posts-image-count-tendance-sign"/><xsl:value-of select="substring($posts-image-count-tendance,1,6)"/>%</span>
								</xsl:if>
								<span class="inlineClear">
								</span>
							</div>
							<div class="line">
								<span class="icon links"></span>
								<span class="value"><xsl:value-of select="$posts-link-count-average"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $posts-link-count-resource)"/></span>
								<xsl:if test="string(number($posts-link-count-tendance)) != 'NaN' and string(number($posts-link-count-tendance)) != 'Infinity'">
									<span class="">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$posts-link-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$posts-link-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:otherwise>arrow equal</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</span>
									<span class="percent"><xsl:value-of select="$posts-link-count-tendance-sign"/><xsl:value-of select="substring($posts-link-count-tendance,1,6)"/>%</span>
								</xsl:if>
								<span class="inlineClear"></span>
							</div>
							<div class="line">
								<span class="icon documents"></span>
								<span class="value"><xsl:value-of select="$posts-file-count-average"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $posts-file-count-resource)"/></span>
								<xsl:if test="string(number($posts-file-count-tendance)) != 'NaN' and string(number($posts-file-count-tendance)) != 'Infinity' and string(number($posts-file-count-tendance)) != '-Infinity'">
									<span class="arrow ">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$posts-file-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$posts-file-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:otherwise>arrow equal</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</span>
									<span class="percent"><xsl:value-of select="$posts-file-count-tendance-sign"/><xsl:value-of select="substring($posts-file-count-tendance,1,6)"/>%</span>
								</xsl:if>
								<span class="inlineClear">
								</span>
							</div>-->
							
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
		
						<!--variable declaration-->
						<xsl:variable name="actions-count-average" select="round($old-actions-count div $nbr-interval)"/>
						<xsl:variable name="actions-like-count-average" select="round($old-actions-like-count div $nbr-interval)"/>
						<xsl:variable name="actions-comment-count-average" select="round($old-actions-comment-count div $nbr-interval)"/>
						
						<xsl:variable name="actions-count-tendance" select="round(($actions-count*100 div $actions-count-average) ) -100"/>
						<xsl:variable name="actions-like-count-tendance" select="round(($actions-like-count*100 div $actions-like-count-average) ) -100"/>
						<xsl:variable name="actions-comment-count-tendance" select="round(($actions-comment-count*100 div $actions-comment-count-average) ) -100"/>
						<xsl:variable name="actions-count-tendance-sign">
							<xsl:choose>
								<xsl:when test="$actions-count-tendance >= 0">+</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="actions-like-count-tendance-sign">
							<xsl:choose>
								<xsl:when test="$actions-like-count-tendance > 0">+</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="actions-comment-count-tendance-sign">
							<xsl:choose>
								<xsl:when test="$actions-comment-count-tendance > 0">+</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:variable name="actions-count-resource">
							<xsl:choose>
								<xsl:when test="$actions-count &lt;= 1">AdminHome_Reaction</xsl:when>
								<xsl:otherwise>AdminHome_Reactions</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="actions-count-average-resource">
							<xsl:choose>
								<xsl:when test="$actions-count-average &lt;= 1">AdminHome_Reaction</xsl:when>
								<xsl:otherwise>AdminHome_Reactions</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<!--<xsl:variable name="actions-like-count-resource">
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
						</xsl:variable>-->
						<div class="top">
							<div class="icon reactions">
							</div>
							<div class="number" style="font-size:30px">
								<xsl:if test="string(number($actions-count-tendance)) != 'NaN' and string(number($actions-count-tendance)) != 'Infinity' and string(number($actions-count-tendance)) != '-Infinity'">
											<xsl:value-of select="$actions-count-tendance-sign"/><xsl:value-of select="substring($actions-count-tendance,1,6)"/>%
								</xsl:if>
							</div>
							<div class="trend">
								<span class="num" style="color:#777777;font-size:11px;"><xsl:value-of select="$actions-count"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $actions-count-resource)"/></span>
								<xsl:if test="string(number($actions-count-tendance)) != 'NaN' and string(number($actions-count-tendance)) != 'Infinity' and string(number($actions-count-tendance)) != '-Infinity'">
									<span class="arrow" style="float:left; margin-right:5px;">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$actions-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$actions-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:when test="$actions-count-tendance = 0">arrow equal</xsl:when>
											</xsl:choose>
										</xsl:attribute>
									</span>
								</xsl:if>
							</div>
							<div class="clear">
							</div>
						</div>
						
						<div class="trendWrapper">
							
							<div class="trendDesc" style="text-align:left;">
								<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_GlobalAverage')"/>
							</div>
							<div class="lineWrapper" style="margin-top:-5px;">
								<div class="line">
									<span class="value">
										<xsl:choose>
											<xsl:when test="string(number($actions-count-average)) != 'NaN' and string(number($actions-count-average)) != 'Infinity' and string(number($actions-count-average)) != '-Infinity'">
												<xsl:value-of select="$actions-count-average"/> 
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose> 
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $actions-count-average-resource)"/>
									</span>
								</div>
							</div>
						</div>
						
						<!--<div class="top">
							<div class="icon reactions">
							</div>
							<div class="number">
											<xsl:value-of select="$actions-count-average"/></div>
							<div class="desc"><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $actions-count-resource)"/></div>
							<div class="trend">
								<xsl:if test="string(number($actions-count-tendance)) != 'NaN' and string(number($actions-count-tendance)) != 'Infinity' and string(number($actions-count-tendance)) != '-Infinity'">
									<span class="num"><xsl:value-of select="$actions-count-tendance-sign"/><xsl:value-of select="substring($actions-count-tendance,1,6)"/>%</span>
									<span class="arrow">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$actions-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$actions-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:otherwise>arrow equal</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</span>
								</xsl:if>
							</div>
							<div class="clear">
							</div>
						</div>
						<div class="lineWrapper">
							<div class="line">
								<span class="icon likes"></span>
								<span class="value"><xsl:value-of select="$actions-like-count-average"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $actions-like-count-resource)"/></span>
								<xsl:if test="string(number($actions-like-count-tendance)) != 'NaN' and string(number($actions-like-count-tendance)) != 'Infinity' and string(number($actions-like-count-tendance)) != '-Infinity'">
									<span class="arrow">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$actions-like-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$actions-like-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:otherwise>arrow equal</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</span>
									<span class="percent"><xsl:value-of select="$actions-like-count-tendance-sign"/><xsl:value-of select="substring($actions-like-count-tendance,1,6)"/>%</span>
								</xsl:if>
								<span class="inlineClear"></span>
							</div>
							<div class="line">
								<span class="icon comments"></span>
								<span class="value"><xsl:value-of select="$actions-comment-count-average"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $actions-comment-count-resource)"/></span>
								<xsl:if test="string(number($actions-comment-count-tendance)) != 'NaN' and string(number($actions-comment-count-tendance)) != 'Infinity'">
									<span class="arrow ">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$actions-comment-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$actions-comment-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:otherwise>arrow equal</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</span>
									<span class="percent"><xsl:value-of select="$actions-comment-count-tendance-sign"/><xsl:value-of select="substring($actions-comment-count-tendance,1,6)"/>%</span>
								</xsl:if>
								<span class="inlineClear">
								</span>
							</div>
						</div>-->
					</div>
					<div class="col">
						<!--variable declaration-->
						<xsl:variable name="communities-count" >
							<xsl:choose>
								<xsl:when test="sum(/Hoozin/NewDataSet/LOG_COMMUNITIES_HISTORY/Count) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/LOG_COMMUNITIES_HISTORY/Count)"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="communities-public-count" >
							<xsl:choose>
								<xsl:when test="sum(/Hoozin/NewDataSet/LOG_COMMUNITIES_HISTORY[Type = 'Public']/Count) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/LOG_COMMUNITIES_HISTORY[Type = 'Public']/Count)"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="communities-private-count"  >
							<xsl:choose>
								<xsl:when test="sum(/Hoozin/NewDataSet/LOG_COMMUNITIES_HISTORY[Type = 'Private']/Count) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/LOG_COMMUNITIES_HISTORY[Type = 'Private']/Count)"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="communities-hidden-count"  >
							<xsl:choose>
								<xsl:when test="sum(/Hoozin/NewDataSet/LOG_COMMUNITIES_HISTORY[Type = 'Hidden']/Count) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/LOG_COMMUNITIES_HISTORY[Type = 'Hidden']/Count)"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="old-communities-count" select="sum(/Hoozin/NewDataSet/LOG_COMMUNITIES_HISTORY/Change)"/>
						<xsl:variable name="old-communities-public-count" select="sum(/Hoozin/NewDataSet/LOG_COMMUNITIES_HISTORY[Type = 'Public']/Change)"/>
						<xsl:variable name="old-communities-private-count" select="sum(/Hoozin/NewDataSet/LOG_COMMUNITIES_HISTORY[Type = 'Private']/Change)"/>
						<xsl:variable name="old-communities-hidden-count" select="sum(/Hoozin/NewDataSet/LOG_COMMUNITIES_HISTORY[Type = 'Hidden']/Change)"/>
		
						
						<!--variable declaration-->
						<xsl:variable name="communities-count-average" select="round($old-communities-count div $nbr-interval)"/>
						<xsl:variable name="communities-public-count-average" select="round($old-communities-public-count div $nbr-interval)"/>
						<xsl:variable name="communities-private-count-average" select="round($old-communities-private-count div $nbr-interval)"/>
						<xsl:variable name="communities-hidden-count-average" select="round($old-communities-hidden-count div $nbr-interval)"/>
						
						<xsl:variable name="communities-count-tendance" select="round(($communities-count*100 div $communities-count-average) ) -100"/>
						<xsl:variable name="communities-public-count-tendance" select="round(($communities-public-count *100 div $communities-public-count-average) ) -100"/>
						<xsl:variable name="communities-private-count-tendance" select="round(($communities-private-count*100 div $communities-private-count-average) ) -100"/>
						<xsl:variable name="communities-hidden-count-tendance" select="round(($communities-hidden-count*100 div $communities-hidden-count-average) ) -100"/>
						<xsl:variable name="communities-count-tendance-sign">
							<xsl:choose>
								<xsl:when test="$communities-count-tendance >= 0">+</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="communities-public-count-tendance-sign">
							<xsl:choose>
								<xsl:when test="$communities-public-count-tendance > 0">+</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="communities-private-count-tendance-sign">
							<xsl:choose>
								<xsl:when test="$communities-private-count-tendance > 0">+</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="communities-hidden-count-tendance-sign">
							<xsl:choose>
								<xsl:when test="$communities-hidden-count-tendance > 0">+</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:variable name="communities-count-resource">
							<xsl:choose>
								<xsl:when test="$communities-count &lt;= 1">AdminHome_Community</xsl:when>
								<xsl:otherwise>AdminHome_Communities</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="communities-count-average-resource">
							<xsl:choose>
								<xsl:when test="$communities-count-average &lt;= 1">AdminHome_Community</xsl:when>
								<xsl:otherwise>AdminHome_Communities</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<!--<xsl:variable name="communities-public-count-resource">
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
						</xsl:variable>-->
						
						<div class="top">
							<div class="icon communities">
							</div>
							<div class="number" style="font-size:30px">
								<xsl:if test="string(number($communities-count-tendance)) != 'NaN' and string(number($communities-count-tendance)) != 'Infinity' and string(number($communities-count-tendance)) != '-Infinity'">
											<xsl:value-of select="$communities-count-tendance-sign"/><xsl:value-of select="substring($communities-count-tendance,1,6)"/>%
								</xsl:if>
							</div>
							<div class="trend">
								<span class="num" style="color:#777777;font-size:11px;"><xsl:value-of select="$communities-count"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $communities-count-resource)"/></span>
								<xsl:if test="string(number($communities-count-tendance)) != 'NaN' and string(number($communities-count-tendance)) != 'Infinity' and string(number($communities-count-tendance)) != '-Infinity'">
									<span class="arrow" style="float:left; margin-right:5px;">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$communities-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$communities-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:when test="$communities-count-tendance = 0">arrow equal</xsl:when>
											</xsl:choose>
										</xsl:attribute>
									</span>
								</xsl:if>
							</div>
							<div class="clear">
							</div>
						</div>
						
						<div class="trendWrapper">
							
							<div class="trendDesc" style="text-align:left;">
								<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_GlobalAverage')"/>
							</div>
							<div class="lineWrapper" style="margin-top:-5px;">
								<div class="line">
									<span class="value">
										<xsl:choose>
											<xsl:when test="string(number($communities-count-average)) != 'NaN' and string(number($communities-count-average)) != 'Infinity' and string(number($communities-count-average)) != '-Infinity'">
												<xsl:value-of select="$communities-count-average"/> 
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose> 
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $communities-count-average-resource)"/>
									</span>
								</div>
							</div>
						</div>

						<!--<div class="top">
							<div class="icon communities">
							</div>
							<div class="number">
											<xsl:value-of select="$communities-count-average"/></div>
							<div class="desc"><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $communities-count-resource)"/></div>
							<div class="trend">
								<xsl:if test="string(number($communities-count-tendance)) != 'NaN' and string(number($communities-count-tendance)) != 'Infinity' and string(number($communities-count-tendance)) != '-Infinity'">
									<span class="num"><xsl:value-of select="$communities-count-tendance-sign"/><xsl:value-of select="substring($communities-count-tendance,1,6)"/>%</span>
									<span class="arrow">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$communities-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$communities-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:otherwise>arrow equal</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</span>
								</xsl:if>
							</div>
							<div class="clear">
							</div>
						</div>
						<div class="lineWrapper">
							<div class="line">
								<span class="icon public"></span>
								<span class="value"><xsl:value-of select="$communities-public-count-average"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $communities-public-count-resource)"/></span>
								<xsl:if test="string(number($communities-public-count-tendance)) != 'NaN' and string(number($communities-public-count-tendance)) != 'Infinity' and string(number($communities-public-count-tendance)) != '-Infinity'">
									<span class="arrow">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$communities-public-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$communities-public-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:otherwise>arrow equal</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</span>
									<span class="percent"><xsl:value-of select="$communities-public-count-tendance-sign"/><xsl:value-of select="substring($communities-public-count-tendance,1,6)"/>%</span>
								</xsl:if>
								<span class="inlineClear"></span>
							</div>
							<div class="line">
								<span class="icon private"></span>
								<span class="value"><xsl:value-of select="$communities-private-count-average"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $communities-private-count-resource)"/></span>
								<xsl:if test="string(number($communities-private-count-tendance)) != 'NaN' and string(number($communities-private-count-tendance)) != 'Infinity'">
									<span class="arrow ">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$communities-private-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$communities-private-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:otherwise>arrow equal</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</span>
									<span class="percent"><xsl:value-of select="$communities-private-count-tendance-sign"/><xsl:value-of select="substring($communities-private-count-tendance,1,6)"/>%</span>
								</xsl:if>
								<span class="inlineClear">
								</span>
							</div>
							<div class="line">
								<span class="icon hidden"></span>
								<span class="value"><xsl:value-of select="$communities-hidden-count-average"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $communities-hidden-count-resource)"/></span>
								<xsl:if test="string(number($communities-hidden-count-tendance)) != 'NaN' and string(number($communities-hidden-count-tendance)) != 'Infinity' and string(number($communities-hidden-count-tendance)) != '-Infinity'">
									<span class="">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$communities-hidden-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$communities-hidden-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:otherwise>arrow equal</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</span>
									<span class="percent"><xsl:value-of select="$communities-hidden-count-tendance-sign"/><xsl:value-of select="substring($communities-hidden-count-tendance,1,6)"/>%</span>
								</xsl:if>
								<span class="inlineClear"></span>
							</div>
						</div>-->
					</div>
					<div class="col">
						<xsl:variable name="discussions-count">
							<xsl:choose>
								<xsl:when test="sum(/Hoozin/NewDataSet/DISCUSSIONS/DiscussionsCount) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/DISCUSSIONS/DiscussionsCount)"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="discussions-discussions-count" >
							<xsl:choose>
								<xsl:when test="sum(/Hoozin/NewDataSet/DISCUSSIONS[IsPrivate = 'true']/DiscussionsCount) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/DISCUSSIONS[IsPrivate = 'true']/DiscussionsCount)"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="discussions-conversation-count">
							<xsl:choose>
								<xsl:when test="sum(/Hoozin/NewDataSet/DISCUSSIONS[IsPrivate = 'false']/DiscussionsCount) != ''"><xsl:value-of select="sum(/Hoozin/NewDataSet/DISCUSSIONS[IsPrivate = 'false']/DiscussionsCount)"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="old-discussions-count" select="sum(/Hoozin/NewDataSet/DISCUSSIONS/Change)"/>
						<xsl:variable name="old-discussions-discussions-count" select="sum(/Hoozin/NewDataSet/DISCUSSIONS[IsPrivate = 'true']/Change)"/>
						<xsl:variable name="old-discussions-conversation-count" select="sum(/Hoozin/NewDataSet/DISCUSSIONS[IsPrivate = 'false']/Change)"/>
		
						<xsl:variable name="discussions-count-average" select="round($old-discussions-count div $nbr-interval)"/>
						<xsl:variable name="discussions-discussions-count-average" select="round($old-discussions-discussions-count div $nbr-interval)"/>
						<xsl:variable name="discussions-conversation-count-average" select="round($old-discussions-conversation-count div $nbr-interval)"/>
						
						<xsl:variable name="discussions-count-tendance" select="round(($discussions-count*100 div $discussions-count-average) ) -100"/>
						<xsl:variable name="discussions-discussions-count-tendance" select="round(($discussions-discussions-count*100 div $discussions-discussions-count-average) ) -100"/>
						<xsl:variable name="discussions-conversation-count-tendance" select="round(($discussions-conversation-count*100 div $discussions-conversation-count-average) ) -100"/>
						<xsl:variable name="discussions-count-tendance-sign">
							<xsl:choose>
								<xsl:when test="$discussions-count-tendance >= 0">+</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="discussions-discussions-count-tendance-sign">
							<xsl:choose>
								<xsl:when test="$discussions-discussions-count-tendance > 0">+</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="discussions-conversation-count-tendance-sign">
							<xsl:choose>
								<xsl:when test="$discussions-conversation-count-tendance > 0">+</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:variable name="discussions-count-resource">
							<xsl:choose>
								<xsl:when test="$discussions-count &lt;= 1">AdminHome_Discussion</xsl:when>
								<xsl:otherwise>AdminHome_Discussions</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="discussions-count-average-resource">
							<xsl:choose>
								<xsl:when test="$discussions-count-average &lt;= 1">AdminHome_Discussion</xsl:when>
								<xsl:otherwise>AdminHome_Discussions</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<!--<xsl:variable name="discussions-discussions-count-resource">
							<xsl:choose>
								<xsl:when test="$discussions-discussions-count &lt;= 1">AdminHome_DiscussionsDiscussion</xsl:when>
								<xsl:otherwise>AdminHome_DiscussionsDiscussions</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="discussions-conversation-count-resource">
							<xsl:choose>
								<xsl:when test="$discussions-conversation-count &lt;= 1">AdminHome_Conversation</xsl:when>
								<xsl:otherwise>AdminHome_Conversation</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>-->
						
						
						<div class="top">
							<div class="icon discussions">
							</div>
							<div class="number" style="font-size:30px">
								<xsl:if test="string(number($discussions-count-tendance)) != 'NaN' and string(number($discussions-count-tendance)) != 'Infinity' and string(number($discussions-count-tendance)) != '-Infinity'">
											<xsl:value-of select="$discussions-count-tendance-sign"/><xsl:value-of select="substring($discussions-count-tendance,1,6)"/>%
								</xsl:if>
							</div>
							<div class="trend">
								<span class="num" style="color:#777777;font-size:11px;"><xsl:value-of select="$discussions-count"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $discussions-count-resource)"/></span>
								<xsl:if test="string(number($discussions-count-tendance)) != 'NaN' and string(number($discussions-count-tendance)) != 'Infinity' and string(number($discussions-count-tendance)) != '-Infinity'">
									<span class="arrow" style="float:left; margin-right:5px;">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$discussions-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$discussions-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:when test="$discussions-count-tendance = 0">arrow equal</xsl:when>
											</xsl:choose>
										</xsl:attribute>
									</span>
								</xsl:if>
							</div>
							<div class="clear">
							</div>
						</div>
						
						<div class="trendWrapper">
							
							<div class="trendDesc" style="text-align:left;">
								<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_GlobalAverage')"/>
							</div>
							<div class="lineWrapper" style="margin-top:-5px;">
								<div class="line">
									<span class="value">
										<xsl:choose>
											<xsl:when test="string(number($discussions-count-average)) != 'NaN' and string(number($discussions-count-average)) != 'Infinity' and string(number($discussions-count-average)) != '-Infinity'">
												<xsl:value-of select="$discussions-count-average"/> 
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose> 
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $discussions-count-average-resource)"/>
									</span>
								</div>
							</div>
						</div>
						
						<!--<div class="top">
							<div class="icon discussions">
							</div>
							<div class="number">
											<xsl:value-of select="$discussions-count-average"/> </div>
							<div class="desc"><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $discussions-count-resource)"/></div>
							<div class="trend">
								<xsl:if test="string(number($discussions-count-tendance)) != 'NaN' and string(number($discussions-count-tendance)) != 'Infinity' and string(number($discussions-count-tendance)) != '-Infinity'">
								<span class="num"><xsl:value-of select="$discussions-count-tendance-sign"/><xsl:value-of select="substring($discussions-count-tendance,1,6)"/>%</span>
								<span class="arrow">
									<xsl:attribute name="class">
										<xsl:choose>
											<xsl:when test="$discussions-count-tendance &gt; 0">arrow up</xsl:when>
											<xsl:when test="$discussions-count-tendance &lt; 0">arrow down</xsl:when>
											<xsl:otherwise>arrow equal</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</span>
								</xsl:if>
							</div>
							<div class="clear">
							</div>
						</div>
						<div class="lineWrapper">
							<div class="line">
								<span class="value"><xsl:value-of select="$discussions-discussions-count-average"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $discussions-discussions-count-resource)"/></span>
								<xsl:if test="string(number($discussions-discussions-count-tendance)) != 'NaN' and string(number($discussions-discussions-count-tendance)) != 'Infinity'">
									<span class="arrow">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$discussions-discussions-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$discussions-discussions-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:otherwise>arrow equal</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</span>
									<span class="percent"><xsl:value-of select="$discussions-discussions-count-tendance-sign"/><xsl:value-of select="substring($discussions-discussions-count-tendance,1,6)"/>%</span>
								</xsl:if>
								<span class="inlineClear"></span>
							</div>
							<div class="line">
								<span class="value"><xsl:value-of select="$discussions-conversation-count-average"/> <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $discussions-conversation-count-resource)"/></span>
								<xsl:if test="string(number($discussions-conversation-count-tendance)) != 'NaN' and string(number($discussions-conversation-count-tendance)) != 'Infinity' and string(number($discussions-conversation-count-tendance)) != '-Infinity'">
									<span class="arrow ">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$discussions-conversation-count-tendance &gt; 0">arrow up</xsl:when>
												<xsl:when test="$discussions-conversation-count-tendance &lt; 0">arrow down</xsl:when>
												<xsl:otherwise>arrow equal</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</span>
									<span class="percent"><xsl:value-of select="$discussions-conversation-count-tendance-sign"/><xsl:value-of select="substring($discussions-conversation-count-tendance,1,6)"/>%</span>
								</xsl:if>
								<span class="inlineClear">
								</span>
							</div>
						</div>-->
					</div>
					
					<div class="clear">
					</div>
				</div>
				<div class="kpiFooter">
					<div class="trendDesc">
						// <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', concat('AdminHome_TrendExplanation', $interval))"/>
					</div>
				</div>
			</div>

		</div>

	</xsl:template>

</xsl:stylesheet>
