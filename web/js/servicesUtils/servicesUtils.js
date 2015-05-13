/**
 * Created by djoé on 11/05/2015.
 */

var servicesUtils = function () {

    this.callService = function(urlService, methode, params, callback)
    {
        $.ajax({
            method: methode,
            url: urlService,
            data: params
        })
        .done(callback);
    }


}