/**
 * Created by djoé on 11/05/2015.
 */

var servicesUtils = function () {

    this.callService = function(urlService, methode, params, callback)
    {
        $.ajax({
            method: methode,
            dataType: 'json',
            url: urlService,
            data: params,
            success: callback
        });
    }


}