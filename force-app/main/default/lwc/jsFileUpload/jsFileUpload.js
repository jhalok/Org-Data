import { LightningElement, track, api, wire } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import forcetk from '@salesforce/resourceUrl/forcetk';
import jQueryfile from '@salesforce/resourceUrl/jQueryfile';
import accessToken from '@salesforce/apex/JsFileUpload_AcsToken.accessToken'; 
export default class JsFileUpload extends LightningElement {

uploading = 0;
uploaded = 0;

connectedCallback() {
    console.log('inside connectedCallback');
    Promise.all([
        loadScript(this, forcetk + '/forceTk.js'),
        loadScript(this, jQueryfile + '/jQueryfile.js'),  
    ])
    .then(() => {
        })
        .catch(error => {
            alert(error);
    });
}

@wire(accessToken)
    accessTokenVal({ error, data }) {
        if (data) {
            console.log('data-------'+JSON.stringify(data));
            this.accessTkn = data;
            console.log('-acsToken-'+this.accessTkn);
        }
        else if(error) {
            window.console.log(error);
    }
}

handleChange(event){
    var CaseId = '0036F00003MnmyE'; 
    this.filesUploaded = event.target.files;
    console.log('fileUploaded withoit stringify'+this.filesUploaded);
        for (var i = 0; i < this.filesUploaded.length; i++) {
            console.log('inside for loop');
            this.upload_file(this.filesUploaded[i], CaseId, this.accessTkn, function(err, res){
                console.log('calling uploadFile mthd');
                    alert('Your file is Uploaded');
        })
    }
}
upload_file = function(file, parentId, accessToken, callback){
    console.log('inside upload file method'); 
        this.filetoBase64(file, function(err, content){
            console.log('back to upload method after reading content');
            console.log('---active data file---'+file);
            console.log('---active data acsTkn---'+accessToken);
            var attachment_object = {
                parentId: parentId,
                Body: content, 
                Name: file.name, 
                ContentType: file.type 
            };
            $.ajax({
                url: 'https://lightdevlopment-dev-ed.my.salesforce.com/services/data/v38.0/sobjects/Attachment',
                data: JSON.stringify(attachment_object),
                type: 'POST',
                processData: false,
                contentType: false,
                headers: {'Authorization': 'Bearer '+accessToken, 'Content-Type': 'application/json'},
                xhr: function(){
                    var xhr = new window.XMLHttpRequest();
                    console.log('xhr request---'+xhr);
                    //Progress of uploaded file
                    xhr.upload.addEventListener("progress", function(evt){
                        if (evt.lengthComputable) {
                            var percentComplete = evt.loaded / evt.total;
                            var percentCompletex= percentComplete*100;  
                            console.log('percent Completed'+percentCompletex);
                        }
                    }, false);
                    return xhr;
                },
                success: function(response) {
                    callback(null, true)
                }
        });
    })
}
filetoBase64 = function(file, callback){
        console.log('inside filereader');
        var reader = new FileReader();
        reader.onload = function() {
            var fileContents = reader.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
            callback(null, fileContents);
        }
        reader.readAsDataURL(file);
    }   
}