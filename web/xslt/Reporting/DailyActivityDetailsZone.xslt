<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
	<xsl:param name="selected"/>
	<xsl:param name="register"/>
	<xsl:param name="title"/>
	<xsl:param name="requestedData"/>

	<xsl:output indent="no" method="html"/>

	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/small-templates.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/formatterChartXml.xslt"/>

	<xsl:template match="/Hoozin">

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

		<xsl:variable name="var-node-temp">
			<xsl:apply-templates select="$chart-template[@name='hoozin-daily-activity-details']">
				<xsl:with-param name ="node" select="."/>

			</xsl:apply-templates>

		</xsl:variable>
		<xsl:variable name="var-node-temp2">
			<xsl:for-each select="msxsl:node-set($var-node-temp)/Hoozin/NewDataSet/Table">
				<xsl:sort select="(./ConnectionsCount+./PostsCount+./ActionsCount)" data-type="number" order="descending"/>
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:variable>

		<div id="{$webpart_id}_content">

			<div class="kpiWrapper topper" id="{$register}" data-toppers-count="10" style="height:auto;">

				<div class="kpiHeader">
					<script type="text/javascript">
						$(function () {
							hoozin.KPI.TopperZone.clearEntities("<xsl:value-of select="$register"/>");
							<xsl:for-each select="msxsl:node-set($var-node-temp2)//Table">
								<xsl:variable name="for-hour" select="./XAxis"/>
								<xsl:variable name="for-hour-with-label">
								<xsl:choose>
										<xsl:when test="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'HoozinAdminHome_CurrentCulture') = 'English'">
											<xsl:choose>
												<xsl:when test="$for-hour > 12"><xsl:value-of select="$for-hour -12"/> pm</xsl:when>
												<xsl:otherwise><xsl:value-of select="$for-hour"/> am</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise><xsl:value-of select="$for-hour"/><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'HoozinAdminHome_Hour')"/></xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="for-posts-count">
									<xsl:choose>
										<xsl:when test="./PostsCount != ''"><xsl:value-of select="./PostsCount"/></xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="for-actions-count">
									<xsl:choose>
										<xsl:when test="./ActionsCount != ''"><xsl:value-of select="./ActionsCount"/></xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="for-connections-count">
									<xsl:choose>
										<xsl:when test="./ConnectionsCount != ''"><xsl:value-of select="./ConnectionsCount"/></xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
									hoozin.KPI.TopperZone.addEntity("<xsl:value-of select="$register"/>", {
																								id:"<xsl:value-of select="$for-hour-with-label"/>",
																								postsCount:<xsl:value-of select="$for-posts-count"/>,
																								actionsCount:<xsl:value-of select="$for-actions-count"/>,
																								connectionsCount:<xsl:value-of select="$for-connections-count"/>
																								}, hoozin.KPI.TopperZone.setDailyActivityInfo );
							</xsl:for-each>
						});
					</script>
					<span class="kpiIcon"></span>
					<h2><xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $title)"/></h2>
				</div>

				<div class="kpiContent" style="height: 290px;">

						<xsl:variable name="var-node" select="msxsl:node-set($var-node-temp2)//Table[1]"/>


						<xsl:variable name="post-label" >
							<xsl:choose>
								<xsl:when test="msxsl:node-set($var-node)/PostsCount > 1">AdminHome_Posts</xsl:when>
								<xsl:otherwise>AdminHome_Post</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="action-label" >
							<xsl:choose>
								<xsl:when test="msxsl:node-set($var-node)/ActionsCount > 1">AdminHome_Reactions</xsl:when>
								<xsl:otherwise>AdminHome_Reaction</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="connection-label" >
							<xsl:choose>
								<xsl:when test="msxsl:node-set($var-node)/ConnectionsCount > 1">AdminHome_Connections</xsl:when>
								<xsl:otherwise>AdminHome_Connection</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>


					<div class="theNumberWrapper col" style="width:100%">
							<div class="theNumber" style="text-align:left;font-size:54px">
								<xsl:choose>
									<xsl:when test="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'HoozinAdminHome_CurrentCulture') = 'English'">
										<xsl:choose>
											<xsl:when test="msxsl:node-set($var-node)/XAxis > 12">
											<xsl:value-of select="msxsl:node-set($var-node)/XAxis -12"/> pm
										</xsl:when>
											<xsl:otherwise>
											<xsl:value-of select="msxsl:node-set($var-node)/XAxis"/> am
										</xsl:otherwise>
										</xsl:choose>

									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="msxsl:node-set($var-node)/XAxis"/>
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'HoozinAdminHome_Hour')"/>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<div class="theChapo">
								<b>
									<xsl:value-of select="pxs:ReplaceString(pxs:GetResource('Prexens.Hoozin.Sharepoint', 'DailyActivityDetailsZone_StrongInfluence'), '{0}', concat('1',pxs:GetResource('Prexens.Hoozin.Sharepoint', 'DailyActivityDetailsZone_First')))"/>
								</b>
							</div>


							<div class="lineWrapper">
								<div class="line">
									<span class="icon posts"/>
									<span class="value posts">
										<xsl:choose>
											<xsl:when test="string(number(msxsl:node-set($var-node)/PostsCount)) != 'NaN' and string(number(msxsl:node-set($var-node)/PostsCount)) != 'Infinity' and string(number(msxsl:node-set($var-node)/PostsCount)) != '-Infinity'">
												<xsl:value-of select="msxsl:node-set($var-node)/PostsCount"/> 
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose> 
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $post-label)"/>
									</span>
									<span class="inlineClear"></span>
								</div>
								<div class="line">
									<span class="icon comments"/>
									<span class="value actions">
										<xsl:choose>
											<xsl:when test="string(number(msxsl:node-set($var-node)/ActionsCount)) != 'NaN' and string(number(msxsl:node-set($var-node)/ActionsCount)) != 'Infinity' and string(number(msxsl:node-set($var-node)/ActionsCount)) != '-Infinity'">
												<xsl:value-of select="msxsl:node-set($var-node)/ActionsCount"/> 
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose> 
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $action-label)"/>
									</span>
									<span class="inlineClear"></span>
								</div>
								<div class="line">
									<span class="icon registers"/>
									<span class="value connections">
										<xsl:choose>
											<xsl:when test="string(number(msxsl:node-set($var-node)/ConnectionsCount)) != 'NaN' and string(number(msxsl:node-set($var-node)/ConnectionsCount)) != 'Infinity' and string(number(msxsl:node-set($var-node)/ConnectionsCount)) != '-Infinity'">
												<xsl:value-of select="msxsl:node-set($var-node)/ConnectionsCount"/> 
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose> 
										<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $connection-label)"/>
									</span>
									<span class="inlineClear"></span>
								</div>
							</div>

						</div>
					
					<div class="clear">
					</div>
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
