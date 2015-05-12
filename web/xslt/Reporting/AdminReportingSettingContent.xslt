<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">

	<xsl:output indent="no" method="html"/>

	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/Includes/global.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/Includes/small-templates.xslt" />


	<xsl:template match="/Hoozin/Dates">


		<script type="text/javascript">
			
			var callbackSuccess = function(response){
				
				hoozin.UI.addObjectToLoad(null, 'contentZone');
				hoozin.UI.refresh(null, null, null, null, function() {

					hoozin.Confirm.openConfirm(
					{
						title:'<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.SharePoint','AdminReportingSettingContent_SuccessTitle')"/>', 
						isClosable:false,
						message: '<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.SharePoint','AdminReportingSettingContent_SuccessMessage')"/>',
						buttons:
							[
								{buttonLabel:'Ok', buttonClass:'btn-validation', buttonFunction:
									function() {
										hoozin.Confirm.closeConfirm();
										hoozin.Popup.close();
									}
								}
							]
						}
					);
					
					
				});
				
				
			}
			var callbackError = function(response){
				hoozin.Confirm.openConfirm(
					{
						title:'<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.SharePoint','AdminReportingSettingContent_ErrorTitle')"/>', 
						isClosable:false,
						message: response + '.',
						buttons:
							[
								{buttonLabel:'Ok', buttonClass:'btn-validation', buttonFunction:
									function() {
										hoozin.Confirm.closeConfirm();
										hoozin.Popup.close();
									}
								}
							]
					}
				);
			}
			
			$(function () {
			
				hoozin.Interface.activeSubMenu('statsSettingLink');

				hoozin.UI.register(
					"contentZone",
					"statisticSetting",
					"<xsl:value-of select="$webpart_storagekey" />",
					null,
					"<xsl:value-of select="$current_page_serverrelativeurl" />"
				);
		
				$("#submitButton").on('click', function () {

					errorArray = new Array();
					var checkbox = $('#datesCheck input:checked');
					var dates = new Array();
				
								
					checkbox.each(function(index){
						dates[index] = $(this).attr('id');
					});
				
					hoozin.Popup.open ({
						title : '<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.SharePoint','AdminReportingSettingContent_WaitingTitle')"/>',
						message : '<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.SharePoint','AdminReportingSettingContent_WaitingMessage')"/>',
						isClosable : false,
						showLoadingIcon : true,
						popupType : 'center'
					});

					hoozin.Factory.daysReprovisioning(dates, callbackSuccess, callbackError);
				
				}); /* END CLICK EVENT */
			});
		</script>
		



		<fieldset class="hoozinFielset noLine noPadding" style="margin-top:0px;">

			<table class="legendDiv" style="margin-bottom: 10px;">
				<tr>
					<td class="roundNumber empty">
					</td>
					<td class="title">
						<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.SharePoint','AdminReportingSettingContent_Title')"/>
						<span class="titleDesc">
						</span>
					</td>
				</tr>
			</table>

			<div class="inputBlock">
				<div class="labelWrapper">
					<label>
						<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.SharePoint','AdminReportingSettingContent_ReprovisionDays')"/>
					</label>
				</div>
				<div class="inputWrapper">
					<div class="checkboxButtonsWrapper" id="datesCheck">
						<xsl:for-each select="//Dates/Date">
							<xsl:variable name="current-date" select="pxs:FormatDateTimeWithCulture(./Previous, '_dd-M-yyyy', pxs:CurrentUICulture())"/>
							<label class="chooseboxStyle">
								<xsl:attribute name="for">
									<xsl:value-of select="$current-date"/>
								</xsl:attribute>
								<input name="dateCheck" checked="" type="checkbox">
									<xsl:attribute name="id">
										<xsl:value-of select="$current-date"/>
									</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:value-of select="pxs:FormatDateTimeWithCulture(./Previous, 'dd MMMM yyyy', pxs:CurrentUICulture())"/>
									</xsl:attribute>
								</input>
								<span class="box"></span>
								<xsl:value-of select="pxs:FormatDateTimeWithCulture(./Previous, 'dd MMMM yyyy', pxs:CurrentUICulture())"/>
							</label>
							<br/>
						</xsl:for-each>

					</div>
					<div class="testsprite"></div>
				</div>
				<div class="clear"></div>
			</div>
		</fieldset>

		<div class="inputBlockButton">
			<input id="submitButton" class="btn btn-primary" type="button">
				<xsl:attribute name="value">
					<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.SharePoint', 'AdminReportingSettingContent_ProvisioningButton')"/>
				</xsl:attribute>
			</input>
		</div>

	</xsl:template>

	<xsl:template match="/Hoozin/Warning[. != '']">
		<fieldset class="hoozinFielset noLine noPadding" style="margin-top:0px;">

			<table class="legendDiv" style="margin-bottom: 10px;">
				<tr>
					<td class="roundNumber empty">
					</td>
					<td class="title">
						<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.SharePoint','AdminReportingSettingContent_Title')"/>
						<span class="titleDesc">
						</span>
					</td>
				</tr>
			</table>
			<div class="alert alert-info">
				<p>
				<xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', .)"/>.
			</p>
			</div>
		</fieldset>
	</xsl:template>
</xsl:stylesheet>
