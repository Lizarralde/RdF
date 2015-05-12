<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">

	<xsl:output indent="no" method="html"/>

	<!-- Includes list -->
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/global.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/includes/small-templates.xslt" />

	<xsl:template match="/Hoozin">

		<xsl:variable name="connected-users-count" select="./ActualConnectionsCount"/>
		<xsl:if test="$isCallBack = 'False'">

			<script type="text/javascript">

				$(function () {
					
				});

			</script>

		</xsl:if>


		<div id="{$webpart_id}_content">

			<div class="kpiWrapper" id="connectedUsersLiveTop">

				<div class="kpiHeader noBorder">
					<div class="dateSelected" style="right:12px;">
						<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_Now')"/>
					</div>
				</div>

				<div class="kpiContent">

					<div class="theNumberWrapper">
						<div class="theNumber">
							<xsl:value-of select="$connected-users-count"/>
						</div>
						<div class="theChapo">
							<span class="greenSquare"></span>
							<xsl:choose>
								<xsl:when test="$connected-users-count > 1">
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_ConnectedUsers')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', 'AdminHome_ConnectedUser')"/>
								</xsl:otherwise>
							</xsl:choose>
						</div>
					</div>

				</div>


			</div>


		</div>

	</xsl:template>

</xsl:stylesheet>
