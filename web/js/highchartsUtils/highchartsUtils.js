var highchartsUtils = function () {

    this.KPI = function() {
        var _charts = {};

        var _generateKPI = function(){
            var kpiDesc = $('.kpiWrapper').not('.linkedChart');
            var chartUtil = this;

            kpiDesc.each(function(index){
                var $this = $(this);
                var request = $this.data('request');
                var id = $this.attr('id');
                var type = $this.data('type');

                var chart;

                if(type == 'square')
                {
                    var begin = $this.data('begin');
                    var max = $this.data('max');
                    var top = $this.data('top');

                    console.log(chartUtils);
                    var chart = new SquareZone();
                    chart.setBegin(begin);
                    chart.setMax(max);
                    chart.setTop(top);
                    chart.initArrow(id,request);

                    _charts[id] = chart;
                }
                else if(type == 'line')
                {

                    var chartL = new Chart();
                    var chartP = new Chart();

                    services.callService('','POST',{param1:request, param2:'',param3:''},function(ret)
                    {
                        var json = JSON.stringify(eval("(" + ret + ")"));
                        var proName = json.procName;
                        var cat = json.cartegories;
                        var data = json.data;
                        chartL.createLineChart(proName+'Line', proName, data, cat);

                        var dataPie = {};

                        $.each(data, function(index){
                            var total = 0;

                            $.each(this, function(){
                                total += this;
                            });
                            dataPie[index] = total;
                        });

                        chartP.createMonoSerieChar(proName+'Pie',data,'serie name');
                    });

                    _charts[request+'Line'] = chartL;
                    _charts[request+'Pie'] = chartP;

                }
            });
        }


        // ###############
        // Public methods
        // ###############
        return {
            generateKPI: function(){
                _generateKPI();
            }
        }

    }
};


this.Chart = function () {

    // ###############
    // Private vars
    // ###############

    var _id = '';
    var request = '';


    this.createMonoSerieChart = function (containerId, request, serieName, data) {
        _id = containerId;
        _request = request;
        $('.kpiWrapper[data-request="' + request + '"&&data-type="pie"]').highcharts({
            chart: {
                height: 230,
                marginTop: 0,
                marginBottom: 0
            },
            title: '',
            tooltip: {
                pointFormat: '{series.name}: <b>{point.y:.1f}</b>'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false,
                        format: '<b>{point.name}</b>: {point.y:.1f} %',
                        style: {
                            color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                        }
                    }
                }
            },
            series: [{
                type: 'pie',
                name: serieName,
                data: data
            }]
        });
    };

    this.createLineChart = function (containerId, request, data, categories) {
        _id = containerId;
        _request = request;
        $('.kpiWrapper[data-request="' + request + '"&&data-type="line"]').highcharts({
            chart: {
                height: 200,
                marginTop: 0,
                marginBottom: 0
            },
            title: '',
            legend: {
                enabled: false
            },
            xAxis: {
                categories: categories
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.y:.1f}</b>'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false,
                        format: '<b>{point.name}</b>: {point.y:.1f} %',
                        style: {
                            color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                        }
                    }
                }
            },
            series: data
        });
    };
}

this.SquareZone = function () {

    // ###############
    // Private vars
    // ###############

    var _id = '';
    var request = '';
    var _begin = 0;
    var _top = 0;
    var _max = 0;

    // ###############
    // Private methods
    // ###############


    var _UpdateWithNextsCommunity = function (request, begin, stop) {
        services.callService('192.168.0.1/aaaaaaaaa', 'POST', {
            param1: request,
            param1: begin,
            param3: ''
        }, this.fillSquareKPI);
    }

    var _fillSquareKPI = function (ret) {
        var json = JSON.stringify(eval("(" + ret + ")"));
        var data = json.data;
        var content = $('#square #kpiContent');
        var p0 = content.find('#p0');

        content.remove('#column:not(#p0)');
        var i = 1;
        _max = _begin;
        $.each(data, function (index) {
            var pn = p0.clone();
            pn.removeClass("p0");
            pn.addClass("p" + i);
            i++;

            pn.find('#userName span').text(this.name);
            pn.find('#userAvatar').attr('title', this.name + ' (' + _begin + ')').attr('title', this.name + ' (' + _begin + ')').src("192.168.0.1/" + this.id + '.jpg');
            pn.find('#position').text(this.y);

            content.append(pn);
            content.append('<div style="float: none;clear: left;"></div>');

            pn.toggle();
            _max++;
        });
    }

    var _bindEvents = function () {
        $('body')
            .off('click', '.adminHomeWrapper .square .kpiFooter .previous')
            .on('click', '.adminHomeWrapper .square .kpiFooter .previous', function () {

                var pageDesc = $(this).closest('.kpiWrapper').attr('id');
                var request = $(this).data('request');

                if (_begin + (2 * _top) - 1 >= _max && _begin + _top < _max) {
                    _UpdateWithNextsCommunity(request, pageDesc, _max - _top, _top - 1);
                    _begin = _max - _top;
                }
                else if (_begin + _top < _max) {
                    _UpdateWithNextsCommunity(request, pageDesc, _begin + _top, _top - 1);
                    _begin += _top;
                }

            })
            .off('click', '.adminHomeWrapper .square .kpiFooter .next')
            .on('click', '.adminHomeWrapper .square .kpiFooter .next', function () {

                var pageDesc = $(this).closest('.kpiWrapper').attr('id');
                var request = $(this).data('request');

                if (_begin - _top < 1 && _begin > 1) {
                    _UpdateWithNextsCommunity(request, pageDesc, 1, _top - 1);
                    _begin = 1;
                }
                else if (_begin != 1) {
                    _UpdateWithNextsCommunity(request, pageDesc, _begin - _top, _top - 1);
                    _begin -= _top;
                }
            });
    }

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

        setId: function (value) {
            _id = value;
        },

        setRequest: function (value) {
            _request = value;
        },

        initArrow: function (id, request) {
            if (_top + _begin < _max) {
                $('#' + id + ' .kpiFooter .previous').addClass('activeArrow');
            }
            if (_begin > 1) {
                $('#' + id + ' .kpiFooter .next').addClass('activeArrow');
            }

            _id = id;
            _request = request;
            _bindEvents();
            _UpdateWithNextsCommunity(request,1,10);
        },

        fillSquareKPI: function (data) {
            _fillSquareKPI(data);
        }

    }
}