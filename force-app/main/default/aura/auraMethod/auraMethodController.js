({
    logParam : function(cmp, event) {
        var params = event.getParam('arguments');
        if (params) {
            var message = params.message;
            console.log("message: " + message);
            return message;
        }
    },
})