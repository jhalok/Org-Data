({
        onPress : function(component) {
            var packageXml = '<?xml version="1.0" encoding="UTF-8"?>' + 
                '<Package xmlns="http://soap.sforce.com/2006/04/metadata">' +
                '<version>35.0</version>' +
                '</Package>' ;

            var zipFile = new JSZip();
            zipFile.file('package.xml',packageXml,{base64: 'true'});
            var data = zipFile.generateAsync();
            alert(data);
        }
    })