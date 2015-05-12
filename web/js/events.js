$(function () {
    $('.list .arrow-down')
    .off('click')
    .on('click', function (e) {
        e.stopPropagation();
        var $this = $(this);
        var list = $this.closest('.list');
        var listItems = list.find('.listItems');
        
        listItems.toggle();
        if(listItems.css('display') != 'none')
            listItems.find('a:first').focus();
    });
    $(document)
    .off('click')
    .on('click', function (e) {
        var listItems = $('.listItems');
        
        listItems.hide();
    });

    $('.listItem')
    .off('click')
    .on('click', function (e) {
       
        var $this = $(this);
        var list = $this.closest('.list');
        var listHeader = list.find('.listHeaderText')
        var dataset = $this.attr('data-dataset');
        var q = $this.attr('data-q');
        var rows = $this.attr('data-rows');
        var facets = $this.attr('data-facets');
        var codeFormatterName = $this.attr('data-joinner-formatter');
        var joinner = $this.attr('data-joinner');
        var valueKey = $this.attr('data-value-key');
        var groupBy = $this.attr('data-group-by');
        var chartType = $this.attr('data-chart-type');
        var serieName = $this.attr('data-serie-name');
        var text = $this.text();
        
        //var url = oDataManager.queryBuilder(dataset, q, rows, facets);
        var url = dataset + '.json';
        console.log(url);

        $.getJSON(url, function (geojson) {
            oDataManager.addDataJson(dataset, geojson, joinner, codeFormatterName, valueKey);
            myMap.setData(oDataManager.getFormattedAllData());
            var groupByArray = groupBy.split(';');
            var chartTypeArray = chartType.split(';');
            var serieNameArray = serieName.split(';');
            var newTag = $('#tagClone').clone();

            if ($("." + dataset).length == 0) {
                $.each(groupByArray, function (index, element) {
                    var newChart = $('#kpiCopy').clone();
                    $('#kpiHomeWrapper').append(newChart);
                    newChart.toggle();
                    newChart.find('h2').text(text);
                    newChart.find('#container1').attr('id', dataset + index);
                    newChart.attr('id', '');
                    newChart.addClass(dataset);
                    
                    if (chartTypeArray[index] == "column") {
                        newChart.addClass('large');
                        var chartData = oDataManager.getColumnChartFormattedData(dataset, element);
                        chartUtils.createColumnChart(dataset + index, chartData.data, chartData.categories, serieNameArray[index]);
                    }
                    else {
                        newChart.addClass('medium');
                        var chartData = oDataManager.getChartFormattedData(dataset, element);
                        chartUtils.createMonoSerieChart(dataset + index, chartData, chartTypeArray[index], serieNameArray[index]);
                    }
                });
                newTag.find('.tagText').text(text);
                newTag.attr('data-dataset', dataset);
                newTag.attr('id', '');
                newTag.toggle();
                $('#tags').append(newTag);
            }
        });
        listHeader.attr('data-dataset',$this.attr('data-dataset'));
    });

    $('#tags')
    .off('click', '.tag')
    .on('click', '.tag', function (e) {
        $('.' + $(this).closest('.tag').attr('data-dataset')).remove();
        $(this).closest('.tag').remove();

        myMap.setData(myMap.getDefaultData());
    });
    
});