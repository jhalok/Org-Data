({
    MAX_FILE_SIZE: 60000000, //Max file size 4.5 MB 
    CHUNK_SIZE: 3000000,      //Chunk Max size 750Kb 
    
    uploadHelper: function(component, event) {
        console.log('inside upload helper');
        console.log('ParentID'+component.get("v.parentId"));
        component.set("v.showLoadingSpinner", true);
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var self = this;
        if (file.size > self.MAX_FILE_SIZE) {
            console.log('file size---'+file.size);
            component.set("v.showLoadingSpinner", false);
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });
        objFileReader.readAsDataURL(file);
    },
 
    uploadProcess: function(component, file, fileContents) {
        console.log('inside uploadProcess helper');
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        console.log('endposition---'+endPosition);
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
 
 
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        console.log('inside uploadChunk');
        console.log('PArentID in upload chunk'+component.get("v.parentId"));
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        action.setParams({
            parentId: component.get("v.parentId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                console.log('new endPosition-----'+endPosition);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    console.log('startPosition is less then endPosition');
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    alert('your File is uploaded successfully');
                    component.set("v.showLoadingSpinner", false);
                }
            }
        });
        $A.enqueueAction(action);
    }
})