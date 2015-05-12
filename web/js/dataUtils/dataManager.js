
var dataManager = function () {
    
    var dataJsons = {};
    
    var codeReducer = function (key) {
        return '751' + (''+key).substring(3, 5);
    };
    
    var adressReducer = function (key) {
        console.log('751' + key.split(' - ')[1].split(' PARIS')[0].substring(3, 5));
        return'751' + key.split(' - ')[1].split(' PARIS')[0].substring(3, 5);
    };
    
    var codeFormatter = { "codeReducer" : codeReducer, "adressReducer" : adressReducer };

    this.addDataJson = function (dataName, dataJson, p_keyJoinner, p_codeFormatterName, p_valueKey, p_groupBy) {
        dataJsons[dataName] = { data : dataJson, keyJoinner :p_keyJoinner, codeFormatter : codeFormatter[p_codeFormatterName], valueKey: p_valueKey,groupBy:p_groupBy } ;
    };

    this.getDataJson = function (dataName) {
        return dataJsons[dataName];
    };
    
    this.getFormattedData = function (dataName, groupBy) {
        var json = this.getDataJson(dataName);
        var records = json.data;
        var keyJoinner = json.keyJoinner;
        var codeFormatter = json.codeFormatter;
        var valueKey = json.valueKey;
        var computedResult = { '75101': 0, '75102': 0, '75105': 0, '75103': 0, '75104': 0, '75106': 0, '75107': 0, '75108': 0, '75109': 0, '75110': 0, '75111': 0, '75112': 0, '75115': 0, '75113': 0, '75114': 0, '75116': 0, '75117': 0, '75118': 0, '75119': 0, '75120': 0 };
        var resultat = [];
        var index = 0;
        
        records.forEach(function (element, index) {
            var fields = $(element)[0]['fields'];
            var key = codeFormatter(fields[keyJoinner]);
            var value;
            
            if (valueKey == undefined || valueKey == '')
                value = 1;
            else
                value = fields[valueKey];
            
            if (key > 75120)
                return;
            
            if (computedResult[key] == undefined)
                computedResult[key] = 0;
            computedResult[key] += value;
            
        });
        
        $.each(computedResult, function (key, val) { 
            
            resultat[index] = { 'code' : key, 'value' : val };
            index++;
        });

        return resultat;
    };
    
    this.getFormattedAllData = function()
    {
        var resultat = [];
        var result = { '75101': 0, '75102': 0, '75105': 0, '75103': 0, '75104': 0, '75106': 0, '75107': 0, '75108': 0, '75109': 0, '75110': 0, '75111': 0, '75112': 0, '75115': 0, '75113': 0, '75114': 0, '75116': 0, '75117': 0, '75118': 0, '75119': 0, '75120': 0 };
        var index = 0;
        var dataM = this;
        $.each(dataJsons, function (key, val) {
            var currentData = dataM.getFormattedData(key);

            $.each(currentData, function (key, val) { 
                result[val['code']] += val['value'];
            });
        });

        $.each(result, function (key, val) {
            
            resultat[index] = { 'code' : key, 'value' : val };
            index++;
        });

        return resultat;
    };

    
    this.getChartFormattedData = function (dataName, groupBy) {
        var json = this.getDataJson(dataName);
        var records = json.data;
        var valueKey = json.valueKey;
        var computedResult = {};
        var resultat = [];
        var index = 0;
        
        records.forEach(function (element, index) {
            var fields = $(element)[0]['fields'];
            var key = fields[groupBy];
            var value;
            
            if (valueKey == undefined || valueKey == '')
                value = 1;
            else
                value = fields[valueKey];
            
            if (computedResult[key] == undefined)
                computedResult[key] = 0;
            computedResult[key] += value;
            
        });
        
        $.each(computedResult, function (key, val) {
            
            resultat[index] = [key,val];
            index++;
        });
        
        return resultat;
    };
    
    this.getColumnChartFormattedData = function (dataName, groupBy){
        var categoryResult = [];
        var data = [];

        var json = this.getDataJson(dataName);
        var records = json.data;
        var valueKey = json.valueKey;
        var computedResult = {};
        var index = 0;

        
        records.forEach(function (element, index2) {
            var fields = $(element)[0]['fields'];
            var key = fields[groupBy];
            var value;
            
            if (valueKey == undefined || valueKey == '')
                value = 1;
            else
                value = fields[valueKey];
            
            if (computedResult[key] == undefined) { 
                computedResult[key] = 0;
                index++;
            }
            computedResult[key] += value;
            
        });
        
        var alpha = 0.80 / index;
        index = 0;
        $.each(computedResult, function (key, val) {
            categoryResult[index] = key;
            data[index] = { y : val, color: 'rgba(0,255,0,' + (1-(alpha*index)) + ')' };
            index++;
        });
        
        return { categories : categoryResult, data : data };
    };

    this.queryBuilder = function(dataset, q, rows, facets) {
        if (dataset == '' || dataset == null)
            return;

        var baseUrl = 'http://opendata.paris.fr/api/records/1.0/search?dataset=' + dataset;
        
        if (q != '' && q != null)
            baseUrl += '&q=' + q;
        
        if (rows != '' && rows != null)
            baseUrl += '&rows=' + rows;

        if (facets != '' && facats != null)
            baseUrl += '&facets=' + facets;

        return baseUrl;
    };


};