<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pxs="http://xml.prexens.com/">

	<msxsl:script language="C#" implements-prefix="pxs">
  <msxsl:assembly name="Prexens.Hoozin, Version=1.0.0.0, Culture=neutral, PublicKeyToken=2a934fc9c35df255" />
  <msxsl:assembly name="Prexens.Hoozin.SharePoint, Version=2.0.0.0, Culture=neutral, PublicKeyToken=c6306360fc636a22" />
  <msxsl:using namespace="Prexens.Hoozin.SharePoint"/>
    

    <![CDATA[
    
      public static string FormatDataPie(string dataXPath, XPathNavigator node, string type, string colors)
      {
        return Prexens.Hoozin.Utility.ChartXsltUtils.FormatDataPie(dataXPath, node, type, colors);
      }
      
      public static string FormatDataMultiSeries(string dataXPath, XPathNavigator node, bool datetimeZoomable, string groupedColumnOrBar, string type, string colors, int average, int interval, int page, int limit)
      {
        return Prexens.Hoozin.Utility.ChartXsltUtils.FormatDataMultiSeries(dataXPath, node, datetimeZoomable, groupedColumnOrBar, type, colors, average, interval, page, limit);
      }
      
      public static string FormatXAxis(string dataXPath, XPathNavigator node, int localeId, int interval)
      {
        return Prexens.Hoozin.Utility.ChartXsltUtils.FormatXAxis(dataXPath, node, localeId, interval);
      }
      
      public static string GetFirstDate(string dataXPath, XPathNavigator node)
      {
        return Prexens.Hoozin.Utility.ChartXsltUtils.GetFirstDate(dataXPath, node);
      }
    
      public static string FormatDataPie(string names, string dataXPath, string colors, XPathNavigator node, string persons)
      {
        return ChartsUtils.FormatDataPie(names, dataXPath, colors, node, persons);
      }
      
      public static string FormatData(string names, string dataXPath, XPathNavigator node, string colors)
      {
        return ChartsUtils.FormatData(names, dataXPath, node, colors);
      }
      
      public static string FormatDataRegularTime(string names, string dataXPath, XPathNavigator node, string start, string interval, string colors)
      {
        return ChartsUtils.FormatDataRegularTime(names, dataXPath, node, start, interval, colors);
      }
      
      public static string FormatDataIrregularTime(string names, string dataXPath, XPathNavigator node, string colors, string type, string timeXPath)
      {
        return ChartsUtils.FormatDataIrregularTime(names, dataXPath, node, colors, type, timeXPath);
      }
      
      public static string CheckXPath(string xpath)
      {
        return xpath.Replace("\"", "'");
      }
      
      public static string GetDate()
      {
        return ChartsUtils.GetDate();
      }
      
      public static string GetTimeCategories(XPathNavigator node, string timeXPath)
      {
        return ChartsUtils.GetTimeCategories(node, timeXPath);
      }
      
      public static int GetDuration(string duration)
      {
        return ChartsUtils.GetDuration(duration);
      }
      
      public static string FormatSimpleArray(string old)
      {
        return ChartsUtils.FormatSimpleArray(old);
      }

	  ]]>


  </msxsl:script>

	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/Includes/global.xslt" />
	<xsl:include href="/_layouts/Prexens/Hoozin/XSLT/Includes/context.xslt" />

	<xsl:template name="hoozin-chart" >
		<xsl:param name="node" />
		<xsl:param name="container" />
		<xsl:param name="type" />
		<xsl:param name="page" />
		<xsl:param name="limit" />
		<xsl:param name="y-axis-name" />
		<xsl:param name="x-axis-name" />
		<xsl:param name="title" />
		<xsl:param name="sub-title" />
		<xsl:param name="column-stacked"/>
		<xsl:param name="sufix" />
		<xsl:param name="vertical-label-x-axis"/>
		<xsl:param name="show-in-legend"/>
		<xsl:param name="show-tooltip"/>
		<xsl:param name="total-height"/>
		<xsl:param name="total-width"/>
		<xsl:param name="datetime-zoomable"/>
		<xsl:param name="datetime-zoomable-axis"/>
		<xsl:param name="datetime-zoomable-max-zoom" select="14"/>
		<xsl:param name="bands"/>
		<xsl:param name="grouped-column-or-bar"/>
		<xsl:param name="average"/>
		<xsl:param name="background" select="'rgba(255, 255, 255, 0.1)'"/>
		<xsl:param name="border-color"/>
		<xsl:param name="border-radius"/>
		<xsl:param name="class-name"/>
		<xsl:param name="margin-left"/>
		<xsl:param name="margin-top"/>
		<xsl:param name="margin-right"/>
		<xsl:param name="margin-bottom"/>
		<xsl:param name="style"/>
		<xsl:param name="legend-style"/>
		<xsl:param name="colors"/>
		<xsl:param name="serie-name"/>
		<xsl:param name="data-labels"/>
		<xsl:param name="legend-layout"/>
		<xsl:param name="legend-align"/>
		<xsl:param name="legend-vertical-align"/>
		<xsl:param name="navigation"/>
		<xsl:param name="active-color"/>
		<xsl:param name="inactive-color"/>
		<xsl:param name="arrow-size"/>
		<xsl:param name="maxHeightLegend"/>
		<xsl:param name="max-char-in-legend"/>
		<xsl:param name="mini-profile-type"/>
		<xsl:param name="data-labels-distance"/>
		<xsl:param name="data-labels-inside"/>
		<xsl:param name="data-labels-color"/>
		<xsl:param name="total-in-legend"/>
		<xsl:param name="value-in-tooltip"/>
		<xsl:param name="percent-in-tooltip"/>
		<xsl:param name="mini-profile-in-x-axis" select="false()"/>
		<xsl:param name="interval" select="1"/>
		<xsl:param name="marker" select="true()"/>
		<xsl:param name="end-on-tick"/>
		<xsl:param name="y-tick-pixel-interval"/>
		<xsl:param name="tooltip-header-sufix"/>
		<xsl:param name="tooltip-formatter"/>
		<xsl:param name="fill-opacity"/>
		<xsl:param name="add-to-update"/>
		<xsl:param name="get-in-topper"/>
		<xsl:param name="inner-size"/>
		

		<xsl:variable name="bandsNode" select="//BandsDefinitions/BandNode"/>

		<xsl:variable name="var-max-char-in-legend">
			<xsl:choose>
				<xsl:when test="$max-char-in-legend != ''">
					<xsl:value-of select="$max-char-in-legend"/>
				</xsl:when>
				<xsl:otherwise>50</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="var-legend-layout">
			<xsl:choose>
				<xsl:when test="$legend-layout != ''">
					<xsl:value-of select="$legend-layout"/>
				</xsl:when>
				<xsl:otherwise>vertical</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="var-legend-align">
			<xsl:choose>
				<xsl:when test="$legend-align != ''">
					<xsl:value-of select="$legend-align"/>
				</xsl:when>
				<xsl:otherwise>center</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="var-legend-vertical-align">
			<xsl:choose>
				<xsl:when test="$legend-vertical-align != ''">
					<xsl:value-of select="$legend-vertical-align"/>
				</xsl:when>
				<xsl:otherwise>bottom</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="var-maxHeightLegend">
			<xsl:choose>
				<xsl:when test="$maxHeightLegend != ''">
					<xsl:value-of select="$maxHeightLegend"/>
				</xsl:when>
				<xsl:otherwise>50</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="var-active-color">
			<xsl:choose>
				<xsl:when test="$active-color != ''">
					<xsl:value-of select="$active-color"/>
				</xsl:when>
				<xsl:otherwise>#8be801</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="var-inactive-color">
			<xsl:choose>
				<xsl:when test="$inactive-color != ''">
					<xsl:value-of select="$inactive-color"/>
				</xsl:when>
				<xsl:otherwise>#ccc</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="var-arrow-size">
			<xsl:choose>
				<xsl:when test="$arrow-size != ''">
					<xsl:value-of select="$arrow-size"/>
				</xsl:when>
				<xsl:otherwise>10</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="miniProfileString">
			<xsl:choose>
				<xsl:when test="$mini-profile-type = 'user'">HoozinData.axd?settings=hoozin&amp;name=UserMiniProfile&amp;sid=</xsl:when>
				<xsl:when test="$mini-profile-type = 'community'">HoozinData.axd?settings=hoozin&amp;name=CommunityMiniProfile&amp;communityWebGUID=</xsl:when>
				<xsl:when test="$mini-profile-type = 'app'">HoozinData.axd?settings=hoozin&amp;name=ApplicationMiniProfile&amp;appID=</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="var-data-labels-distance">
			<xsl:choose>
				<xsl:when test="$data-labels-distance != ''">
					<xsl:value-of select="$data-labels-distance"/>
				</xsl:when>
				<xsl:otherwise>50</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<xsl:variable name="var-data-labels-color">
			<xsl:choose>
				<xsl:when test="$data-labels-color != ''">
					<xsl:value-of select="$data-labels-color"/>
				</xsl:when>
				<xsl:otherwise>#000000</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="var-data-labels">
			<xsl:choose>
				<xsl:when test="$data-labels">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="datetime-formatter">
			<xsl:choose>
				<xsl:when test="$context/CurrentUserProfile/PreferredLanguage = 1036">%e %b</xsl:when>
				<xsl:otherwise>%b %e</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- Chart generation -->
		<script type="text/javascript">

		var chart<xsl:value-of select="$container" /> = null;
		var chart<xsl:value-of select="$container" />ChartWidth = 0;
		if (!Array.prototype.forEach) {
			Array.prototype.forEach = function (fn, scope) {
				for (var i = 0, len = this.length; i &lt; len; ++i) {
					fn.call(scope || this, this[i], i, this);
				}
			}
		}
      $(function () {
	  
	  <xsl:if test="$context/CurrentUserProfile/PreferredLanguage = 1036">
		  Highcharts.setOptions({
			lang: {
			months: ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'],
			shortMonths: ['Jan', 'Fév','Mars', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sept', 'Oct', 'Nov', 'Déc'],
			weekdays: ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi']}
		});
	  </xsl:if>
	  
		<xsl:if test="$mini-profile-in-x-axis">
			var indexXAxis = 0;
		</xsl:if>
        $('#<xsl:value-of select="$container" />').highcharts({
          chart: {
		    borderWidth:0,
            <!-- General chart options -->
            <xsl:if test="$total-height != ''">
            height: <xsl:value-of select="$total-height"/>,
            </xsl:if>
            <xsl:if test="$total-width != ''">
            width: <xsl:value-of select="$total-width"/>,
            </xsl:if>
            <xsl:if test="$datetime-zoomable = true()">
            zoomType:'<xsl:value-of select="$datetime-zoomable-axis"/>',
            </xsl:if>
            <xsl:if test="$background != ''">
              backgroundColor: '<xsl:value-of select="$background"/>',
            </xsl:if>
            <xsl:if test="$border-color != ''">
              borderColor: '<xsl:value-of select="$border-color"/>',
            </xsl:if>
            <xsl:if test="$border-radius != ''">
              borderRadius: <xsl:value-of select="$border-radius"/>,
            </xsl:if>
            <xsl:if test="$class-name != ''">
              className: '<xsl:value-of select="$class-name"/>',
            </xsl:if>
            <xsl:if test="$margin-left != ''">
              marginLeft: <xsl:value-of select="$margin-left"/>,
            </xsl:if>
            <xsl:if test="$margin-top != ''">
              marginTop: <xsl:value-of select="$margin-top"/>,
            </xsl:if>
            <xsl:if test="$margin-right != ''">
              marginRight: <xsl:value-of select="$margin-right"/>,
            </xsl:if>
            <xsl:if test="$margin-bottom != ''">
              marginBottom: <xsl:value-of select="$margin-bottom"/>,
            </xsl:if>
            <xsl:if test="$style != ''">
              style: '<xsl:value-of select="$style"/>',
            </xsl:if>
			events: {
				load: function(event){
					hoozin.KPI.onChartLoadOrRedraw(this, '<xsl:value-of select="$container"/>', <xsl:value-of select="$show-in-legend"/>, '<xsl:value-of select="$legend-layout"/>', '<xsl:value-of select="$miniProfileString"/>', <xsl:value-of select="$mini-profile-in-x-axis"/>, '<xsl:value-of select="$add-to-update"/>', '<xsl:value-of select="$get-in-topper"/>');
				},
				redraw: function(event){
					hoozin.KPI.onChartLoadOrRedraw(this, '<xsl:value-of select="$container"/>', <xsl:value-of select="$show-in-legend"/>, '<xsl:value-of select="$legend-layout"/>', '<xsl:value-of select="$miniProfileString"/>', <xsl:value-of select="$mini-profile-in-x-axis"/>, '<xsl:value-of select="$add-to-update"/>', '<xsl:value-of select="$get-in-topper"/>');
				}
			}
		},
		title: {
		text: '<xsl:value-of select="$title" />',
            x: -20 //center
          },
        subtitle: {
            text: '<xsl:value-of select="$sub-title" />',
            x: -20
        },
		<!--X axis options (only for non monoserie chart)-->
        <xsl:if test="$type != 'pie' and $type != 'funnel'">
        xAxis:{
        <xsl:choose>
		  <!--Auto x axis format for datatime-->
          <xsl:when test="$datetime-zoomable = true()">
            type: 'datetime',
			dateTimeLabelFormats: {
                day: '<xsl:value-of select="$datetime-formatter"/>'
            },
            maxZoom: <xsl:value-of select="$datetime-zoomable-max-zoom"/> * 24 * 3600000
          </xsl:when>
		  <!--Custom categories-->
          <xsl:otherwise>
			<xsl:variable name="local-id" select="$context/CurrentUserProfile/PreferredLanguage != ''"/>
			<xsl:choose>
				<xsl:when test="$local-id">
					categories: <xsl:value-of select="pxs:FormatXAxis('', $node, $context/CurrentUserProfile/PreferredLanguage, $interval)" disable-output-escaping="yes"/>
				</xsl:when>
				<xsl:otherwise>
					categories: <xsl:value-of select="pxs:FormatXAxis('', $node, 1033, $interval)" disable-output-escaping="yes"/>
				</xsl:otherwise>
			</xsl:choose>
            
          </xsl:otherwise>
        </xsl:choose>
		<!--Vertical x axis labels (Exemple : if lot of categories)-->
        <xsl:if test="$vertical-label-x-axis = true()">
          ,
          labels: {
          rotation: 90,
          y:30
		  <!--Set necessary information for attach mini profile in x axis label-->
		  <xsl:if test="$mini-profile-in-x-axis">
			,useHTML:true
			,formatter: function(){
				var xAxisLabel= $('&lt;div/&gt;').html(this.value).text();
				return "&lt;span class='XAxis'&gt;"+$('&lt;div/&gt;').text(xAxisLabel.substr(0,20)).html() + (xAxisLabel.length > 20 ? "...":"") +"&lt;/span&gt;";
			}
		  </xsl:if>
          }
        </xsl:if>
		  <xsl:if test="$vertical-label-x-axis = false()">
            ,
            labels: {
            <xsl:if test="$mini-profile-in-x-axis">
				useHTML:true
				,formatter: function(){
				var xAxisLabel= $('&lt;div/&gt;').html(this.value).text();
				return "&lt;span class='XAxis'&gt;"+$('&lt;div/&gt;').text(xAxisLabel.substr(0,20)).html() + (xAxisLabel.length > 20 ? "...":"") +"&lt;/span&gt;";
				}
		  </xsl:if>
            }
          </xsl:if>
		  ,title: {
			text: '<xsl:value-of select="$x-axis-name"/>'
		  }
        },
        yAxis: {
			startOnTick:false,
		  <xsl:if test="$end-on-tick != ''">
			  endOnTick: <xsl:value-of select="$end-on-tick"/>,
		  </xsl:if>
		  <xsl:if test="$y-tick-pixel-interval != ''">
			  tickPixelInterval: <xsl:value-of select="$y-tick-pixel-interval"/>,
		  </xsl:if>
			
			
          title: {
            text: '<xsl:value-of select="$y-axis-name" />'
			},
        <!--define bands/landing-->
        <xsl:if test="$bands = true()">
          plotBands: [
          <xsl:for-each select="$bandsNode">
            {
				from: <xsl:value-of select="from"/>,
				to: <xsl:value-of select="to"/>,
				color: '<xsl:value-of select="color"/>',
				label: {
					text : '<xsl:value-of select="label/text"/>',
					style: {
						color: '<xsl:value-of select="label/style/color"/>'
					}
				}
            },
          </xsl:for-each>
          ],
        </xsl:if>
		},
		</xsl:if>
		
        <!--Define tooltip-->
        tooltip: {
		  enabled:<xsl:choose><xsl:when test="not($show-tooltip = false())">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>,
		  <xsl:if test="$tooltip-header-sufix != ''">
			headerFormat: '&lt;span style="font-size: 10px"&gt;{point.key} <xsl:value-of select="pxs:GetResource('Prexens.Hoozin.Sharepoint', $tooltip-header-sufix)"/>&lt;/span&gt;&lt;br/&gt;',
		  </xsl:if>
		  <xsl:choose>
			  <xsl:when test="$tooltip-formatter = ''">
				  pointFormat: '&lt;span&gt;'
							  +'   &lt;span style="<xsl:if test="$type != 'bar'">color:{series.color};</xsl:if>padding:0"&gt;{series.name}: &lt;/span&gt;'
							  +'   &lt;span style="padding:0"&gt;&lt;b&gt;<xsl:if test="not($value-in-tooltip = false())">{point.y:1f}</xsl:if><xsl:if test="not($value-in-tooltip = false()) and not($percent-in-tooltip = false())"> - </xsl:if><xsl:if test="not($percent-in-tooltip = false())">{point.percentage:.1f}%</xsl:if><xsl:value-of select="$sufix"/>&lt;/b&gt;&lt;/span&gt;'
							  +'&lt;/span&gt;',
			  </xsl:when>
			  <xsl:otherwise>
				  formatter: <xsl:value-of select="$tooltip-formatter"/>,
			  </xsl:otherwise>
		  </xsl:choose>
		  useHTML: true,
		  shadow: false,
		  borderRadius: 0,
		  dateTimeLabelFormats: {
                day: '%A, %e %b %Y'
         }
        },
		<!--Define legend-->
		<xsl:if test="$show-in-legend = true()">
        legend: {
		  floating: true,
          margin: 30,
          useHTML:true,
          labelFormatter: function(){
		  
			  var itemName = $("&lt;div/&gt;").html(this.name).text();
			  <!--percentage calcul-->
			  <xsl:if test="$total-in-legend = 'percent'">
				var total = 0, percentage;
				$.each(this.series.data, function() {
				total+=this.y;
				});
				percentage=((this.y/total)*100).toFixed(2); 
			  </xsl:if>
				<!--Add necessary information for attach mini profile to legend Item-->
				<xsl:choose>
				  <xsl:when test="$mini-profile-type = ''">
					var format = "&lt;span title='" + this.name + "'&gt;";
				  </xsl:when>
				  <xsl:otherwise>
					var format = "&lt;span data-href='<xsl:value-of select="$miniProfileString"/>" + this.userOptions.id + "' class='showMiniProfileChart addPointer' title='" + this.name + "'&gt;";
				  </xsl:otherwise>
				</xsl:choose>
			  if (this.name.length > <xsl:value-of select="$var-max-char-in-legend"/>)
				return format  + $("&lt;div/&gt;").text(itemName.substr(0,<xsl:value-of select="$var-max-char-in-legend"/>)).html() + "...<xsl:if test="$total-in-legend = 'percent'"> : " + percentage + "%" +"</xsl:if><xsl:if test="$total-in-legend = 'total'"> : " + this.y +"</xsl:if>&lt;/span&gt;";
			  else
				return format + $("&lt;div/&gt;").text(itemName.substr(0,<xsl:value-of select="$var-max-char-in-legend"/>)).html() + "<xsl:if test="$total-in-legend = 'percent'"> : " + percentage + "%" +"</xsl:if><xsl:if test="$total-in-legend = 'total'"> : " + this.y +"</xsl:if>&lt;/span&gt;";
          },
		  <!--Define style : custom or dafault-->
          <xsl:choose>
            <xsl:when test="$legend-style != ''">
              style: '<xsl:value-of select="$legend-style"/>',
			  itemStyle: {
				   cursor: 'pointer',
				   color: '#274b6d',
				   fontSize: '10px'
			  }
            </xsl:when>
            <xsl:otherwise>
              layout: '<xsl:value-of select="$var-legend-layout"/>',
              align: '<xsl:value-of select="$var-legend-align"/>',
              verticalAlign: '<xsl:value-of select="$var-legend-vertical-align"/>',
              maxHeight: <xsl:value-of select="$var-maxHeightLegend"/>,
              <xsl:if test="$navigation = true()">
                navigation:{
                  activeColor:'<xsl:value-of select="$var-active-color"/>',
                  inactiveColor:'<xsl:value-of select="$inactive-color"/>',
                  arrowSize: <xsl:value-of select="$var-arrow-size"/>,
                  animation:true,
                },
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>

        },
        </xsl:if>
		<!--Define plot options-->
        plotOptions: {
		
        <xsl:if test="$type = 'pie' or $type = 'funnel' or $type = 'bar'">
          <xsl:value-of select="$type"/>: {
			pointPadding: 0,
			groupPadding: 0,
            borderWidth: 0,
            shadow: false,
            allowPointSelect: true,
			<xsl:if test="$type = 'bar'">
            cursor: 'pointer',
			allowPointSelect:false,
			</xsl:if>
			<xsl:if test="$inner-size != ''">
				innerSize:<xsl:value-of select="$inner-size"/>,
			</xsl:if>
			<xsl:if test="$type = 'pie' or $type = 'funnel'">
				cursor: 'pointer',
			</xsl:if>
				  
		<xsl:choose>
			<!--Define default data labels-->
			<xsl:when test="$data-labels-inside != true()">
            dataLabels: {
              enabled: <xsl:value-of select="$var-data-labels"/>,
			  distance: <xsl:value-of select="$var-data-labels-distance"/>,
              color: '<xsl:value-of select="$var-data-labels-color"/>',
              connectorColor: '#000000',
              format: '&lt;b&gt;{point.name}&lt;/b&gt;: {point.y:1f}'
            }
			</xsl:when>
			<!--Define inside data label-->
			<xsl:otherwise>
				dataLabels: {
                    enabled: true,
                    formatter: function() {
                        return this.y == 0? '' : this.y;
                    },
                    distance: <xsl:value-of select="$var-data-labels-distance"/>,
                    color:'<xsl:value-of select="$var-data-labels-color"/>'
                }
			</xsl:otherwise>
		</xsl:choose>
            <xsl:if test="$show-in-legend = true()">
              , showInLegend:true
            </xsl:if>
          },
        </xsl:if>
        <xsl:if test="$type = 'area'">
          area: {
            marker: {
              enabled: false,
              symbol: 'circle',
              radius: 2,
              states: {
                hover: {
                  enabled: true
                }
              }
            }
          },

        </xsl:if>
		areaspline: {
                <xsl:if test="$column-stacked != '' and $fill-opacity = ''">
				stacking:'<xsl:value-of select="$column-stacked"/>',
				fillOpacity:1,
				</xsl:if>
				<xsl:if test="$column-stacked != '' and $fill-opacity != ''">
				stacking:'<xsl:value-of select="$column-stacked"/>',
				fillOpacity:<xsl:value-of select="$fill-opacity"/>,
				</xsl:if>
                marker: {
                    enabled: false,
                    symbol: 'circle',
                    radius: 2,
                    states: {
                        hover: {
                            enabled: true
                        }
                    }
                },
                lineWidth: 0
            },
        <xsl:if test="$type = 'line' and $marker = false()">
		line:{
			marker:{
				enabled:false
			}
		},
		</xsl:if>
		column:{
			pointPadding: 0,
			groupPadding: 0.02,
            borderWidth: 0,
            shadow: false,
            allowPointSelect: false,
            cursor: 'pointer',
			<xsl:if test="$type = 'column' and $column-stacked != ''">
				stacking: '<xsl:value-of select="$column-stacked"/>'
			</xsl:if>
		},
		spline:{
			lineWidth: 3,
			marker:{
				enabled:false
			}
		},
		
        
        series: {
		<xsl:if test="$datetime-zoomable = true()">
			pointStart: <xsl:value-of select="pxs:GetFirstDate('', $node)" disable-output-escaping="yes"/>,
			pointInterval: <xsl:value-of select="$interval" disable-output-escaping="yes"/> * 24 * 3600 * 1000, // one day
		</xsl:if>
			point: {
				events: {
					<xsl:if test="$add-to-update != ''">
					mouseOver: function(){ hoozin.KPI.updateAttachedChart('<xsl:value-of select="$container"/>', this.category);}
					</xsl:if>
					<xsl:if test="$get-in-topper != ''">
					click: function(){ 
						hoozin.KPI.TopperZone.changeTopper(this.series.chart.getInTopper, this.x);
					}
					</xsl:if>
				}
			}
        },
        
     
        },
		<!--Define serie(s)-->
        series: <xsl:choose>
                  <xsl:when test ="$type != 'pie' and $type != 'funnel' and $type != 'bar'">
                    <xsl:value-of select="pxs:FormatDataMultiSeries('', $node,$datetime-zoomable = true(), $grouped-column-or-bar, $type, $colors, $average, $interval, $page,$limit)" disable-output-escaping="yes"/>
                  </xsl:when>
                  <xsl:otherwise>
                    [{type:'<xsl:value-of select="$type"/>',
                    name:"<xsl:value-of select="$serie-name"/>",
                    data:<xsl:value-of select="pxs:FormatDataPie('', $node,$type, $colors)" disable-output-escaping="yes"/>,
                    <xsl:if test="$type = 'bar'">color:'rgba(255, 255, 255, 0.1)'</xsl:if>}]
                  </xsl:otherwise>
                </xsl:choose>,
				
		credits:{
			enabled:false
			}
        });
		
		
		
		
      });
    </script>
	</xsl:template>
</xsl:stylesheet>
