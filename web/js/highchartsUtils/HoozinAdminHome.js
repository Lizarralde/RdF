$(function () {


	hoozin.KPI = function () {


		// ###############
		// Private vars
		// ###############
		var invariantParams = {};
		var _windowHeight;
		var _windowWidth;
		var _chartCount = 0;
		var _resizedChartCount = 0;
		var _activedResize = true;
		var _intervalID;
		var _charts = {};
		var _intervalID;


		// ###############
		// Private methods
		// ###############

		var _addChart = function (name, chart) {
			_charts[name] = chart;
		}

		var _clearChart = function () {
			_charts = {};
		}

		var _updateTimeInterval = function (intervalKey, request, pageDesc, addToRefresh, resourceKey, days) {

			if (intervalKey != "Today" && intervalKey != "Yesterday" && intervalKey != "LastWeek" && intervalKey != "LastMonth" && intervalKey != "AllTime"
				&& intervalKey != "DAY" && intervalKey != "WEEK" && intervalKey != "MONTH") {
				return;
			}

			var today = new Date();
			var intervalBegin;
			var intervalEnd;
			var selectedLabel = 'AdminHome_' + resourceKey;
			var interval;

			if (intervalKey == "Today") {
				intervalBegin = today;
				intervalEnd = today;
			}
			else if (intervalKey == "Yesterday") {
				today.setDate(today.getDate() - 1);
				intervalBegin = today;
				intervalEnd = new Date();
				intervalEnd.setHours(0, 0, 0, 0);
				interval = "DAY";
			}
			else if (intervalKey == "LastWeek") {
				today.setDate(today.getDate() - today.getDay());
				intervalEnd = today;
				today = new Date();
				today.setDate(today.getDate() - today.getDay() - 7);
				intervalBegin = today;
				interval = "WEEK";
			}
			else if (intervalKey == "LastMonth") {
				today.setDate(today.getDate() - today.getDay());
				intervalEnd = today;
				today = new Date();
				today.setDate(today.getDate() - today.getDay() - 31);
				intervalBegin = today;
				interval = "MONTH";
			}
			else if (intervalKey == "AllTime") {
			}
			else if (intervalKey == "DAY" || intervalKey == "WEEK" || intervalKey == "MONTH") {
				interval = intervalKey;
			}

			var settings = (invariantParams[intervalKey] == null ? { Settings: {}, Parameters: {}, Options: {}} : invariantParams[intervalKey]);
			settings.Settings["RequestedData"] = request;
			settings.Options["Value"] = interval;
			settings.Settings["SinceDate"] = intervalBegin;
			settings.Settings["ToDate"] = intervalEnd;
			settings.Parameters["selected"] = selectedLabel;
			settings.Parameters["interval"] = interval;
			settings.Parameters["requestedData"] = request;

			hoozin.Overlay.showOverlays('contentZone');
			hoozin.UI.addObjectToLoad(null, pageDesc);
			if (addToRefresh != '' && addToRefresh != undefined) {
				hoozin.UI.addObjectToLoad(null, addToRefresh);
			}
			hoozin.UI.refresh(settings, null, null, null, null, null, null, null, false);
		}

		var bindEvents = function () {
			$('body')
			.off('click', '.adminHomeWrapper .dateSelector ul a')
			.on('click', '.adminHomeWrapper .dateSelector ul a', function () {

				var pageDesc = $(this).closest('.kpiWrapper').attr('id');
				var days = $(this).data('days');
				var intervalKey = $(this).data('intervalKey');
				var resourceKey = $(this).data('resourceKey');
				var request = $(this).data('request');
				var refresh = $(this).data('refresh');

				if (resourceKey == null || resourceKey === undefined) {
					resourceKey = intervalKey;
				}

				_updateTimeInterval(intervalKey, request, pageDesc, refresh, resourceKey, days);

			});

			$(window).resize(function () {
				if ($('.highcharts-container').length == 0) {
					return;
				}
				clearTimeout(_intervalID);
				_intervalID = setTimeout(function () {
					$.each(_charts, function (key, value) {
						var width;
						var padding;
						if ($(value.container).closest('.d').html() == undefined) {
							if ($(value.container).closest('#subContent').html() == undefined) {
								width = $(value.container).closest('#contextContent').width();
							}
							else {
								width = $(value.container).closest('#subContent').width();
							}
							padding = 0;
						}
						else {
							width = $(value.container).closest('.d').width();
							padding = 36;
						}
						value.setSize(
						width - padding,
						value.chartHeight
					);
					});
				}, 500);
			});


		} ();

		var _timeTooltipFormatter = function ($this) {
			var currentCulture = _prexensHoozinSharepointClient.HoozinAdminHome_CurrentCulture;
			var headerFormat;
			var pointFormat;

			if (currentCulture == "English") {
				headerFormat = '<span style="font-size: 10px">' + ($this.x > 12 ? $this.x - 12 + ' pm ' : $this.x + ' am ') + '</span><br/>';
			}
			else {
				headerFormat = '<span style="font-size: 10px">' + $this.x + ' ' + _prexensHoozinSharepointClient.HoozinAdminHome_Hour + '</span><br/>';
			}

			pointFormat = '<span>'
						+ '   <span style="padding:0">' + $this.series.name + ': </span>'
						+ '   <span style="padding:0"><b>' + $this.y + '</b></span>'
						+ '</span>'

			return headerFormat + pointFormat;
		}

		var _updateAttachedChart = function (name, xAxisValue) {
			var updatedChart = _charts[name];
			var chartToUpdate = _charts[updatedChart.addToUpdate];
			var newSerieData = [];
			if (chartToUpdate == null || chartToUpdate == undefined)
				return;
			updatedChart.series.forEach(function (serie) {
				newSerieData.push(chartToUpdate.series[0].data.filter(function (s) { return s.name == serie.name; })[0].options);
				newSerieData[newSerieData.length - 1].y = serie.data.filter(function (d) { return d.category == xAxisValue; })[0].y;
			});

			chartToUpdate.series[0].setData(newSerieData, false);
			chartToUpdate.redraw();
		}

		var _onChartLoadOrRedraw = function (chart, container, showLegend, legendLayout, miniprofileString, miniprofileInXAxis, addToUpdate, getInTopper) {
			//Get Chart and legend objects

			if (!hoozin.browser.isIE8) {

				var legend = $('#' + container + ' .highcharts-legend:eq(1)');
				legend.find('div:first').addClass('null');

				//Get SVG legend symbol group
				var legendSymbol = $('#' + container + ' .highcharts-legend:first');
				//Get legend items group
				var legendItem = legend.find("div .highcharts-legend-item");

				//Get legend symbol element
				var legendSymbolItem = legendSymbol.find("g .highcharts-legend-item");

				//Remove default style
				$('#' + container + ' div.highcharts-legend-item').attr('style', '');

				//Add 'horizontal' or 'vertical' class at legend element
				legend.addClass(legendLayout);
				legend.find(".null").attr('style', '').empty();

				legendItem.each(function (index) {

					var item = chart.legend.allItems[index];
					var li = chart.legend.allItems[index].legendItem;
					var serializer = new XMLSerializer();
					//Get all element symbole definition
					var svg = $(legendSymbolItem[index]).children().slice(0, 2);
					//Serialize SVG to get recup HTML (.html() and .InnerHtml() don't work)
					var str = serializer.serializeToString(svg.get(0));
					if (svg.length == 2)
						str += serializer.serializeToString(svg.get(1));
					//Encapsulate symbol element in SVG and div for apply some style
					$(this).find('div').remove();
					$(this).prepend('<div><svg><g>' + str + '</g></svg></div>');

					//Remove default style and apply custom style
					$(this).find('div').addClass("imgLegend");
					if ($(this).find('span:first').length == 0) {
						$(this).append($('<span zindex="2" class="labelLegend"><span title="' + item.name + '">' + item.name + '</span></span>'));
					}
					$(this).find('span:first').addClass("labelLegend").attr('style', '');

					//Attach mini profile in legend element
					if (miniprofileString != '') {
						$(this).attr('data-href', miniprofileString + item.userOptions.id).addClass('showMiniProfileChart');
					}
					else {
						$(this).on('click', function (event) {

							var strLegendItemClick = 'legendItemClick',
								fnLegendItemClick = function () {
									item.setVisible();
								};

							// Pass over the click/touch event. #4.
							event = {
								browserEvent: event
							};

							// click the name or symbol
							if (item.firePointEvent) { // point
								item.firePointEvent(strLegendItemClick, event, fnLegendItemClick);
							} else {
								MyHighcharts.prototype.fireEvent(item, strLegendItemClick, event, fnLegendItemClick);
							}

						});
					}
					//Rebind HighCharts default comportement (otherwise don't work in Firefox)
					$(this).on("mouseover", function (e) {
						e.stopPropagation();
						item.setState("hover");
						li.css(chart.legend.options.itemHoverStyle);
					}).on("mouseout", function (e) {
						e.stopPropagation();
						li.css(item.visible ? chart.legend.itemStyle : chart.legend.itemHiddenStyle);
						item.setState();
					});


					$(this).replaceWith($(this).html());
					legend.find(".null").append($(this));
				});

				//Hide default highcharts legend
				legendSymbol.hide();

				//Add div with 'clear' class for 'horizontal' layout
				legend.find(".null").append("<div class='clear'></div>");

				//Attach custom legend after chart
				$('#' + container + '').append(legend.attr('style', ''));



			}
			else {
				var legend = $('#' + container + ' .highcharts-legend');
				if (showLegend) {

					legend.addClass(legendLayout);
					legend.find('div:first').addClass('null');
					legend.find('div').attr('style', '')
					legend.find('shape:last').hide();
					legend.find('.highcharts-legend-item shape').each(function (index) {
						var item = chart.legend.allItems[index];
						var li = chart.legend.allItems[index].legendItem;
						var divImgLabel = $("<div class='imgLegend'/>");
						$(this).before(divImgLabel)
						$(this).appendTo(divImgLabel);
						//Attach mini profile in legend element
						if (miniprofileString != '') {
							divImgLabel.attr('data-href', miniProfilestring + item.userOptions.id).addClass('showMiniProfileChart');
						}
					});
					legend.find('.highcharts-legend-item > span').addClass("labelLegend").attr('style', '');
					//Add div with 'clear' class for 'horizontal' layout
					legend.find(".null").append("<div class='clear'></div>");

					//Attach custom legend after chart
					$('#' + container + '').append(legend.attr('style', ''));

				}
				else {
					legend.hide();
				}
			}

			//Attach mini profile in x axis label
			if (miniprofileString != '') {

				var index = 0;
				chart.series[0].data.forEach(function () {
					//Attach mini profile in x axis label
					if (miniprofileInXAxis) {
						$($('#' + container + ' .XAxis')[index]).attr('data-href', miniprofileString + chart.series[0].data[index].id).addClass('showMiniProfileChart addPointer');
					}
					index++;
				});
			}

			$('#' + container + ' .showMiniProfileChart').each(function (index) {

				$(this)
				.off('click')
				.on('click', function () {
					var url = $(this).attr('data-href');
					if (hasValue(url)) {
						hoozin.MiniProfile.open(url);
					}
				});
			});
			if (addToUpdate != '') {
				chart.addToUpdate = addToUpdate;
			}
			if (getInTopper != '') {
				chart.getInTopper = getInTopper;
			}
			hoozin.KPI.addChart(container, chart);
		}


		// ##################### //
		// PUBLIC METHODS
		// ##################### //
		return {
			getChart: function (name) {
				return _charts[name];
			},
			updateTimeInterval: function (intervalKey, request, pageDesc, days) {
				_updateTimeInterval(intervalKey, request, pageDesc, days);
			},
			onChartLoadOrRedraw: function (chart, container, showLegend, legendLayout, miniprofileString, miniprofileInXAxis, addToUpdate, getInTopper) {
				_onChartLoadOrRedraw(chart, container, showLegend, legendLayout, miniprofileString, miniprofileInXAxis, addToUpdate, getInTopper);
			},
			timeTooltipFormatter: function () {
				return _timeTooltipFormatter(this);
			},
			updateAttachedChart: function (name, xAxisValue) {
				_updateAttachedChart(name, xAxisValue);
			},
			get: function () {
				return {
					windowHeight: _windowHeight,
					windowWidth: _windowWidth,
					chartCount: _chartCount,
					resizedChartCount: _resizedChartCount
				}
			},

			setWindowWidth: function (value) {
				_windowWidth = value;
			},

			setChartCount: function (value) {
				_chartCount = value;
			},

			setResizedChartCount: function (value) {
				_resizedChartCount = value;
			},

			addChart: function (name, chart) {
				_addChart(name, chart);
			},

			clearChart: function () {
				_clearChart();
			}
		}

	} ();

	hoozin.KPI.TopperZone = function () {

		// ###############
		// Private vars
		// ###############
		var _entities = {};

		// ###############
		// Private methods
		// ###############

		var _getNextEntity = function (id) {
			_entities[id].index++;
			var entity
			try {
				entity = _entities[id].entities[_entities[id].index];
			} catch (e) {
				_entities[id].index--;
			}

			if (entity == undefined) {
				_entities[id].index--;
			}

			return entity;

		}

		var _getPreviousEntity = function (id) {
			_entities[id].index--;
			var entity
			try {
				entity = _entities[id].entities[_entities[id].index];
			} catch (e) {
				_entities[id].index++;
			}

			if (entity == undefined) {
				_entities[id].index++;
			}

			return entity;

		}

		var _setEntityInfo = function (id, type, entity) {
			var miniProfileUrl = '';
			var avatarUrl = '';

			if (type == 'user') {
				miniProfileUrl = 'HoozinData.axd?settings=hoozin&name=UserMiniProfile&sid=' + entity.id;
				avatarUrl = '/HoozinAvatar.axd?sid=' + entity.id + '&size=40&lastModified=' + entity.lastModified;
			}
			else if (type == 'community') {
				miniProfileUrl = 'HoozinData.axd?settings=hoozin&name=CommunityMiniProfile&communityWebGUID=' + entity.id;
				avatarUrl = '/GetHoozinCommunityImage.axd?type=avatar&size=40&guid=' + entity.id + '&lastModified=' + entity.lastModified;
			}
			else if (type == 'app') {
				miniProfileUrl = 'HoozinData.axd?settings=hoozin&name=ApplicationMiniProfile&appID=' + entity.id;
				avatarUrl = 'background-image:url(\'' + entity.imgUrl + '\')';
			}

			$('#' + id + ' .theNumber').text(entity.count);
			$('#' + id + ' .showMiniProfile').attr('data-href', miniProfileUrl);
			if (type != 'app') {
				$('#' + id + ' img.avatar').attr('alt', entity.name).attr('src', avatarUrl);
			}
			else {
				$('#' + id + ' div.avatar').attr('alt', entity.name).attr('style', avatarUrl);
			}
			$('#' + id + ' .toperNameWrapper b').text(entity.name);
		}

		var _setUserInfo = function (id, entity, index) {
			var miniProfileUrl = '';
			var avatarUrl = '';

			miniProfileUrl = 'HoozinData.axd?settings=hoozin&name=UserMiniProfile&sid=' + entity.id;
			avatarUrl = '/HoozinAvatar.axd?sid=' + entity.id + '&size=40&lastModified=' + entity.lastModified;

			var postsCount = entity.postsCount;
			var postsLabel;
			if (postsCount > 1) {
				postsLabel = _prexensHoozinSharepointClient.HoozinAdminHome_Posts;
			}
			else {
				postsLabel = _prexensHoozinSharepointClient.HoozinAdminHome_Post;
			}
			var likesCount = entity.likesCount;
			var likesLabel;
			if (likesCount > 1) {
				likesLabel = _prexensHoozinSharepointClient.HoozinAdminHome_LikesOnPosts;
			}
			else {
				likesLabel = _prexensHoozinSharepointClient.HoozinAdminHome_LikeOnPosts;
			}
			var commentsCount = entity.commentsCount;
			var commentsLabel;
			if (commentsCount > 1) {
				commentsLabel = _prexensHoozinSharepointClient.HoozinAdminHome_CommentsOnPosts;
			}
			else {
				commentsLabel = _prexensHoozinSharepointClient.HoozinAdminHome_CommentOnPosts;
			}



			$('#' + id + ' .postTopperPosts').text(postsCount + ' ' + postsLabel);
			$('#' + id + ' .postTopperLikes').text(likesCount + ' ' + likesLabel);
			$('#' + id + ' .postTopperComments').text(commentsCount + ' ' + commentsLabel);
			$('#' + id + ' .showMiniProfile').attr('data-href', miniProfileUrl);
			$('#' + id + ' img.avatar').attr('alt', entity.name).attr('src', avatarUrl);
			$('#' + id + ' .toperNameWrapper b').text(entity.name);
			$('#' + id + ' .toperValueWrapper').text('#' + (index + 1));
		}

		var _setDailyActivityInfo = function (id, entity, index) {

			var postsCount = entity.postsCount;
			var postsLabel;
			if (postsCount > 1) {
				postsLabel = _prexensHoozinSharepointClient.HoozinAdminHome_Posts;
			}
			else {
				postsLabel = _prexensHoozinSharepointClient.HoozinAdminHome_Post;
			}
			var actionsCount = entity.actionsCount;
			var actionsLabel;
			if (actionsCount > 1) {
				actionsLabel = _prexensHoozinSharepointClient.HoozinAdminHome_Actions;
			}
			else {
				actionsLabel = _prexensHoozinSharepointClient.HoozinAdminHome_Action;
			}
			var connectionsCount = entity.connectionsCount;
			var connectionsLabel;
			if (connectionsCount > 1) {
				connectionsLabel = _prexensHoozinSharepointClient.HoozinAdminHome_Connections;
			}
			else {
				connectionsLabel = _prexensHoozinSharepointClient.HoozinAdminHome_Connection;
			}

			var prefix = index == 0 ? _prexensHoozinSharepointClient.DailyActivityDetailsZone_First : index == 1 ? _prexensHoozinSharepointClient.DailyActivityDetailsZone_Second : index == 2 ? _prexensHoozinSharepointClient.DailyActivityDetailsZone_Third : _prexensHoozinSharepointClient.DailyActivityDetailsZone_Other;

			$('#' + id + ' .lineWrapper .value.posts').text(postsCount + ' ' + postsLabel);
			$('#' + id + ' .lineWrapper .value.actions').text(actionsCount + ' ' + actionsLabel);
			$('#' + id + ' .lineWrapper .value.connections').text(connectionsCount + ' ' + connectionsLabel);
			$('#' + id + ' .theNumber').text(entity.id);
			$('#' + id + ' .theChapo b').text((_prexensHoozinSharepointClient.DailyActivityDetailsZone_StrongInfluence).replace('{0}', (index + 1) + prefix));
		}

		var _setPostInfo = function (id, entity, index) {
			var avatarUrl = '';
			var miniProfileUrl = '';

			avatarUrl = '/HoozinAvatar.axd?sid=' + entity.userSid + '&size=70&lastModified=' + entity.lastModified;
			miniProfileUrl = 'HoozinData.axd?settings=hoozin&name=UserMiniProfile&sid=' + entity.userSid;

			var postPlugin = entity.postPlugin;

			var likesCount = entity.likesCount;
			var likesLabel;
			if (likesCount > 1) {
				likesLabel = _prexensHoozinSharepointClient.HoozinAdminHome_Likes;
			}
			else {
				likesLabel = _prexensHoozinSharepointClient.HoozinAdminHome_Like;
			}
			var commentsCount = entity.commentsCount;
			var commentsLabel;
			if (commentsCount > 1) {
				commentsLabel = _prexensHoozinSharepointClient.HoozinAdminHome_Comments;
			}
			else {
				commentsLabel = _prexensHoozinSharepointClient.HoozinAdminHome_Comment;
			}

			var date = new Date(entity.postDate);
			var dateStr = date.getDate().toString() + '/' + (date.getMonth() + 1).toString() + '/' + date.getFullYear().toString();

			$('#' + id + ' .postTopperPosts span').text(postPlugin);
			$('#' + id + ' .postTopperLikes').text(likesCount);
			$('#' + id + ' .postTopperComments').text(commentsCount);
			$('#' + id + ' img.avatar').attr('alt', entity.name).attr('src', avatarUrl);
			$('#' + id + ' .tweetContent').html(entity.postHtml);
			$('#' + id + ' .toperNameWrapper b').text(entity.name);
			$('#' + id + ' .toperValueWrapper').text(dateStr);
			$('#' + id + ' .showMiniProfile').attr('data-href', miniProfileUrl);
			$('#' + id + ' .tweetContent').attr('data-post-id', entity.id);
			$('#' + id + ' .tweetContent').attr('data-post-url', entity.url);

		}

		var _setTagInfo = function (id, entity) {
			$('#' + id + ' .tagText').text(entity.text);
			$('#' + id + ' .theNumber').text(entity.count);
		}

		var _setCommunitiesCreatedInfo = function (id, entity) {
			$('#' + id + ' .theText').html(_prexensHoozinSharepointClient[entity.monthResource] + '<br/>' + entity.year);
			$('#' + id + ' .theChapo .text').text(entity.count + ' ' + _prexensHoozinSharepointClient[entity.count > 1 ? 'CommunitiesMonthlyTopperZone_CommunitiesCreated' : 'CommunitiesMonthlyTopperZone_CommunityCreated']);
		}

		var _changeTopper = function (id, index) {
			var entity = _entities[id];
			if (entity.index < index) {
				_nextEvent($('#' + id + '  .kpiFooter .next'), index);
			}
			if (entity.index > index) {
				_previousEvent($('#' + id + ' .kpiFooter .previous'), index);
			}
		}

		var _previousEvent = function (topper, index) {

			var id = topper.closest('.kpiWrapper').attr('id');

			if (_entities[id] == undefined)
				return;
			var type = _entities[id].type;
			var updateFunction = _entities[id].updateFunction;
			var entity;

			do {
				entity = _getPreviousEntity(id);
			} while (typeof index == 'number' && _entities[id].index != index);

			if (entity == undefined)
				return;

			if (_entities[id].index == 0)
				topper.removeClass('activeArrow')
			if (_entities[id].index != _entities[id].entities.length - 1)
				topper.parent().find('.next').addClass('activeArrow')

			if (updateFunction == undefined || updateFunction == null)
				_setEntityInfo(id, type, entity);
			else
				updateFunction(id, entity, _entities[id].index);
			$('#' + id + '.topper .kpiFooter .position b').text('#' + (_entities[id].index + 1));
		}

		var _nextEvent = function (topper, index) {

			var id = topper.closest('.kpiWrapper').attr('id');
			if (_entities[id] == undefined)
				return;
			var type = _entities[id].type;
			var updateFunction = _entities[id].updateFunction;
			var entity;

			do {
				entity = _getNextEntity(id);
			} while (typeof index == 'number' && _entities[id].index != index);


			if (entity == undefined)
				return;
			if (_entities[id].index == _entities[id].entities.length - 1) {
				topper.removeClass('activeArrow');
			}
			if (_entities[id].index != 0)
				topper.parent().find('.previous').addClass('activeArrow');

			if (updateFunction == undefined || updateFunction == null)
				_setEntityInfo(id, type, entity);
			else
				updateFunction(id, entity, _entities[id].index);
			$('#' + id + '.topper .kpiFooter .position b').text('#' + (_entities[id].index + 1));
		}

		var bindEvents = function () {
			$('body')
			.off('click', '.adminHomeWrapper .topper .kpiFooter .previous')
			.on('click', '.adminHomeWrapper .topper .kpiFooter .previous', function () {
				_previousEvent($(this));
			})
			.off('click', '.adminHomeWrapper .topper .kpiFooter .next')
			.on('click', '.adminHomeWrapper .topper .kpiFooter .next', function () {
				_nextEvent($(this));
			});
			$('body')
			.off('click', '.topPost .tweetContent')
			.on('click', '.topPost .tweetContent', function () {

				// Get Post Id
				var postID = $(this).attr('data-post-id');
				var postURL = $(this).attr('data-post-url');

				var params;
				if (!hasValue(postID)) {
					params = "PostURL=" + postURL;
				}
				else {
					params = "PostID=" + postID;
				}

				var popupTitle = _prexensHoozinSharepointClient.SearchResults_PopupTitle;

				hoozin.Popup.open(
					{
						title: popupTitle,
						isClosable: true,
						showLoadingIcon: true,
						urlToLoad: 'HoozinData.axd?settings=hoozin&name=PostView&' + params,
						popupType: 'scroll',
						backgroundColor: '#F2F2F2',
						messagePadding: '0 18px 18px 18px', 
						pixelsResponsiveWidths: true,
						onOpenFunction: function () { hoozin.Stream.initReadMore(); }
					}
				);

			});
		} ();

		// ###############
		// Public methods
		// ###############
		return {
			setUserInfo: function (id, index, entity) {
				return _setUserInfo(id, index, entity);
			},

			setDailyActivityInfo: function (id, index, entity) {
				return _setDailyActivityInfo(id, index, entity);
			},

			setPostInfo: function (id, index, entity) {
				return _setPostInfo(id, index, entity);
			},

			setTagInfo: function (id, entity) {
				return _setTagInfo(id, entity);
			},

			setCommunitiesCreatedInfo: function (id, entity) {
				return _setCommunitiesCreatedInfo(id, entity);
			},

			clearEntities: function (id) {
				if (_entities[id] != undefined)
					_entities[id].index = 0;
				_entities[id] = undefined;
			},

			addEntity: function (id, entity, option, max) {
				if (_entities[id] == undefined)
					_entities[id] = {};
				if (_entities[id].entities == undefined) {
					_entities[id].entities = new Array();
					_entities[id].index = 0;
					if (typeof option === 'function')
						_entities[id].updateFunction = option;
					else
						_entities[id].type = option;
				}
				for (i = 0; i < _entities[id].entities.length; i++) {
					if (_entities[id].entities[i].id == entity.id) {
						return;
					}
				}
				if (_entities[id].entities.length == max) {
					return;
				}
				_entities[id].entities.push(entity)
				if (_entities[id].entities.length > 1) {
					$('#' + id + ' .kpiFooter .active').addClass('activeArrow');
				}
			},

			changeTopper: function (id, index) {
				_changeTopper(id, index);
			},
			getEntities: function (id) {
				return _entities[id];
			},

			getNextEntity: function (id) {
				return _getNextEntity(id);
			},

			getPreviousEntity: function (id) {
				return _getPreviousEntity(id);
			}
		}
	} ();

	hoozin.KPI.SquareZone = function () {

		// ###############
		// Private vars
		// ###############
		var _begin = 0;
		var _top = 0;
		var _max = 0;

		// ###############
		// Private methods
		// ###############


		var _UpdateWithNextsCommunity = function (request, pageDesc, begin, stop) {
			var settings = { Settings: {}, Parameters: {}, Options: {} }
			settings.Settings["RequestedData"] = request;
			settings.Settings["page"] = begin;
			settings.Settings["TopRank"] = stop;
			settings.Parameters["begin"] = begin;
			settings.Parameters["top"] = _top;
			settings.Parameters["requestedData"] = request;

			hoozin.Overlay.showOverlays('contentZone');
			hoozin.UI.addObjectToLoad(null, pageDesc);
			hoozin.UI.refresh(settings, null, null, null, null, null, null, null, false);
		}

		var bindEvents = function () {
			$('body')
			.off('click', '.adminHomeWrapper .square .kpiFooter .previous')
			.on('click', '.adminHomeWrapper .square .kpiFooter .previous', function () {

				var pageDesc = $(this).closest('.kpiWrapper').attr('id');
				var request = $(this).data('request');

				if (_begin + (2 * _top) - 1 >= _max && _begin + _top < _max)
					_UpdateWithNextsCommunity(request, pageDesc, _max - _top, _top - 1);
				else if (_begin + _top < _max)
					_UpdateWithNextsCommunity(request, pageDesc, _begin + _top, _top - 1);
			})
			.off('click', '.adminHomeWrapper .square .kpiFooter .next')
			.on('click', '.adminHomeWrapper .square .kpiFooter .next', function () {

				var pageDesc = $(this).closest('.kpiWrapper').attr('id');
				var request = $(this).data('request');

				if (_begin - _top < 1 && _begin > 1)
					_UpdateWithNextsCommunity(request, pageDesc, 1, _top - 1);
				if (_begin != 1)
					_UpdateWithNextsCommunity(request, pageDesc, _begin - _top, _top - 1);
			});
		} ();

		// ###############
		// Public methods
		// ###############
		return {
			setBegin: function (value) {
				_begin = value;
			},

			setTop: function (value) {
				_top = value;
			},

			setMax: function (value) {
				_max = value;
			},

			initArrow: function (id) {
				if (_top + _begin < _max) {
					$('#' + id + ' .kpiFooter .previous').addClass('activeArrow');
				}
				if (_begin > 1) {
					$('#' + id + ' .kpiFooter .next').addClass('activeArrow');
				}
			}
		}
	} ();


});





